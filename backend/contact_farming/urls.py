from django.urls import path

from .views import ContactFarmingPostView, PostListView

urlpatterns = [
    path('contact-farming/', ContactFarmingPostView.as_view()),
    path('contact-farming-posts/', PostListView.as_view()),
]
