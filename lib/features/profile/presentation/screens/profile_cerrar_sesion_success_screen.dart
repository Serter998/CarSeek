import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/core/services/navigation_service.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCerrarSesionSuccessScreen extends StatelessWidget {
  final String mensaje;
  const ProfileCerrarSesionSuccessScreen({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProfileBloc>().add(OnNavigateToInitial());
      context.read<AuthBloc>().add(OnNavigateToLoginEvent());
      CustomSnackBar.show(context: context, message: mensaje, backgroundColor: AppColors.primary);
      await NavigationService.navigateToAndRemoveUntil(context, "/");
    });
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
