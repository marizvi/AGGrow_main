from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from auth_p.views import verify_view

urlpatterns = [
    path('admin/', admin.site.urls),

    path('verify/<str:_hash>/', verify_view),

    path('api/v1/', include('auth_p.urls')),
    path('api/v1/', include('scrap_data.urls')),
    path('api/v1/', include('contact_farming.urls')),
    path('api/v1/', include('market_place.urls')),

    path('api/v1/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/v1/schema/swagger-ui/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]
