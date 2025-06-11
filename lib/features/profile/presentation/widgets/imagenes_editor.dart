import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagenesEditor extends StatefulWidget {
  final List<String> imagenesIniciales;
  final ValueChanged<List<String>> onImagenesActualizadas;

  const ImagenesEditor({
    super.key,
    required this.imagenesIniciales,
    required this.onImagenesActualizadas,
  });

  @override
  State<ImagenesEditor> createState() => _ImagenesEditorState();
}

class _ImagenesEditorState extends State<ImagenesEditor> {
  late List<String> _imagenes;

  @override
  void initState() {
    super.initState();
    _imagenes = List.from(widget.imagenesIniciales);
  }

  Future<void> _subirImagen() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) return;

      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final supabase = Supabase.instance.client;
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';

      if (kIsWeb) {
        final Uint8List fileBytes = await pickedImage.readAsBytes();
        await supabase.storage.from('imagenes').uploadBinary(
          fileName,
          fileBytes,
          fileOptions: FileOptions(contentType: mimeType),
        );
      } else {
        final File file = File(pickedImage.path);
        await supabase.storage.from('imagenes').upload(
          fileName,
          file,
          fileOptions: FileOptions(contentType: mimeType),
        );
      }

      final publicUrl = supabase.storage.from('imagenes').getPublicUrl(fileName);

      setState(() {
        _imagenes.add(publicUrl);
      });

      widget.onImagenesActualizadas(_imagenes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo imagen: $e')),
        );
      }
    }
  }

  Future<void> _eliminarImagen(int index) async {
    try {
      final supabase = Supabase.instance.client;
      final String imageUrl = _imagenes[index];

      final uri = Uri.parse(imageUrl);
      final String fileName = uri.pathSegments.last;

      await supabase.storage.from('imagenes').remove([fileName]);

      setState(() {
        _imagenes.removeAt(index);
      });

      widget.onImagenesActualizadas(_imagenes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen eliminada correctamente')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error eliminando imagen: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _imagenes
                .asMap()
                .entries
                .map(
                  (entry) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      entry.value,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _eliminarImagen(entry.key),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            onPressed: _subirImagen,
            icon: const Icon(Icons.upload),
            label: const Text('Subir imagen'),
          ),
        ),
      ],
    );
  }
}
