import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAdministracionScreen extends StatefulWidget {
  final Usuario usuario;

  const ProfileAdministracionScreen({super.key, required this.usuario});

  @override
  State<ProfileAdministracionScreen> createState() =>
      _ProfileAdministracionScreenState();
}

class _ProfileAdministracionScreenState
    extends State<ProfileAdministracionScreen> {
  void _handleVerificaciones() {
    context.read<ProfileBloc>().add(OnNavigateToAdministracionVerificaciones());
  }

  void _handleGestionUsuarios() {
    context.read<ProfileBloc>().add(OnNavigateToAdministracionUsuarios());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    ProfileActionButton(
                      icon: Icons.verified_outlined,
                      label: "Verificaciones",
                      onPressed: _handleVerificaciones,
                    ),
                    const Divider(height: 1),
                    if (widget.usuario.tipoUsuario == TipoUsuario.administrador)
                      ProfileActionButton(
                        icon: Icons.security,
                        label: "Gestión de Usuarios",
                        onPressed: _handleGestionUsuarios,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
