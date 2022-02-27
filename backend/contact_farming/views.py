from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions, status, generics
from rest_framework.views import APIView

from auth_p.authentication import ExpiringTokenAuthentication
from auth_p.serializers import ErrorSerializer, TypedErrorDict
from auth_p.utils import Response
from contact_farming.models import Post
from contact_farming.serializers import PostSerializer, IdSerializer, MySerializer
from scrap_data.views import StandardResultsSetPagination


class ContactFarmingPostView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    @extend_schema(
        request=PostSerializer,
        responses={
            status.HTTP_201_CREATED: PostSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
        }
    )
    def post(self, request):
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            _post = serializer.save(user=request.user)
            return Response(PostSerializer(_post, context={'request': request}), check_valid=False, status=status.HTTP_201_CREATED)

        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='SomethingWentWrong', error_data=serializer.errors)),
            status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        parameters=[IdSerializer],
        responses={
            status.HTTP_200_OK: PostSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized"),
            status.HTTP_404_NOT_FOUND: OpenApiResponse(ErrorSerializer, description="NotFound"),
        }
    )
    def get(self, request):
        serializer = IdSerializer(data=request.query_params)
        if serializer.is_valid():
            try:
                post = Post.objects.get(id=serializer.data['id'])
                return Response(PostSerializer(post, context={'request': request}), check_valid=False, status=status.HTTP_200_OK)
            except Post.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='PostDoesNotExist', error_data=serializer.data)),
                    status=status.HTTP_400_BAD_REQUEST)
        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='IdMissing', error_data=serializer.data)),
            status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        parameters=[IdSerializer],
        request=PostSerializer,
        responses={
            status.HTTP_201_CREATED: PostSerializer,
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
            _post = Post.objects.get(id=product_id)
        except Post.DoesNotExist:
            return Response(ErrorSerializer(
                data=TypedErrorDict(error_message='PostDoesNotExist', error_data=id_serializer.data)),
                status=status.HTTP_404_NOT_FOUND)
        serializer = PostSerializer(data=request.data, instance=_post, partial=True)

        if serializer.is_valid():
            try:
                serializer.save(user=request.user, partial=True)
                return Response(PostSerializer(serializer.instance, context={'request': request}), check_valid=False,
                                status=status.HTTP_200_OK)
            except Post.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='PostDoesNotExist', error_data=serializer.data)),
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
                _post = Post.objects.get(id=serializer.data['id'])
                if _post.user != request.user:
                    return Response(ErrorSerializer(
                        data=TypedErrorDict(error_message='NotYourPost', error_data=serializer.data)),
                        status=status.HTTP_400_BAD_REQUEST)
                _post.delete()
                return Response(status=status.HTTP_200_OK)
            except Post.DoesNotExist:
                return Response(ErrorSerializer(
                    data=TypedErrorDict(error_message='ProductDoesNotExist', error_data=serializer.data)),
                    status=status.HTTP_404_NOT_FOUND)
        return Response(ErrorSerializer(
            data=TypedErrorDict(error_message='IdMissing', error_data=serializer.data)),
            status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    parameters=[MySerializer],
    responses={
        status.HTTP_200_OK: PostSerializer,
        status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized")
    }
)
class PostListView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    def get_queryset(self):

        serializer = MySerializer(data=self.request.query_params)
        if serializer.is_valid():
            if serializer.data.get('my'):
                return Post.objects.filter(user=self.request.user).order_by('-created_at')
        return Post.objects.all().order_by('-created_at')

    serializer_class = PostSerializer
    pagination_class = StandardResultsSetPagination
