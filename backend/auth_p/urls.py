from django.urls import path

from .views import UserView, Login, Register

urlpatterns = [
    path('me/', UserView.as_view()),
    path('login/', Login.as_view()),
    path('register/', Register.as_view()),
]
