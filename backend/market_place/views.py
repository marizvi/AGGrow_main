from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions, status, generics
from rest_framework.views import APIView

from auth_p.authentication import ExpiringTokenAuthentication
from auth_p.serializers import ErrorSerializer, TypedErrorDict
from auth_p.utils import Response
from contact_farming.serializers import IdSerializer, MySerializer
from scrap_data.utils import StandardResultsSetPagination
from .models import Product
from .serializers import ProductSerializer, TypeSerializer


class MarketPlaceProductView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    @extend_schema(
        request=ProductSerializer,
        responses={
            status.HTTP_201_CREATED: ProductSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
        }
    )
    def post(self, request):
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            _post = serializer.save(user=request.user)
            return Response(ProductSerializer(_post, context={'request': request}), check_valid=False, status=status.HTTP_201_CREATED)

        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='SomethingWentWrong', error_data=serializer.errors)),
            status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        parameters=[IdSerializer],
        responses={
            status.HTTP_200_OK: ProductSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
            status.HTTP_404_NOT_FOUND: OpenApiResponse(ErrorSerializer, description="NotFound"),
        }
    )
    def get(self, request):
        serializer = IdSerializer(data=request.query_params)
        if serializer.is_valid():
            try:
                _post = Product.objects.get(id=serializer.data['id'])
                return Response(ProductSerializer(_post, context={'request': request}), check_valid=False, status=status.HTTP_200_OK)
            except Product.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='ProductDoesNotExist', error_data=serializer.data)),
                    status=status.HTTP_404_NOT_FOUND)
        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='IdMissing', error_data=serializer.data)),
            status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        parameters=[IdSerializer],
        request=ProductSerializer,
        responses={
            status.HTTP_201_CREATED: ProductSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
            status.HTTP_404_NOT_FOUND: OpenApiResponse(ErrorSerializer, description="NotFound"),
        }
    )
    def patch(self, request):
        id_serializer = IdSerializer(data=request.query_params)
        if id_serializer.is_valid():
            product_id = id_serializer.data['id']
        else:
            return Response(ErrorSerializer(
                data=TypedErrorDict(error_message='IdMissing', error_data=id_serializer.data)),
                status=status.HTTP_400_BAD_REQUEST)
        try:
            _post = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response(ErrorSerializer(
                data=TypedErrorDict(error_message='ProductDoesNotExist', error_data=id_serializer.data)),
                status=status.HTTP_404_NOT_FOUND)
        serializer = ProductSerializer(data=request.data, instance=_post, partial=True)

        if serializer.is_valid():
            try:
                serializer.save(partial=True, user=request.user)
                return Response(ProductSerializer(serializer.instance, context={'request': request}), check_valid=False,
                                status=status.HTTP_200_OK)
            except Product.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='ProductDoesNotExist', error_data=serializer.data)),
                    status=status.HTTP_404_NOT_FOUND)
        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='IdMissing', error_data=serializer.data)),
            status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        parameters=[IdSerializer],
        responses={
            status.HTTP_200_OK: None,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
            status.HTTP_404_NOT_FOUND: OpenApiResponse(ErrorSerializer, description="NotFound"),
        }
    )
    def delete(self, request):
        serializer = IdSerializer(data=request.query_params)
        if serializer.is_valid():
            try:
                _post = Product.objects.get(id=serializer.data['id'])
                if _post.user != request.user:
                    return Response(ErrorSerializer(
                        data=TypedErrorDict(error_message='NotYourProduct', error_data=serializer.data)),
                        status=status.HTTP_400_BAD_REQUEST)
                _post.delete()
                return Response(status=status.HTTP_200_OK)
            except Product.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='ProductDoesNotExist', error_data=serializer.data)),
                    status=status.HTTP_404_NOT_FOUND)
        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='IdMissing', error_data=serializer.data)),
            status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    parameters=[
        MySerializer,
        TypeSerializer,
    ],
    responses={
        status.HTTP_200_OK: ProductSerializer,
        status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized")
    }
)
class ProductListView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    def get_queryset(self):
        my_serializer = MySerializer(data=self.request.query_params)
        type_serializer = TypeSerializer(data=self.request.query_params)
        queryset = Product.objects.all()
        if my_serializer.is_valid():
            if my_serializer.data.get('my'):
                return queryset.filter(user=self.request.user)
        if type_serializer.is_valid():
            if type_serializer.data.get('type'):
                return queryset.filter(type=type_serializer.data['type'])
        return queryset.order_by('-created_at')

    serializer_class = ProductSerializer
    pagination_class = StandardResultsSetPagination
