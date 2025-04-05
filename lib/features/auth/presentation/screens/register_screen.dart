import 'package:car_seek/core/services/validation_service.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/password_input_text.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
  TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Crear una cuenta",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(height: 20),
            InputText(
              placeholder: "Introduzca su nombre*",
              controller: nombreController,
            ),
            InputText(
              placeholder: "Introduzca su correo*",
              controller: emailController,
            ),
            PasswordInputText(
              placeholder: "Introduzca su contraseña*",
              controller: passwordController,
            ),
            PasswordInputText(
              placeholder: "Confirmar contraseña*",
              controller: passwordConfirmController,
            ),
            InputText(
              placeholder: "Teléfono (opcional)",
              controller: telefonoController,
            ),
            InputText(
              placeholder: "Ubicación (opcional)",
              controller: ubicacionController,
            ),
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
                function: () {
                  final nombre = nombreController.text.trim();
                  final correo = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final passwordConfirmed = passwordConfirmController.text
                      .trim();
                  final telefono = telefonoController.text.trim();
                  final ubicacion = ubicacionController.text.trim();

                  if (correo.isNotEmpty &&
                      password.isNotEmpty &&
                      passwordConfirmed.isNotEmpty &&
                      nombre.isNotEmpty) {
                    if (ValidationService.isSameString(
                        password, passwordConfirmed)) {
                      if (ValidationService.isCorrectFormat(
                          correo, TextFormat.email)) {
                        if (ValidationService.isCorrectFormat(
                            password, TextFormat.password)) {
                          if(telefono.isNotEmpty) {
                            if(ValidationService.isCorrectFormat(telefono, TextFormat.phone)) {
                              context.read<AuthBloc>().add(
                                OnRegisterEvent(
                                  email: correo,
                                  password: password,
                                  nombre: nombre,
                                  telefono: telefono,
                                  ubicacion: ubicacion,
                                ),
                              );
                            } else {
                              CustomSnackBar.showError(context: context,
                                  message: "Por favor, ingrese un formato de teléfono valido");
                            }
                          } else {
                            context.read<AuthBloc>().add(
                              OnRegisterEvent(
                                email: correo,
                                password: password,
                                nombre: nombre,
                                telefono: telefono,
                                ubicacion: ubicacion,
                              ),
                            );
                          }
                        } else {
                          CustomSnackBar.showError(context: context,
                              message: "Por favor, ingrese un formato de contraseña valido");
                        }
                      } else {
                        CustomSnackBar.showError(context: context,
                            message: "Por favor, ingrese un formato de correo valido");
                      }
                    } else {
                      CustomSnackBar.showError(context: context,
                          message: "Las contraseñas no coinciden");
                    }
                  } else {
                    CustomSnackBar.showWarning(context: context,
                        message: "Por favor, ingrese su correo, nombre y contraseña");
                  }
                },
                text: "Registrarse",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
