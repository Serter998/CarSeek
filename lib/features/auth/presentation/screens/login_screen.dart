import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:car_seek/features/auth/presentation/widgets/password_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InputText(
            placeholder: "Introduzca su correo*",
            controller: emailController,
          ),
          PasswordInputText(
            placeholder: "Introduzca su contraseña*",
            controller: passwordController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RedirectTextButton(
                function:
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Proximamente...",
                        ),
                      ),
                    ),
                text: "¿Has olvidado tu contraseña?",
              ),
              RedirectTextButton(
                function: () {
                  context.read<AuthBloc>().add(OnNavigateToRegisterEvent());
                },
                text: "¿Aún no estás registrado?",
              ),
            ],
          ),
          const SizedBox(height: 10),
          ActionButton(
            function: () {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isNotEmpty && password.isNotEmpty) {
                context.read<AuthBloc>().add(
                  OnLoginEvent(email: email, password: password),
                );
              } else {
                CustomSnackBar.showWarning(context: context,
                    message: "Por favor, ingrese su correo y contraseña");
              }
            },
            text: "Iniciar sesión",
          ),
        ],
      ),
    );
  }
}
