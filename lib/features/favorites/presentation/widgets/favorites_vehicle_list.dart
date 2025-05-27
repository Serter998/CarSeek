import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/features/home/presentation/widgets/vehicle_card.dart';

class FavoritesVehicleList extends StatelessWidget {
  final List<Vehiculo> vehiculos;
  final String searchQuery;
  final void Function(Vehiculo) onToggleFavorite;
  final void Function(Vehiculo) onTapVehicle;

  const FavoritesVehicleList({
    Key? key,
    required this.vehiculos,
    required this.searchQuery,
    required this.onToggleFavorite,
    required this.onTapVehicle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredVehiculos = vehiculos.where((vehiculo) {
      final title = vehiculo.titulo?.toLowerCase() ?? '';
      final description = vehiculo.descripcion?.toLowerCase() ?? '';
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();

    if (filteredVehiculos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            searchQuery.isEmpty
                ? 'No tienes vehículos favoritos'
                : 'No se encontraron resultados para "$searchQuery".',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return SizedBox(
        height: 320,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.85),
          itemCount: filteredVehiculos.length,
          itemBuilder: (context, index) {
            final vehiculo = filteredVehiculos[index];
            return Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 20,
                bottom: 100,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                constraints: const BoxConstraints(
                  maxHeight: 280,
                ),
                child: MarketplaceVehicleCard(
                  vehiculo: vehiculo,
                  isFavorite: true,
                  onToggleFavorite: () => onToggleFavorite(vehiculo),
                  onTap: () => onTapVehicle(vehiculo),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: filteredVehiculos.length,
            itemBuilder: (context, index) {
              final vehiculo = filteredVehiculos[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: MarketplaceVehicleCard(
                  vehiculo: vehiculo,
                  isFavorite: true,
                  onToggleFavorite: () => onToggleFavorite(vehiculo),
                  onTap: () => onTapVehicle(vehiculo),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}