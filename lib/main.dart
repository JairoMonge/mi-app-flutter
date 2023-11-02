import 'dart:convert';

import 'package:flutter/material.dart'; // Importa el paquete Flutter para la interfaz de usuario.
import 'package:http/http.dart'
    as http; // Importa el paquete HTTP para realizar solicitudes HTTP.
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  
  // Define la clase principal de la aplicación.
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() =>
      _MyAppState(); // Crea una instancia de la clase de estado _MyAppState.
}

class _MyAppState extends State<MyApp> {
  // Define la clase de estado de la aplicación.
  String message = ""; // Variable para almacenar el mensaje de la API.

  void fetchMessage() async {
    // Método para realizar una solicitud HTTP a la API.
    final response = await http.get(Uri.parse(dotenv.env['API_URL'] ?? 'API_URL not found')); // Realiza una solicitud GET a la URL de la API.

    if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body); // Decodifica la respuesta JSON.

     
      // Si la solicitud es exitosa (código de estado 200).
      setState(() {
        // Actualiza el estado de la aplicación con el mensaje recibido.
        message = jsonResponse['mensaje'];
      });
    } else {
      // Si la solicitud falla.
      setState(() {
        // Actualiza el estado de la aplicación con un mensaje de error.
        message = "Error al obtener el mensaje";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Método para construir la interfaz de usuario.
    return MaterialApp(
      // Crea una aplicación MaterialApp.
      home: Scaffold(
        // Crea un Scaffold que proporciona una estructura básica para la interfaz de usuario.
        appBar: AppBar(
          // Define una barra de aplicación en la parte superior.
          title: const Text(
              'Ejemplo de conexión a API de Laravel'), // Establece el título de la barra de aplicación.
        ),
        body: Center(
          // Centra el contenido en la pantalla.
          child: Column(
            // Crea una columna de widgets.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                // Crea un botón elevado.
                onPressed:
                    fetchMessage, // Asocia el método fetchMessage al botón.
                child: const Text('Obtener Mensaje'), // Texto del botón.
              ),
              const SizedBox(height: 20), // Agrega un espacio en blanco.
              const Text(
                // Texto estático.
                'Mensaje de la API:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                // Texto dinámico que muestra el mensaje de la API.
                message,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
