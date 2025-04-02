import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InputText(isPassword: false, placeholder: "Introduzca su correo*"),
          InputText(isPassword: true, placeholder: "Introduzca su contraseña*"),
          InputText(isPassword: true, placeholder: "Confirmar contraseña*"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RedirectTextButton(function: () {
                context.read<AuthBloc>().add(OnNavigateToLoginEvent());
              }, text: "¿Ya tienes una cuenta? Inicia sesión"),
            ],
          ),
          ActionButton(function: null, text: "Registrarse"),
        ],
      ),
    );
  }
}
