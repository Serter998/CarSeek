import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

class ResponsiveVehicleGrid extends StatelessWidget {
  final List<Vehiculo> vehiculos;
  final Widget Function(Vehiculo vehiculo) itemBuilder;

  const ResponsiveVehicleGrid({
    super.key,
    required this.vehiculos,
    required this.itemBuilder,
  });

  int _calculateCrossAxisCount(double width) {
    if (width >= 2000) return 8;
    if (width >= 1800) return 7;
    if (width >= 1500) return 6;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vehiculos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return itemBuilder(vehiculos[index]);
          },
        );
      },
    );
  }
}
