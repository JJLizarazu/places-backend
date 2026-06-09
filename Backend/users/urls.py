from django.urls import path
from .views import RegistroView, LoginView, RecuperarPasswordView

urlpatterns = [
    path('flutter/registro/', RegistroView.as_view(), name='registro_flutter'),
    path('flutter/login/', LoginView.as_view(), name='login_flutter'),
    path('flutter/recuperar/', RecuperarPasswordView.as_view(), name='recuperar_flutter'),
]