import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Mensaje.dart';

class FormMensaje extends StatefulWidget {

  final scafoldKey;
  final MensajePV mpv;

  FormMensaje({Key key, this.scafoldKey, this.mpv}) : super(key: key);

  

  @override
  _FormMensajeState createState() => _FormMensajeState();
}

class _FormMensajeState extends State<FormMensaje> {

  // Para gaurdar la foto  
  File foto; 

  Mensaje mensaje;
  bool guardando = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (mensaje == null) {
      mensaje = new Mensaje();
    }
    
    return  AlertDialog(
              elevation: 5.0,
              content: Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[

                        _mostrarFoto(), 

                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                          label: Text('Seleccionar foto'),
                          icon: Icon(Icons.photo_size_select_actual),
                          onPressed: _seleccionarFoto,
                        ),

                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                          label: Text('Tomar foto'),
                          icon: Icon(Icons.camera_alt),
                          onPressed: _tomarFoto,
                        ),

                        TextFormField(
                          initialValue: mensaje.nombre,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            hintText: 'Ingrese su nombre'
                          ),
                          onSaved: (value) => mensaje.nombre = value,
                          validator: (value) {
                            return _validarCampos(value);
                          },
                        ),

                        TextFormField(
                          initialValue: mensaje.mensaje,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Mensaje',
                            hintText: 'Ingrese su mensaje'
                          ),
                          onSaved: (value) => mensaje.mensaje = value,
                          validator: (value) {
                            return _validarCampos(value);
                          },
                        ),


                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15
                          ),
                          child: Divider(
                            color: Colors.blue,
                            thickness: 10,
                          ),
                        ),
                        
                        

                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          color: Colors.green,
                          textColor: Colors.white,
                          label: Text('Guardar'),
                          icon: Icon(Icons.save),
                          onPressed: (guardando) ? null : _guardar,
                        )

                      ],
                    ),
                  ),
                ),
              ),
            );
  }

  void _guardar() async {
    formKey.currentState.save();

    setState(() {
      guardando = true;
    });

    String base64Image = base64.encode(foto.readAsBytesSync());
    String nombre = foto.path.split('/').last;

    //base64Image = base64Image.replaceAll(r"\'", "'");
    base64Image = base64Image.replaceAll('\\', r'\\');
    base64Image = base64Image.replaceAll('/', r'\/');
    
    // String strFoto = utf8.decode(base64.decode(base64Image)).toString();
    // print('Base 64');
    // print(base64Image);

    // PATH
    print('Nombre imagen: ' + nombre);

    Map<String, dynamic> res = await widget.mpv.guardarMensaje(
      mensaje,
      base64Image,
      nombre
    );



    print('RES');
    print(res);


    final snackbar = SnackBar(
      content: Text(res["mensaje"]),
      duration: Duration(milliseconds: 1000),
    );
    widget.scafoldKey.currentState.showSnackBar(snackbar);
    setState(() {
      guardando = false;
    });

    if (res['subido']) {
      Navigator.of(context).pop();
    }
  }

  // Para seleccionar la imagen 
  _seleccionarFoto() async {
    _cargaImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _cargaImagen(ImageSource.camera);
  }

  _cargaImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(
      source: origen
    );

    if ( foto != null) {
      // Borramos para que no se muestrela foto que ya estaba antes 
      mensaje.imagen = null; 
      print('URL: ' + foto.path);
    }

    setState(() { });
  }

  Widget _mostrarFoto() {
    if (mensaje.imagen != null) {
      return getImage(mensaje.imagen);
    } else {
      // Guardamos el path de la imagen
      if ( foto != null) {
        mensaje.imagen = foto.path;
        return getImage(foto.path);
      } 

      return Image(
        image: AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget getImage(String path) {
    return Image(
      image: FileImage(new File(path)),
      height: 300.0,
      fit: BoxFit.contain,
    );
  }

    String _validarCampos(String value) {
    if ( value.length <= 3 ) {
      return 'No puede ingresar menos de 3 letras.';
    } else {
      return null;
    }
  }


}