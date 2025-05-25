import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class UsuarioDetalleSheet extends StatelessWidget {
  final Usuario usuario;
  final void Function(TipoUsuario nuevoTipo) onCambiarTipo;

  const UsuarioDetalleSheet({super.key, required this.usuario, required this.onCambiarTipo});

  void _mostrarDialogoCambioTipo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: TipoUsuario.values.map((tipo) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(tipo.nombre),
              onTap: () {
                Navigator.pop(ctx);
                onCambiarTipo(tipo);
              },
            );
          }).toList(),
        ),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usuario.nombre, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _infoRow(Icons.person_outline, 'ID: ${usuario.id}'),
              if (usuario.telefono != null)
                _infoRow(Icons.phone, 'Teléfono: ${usuario.telefono}'),
              if (usuario.ubicacion != null)
                _infoRow(Icons.location_on, 'Ubicación: ${usuario.ubicacion}'),
              _infoRow(Icons.star, 'Reputación: ${usuario.reputacion ?? 0}'),
              _infoRow(Icons.badge, 'Tipo: ${usuario.tipoUsuario.nombre}'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Cambiar tipo'),
                    onPressed: () => _mostrarDialogoCambioTipo(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}