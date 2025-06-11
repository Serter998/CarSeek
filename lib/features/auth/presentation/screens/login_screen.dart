import 'package:car_seek/core/themes/dividers_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:car_seek/features/auth/presentation/widgets/remember_checkbox.dart';

class LoginScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;
  final bool rememberMe;

  const LoginScreen({
    super.key,
    this.initialEmail,
    this.initialPassword,
    this.rememberMe = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool rememberMe;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    passwordController = TextEditingController(text: widget.initialPassword);
    rememberMe = widget.rememberMe;
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<AuthBloc>().add(
        OnLoginEvent(email: email, password: password, rememberMe: rememberMe),
      );
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Por favor, ingrese su correo y contraseña",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/CarSeekSinFondo.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          "Iniciar sesión",
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        InputText(
                          placeholder: "Correo electrónico*",
                          icon: const Icon(Icons.mail_outline),
                          controller: emailController,
                          toolTip: null,
                          isPassword: false,
                          longitudMax: 100,
                        ),
                        const SizedBox(height: 16),
                        InputText(
                          placeholder: "Contraseña*",
                          icon: const Icon(Icons.lock_outline),
                          controller: passwordController,
                          toolTip: null,
                          isPassword: true,
                          longitudMax: 80,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RememberMeCheckbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    OnNavigateToForgotPasswordEvent(),
                                  );
                                },
                                child: const Text(
                                  "¿Olvidaste tu contraseña?",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        ActionButton(
                          function: () => _handleLogin(context),
                          text: "Iniciar sesión",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Text("¿Aún no tienes cuenta?", style: textTheme.bodyMedium),
                    RedirectTextButton(
                      function: () {
                        context.read<AuthBloc>().add(OnNavigateToRegisterEvent());
                      },
                      text: "Regístrate aquí",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
