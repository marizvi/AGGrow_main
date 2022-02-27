from django.urls import path

from .views import ProductListView, MarketPlaceProductView

urlpatterns = [
    path('product/', MarketPlaceProductView.as_view()),
    path('product-list/', ProductListView.as_view()),
]
