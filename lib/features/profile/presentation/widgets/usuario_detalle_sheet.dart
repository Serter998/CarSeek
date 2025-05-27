import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class UsuarioDetalleSheet extends StatefulWidget {
  final Usuario usuario;
  final void Function(TipoUsuario nuevoTipo) onCambiarTipo;
  final void Function(Usuario usuario) onBorrarUsuario;

  const UsuarioDetalleSheet({
    super.key,
    required this.usuario,
    required this.onCambiarTipo,
    required this.onBorrarUsuario,
  });

  @override
  State<UsuarioDetalleSheet> createState() => _UsuarioDetalleSheetState();
}

class _UsuarioDetalleSheetState extends State<UsuarioDetalleSheet> {
  void _mostrarDialogoCambioTipo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: TipoUsuario.values.map((tipo) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(tipo.nombre),
              onTap: () {
                Navigator.pop(ctx);
                widget.onCambiarTipo(tipo);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _mostrarDialogoConfirmacion() {
    final TextEditingController controller = TextEditingController();
    String textoIngresado = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool esConfirmacionValida = textoIngresado.trim().toLowerCase() == 'confirmar';

            return AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Para eliminar este usuario, escribe "confirmar" abajo.'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      setDialogState(() {
                        textoIngresado = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Escribe "confirmar"',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: esConfirmacionValida
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).disabledColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: esConfirmacionValida
                      ? () {
                    Navigator.pop(ctx);
                    widget.onBorrarUsuario(widget.usuario);
                  }
                      : null,
                  child: const Text('Eliminar cuenta'),
                ),
              ],
            );
          },
        );
      },
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
              Text(widget.usuario.nombre, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _infoRow(Icons.person_outline, 'ID: ${widget.usuario.id}'),
              if (widget.usuario.telefono != null)
                _infoRow(Icons.phone, 'Teléfono: ${widget.usuario.telefono}'),
              if (widget.usuario.ubicacion != null)
                _infoRow(Icons.location_on, 'Ubicación: ${widget.usuario.ubicacion}'),
              _infoRow(Icons.star, 'Reputación: ${widget.usuario.reputacion ?? 0}'),
              _infoRow(Icons.badge, 'Tipo: ${widget.usuario.tipoUsuario.nombre}'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    onPressed: _mostrarDialogoConfirmacion,
                  ),
                  const SizedBox(width: 12),
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