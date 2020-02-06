// Para la foto o imagen 
import 'package:app_firebase_lambda/form.dart';

import 'package:flutter/material.dart';

import 'Mensaje.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lambda - Firebase',
      home: HomePage()
    );
  }
}


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Mensaje>> _msgs;
  List<Mensaje> mensajes; 

  Mensaje mensaje;
  bool guardando = false;

  MensajePV mpv = new MensajePV();

  
  final scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    _msgs = mpv.getMensajes();

    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        title: Text('Lista mensajes'),
      ),
      body: Column(
        children: <Widget>[

          ListTile(
            title: Text('Mensajes'),
            trailing: IconButton(
              icon: Icon(Icons.update), 
              onPressed: () {
                setState(() {
                  _msgs = null;
                  mensajes = null;
                  print('RELOAD');
                });
              }
            ),
          ),

          Divider(
            thickness: 3,
            color: Colors.blue,
            height: 10,
          ),

          Expanded(
            child: FutureBuilder(
              future: _msgs,
              builder: (
                BuildContext context, AsyncSnapshot<List<Mensaje>> data
              ) {
                if (data.hasData) {
                  mensajes = data.data;
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0
                    ),
                    itemCount: mensajes.length,
                    itemBuilder: (
                      BuildContext context, 
                      int i
                    ) {
                      return ListTile(
                        title: 
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Nombre: ' + mensajes[i].nombre),
                            Text('Mensaje: ' + mensajes[i].mensaje),
                            Divider(
                              thickness: 4,
                              height: 15, 
                              color: Colors.blue.shade500,
                            ),
                          ],
                        ),

                        
                      );
                    }
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
          _enviarMensaje(context);
        }
      ),
    );
  }

  void _enviarMensaje(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        return FormMensaje(scafoldKey: scafoldKey, mpv: mpv,);
      }
    );
  }

}
