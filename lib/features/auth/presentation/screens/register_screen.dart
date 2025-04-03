import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/password_input_text.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Crear una cuenta", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            InputText(isPassword: false, placeholder: "Introduzca su nombre*"),
            InputText(isPassword: false, placeholder: "Introduzca su correo*"),
            PasswordInputText(placeholder:"Introduzca su contraseña*"),
            PasswordInputText(placeholder:"Confirmar contraseña*"),
            InputText(isPassword: false, placeholder: "Teléfono (opcional)"),
            InputText(isPassword: false, placeholder: "Ubicación (opcional)"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RedirectTextButton(
                  function: () {
                    context.read<AuthBloc>().add(OnNavigateToLoginEvent());
                  },
                  text: "¿Ya tienes una cuenta? Inicia sesión",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ActionButton(
                function: null,
                text: "Registrarse",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
