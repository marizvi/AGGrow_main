from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions
from rest_framework import status
from rest_framework.request import Request
from rest_framework.views import APIView

from .authentication import ExpiringTokenAuthentication
from .models import User
from .serializers import UserSerializer, LoginSerializer, ErrorSerializer, SendTokenSerializer, TypedErrorDict
from .utils import Response


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
        description="Register a new user. ErrorMessages: EmailExists, InvalidEmail, InvalidUsername, InvalidPassword",
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
        description="Login a user. ErrorMessages: InvalidEmail, InvalidPassword, InvalidCredentials"
    )
    def post(self, request: Request, format=None) -> Response:
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            user = User.authenticate_user(request._request, serializer.data['email'],
                                          serializer.data['password'])
            if user is not None:
                return Response(SendTokenSerializer(user.get_token()), check_valid=False, status=status.HTTP_200_OK)
            else:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidCredentials', error_data=serializer.errors)),
                    status=status.HTTP_400_BAD_REQUEST)
        else:
            if 'email' in serializer.errors:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidEmail', error_data=serializer.errors)),
                    status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='InvalidPassword', error_data=serializer.errors)),
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
