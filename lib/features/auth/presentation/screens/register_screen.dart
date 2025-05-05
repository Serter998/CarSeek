import 'package:car_seek/core/services/validation_service.dart';
import 'package:car_seek/core/themes/dividers_styles.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
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
            InputText(
              placeholder: "Introduzca su nombre*",
              icon: Icon(Icons.person),
              controller: nombreController,
              toolTip: null,
              isPassword: false,
              longitudMax: 100,
            ),
            InputText(
              placeholder: "Introduzca su correo*",
              icon: Icon(Icons.mail),
              controller: emailController,
              toolTip: "example@mail.com",
              isPassword: false,
              longitudMax: 100,
            ),
            InputText(
              placeholder: "Introduzca su contraseña*",
              icon: Icon(Icons.lock),
              controller: passwordController,
              toolTip: "Longitud minima 8, debe contener 1 mayúscula, 1 minúscula, 1 número y un caracter especial como mínimo.",
              isPassword: true,
              longitudMax: 80,
            ),
            InputText(
              placeholder: "Confirmar contraseña*",
              icon: Icon(Icons.lock_outline),
              controller: passwordConfirmController,
              toolTip: "Longitud minima 8, debe contener 1 mayúscula, 1 minúscula, 1 número y un caracter especial como mínimo.",
              isPassword: true,
              longitudMax: 80,
            ),
            InputText(
              placeholder: "Teléfono (opcional)",
              icon: Icon(Icons.phone),
              controller: telefonoController,
              toolTip: "Ej: 666 666 666",
              isPassword: false,
              longitudMax: 16,
            ),
            InputText(
              placeholder: "Ubicación (opcional)",
              icon: Icon(Icons.location_pin),
              controller: ubicacionController,
              toolTip: null,
              isPassword: false,
              longitudMax: 80,
            ),
            DividersStyles.dividerGray,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RedirectTextButton(
                  function: () {
                    context.read<AuthBloc>().add(OnLoadCredentialsEvent());
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
