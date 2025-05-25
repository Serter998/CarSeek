import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:car_seek/features/profile/presentation/widgets/imagenes_editor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileVehicleDetailScreen extends StatefulWidget {
  final Vehiculo vehiculo;

  const ProfileVehicleDetailScreen({super.key, required this.vehiculo});

  @override
  State<ProfileVehicleDetailScreen> createState() =>
      _ProfileVehicleDetailScreenState();
}

class _ProfileVehicleDetailScreenState
    extends State<ProfileVehicleDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tituloController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anioController;
  late TextEditingController _kilometrosController;
  late TextEditingController _cvController;
  late TextEditingController _precioController;
  late TextEditingController _ubicacionController;
  late TextEditingController _descripcionController;

  TipoCombustible _tipoCombustible = TipoCombustible.gasolina;
  TipoEtiqueta _tipoEtiqueta = TipoEtiqueta.c;
  late List<String> _imagenes;

  @override
  void initState() {
    super.initState();
    final v = widget.vehiculo;

    _tituloController = TextEditingController(text: v.titulo);
    _marcaController = TextEditingController(text: v.marca);
    _modeloController = TextEditingController(text: v.modelo);
    _anioController = TextEditingController(text: v.anio.toString());
    _kilometrosController = TextEditingController(
      text: v.kilometros.toString(),
    );
    _cvController = TextEditingController(text: v.cv.toString());
    _precioController = TextEditingController(text: v.precio.toString());
    _ubicacionController = TextEditingController(text: v.ubicacion ?? '');
    _descripcionController = TextEditingController(text: v.descripcion ?? '');
    _tipoCombustible = v.tipoCombustible;
    _tipoEtiqueta = v.tipoEtiqueta;
    _imagenes = List.from(v.imagenes);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _kilometrosController.dispose();
    _cvController.dispose();
    _precioController.dispose();
    _ubicacionController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? type,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: inputDecoration(label, icon),
      validator:
          required
              ? (val) =>
                  (val == null || val.isEmpty) ? 'Campo obligatorio' : null
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          Widget rowOrColumn(Widget left, Widget right) {
            return isWide
                ? Row(
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 16),
                    Expanded(child: right),
                  ],
                )
                : Column(children: [left, const SizedBox(height: 16), right]);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ImagenesEditor(
                            imagenesIniciales: _imagenes,
                            onImagenesActualizadas: (nuevas) {
                              setState(() => _imagenes = nuevas);
                            },
                          ),
                          const SizedBox(height: 24),
                          buildField(
                            _tituloController,
                            'Título',
                            Icons.title,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          rowOrColumn(
                            buildField(
                              _marcaController,
                              'Marca',
                              Icons.directions_car,
                            ),
                            buildField(
                              _modeloController,
                              'Modelo',
                              Icons.car_repair,
                            ),
                          ),
                          const SizedBox(height: 16),
                          rowOrColumn(
                            buildField(
                              _anioController,
                              'Año',
                              Icons.calendar_today,
                              type: TextInputType.number,
                            ),
                            buildField(
                              _kilometrosController,
                              'Kilómetros',
                              Icons.speed,
                              type: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 16),
                          rowOrColumn(
                            buildField(
                              _cvController,
                              'CV',
                              Icons.flash_on,
                              type: TextInputType.number,
                            ),
                            buildField(
                              _precioController,
                              'Precio (€)',
                              Icons.euro,
                              type: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 16),
                          buildField(
                            _ubicacionController,
                            'Ubicación',
                            Icons.location_on,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descripcionController,
                            maxLines: 4,
                            decoration: inputDecoration(
                              'Descripción',
                              Icons.description,
                            ),
                          ),
                          const SizedBox(height: 16),
                          rowOrColumn(
                            DropdownButtonFormField<TipoCombustible>(
                              value: _tipoCombustible,
                              decoration: inputDecoration(
                                'Combustible',
                                Icons.local_gas_station,
                              ),
                              onChanged:
                                  (val) =>
                                      setState(() => _tipoCombustible = val!),
                              items:
                                  TipoCombustible.values
                                      .map(
                                        (tipo) => DropdownMenuItem(
                                          value: tipo,
                                          child: Text(tipo.nombre),
                                        ),
                                      )
                                      .toList(),
                            ),
                            DropdownButtonFormField<TipoEtiqueta>(
                              value: _tipoEtiqueta,
                              decoration: inputDecoration(
                                'Etiqueta',
                                Icons.eco,
                              ),
                              onChanged:
                                  (val) => setState(() => _tipoEtiqueta = val!),
                              items:
                                  TipoEtiqueta.values
                                      .map(
                                        (tipo) => DropdownMenuItem(
                                          value: tipo,
                                          child: Text(tipo.nombre),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _confirmarBorrado,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Borrar publicación',
                          style: TextStyle(color: Colors.red),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            guardarCambios();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Guardar',
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool isDataNotEmpty(
    String marca,
    String modelo,
    String anio,
    String km,
    TipoCombustible? combustibleSeleccionado,
    String cv,
    TipoEtiqueta? tipoEtiqueta,
    String precioTexto,
    String ubicacion,
  ) {
    return marca.isNotEmpty &&
        modelo.isNotEmpty &&
        anio.isNotEmpty &&
        km.isNotEmpty &&
        combustibleSeleccionado != null &&
        cv.isNotEmpty &&
        tipoEtiqueta != null &&
        precioTexto.isNotEmpty &&
        ubicacion.isNotEmpty &&
        _imagenes.isNotEmpty;
  }

  void guardarCambios() {
    final titulo = _tituloController;
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final anioTexto = _anioController.text.trim();
    final kmTexto = _kilometrosController.text.trim();
    final combustibleSeleccionado = _tipoCombustible;
    final cvTexto = _cvController.text.trim();
    final tipoEtiqueta = _tipoEtiqueta;
    final descripcion = _descripcionController.text.trim();
    final precioTexto = _precioController.text.trim();
    final ubicacion = _ubicacionController.text.trim();

    if (isDataNotEmpty(
      marca,
      modelo,
      anioTexto,
      kmTexto,
      combustibleSeleccionado,
      cvTexto,
      tipoEtiqueta,
      precioTexto,
      ubicacion
    )) {
      try {
        final anio = int.parse(anioTexto);
        final km = int.parse(kmTexto);
        final cv = int.parse(cvTexto);
        final precio = double.parse(precioTexto.replaceAll(",", "."));
        if (anio > 1900 && anio < DateTime.now().year + 1) {
          Vehiculo vehiculoActualizado = Vehiculo(
            idVehiculo: widget.vehiculo.idVehiculo,
            idUsuario: widget.vehiculo.idUsuario,
            titulo: titulo.text.trim(),
            marca: marca,
            modelo: modelo,
            anio: anio,
            kilometros: km,
            tipoCombustible: combustibleSeleccionado,
            cv: cv,
            tipoEtiqueta: tipoEtiqueta,
            precio: precio,
            ubicacion: ubicacion,
            descripcion: descripcion,
            imagenes: _imagenes,
            fechaCreacion: widget.vehiculo.fechaCreacion,
            fechaActualizacion: DateTime.now(),
          );
          context.read<ProfileBloc>().add(OnEditVehicleEvent(vehiculo: vehiculoActualizado));
          CustomSnackBar.show(
            context: context,
            message: "Cambios guardados con éxito.",
            backgroundColor: Colors.white10,
          );
        } else {
          CustomSnackBar.showWarning(
            context: context,
            message:
                "Debes introducir un año entre 1901 y el ${DateTime.now().year}.",
          );
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

  void borrarPublicacion() {
    context.read<ProfileBloc>().add(OnDeleteVehiculoEvent(vehiculo: widget.vehiculo));
    CustomSnackBar.show(
      context: context,
      message: "Vehículo borrado con éxito.",
      backgroundColor: Colors.white10,
    );
  }

  void _confirmarBorrado() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirmar borrado'),
            content: const Text(
              '¿Estás seguro de que quieres borrar esta publicación?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  borrarPublicacion();
                },
                child: const Text(
                  'Borrar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
