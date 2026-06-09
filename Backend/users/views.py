from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Persona, Usuario

class RegistroView(APIView):
    def post(self, request):
        data = request.data
        if Persona.objects.filter(correo_electronico=data.get('correo_electronico')).exists():
            return Response({'error': 'Ya existe una cuenta con este correo electrónico.'}, status=status.HTTP_400_BAD_REQUEST)
        if Usuario.objects.filter(usuario=data.get('usuario')).exists():
            return Response({'error': 'Este nombre de usuario ya está en uso. Elige otro.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            persona = Persona.objects.create(
                nombres=data.get('nombres'), primer_apellido=data.get('primer_apellido'),
                segundo_apellido=data.get('segundo_apellido'), ci=data.get('ci'),
                fecha_nacimiento=data.get('fecha_nacimiento'), genero=data.get('genero'),
                direccion=data.get('direccion'), telefono_fijo=data.get('telefono_fijo', '0'),
                celular=data.get('celular'), correo_electronico=data.get('correo_electronico')
            )
            usuario = Usuario.objects.create_user(
                usuario=data.get('usuario'), password=data.get('password'), persona=persona
            )
            return Response({'mensaje': 'Usuario creado exitosamente'}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        try:
            persona = Persona.objects.get(correo_electronico=email)
            usuario = Usuario.objects.get(persona=persona)
            if usuario.check_password(password):
                user_data = {
                    'nombres': persona.nombres,
                    'apellidos': f"{persona.primer_apellido} {persona.segundo_apellido or ''}".strip(),
                    'correo': persona.correo_electronico,
                    'usuario': usuario.usuario,
                    'celular': persona.celular
                }
                return Response({'mensaje': 'Login exitoso', 'user_data': user_data}, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Contraseña incorrecta'}, status=status.HTTP_401_UNAUTHORIZED)
        except Persona.DoesNotExist:
            return Response({'error': 'No existe una cuenta con este correo'}, status=status.HTTP_404_NOT_FOUND)
        except Usuario.DoesNotExist:
            return Response({'error': 'La cuenta no tiene un usuario asignado'}, status=status.HTTP_404_NOT_FOUND)

class RecuperarPasswordView(APIView):
    def post(self, request):
        email = request.data.get('email')
        nueva_password = request.data.get('nueva_password')
        try:
            persona = Persona.objects.get(correo_electronico=email)
            usuario = Usuario.objects.get(persona=persona)
            usuario.set_password(nueva_password) # Encripta la nueva clave
            usuario.save()
            return Response({'mensaje': 'Contraseña actualizada correctamente'}, status=status.HTTP_200_OK)
        except Persona.DoesNotExist:
            return Response({'error': 'No se encontró cuenta asociada a ese correo'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)