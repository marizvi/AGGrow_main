import logging

from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions, generics
from rest_framework import status
from rest_framework.views import APIView

from auth_p.authentication import ExpiringTokenAuthentication
from auth_p.serializers import ErrorSerializer
from auth_p.utils import Response
from .models import LatestMandi, News
from .scrapers import LatestMandiScraper, NewsScrapper
from .serializers import SendLatestMandiSerializer, NewsSerializer
from .utils import StandardResultsSetPagination

latestMandiScraper = LatestMandiScraper()
newsScrapper = NewsScrapper()

logger = logging.getLogger('testlogger')


@extend_schema(
    request=SendLatestMandiSerializer,
    responses={
        status.HTTP_200_OK: SendLatestMandiSerializer,
        status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized")
    }
)
class MandiPricesView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]
    lookup_url_kwarg = "state"

    def get_queryset(self):
        latestMandiScraper.get_scrape_data()
        state = None
        if self.kwargs.get(self.lookup_url_kwarg) and len(self.kwargs.get(self.lookup_url_kwarg)) > 4:
            state = f'{self.kwargs.get(self.lookup_url_kwarg)}'
        sorted_latest_prices_queryset = LatestMandi.objects.all().order_by('-created_at')
        query_set = LatestMandi.objects.all()
        if state:
            query_set = query_set.filter(state=state)
        if sorted_latest_prices_queryset.exists():
            query_set.filter(created_at=sorted_latest_prices_queryset.first().created_at)
        return query_set.order_by('-created_at')

    serializer_class = SendLatestMandiSerializer
    pagination_class = StandardResultsSetPagination


@extend_schema(
    responses={
        status.HTTP_200_OK: NewsSerializer,
        status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
        status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized")
    }
)
class NewsListView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    def get_queryset(self):
        newsScrapper.get_scrape_data()
        return News.objects.filter(breaking=False).order_by('-created_at')

    serializer_class = NewsSerializer
    pagination_class = StandardResultsSetPagination


class BreakingNews(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ExpiringTokenAuthentication]

    @extend_schema(
        responses={
            status.HTTP_200_OK: NewsSerializer,
            status.HTTP_400_BAD_REQUEST: OpenApiResponse(ErrorSerializer, description="Bad request"),
            status.HTTP_404_NOT_FOUND: OpenApiResponse(ErrorSerializer, description="No Breaking News"),
            status.HTTP_401_UNAUTHORIZED: OpenApiResponse(ErrorSerializer, description="Unauthorized")
        }
    )
    def get(self, request):
        newsScrapper.get_scrape_data()
        news_queryset = News.objects.filter(breaking=True).order_by('-created_at')
        if not news_queryset.exists():
            return Response(status=status.HTTP_404_NOT_FOUND)
        breaking_news = news_queryset.first()
        return Response(NewsSerializer(breaking_news), check_valid=False, status=status.HTTP_200_OK)
