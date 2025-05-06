import 'dart:io';

import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/features/sell/presentation/widgets/detalle_vehiculo_widget.dart';
import 'package:car_seek/share/data/repositories/usuario_repository_impl.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_user_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../widgets/continue_button_widget.dart';

class SellCreateSubmitScreen extends StatefulWidget {
  final String titulo;
  final String marca;
  final String modelo;
  final int anio;
  final int km;
  final TipoCombustible tipoCombustible;
  final int cv;
  final TipoEtiqueta tipoEtiqueta;
  final String descripcion;

  const SellCreateSubmitScreen({
    super.key,
    required this.titulo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.km,
    required this.tipoCombustible,
    required this.cv,
    required this.tipoEtiqueta,
    required this.descripcion,
  });

  @override
  State<SellCreateSubmitScreen> createState() => _SellCreateSubmitScreenState();
}

class _SellCreateSubmitScreenState extends State<SellCreateSubmitScreen> {
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  List<String> _imagenes = [];
  final GetCurrentUserUseCase _getCurrentUserUseCase = GetCurrentUserUseCase(
    repository: UsuarioRepositoryImpl(
      userSource: UsuarioSourceImpl(dotenv.env['API_KEY'] ?? ''),
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _precioController.dispose();
    _ubicacionController.dispose();
  }

  Future<void> _subirImagen() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        final String fileName =
            'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final supabase = Supabase.instance.client;

        // Detectar tipo MIME
        final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';

        if (kIsWeb) {
          // Para Web
          final Uint8List fileBytes = await pickedImage.readAsBytes();
          await supabase.storage
              .from('imagenes')
              .uploadBinary(
                fileName,
                fileBytes,
                fileOptions: FileOptions(contentType: mimeType),
              );
        } else {
          // Para móvil
          final File file = File(pickedImage.path);
          await supabase.storage
              .from('imagenes')
              .upload(
                fileName,
                file,
                fileOptions: FileOptions(contentType: mimeType),
              );
        }

        // Obtener URL pública
        final String publicUrl = supabase.storage
            .from('imagenes')
            .getPublicUrl(fileName);

        setState(() {
          _imagenes.add(publicUrl);
        });
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context: context,
          message: 'Error subiendo imagen: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _eliminarImagen(int index) async {
    if (index < 0 || index >= _imagenes.length) return;

    try {
      final String imageUrl = _imagenes[index];
      final supabase = Supabase.instance.client;

      // Extraer el nombre del archivo de la URL
      final Uri uri = Uri.parse(imageUrl);
      final String filePath = uri.pathSegments.last;

      // Eliminar el archivo del almacenamiento
      await supabase.storage.from('imagenes').remove([filePath]);

      // Eliminar de la lista local
      setState(() {
        _imagenes.removeAt(index);
      });

      if (context.mounted) {
        CustomSnackBar.showSuccess(
          context: context,
          message: 'Imagen eliminada correctamente',
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context: context,
          message: 'Error al eliminar la imagen: $e',
        );
      }
    }
  }

  void _volver() {
    context.read<SellBloc>().add(
      OnVolverCaracteristicasSellEvent(
        titulo: widget.titulo,
        anio: widget.anio,
        cv: widget.cv,
        tipoEtiqueta: widget.tipoEtiqueta,
        km: widget.km,
        marca: widget.marca,
        descripcion: widget.descripcion,
        modelo: widget.modelo,
        tipoCombustible: widget.tipoCombustible,
      ),
    );
  }

  Future<void> _publicar() async {
    final titulo = widget.titulo;
    final marca = widget.marca;
    final modelo = widget.modelo;
    final anio = widget.anio;
    final km = widget.km;
    final tipoCombustible = widget.tipoCombustible;
    final cv = widget.cv;
    final tipoEtiqueta = widget.tipoEtiqueta;
    final descripcion = widget.descripcion;
    final precioTexto = _precioController.text.trim();
    final ubicacion = _ubicacionController.text.trim();

    if (precioTexto.isNotEmpty &&
        ubicacion.isNotEmpty &&
        _imagenes.isNotEmpty) {
      try {
        final precio = double.parse(precioTexto.replaceAll(",", "."));
        final resp = await _getCurrentUserUseCase();
        User? user;
        resp.fold((f) => user = null, (u) => user = u);
        if (user != null) {
          Vehiculo vehiculo = Vehiculo(
            idVehiculo: Uuid().v4(),
            idUsuario: user!.id,
            titulo: titulo,
            marca: marca,
            modelo: modelo,
            anio: anio,
            kilometros: km,
            descripcion: descripcion,
            destacado: false,
            ubicacion: ubicacion,
            imagenes: _imagenes,
            tipoCombustible: tipoCombustible,
            cv: cv,
            tipoEtiqueta: tipoEtiqueta,
            precio: precio,
          );
          context.read<SellBloc>().add(OnCreateSellEvent(vehiculo: vehiculo));
        }
      } catch (e) {
        CustomSnackBar.showError(
          context: context,
          message: "Error al parsear los datos. Contacte con soporte.",
        );
      }
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Por favor, rellena todos los campos con *.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetalleVehiculoWidget(
                titulo: widget.titulo,
                marca: widget.marca,
                modelo: widget.modelo,
                anio: widget.anio.toString(),
                km: widget.km.toString(),
                cv: widget.cv.toString(),
                descripcion: widget.descripcion,
                tipoCombustible: widget.tipoCombustible,
                tipoEtiqueta: widget.tipoEtiqueta,
              ),
              const SizedBox(height: 32),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _precioController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,10}(,\d{0,2})?$'),
                          ),
                          LengthLimitingTextInputFormatter(8)
                        ],
                        decoration: InputDecoration(
                          labelText: 'Precio*',
                          prefixIcon: const Icon(Icons.euro),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _ubicacionController,
                        decoration: InputDecoration(
                          labelText: 'Ubicación*',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Imágenes del vehículo*",
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ..._imagenes.asMap().entries.map(
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
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () => _eliminarImagen(entry.key),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _subirImagen,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(),
                                    ),
                                    child: const Icon(Icons.add_a_photo),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  ContinueButton(onPressed: _volver, text: "Volver"),
                  ContinueButton(
                    onPressed: _publicar,
                    text: "Publicar anuncio",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
