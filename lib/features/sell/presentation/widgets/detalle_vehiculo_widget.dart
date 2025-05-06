import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:flutter/material.dart';

class DetalleVehiculoWidget extends StatelessWidget {
  final String titulo;
  final String marca;
  final String modelo;
  final String anio;
  final String km;
  final String cv;
  final String descripcion;
  final TipoCombustible tipoCombustible;
  final TipoEtiqueta tipoEtiqueta;

  const DetalleVehiculoWidget({
    super.key,
    required this.titulo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.km,
    required this.cv,
    required this.descripcion,
    required this.tipoCombustible,
    required this.tipoEtiqueta,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car, size: 40),
                const SizedBox(height: 8),
                Text("Título: $titulo", style: textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 12),

                _buildInfoItem(Icons.factory, "Marca", marca),
                _buildInfoItem(Icons.model_training, "Modelo", modelo),
                _buildInfoItem(Icons.calendar_today, "Año", anio),
                _buildInfoItem(Icons.speed, "Kilómetros", km),
                _buildInfoItem(Icons.local_gas_station, "Combustible", tipoCombustible.nombre),
                _buildInfoItem(Icons.electric_bolt, "CV", cv),
                _buildInfoItem(Icons.eco, "Etiqueta", tipoEtiqueta.nombre),

                const SizedBox(height: 16),
                // Descripción alineada a la izquierda
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.description, size: 20),
                    const SizedBox(width: 8),
                    Text("Descripción:", style: textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    descripcion,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
