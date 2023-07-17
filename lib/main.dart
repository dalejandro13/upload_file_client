import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(
    const MaterialApp(
      home: UploadFile(),
    ));
}

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {

  Future<void> uploadFile(BuildContext context) async {
    // Selecciona el archivo
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      // Crea la solicitud
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.2.1/upload'), // Cambia esto por la IP y el puerto de tu servidor
      );

      // Adjunta el archivo a la solicitud
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploadFile', // Este nombre debe coincidir con el nombre que el servidor espera
          file.path,
        ),
      );

      // Envía la solicitud
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo subido exitosamente');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Archivo subido exitosamente')));
      } 
      else {
        print('Error al subir el archivo');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al subir el archivo')));
      }
    } 
    else {
      print('No se seleccionó ningún archivo');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se seleccionó ningún archivo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadFile(context);
          },
          child: const Text('Subir archivo'),
        ),
      ),
    );
  }
}