import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInitialScreen extends StatefulWidget {
  final Usuario usuario;
  const ProfileInitialScreen({super.key, required this.usuario});

  @override
  State<ProfileInitialScreen> createState() => _ProfileInitialScreenState();
}

class _ProfileInitialScreenState extends State<ProfileInitialScreen> {
  void _handleEditarPerfil() {
    context.read<ProfileBloc>().add(OnNavigateToUpdate());
  }

  void _handleMisVentas() {
    context.read<ProfileBloc>().add(OnEnterEditVehicleEvent());
  }

  void _handleAdministracion() {
    context.read<ProfileBloc>().add(OnNavigateToAdministracion());
  }

  Future<void> _confirmEliminarCuenta() async {
    final TextEditingController _controller = TextEditingController();
    bool isConfirmed = false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('¿Eliminar cuenta?'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Esta acción es irreversible. Si estás seguro, escribe "confirmar" para eliminar tu cuenta permanentemente.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          isConfirmed =
                              value.trim().toLowerCase() == 'confirmar';
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Escribe "confirmar"',
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed:
                      isConfirmed ? () => Navigator.pop(context, true) : null,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      context.read<ProfileBloc>().add(OnDeleteUsuarioEvent());
    }
  }

  Future<void> _confirmCerrarSesion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cerrar sesión?'),
          content: const Text('¿Estás seguro de que deseas cerrar tu sesión?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<ProfileBloc>().add(OnCerrarSesionEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 12,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              'assets/images/CarSeekSinFondo.png',
                              height: 140,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ProfileActionButton(
                            icon: Icons.edit,
                            label: "Editar perfil",
                            onPressed: _handleEditarPerfil,
                          ),
                          const Divider(height: 1),
                          ProfileActionButton(
                            icon: Icons.storefront,
                            label: "Mis ventas",
                            onPressed: _handleMisVentas,
                          ),
                          
                          if (widget.usuario.tipoUsuario == TipoUsuario.mecanico ||
                              widget.usuario.tipoUsuario == TipoUsuario.administrador) ...[
                            const Divider(height: 1),
                            ProfileActionButton(
                              icon: Icons.build,
                              label: "Administración",
                              onPressed: _handleAdministracion,
                            ),
                          ],

                          const Divider(height: 1),
                          DestructiveProfileActionButton(
                            icon: Icons.delete_forever,
                            label: "Eliminar cuenta",
                            onPressed: _confirmEliminarCuenta,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    DestructiveProfileActionButton(
                      icon: Icons.logout,
                      label: "Cerrar sesión",
                      onPressed: _confirmCerrarSesion,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
