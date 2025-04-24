import 'package:car_seek/core/themes/dividers_styles.dart';
import 'package:car_seek/core/themes/text_styles.dart';
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            CustomSnackBar.showSuccess(
              context: context,
              message: state.message,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Introduce tu correo electrónico para restablecer tu contraseña",
                  style: TextStyles.defaultText,
                  textAlign: TextAlign.left,
                ),
              ),
              InputText(
                placeholder: "Correo electrónico*",
                icon: Icon(Icons.mail),
                controller: emailController,
                toolTip: null,
                isPassword: false,
                longitudMax: 100,
              ),
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
              DividersStyles.dividerGray,
              RedirectTextButton(
                function: () {
                  context.read<AuthBloc>().add(OnLoadCredentialsEvent());
                },
                text: "Volver al Inicio de Sesión",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
