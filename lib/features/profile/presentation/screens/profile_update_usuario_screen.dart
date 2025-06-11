import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/core/services/validation_service.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../share/domain/entities/usuario.dart';

class ProfileUpdateUsuarioScreen extends StatefulWidget {
  final User user;
  final Usuario usuario;

  const ProfileUpdateUsuarioScreen({
    super.key,
    required this.user,
    required this.usuario,
  });

  @override
  State<ProfileUpdateUsuarioScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<ProfileUpdateUsuarioScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController reputacionController = TextEditingController();

  String tipoUsuarioSeleccionado = 'cliente';
  double reputacion = 0.0;

  @override
  void initState() {
    emailController.text = widget.user.email ?? "";
    nombreController.text = widget.usuario.nombre ?? "";
    telefonoController.text = widget.usuario.telefono ?? "";
    ubicacionController.text = widget.usuario.ubicacion ?? "";
    tipoUsuarioSeleccionado = widget.usuario.tipoUsuario.nombre ?? "";
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nombreController.dispose();
    telefonoController.dispose();
    ubicacionController.dispose();
    reputacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: LucideIcons.mail,
                        readOnly: true,
                      ),
                      _buildTextField(
                        controller: nombreController,
                        label: 'Nombre*',
                        icon: LucideIcons.user,
                      ),
                      _buildTextField(
                        controller: telefonoController,
                        label: 'Teléfono',
                        icon: LucideIcons.phone,
                        inputType: TextInputType.phone,
                      ),
                      _buildTextField(
                        controller: ubicacionController,
                        label: 'Ubicación',
                        icon: LucideIcons.mapPin,
                      ),
                      const SizedBox(height: 8),
                      _buildReputacionDisplay(
                        label: 'Reputación',
                        icon: LucideIcons.star,
                        value: reputacion,
                      ),
                      const SizedBox(height: 8),
                      _buildTipoUsuarioDisplay(
                        label: 'Tipo de Usuario',
                        icon: LucideIcons.userCog,
                        value: tipoUsuarioSeleccionado,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(LucideIcons.save),
                  label: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    String? nombre = nombreController.text.toString();
    String? telefono = telefonoController.text.toString();
    String? ubicacion = ubicacionController.text.toString();
    if (nombre.isNotEmpty) {
      if (nombre == widget.usuario.nombre &&
          telefono == widget.usuario.telefono &&
          ubicacion == widget.usuario.ubicacion) {
        CustomSnackBar.showWarning(
          context: context,
          message: "Debes modificar algún campo para poder guardar.",
        );
      } else {
        if(telefono.isNotEmpty) {
          if(!ValidationService.isCorrectFormat(telefono, TextFormat.phone)) {
            CustomSnackBar.showWarning(
              context: context,
              message: "Debes introducir un número de telefono valido(666 666 666).",
            );
            return;
          }
        }
        Usuario usuarioModed = Usuario(
          id: widget.usuario.id,
          userId: widget.usuario.userId,
          nombre: nombre,
          telefono: telefono,
          ubicacion: ubicacion,
          reputacion: widget.usuario.reputacion,
          fechaRegistro: widget.usuario.fechaRegistro,
          fechaActualizacion: DateTime.now(),
          tipoUsuario: widget.usuario.tipoUsuario,
        );
        context.read<ProfileBloc>().add(
          OnUpdateUsuarioEvent(usuario: usuarioModed),
        );
        CustomSnackBar.show(
          context: context,
          message: "Perfil actualizado con éxito.",
          backgroundColor: AppColors.primary,
        );
      }
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Debes rellenar los campos con *.",
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildReputacionDisplay({
    required String label,
    required IconData icon,
    required double value,
  }) {
    const int totalStars = 5;
    double normalized = value / 2.0; // 0–10 → 0–5
    int fullStars = normalized.floor();
    bool hasHalfStar = (normalized - fullStars) >= 0.5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: List.generate(totalStars, (index) {
                if (index < fullStars) {
                  return const Icon(
                    LucideIcons.star,
                    color: Colors.amber,
                    size: 20,
                  );
                } else if (index == fullStars && hasHalfStar) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Icon(
                        LucideIcons.star,
                        color: Theme.of(context).disabledColor,
                        size: 20,
                      ),
                      ClipRect(
                        clipper: _HalfClipper(),
                        child: const Icon(
                          LucideIcons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Icon(
                    LucideIcons.star,
                    color: Theme.of(context).disabledColor,
                    size: 20,
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipoUsuarioDisplay({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value[0].toUpperCase() + value.substring(1),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0.0, 0.0, size.width / 2, size.height);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
