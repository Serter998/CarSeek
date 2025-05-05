import 'package:car_seek/core/themes/text_styles.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellCreateCaracteristicsScreen extends StatefulWidget {
  final String titulo;

  const SellCreateCaracteristicsScreen({super.key, required this.titulo});

  @override
  State<SellCreateCaracteristicsScreen> createState() =>
      _SellCreateCaracteristicsScreenState();
}

class _SellCreateCaracteristicsScreenState
    extends State<SellCreateCaracteristicsScreen> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  TipoCombustible? _combustibleSeleccionado;
  final TextEditingController _cvController = TextEditingController();
  TipoEtiqueta? _etiquetaSeleccionada;
  final TextEditingController _descripcionController = TextEditingController();

  void _continuar() {
    final titulo = widget.titulo;
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final anioTexto = _anioController.text.trim();
    final kmTexto = _kmController.text.trim();
    final combustibleSeleccionado = _combustibleSeleccionado;
    final cvTexto = _cvController.text.trim();
    final tipoEtiqueta = _etiquetaSeleccionada;
    final descripcion = _descripcionController.text.trim();

    if (isDataNotEmpty(
      marca,
      modelo,
      anioTexto,
      kmTexto,
      combustibleSeleccionado,
      cvTexto,
      tipoEtiqueta,
    )) {
      try {
        final anio = int.parse(anioTexto);
        final km = int.parse(kmTexto);
        final cv = int.parse(cvTexto);
        context.read<SellBloc>().add(OnSetCaracteristicasEvent(titulo: titulo,
            marca: marca,
            modelo: modelo,
            anio: anio,
            km: km,
            combustibleSeleccionado: combustibleSeleccionado!,
            cv: cv,
            tipoEtiqueta: tipoEtiqueta!,
            descripcion: descripcion));
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

  bool isDataNotEmpty(String marca,
      String modelo,
      String anio,
      String km,
      TipoCombustible? combustibleSeleccionado,
      String cv,
      TipoEtiqueta? tipoEtiqueta,) {
    return marca.isNotEmpty &&
        modelo.isNotEmpty &&
        anio.isNotEmpty &&
        km.isNotEmpty &&
        combustibleSeleccionado != null &&
        cv.isNotEmpty &&
        tipoEtiqueta != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Rellene las características de su vehículo",
                      style: TextStyles.titleText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Debes introducir valores reales, sino podrás ser baneado.",
                      style: TextStyles.subtitleText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Agrupación de campos
              _buildInputField(
                  _marcaController, 'Escribe la marca del vehículo aquí*'),
              const SizedBox(height: 24),

              _buildInputField(
                  _modeloController, 'Escribe el modelo del vehículo aquí*'),
              const SizedBox(height: 24),

              _buildInputField(
                _anioController,
                'Escribe el año del vehículo aquí*',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              const SizedBox(height: 24),

              _buildInputField(
                _kmController,
                'Escribe los km del vehículo aquí*',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<TipoCombustible>(
                value: _combustibleSeleccionado,
                onChanged: (TipoCombustible? newValue) {
                  setState(() {
                    _combustibleSeleccionado = newValue;
                  });
                },
                decoration: _dropdownDecoration(
                    'Selecciona el tipo de combustible*'),
                items: TipoCombustible.values.map((tipo) {
                  return DropdownMenuItem<TipoCombustible>(
                    value: tipo,
                    child: Text(tipo.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              _buildInputField(
                _cvController,
                'Escribe los cv del vehículo aquí*',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<TipoEtiqueta>(
                value: _etiquetaSeleccionada,
                onChanged: (TipoEtiqueta? newValue) {
                  setState(() {
                    _etiquetaSeleccionada = newValue;
                  });
                },
                decoration: _dropdownDecoration(
                    'Selecciona el tipo de etiqueta*'),
                items: TipoEtiqueta.values.map((tipo) {
                  return DropdownMenuItem<TipoEtiqueta>(
                    value: tipo,
                    child: Text(tipo.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _descripcionController,
                maxLines: 6,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText:
                  'Aquí puedes especificar detalles de tu vehículo, como si tiene algún problema el vehículo, alguna modificación, etc...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      String label, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
      ),
    );
  }
}
