import 'package:flutter/material.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:car_seek/core/services/validation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Introduce tu correo electrónico para restablecer tu contraseña",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            InputText(
              placeholder: "Correo electrónico*",
              controller: emailController,
            ),
            const SizedBox(height: 20),
            ActionButton(
              function: () {
                final email = emailController.text.trim();

                if (email.isNotEmpty) {
                  if (ValidationService.isCorrectFormat(email, TextFormat.email)) {
                    context.read<AuthBloc>().add(OnForgotPasswordEvent(email: email));
                  } else {
                    CustomSnackBar.showError(
                      context: context,
                      message: "Por favor, ingrese un correo válido",
                    );
                  }
                } else {
                  CustomSnackBar.showWarning(
                    context: context,
                    message: "Por favor, ingrese su correo electrónico",
                  );
                }
              },
              text: "Enviar enlace de restablecimiento",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RedirectTextButton(
                  function: () {
                    context.read<AuthBloc>().add(OnNavigateToLoginEvent());
                  },
                  text: "Volver al Inicio de Sesión",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
