import datetime

from django.shortcuts import render
from django.utils.timezone import utc
from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.request import Request
from rest_framework.views import APIView

from .authentication import ExpiringTokenAuthentication
from .models import User, VerificationHash
from .serializers import UserSerializer, LoginSerializer, ErrorSerializer, SendTokenSerializer, TypedErrorDict
from .utils import Response, send_registration_verification_mail


class Register(APIView):
    """
    Register a new user.
    """

    permission_classes = [permissions.AllowAny]

    @extend_schema(
        request=UserSerializer,
        responses={
            status.HTTP_201_CREATED: SendTokenSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        },
        description="Register a new user. ErrorMessages: EmailExists, InvalidEmail, InvalidUsername",
    )
    def post(self, request: Request, format=None) -> Response:
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(SendTokenSerializer(user.get_token()), check_valid=False, status=status.HTTP_201_CREATED)
        else:
            if 'username' in serializer.errors:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidUsername', error_data=serializer.errors)),
                    status=status.HTTP_400_BAD_REQUEST)
            elif 'email' in serializer.errors:
                if serializer.errors['email'][0].code == 'unique':
                    return Response(ErrorSerializer(
                        data=TypedErrorDict(error_message='EmailExists', error_data=serializer.errors)),
                        status=status.HTTP_400_BAD_REQUEST)
                else:
                    return Response(ErrorSerializer(
                        data=TypedErrorDict(error_message='InvalidEmail', error_data=serializer.errors)),
                        status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidPassword', error_data=serializer.errors)),
                    status=status.HTTP_400_BAD_REQUEST)


class Login(APIView):
    """
    Login a user.
    """

    permission_classes = [permissions.AllowAny]

    @extend_schema(
        request=LoginSerializer,
        responses={
            status.HTTP_200_OK: SendTokenSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        },
        description="Login a user. ErrorMessages: InvalidEmail, InvalidCredentials, NotRegistered"
    )
    def post(self, request: Request, format=None) -> Response:
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            user = User.authenticate_user(request._request, serializer.data['email'],
                                          serializer.data['password'])
            if user is not None:
                if not user.verified:
                    if not VerificationHash.objects.filter(user=user,
                                                           valid_until__lt=datetime.datetime.utcnow().replace(tzinfo=utc)).exists():
                        send_registration_verification_mail(user,
                                                            VerificationHash.objects.create(user=user, type='R').hash,
                                                            threaded=True)
                    return Response(ErrorSerializer(
                        data=TypedErrorDict(error_message='VerificationRequired', error_data=serializer.errors)),
                        status=status.HTTP_400_BAD_REQUEST)
                else:
                    return Response(SendTokenSerializer(user.get_token()), check_valid=False, status=status.HTTP_200_OK)
            else:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidCredentials', error_data=serializer.errors)),
                    status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(ErrorSerializer(
                data=TypedErrorDict(error_message='InvalidEmail', error_data=serializer.errors)),
                status=status.HTTP_400_BAD_REQUEST)


class UserView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    @extend_schema(
        responses={
            status.HTTP_200_OK: UserSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
        }
    )
    def get(self, request: Request, format=None) -> Response:
        user = request.user
        serializer = UserSerializer(user)
        return Response(serializer, check_valid=False, status=status.HTTP_200_OK)


@api_view(['GET'])
def verify_view(request: Request, _hash: str) -> Response:
    try:
        v_hash = VerificationHash.objects.get(hash=_hash)
        if not v_hash.user.verified:
            v_hash.user.verified = True
            v_hash.user.save()
        return render(request, 'verify_success.html')
    except VerificationHash.DoesNotExist:
        return render(request, 'verification_failed.html')
