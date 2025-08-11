import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  bool _isLoading = false;

  void _reset() => setState(() {
        _selectedImage = null;
        _isLoading = false;
      });

  Future<void> _processAndSave() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);
    try {
      final resultMessage = await ApiService.processInvoice(_selectedImage!);
      _showSnackBar(resultMessage, isError: false);
      _reset();
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
    ));
  }

  Future<void> _pickImage(ImageSource source) async {
    // Ahora esta función llama a nuestro servicio mejorado que maneja los permisos.
    final image = await ImageService.pickImage(source);
    if (image != null) {
      setState(() => _selectedImage = image);
    } else {
      // Opcional: Mostrar un mensaje si el usuario no dio permiso.
      if (mounted) {
        _showSnackBar(
            "No se concedió el permiso para acceder a ${source.name}.",
            isError: true);
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
                child: Wrap(children: [
              ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Cámara'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  }),
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galería'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  }),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Facturas con IA'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Stack(children: [
        Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Escanea tu factura',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: _selectedImage == null
                              ? const Text(
                                  'Aún no has seleccionado una imagen.')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_selectedImage!,
                                      fit: BoxFit.contain))),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedImage == null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Tomar o Elegir Foto'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontSize: 18)),
                        onPressed:
                            _isLoading ? null : _showImageSourceActionSheet,
                      )
                    else
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text('Procesar y Guardar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18)),
                              onPressed: _isLoading ? null : _processAndSave,
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: _isLoading ? null : _reset,
                                child: const Text('Elegir otra imagen')),
                          ]),
                  ],
                ))),
        if (_isLoading)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Procesando...",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ]))),
      ]),
    );
  }
}
