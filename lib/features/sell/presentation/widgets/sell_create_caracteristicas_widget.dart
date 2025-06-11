import 'package:car_seek/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';

import 'continue_button_widget.dart';

class SellCreateCaracteristicsCard extends StatelessWidget {
  final TextEditingController marcaController;
  final TextEditingController modeloController;
  final TextEditingController anioController;
  final TextEditingController kmController;
  final TipoCombustible? combustibleSeleccionado;
  final TextEditingController cvController;
  final TipoEtiqueta? etiquetaSeleccionada;
  final TextEditingController descripcionController;
  final Function(TipoCombustible?) onCombustibleChanged;
  final Function(TipoEtiqueta?) onEtiquetaChanged;
  final Function onVolver;
  final Function onSave;

  const SellCreateCaracteristicsCard({
    super.key,
    required this.marcaController,
    required this.modeloController,
    required this.anioController,
    required this.kmController,
    required this.combustibleSeleccionado,
    required this.cvController,
    required this.etiquetaSeleccionada,
    required this.descripcionController,
    required this.onCombustibleChanged,
    required this.onEtiquetaChanged,
    required this.onVolver,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Rellene las características de su vehículo",
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Debes introducir valores reales, sino podrás ser baneado.",
                style: TextStyles.subtitleText,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Marca
            _buildInputItem(Icons.factory, 'Marca*', marcaController),
            const SizedBox(height: 16),

            // Modelo
            _buildInputItem(Icons.model_training, 'Modelo*', modeloController),
            const SizedBox(height: 16),

            // Año
            _buildInputItem(Icons.calendar_today, 'Año*', anioController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            const SizedBox(height: 16),

            // Kilómetros
            _buildInputItem(Icons.speed, 'Kilómetros*', kmController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
            ),
            const SizedBox(height: 16),

            // Tipo de combustible
            _buildDropdownItem(
                Icons.local_gas_station,
                'Combustible*',
                TipoCombustible.values,
                combustibleSeleccionado,
                onCombustibleChanged,
            ),
            const SizedBox(height: 16),

            // CV
            _buildInputItem(Icons.electric_bolt, 'CV*', cvController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            const SizedBox(height: 16),

            // Tipo de etiqueta
            _buildDropdownItem(
                Icons.eco,
                'Etiqueta*',
                TipoEtiqueta.values,
                etiquetaSeleccionada,
                onEtiquetaChanged,
            ),
            const SizedBox(height: 16),

            // Descripción
            _buildTextFieldWithIcon(
                Icons.description,
                'Descripción',
                descripcionController
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                ContinueButton(onPressed: () => onVolver(), text: "Volver",),
                ContinueButton(onPressed: () => onSave(), text: "Continuar",),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputItem(
      IconData icon,
      String label,
      TextEditingController controller, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownItem<T>(
      IconData icon,
      String label,
      List<T> items,
      T? selectedValue,
      ValueChanged<T?> onChanged,
      ) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<T>(
            value: selectedValue,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(_getDisplayName(item)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getDisplayName(dynamic item) {
    if (item is TipoCombustible) return item.nombre;
    if (item is TipoEtiqueta) return item.nombre;
    return item.toString();
  }

  Widget _buildTextFieldWithIcon(
      IconData icon,
      String label,
      TextEditingController controller,
      ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}