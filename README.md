# <center>Informes</center>

### Elastic Beanstalk

Es un servicio de ofrece AWS, nos ayuda a implementar y escalar servicios y aplicaciones desarrollados en los siguientes lenguajes:
1. Java
2. .NET
3. PHP
4. Node.js
5. Python
6. Ruby
7. Go
8. Docker

Elastic Beanstalk se encarga de administrar de forma automática la implementación, el escalado automático y la monitorización de la aplicación.

**Crear una aplicación Spring**

1. Ingresamos a ```https://start.spring.io/```
2. Creamos una nueva aplicación maven con las dependencias necesarias de una aplicación REST
3. Programamos nuestra aplicación REST
4. Se compila el proyecto
5. Clean. ```mvn clean```
6. Compilar. ```mvn compile```
7. Nuestro proyecto ```.jar``` lo comprimimos en un ```.zip``` para poder subirlo al servicio de Elastic Beanstalk

**Creamos nuestro entorno en Elastic Beanstalk**

1. En servicios buscamos Elastic Beanstalk
2. Creamos un nuevo entorno
3. Seleccionamos ```Entorno del servidor web```
4. Escribimos el nombre del entorno
5. En campo escribimos la url que se usará para acceder a la aplicación
6. En plataforma seleccionamos la plataforma que usaremos, en este caso ```Java```
7. En Código de la aplicación seleccionamos cargar código
8. Subimos nuestro código comprimido en .zip

Repositorio del proyecto subido:
> https://github.com/JohnnyGG98/producto-ss

Endpoint
> http://pruebauno-env.fprpsksqtk.us-east-1.elasticbeanstalk.com/

SwaggerUI
> http://pruebauno-env.fprpsksqtk.us-east-1.elasticbeanstalk.com/swagger-ui.html

**Conclusión**

Poner en producción o pruebas cualquier aplicación WEB se hace de forma rápida y ahorrando recursos al usar el servicio de AWS, nos libera de crear máquinas virtuales instalar dependencias para correr nuestra aplicación asignar los recursos que usará. Todo esto Elastic Beanstalk lo hace de forma rápida y automática.

### Firebase

Es una plataforma desarrollada por Google que nos provee de diferentes servicios enfocadas para el uso desde plataformas móviles, el servicio que utilizaremos sera el de base de datos en tiempo real. La base de datos es una no relacional y todos sus datos se almacenan en formato JSON en la que se pueden configurar sus diferentes reglas.

**Crear proyecto en Firebase**

1. Entramos a la consola de firebase.
2. Creamos un nuevo proyecto.
3. Nos vamos a la sección de bases de datos.
4. Seleccionamos la opción de base de datos en tiempo real.
5. Nos dirigimos a reglas y pegamos el siguiente código.
```javascript
{
  /* Visit
     https://firebase.google.com/docs/database/security
     to learn more about security rules.
  */
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

**Guardar y leer datos de Firebase desde Python**
1. Creamos un proyecto en python 3.6
2. Seguimos los siguientes pasos para configurar un proyecto en con entorno virtual en python
```
$ mkdir p-firebase
$ cd p-firebase/
$ virtualenv -p python3 .
$ cd /bin
$ source activate
```
3. Instalamos las librerías que usaremos
```
$ pip install python-firebase
$ pip install boto3
```
4. Importamos las librerías e iniciamos las conexiones a firebase y s3.
```python
import json
import boto3
import base64
from firebase import firebase

# Constantes
URL_FIREBASE = 'https://prueba-firebase-aws.firebaseio.com/'
URL_BUCKET = 'https://bucket2.s3.amazonaws.com/'

# Nos conectamos a nuestra base de datos  
miFirebase = firebase.FirebaseApplication(URL_FIREBASE, None)
# S3
s3 = boto3.client('s3')
```
5. Definimos nuestro  main.
```python
def lambda_handler(event, context):
    return json.dumps(json)
```
6. Guardamos datos en firebase.
```python
usuario = {
    'nombre': nombre,
    'mensaje': mensaje,
    'imagen': urlImg
}
# Ahora guardamos el usuario
miFirebase.post('/usuario', usuario)
```
7. Consultamos datos en firebase.
```python
res = miFirebase.get('/usuario', None)
```

**Crear un servicio Lambda**
1. Creamos un servicio Lambda
2. Creamos un rol que tenga todos los accesos de S3.
3. En nuestro lambda seleccionar la opción de ```cargar un archivo .zip```
4. Subimos nuestro .zip
5. Lo publicamos en un servicio API de AWS.


Aplicación móvil
> https://github.com/JohnnyGG98/app-firebase-lambda

Endpoint
> https://4hseyvf8ab.execute-api.us-east-1.amazonaws.com/jg-lambda-firebase/lambda-firebase


**Conclusión**

Las funciones lambda nos sirven para implementar tareas específicas con el lenguaje más óptimo de forma rápida, y con gran integración con los diferentes servicios que ofrece AWS u otros servicios como en este caso Firebase que es una base de datos en tiempo real muy usada en aplicaciones móviles.

### Código fuente completo de Lambda

```python
import json
import boto3
import base64
from firebase import firebase

# Constantes
URL_FIREBASE = 'https://prueba-firebase-aws.firebaseio.com/'
URL_BUCKET = 'https://bucket2.s3.amazonaws.com/'

# Nos conectamos a nuestra base de datos  
miFirebase = firebase.FirebaseApplication(URL_FIREBASE, None)

# S3
s3 = boto3.client('s3')

def lambda_handler(event, context):
    # TODO implement
    opcion = event['opcion']

    jsonResponse = {
        'statuscode': 400,
        'mensaje': 'No se ejecuta ninguna opcion aun'
    }
    # Opcion para guardar un usuario
    if opcion == 1:
        res = guardarUsuario(event)
        jsonResponse = {
            'statuscode': 200,
            'mensaje': res
        }
    #Opcion para listar todos los usuarios
    elif opcion == 2:        
        res = getUsuarios()
        jsonResponse = {
            'statuscode': 200,
            'items': res
        }
    # Error cuando no tenemos usuario
    else:
        #print('No tenemos opcion')
        jsonResponse = {
            'statuscode': 400,
            'mensaje': 'No tenemos la opcion buscada eso es triste mi amigo'
        }

    return json.dumps(jsonResponse)


def guardarUsuario(data):
    # Primero guardamos la foto  
    # Campos por defecto
    urlImg = 'noimagen'
    nombreImagen = data.get('nombreImagen')
    file = data.get('file')
    if nombreImagen or file:  
        urlImg = guardarFile(nombreImagen, file)

    # Mapeamos nuestra objeto para guardarlo
    nombre = data.get('nombre')
    mensaje = data.get('mensaje')
    if nombre or mensaje :
        usuario = {
            'nombre': nombre,
            'mensaje': mensaje,
            'imagen': urlImg
        }
        # Ahora guardamos el usuario
        miFirebase.post('/usuario', usuario)
        return 'Guardamos el usuario.'
    else:
        return 'No tenemos toda la informacion para guardar un usuario'


def guardarFile(nombre, file):
    img = base64.b64decode(file)
    s3.put_object(
        Bucket = 'bucket2',
        Key = nombre,
        Body = img
    )
    return URL_BUCKET + nombre;

def getUsuarios():
    res = miFirebase.get('/usuario', None)
    return res
```
