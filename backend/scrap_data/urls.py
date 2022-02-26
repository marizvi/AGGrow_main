from django.urls import path

from .views import MandiPricesView

urlpatterns = [
    # path('mandi-prices/', MandiPrices.as_view()),
    path('mandi-prices/', MandiPricesView.as_view()),
    path('mandi-prices/<str:state>/', MandiPricesView.as_view()),
]
