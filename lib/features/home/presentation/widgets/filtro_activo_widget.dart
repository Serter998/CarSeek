import 'package:flutter/material.dart';
import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';

class FiltroActivoWidget extends StatelessWidget {
  final FiltroVehiculo filtro;
  final VoidCallback onClear;

  const FiltroActivoWidget({
    super.key,
    required this.filtro,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt, size: 20, color: AppColors.primary),
              const SizedBox(width: 4),
              const Text(
                '',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                filtro.label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Quitar filtro'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
