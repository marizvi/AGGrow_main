import logging

from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import permissions, generics
from rest_framework import status
from rest_framework.pagination import PageNumberPagination

# from auth_p.authentication import ExpiringTokenAuthentication
from auth_p.authentication import ExpiringTokenAuthentication
from auth_p.serializers import ErrorSerializer
from .models import LatestMandi
from .scrapers import LatestMandiScraper
from .serializers import SendLatestMandiSerializer

latestMandiScraper = LatestMandiScraper()

logger = logging.getLogger('testlogger')


class StandardResultsSetPagination(PageNumberPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100


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
