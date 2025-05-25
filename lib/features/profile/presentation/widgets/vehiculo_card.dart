import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:flutter/material.dart';

class VehiculoCard extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback onTap;

  const VehiculoCard({super.key, required this.vehiculo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Imagen
              if (vehiculo.imagenes.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    vehiculo.imagenes.first,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 100,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_car),
                ),
              const SizedBox(width: 12),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehiculo.marca} ${vehiculo.modelo}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehiculo.anio} · ${vehiculo.kilometros} km',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehiculo.precio.toStringAsFixed(2)} €',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Icono de verificación
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 4),
                child: Icon(
                  vehiculo.verificado == true
                      ? Icons.verified
                      : Icons.verified_outlined,
                  color: vehiculo.verificado == true
                      ? Colors.green
                      : Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
