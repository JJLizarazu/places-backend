from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

# --- TABLAS DEL LOGIN/USUARIO ---
class Persona(models.Model):
    nombres = models.CharField(max_length=100)
    primer_apellido = models.CharField(max_length=100)
    segundo_apellido = models.CharField(max_length=100, blank=True, null=True)
    ci = models.CharField(max_length=50)
    fecha_nacimiento = models.DateField()
    genero = models.CharField(max_length=50)
    direccion = models.CharField(max_length=200)
    telefono_fijo = models.CharField(max_length=50, default="0")
    celular = models.CharField(max_length=50)
    complemento_ci = models.CharField(max_length=50, blank=True, null=True)
    correo_electronico = models.EmailField(max_length=100, unique=True)

    def __str__(self):
        return f"{self.nombres} {self.primer_apellido}"

class UsuarioManager(BaseUserManager):
    def create_user(self, usuario, password=None, **extra_fields):
        if not usuario:
            raise ValueError('El usuario debe tener un nombre de usuario')
        user = self.model(usuario=usuario, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, usuario, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(usuario, password, **extra_fields)

class Usuario(AbstractBaseUser, PermissionsMixin):
    persona = models.OneToOneField(Persona, on_delete=models.CASCADE, null=True, blank=True)
    usuario = models.CharField(max_length=50, unique=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    objects = UsuarioManager()
    USERNAME_FIELD = 'usuario' 
    def __str__(self):
        return self.usuario

# --- TABLAS DE LA APP (PLACES) ---
class Lugar(models.Model):
    nombre = models.CharField(max_length=200)
    descripcion = models.CharField(max_length=500)
    provincia = models.CharField(max_length=100)
    municipio = models.CharField(max_length=100)
    departamento = models.CharField(max_length=100)
    ubicacion = models.CharField(max_length=300)
    latitud = models.DecimalField(max_digits=50, decimal_places=15)
    longitud = models.DecimalField(max_digits=50, decimal_places=15)
    url = models.CharField(max_length=300)

class Horario(models.Model):
    lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)
    dia = models.CharField(max_length=50)
    apertura = models.TimeField()
    cierre = models.TimeField()

class Comentario(models.Model):
    comentario = models.CharField(max_length=500)
    calificacion = models.IntegerField()
    fecha = models.DateField(auto_now_add=True)
    persona = models.ForeignKey(Persona, on_delete=models.CASCADE)
    lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)
    # Autoreferencia para "re-comentarios" (Agregamos related_name='respuestas' aquí)
    recomentario = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='respuestas')

class Foto(models.Model):
    url = models.CharField(max_length=300)
    descripcion = models.CharField(max_length=100)
    lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)
    comentario = models.ForeignKey(Comentario, on_delete=models.CASCADE, null=True, blank=True)

class Funcionalidad(models.Model):
    nombre = models.CharField(max_length=100)

class Rol(models.Model):
    nombre = models.CharField(max_length=100)
    privilegios = models.ManyToManyField(Funcionalidad, related_name='roles')

class Cuenta(models.Model):
    persona = models.ForeignKey(Persona, on_delete=models.CASCADE)
    rol = models.ForeignKey(Rol, on_delete=models.CASCADE)

class Favorito(models.Model):
    persona = models.ForeignKey(Persona, on_delete=models.CASCADE)
    lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)