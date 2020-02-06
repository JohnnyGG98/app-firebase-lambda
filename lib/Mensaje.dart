// Para el API 
import 'dart:convert';
import 'package:http/http.dart' as http;

// Para mapear nuestras asistencias 
class MensajePV {

  String _url = 'https://4hseyvf8ab.execute-api.us-east-1.amazonaws.com/jg-lambda-firebase/lambda-firebase'; 

  Future<List<Mensaje>> getMensajes() async {
    String data = '''{
      "opcion": 2
    }''';
    final res = await http.post(
      _url,
      body: data
    );

    List<Mensaje> msgs = new List(); 

    try {

      final String resData = json.decode(res.body.trim());
      final Map<String, dynamic> dataMap = json.decode(resData);

      Map<String, dynamic> items = dataMap['items'];
    
      items.forEach((key, value) {
        final m = Mensaje.fromJSONMap(key.toString(), value);
        msgs.add(m);
      });

    } catch (e) {
      print('Error');
      print(e.toString());
    }
    
    
    return msgs;
  }


  Future<Map<String, dynamic>> guardarMensaje(
    Mensaje mensaje, 
    String base64, 
    String nombreImg
  ) async {
    String data = '''{
      "opcion": 1,
      "nombreImagen": "$nombreImg",
      "nombre": "${mensaje.nombre}",
      "mensaje": "${mensaje.mensaje}",
      "file": "$base64"
    }''';

    //data = jsonEncode(data).toString();
    // print(data);
    final res = await http.post(
      _url,
      body: data
    );
    bool subido = false;
    String mensajeRes = '';
    try {
      mensajeRes = json.decode(res.body.trim());
      Map<String, dynamic> resJson =  json.decode(mensajeRes);
      if (resJson['statuscode'] == 200) {
        subido = true; 
      }
      mensajeRes = resJson['mensaje'];
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return {
      "subido": subido,
      "mensaje": mensajeRes 
    };
  }

}

// Modelo que usaremos para los mensajes 
class Mensaje {

  String id; 
  String nombre;
  String mensaje; 
  String imagen;

  Mensaje({
    this.id,
    this.nombre,
    this.mensaje,
    this.imagen
  });

  Mensaje.fromJSONMap(String idFirebase, Map<String, dynamic> json) {
    id = idFirebase;
    nombre = json['nombre'] != null ? json['nombre'] : "";
    mensaje = json['mensaje'] != null ? json['mensaje'] : "";
    imagen = json['imagen'] != null ? json['imagen'] : "";
  }

}