import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

class VehiculoDetalleSheet extends StatelessWidget {
  final Vehiculo vehiculo;
  final void Function(Vehiculo vehiculo) onAprobar;
  final void Function(Vehiculo vehiculo) onRechazar;
  final void Function(Vehiculo vehiculo) onEliminar;

  const VehiculoDetalleSheet({
    super.key,
    required this.vehiculo,
    required this.onAprobar,
    required this.onRechazar,
    required this.onEliminar,
  });

  void _confirmarAccion(
      BuildContext context,
      String accion,
      VoidCallback onConfirmar,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$accion vehículo'),
        content: Text(
          '¿Estás seguro de que quieres $accion este vehículo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accion == 'Eliminar' ? Colors.red : null,
            ),
            child: Text(accion),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }

  Widget _verificacionEstado(BuildContext context) {
    final bool? verificado = vehiculo.verificado;
    final Color color;
    final String texto;
    final IconData icon;

    if (verificado == true) {
      color = Colors.green;
      texto = 'Verificado';
      icon = Icons.verified;
    } else {
      color = Colors.grey;
      texto = 'No verificado';
      icon = Icons.verified_outlined;
    }

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          texto,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehiculo.titulo,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _verificacionEstado(context),
              const SizedBox(height: 16),

              _infoRow(Icons.directions_car, '${vehiculo.marca} ${vehiculo.modelo}'),
              _infoRow(Icons.calendar_today, 'Año: ${vehiculo.anio}'),
              _infoRow(Icons.speed, 'Kilómetros: ${vehiculo.kilometros} km'),
              _infoRow(Icons.bolt, 'Potencia: ${vehiculo.cv} CV'),
              _infoRow(Icons.local_gas_station, 'Combustible: ${vehiculo.tipoCombustible.nombre}'),
              _infoRow(Icons.eco, 'Etiqueta: ${vehiculo.tipoEtiqueta.nombre}'),
              _infoRow(Icons.attach_money, 'Precio: €${vehiculo.precio.toStringAsFixed(2)}'),

              if (vehiculo.ubicacion != null)
                _infoRow(Icons.location_on_outlined, vehiculo.ubicacion!),

              if (vehiculo.descripcion != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Descripción:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(vehiculo.descripcion!),
              ],

              const SizedBox(height: 24),

              // Verificar y Rechazar en una fila
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _confirmarAccion(context, 'Verificar', () => onAprobar(vehiculo)),
                    icon: const Icon(Icons.check),
                    label: const Text('Verificar'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _confirmarAccion(context, 'Rechazar', () => onRechazar(vehiculo)),
                    icon: const Icon(Icons.close),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Botón de Eliminar debajo
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () => _confirmarAccion(context, 'Eliminar', () => onEliminar(vehiculo)),
                    icon: Icon(Icons.delete_forever, color: Colors.red.shade800),
                    label: Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}