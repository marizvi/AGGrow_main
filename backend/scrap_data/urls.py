from django.urls import path

from .views import MandiPricesView, NewsListView, BreakingNews

urlpatterns = [
    path('news/', NewsListView.as_view()),
    path('breaking-news/', BreakingNews.as_view()),
    path('mandi-prices/', MandiPricesView.as_view()),
    path('mandi-prices/<str:state>/', MandiPricesView.as_view()),
]
