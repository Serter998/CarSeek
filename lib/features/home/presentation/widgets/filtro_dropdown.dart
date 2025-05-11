import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:flutter/material.dart';

class FiltroDropdown extends StatelessWidget {
  final FiltroVehiculo? selectedFiltro;
  final void Function(FiltroVehiculo) onFiltroSeleccionado;

  const FiltroDropdown({
    super.key,
    required this.selectedFiltro,
    required this.onFiltroSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FiltroVehiculo>(
      onSelected: onFiltroSeleccionado,
      icon: const Icon(Icons.filter_list),
      itemBuilder: (context) {
        return FiltroVehiculo.values.map((filtro) {
          final isSelected = filtro == selectedFiltro;

          return CheckedPopupMenuItem<FiltroVehiculo>(
            value: filtro,
            checked: isSelected,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                filtro.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
