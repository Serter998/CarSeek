import 'package:car_seek/core/themes/dividers_styles.dart';
import 'package:car_seek/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
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
    final textTheme = Theme.of(context).textTheme;

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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Introduce tu correo electrónico para restablecer tu contraseña",
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      InputText(
                        placeholder: "Correo electrónico*",
                        icon: const Icon(Icons.mail),
                        controller: emailController,
                        toolTip: null,
                        isPassword: false,
                        longitudMax: 100,
                      ),
                      const SizedBox(height: 24),
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
                      DividersStyles.dividerGray,
                      const SizedBox(height: 16),
                      Center(
                        child: RedirectTextButton(
                          function: () {
                            context.read<AuthBloc>().add(OnLoadCredentialsEvent());
                          },
                          text: "Volver al Inicio de Sesión",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}