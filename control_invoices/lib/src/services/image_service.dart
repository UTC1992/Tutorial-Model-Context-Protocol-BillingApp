import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Maneja la solicitud de permiso y luego abre el selector de imágenes.
  static Future<File?> pickImage(ImageSource source) async {
    // Determina qué permiso se necesita según la fuente (cámara o galería)
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    // Verifica el estado del permiso
    PermissionStatus status = await permission.status;

    if (status.isDenied) {
      // Si el permiso está denegado, lo pedimos.
      status = await permission.request();
    }

    if (status.isPermanentlyDenied) {
      // Si está permanentemente denegado, abrimos los ajustes de la app.
      await openAppSettings();
      return null;
    }

    // Si el permiso es concedido, procede a seleccionar la imagen
    if (status.isGranted) {
      try {
        final XFile? pickedFile =
            await _picker.pickImage(source: source, imageQuality: 85);
        return pickedFile != null ? File(pickedFile.path) : null;
      } catch (e) {
        print("Error al seleccionar la imagen: $e");
        return null;
      }
    }

    // Si el permiso no fue concedido por alguna otra razón.
    print("Permiso de ${source.name} no concedido.");
    return null;
  }
}
