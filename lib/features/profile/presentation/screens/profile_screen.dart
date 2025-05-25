import 'package:car_seek/core/navigation/navigation_widget.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/profile/presentation/screens/administracion/profile_administracion_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/administracion/profile_administracion_usuarios_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/administracion/profile_administracion_verificaciones_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_cerrar_sesion_success_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_edit_vehicles_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_error_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_initial_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_update_usuario_screen.dart';
import 'package:car_seek/features/profile/presentation/screens/profile_vehicle_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    final state = context.read<ProfileBloc>().state;
    if (state is! ProfileInitial) {
      context.read<ProfileBloc>().add(OnNavigateToInitial());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            // Si el estado es PublishInitial, no mostrar el botón de atrás
            if (state is ProfileInitial || state is ProfileUpdateSuccess) {
              return Icon(Icons.person);
            } else if(state is ProfileUpdateVehicle) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<ProfileBloc>().add(OnNavigateToUpdateVehicles());
                },
              );
            } else if(state is ProfileAdministracionVerificaciones || state is ProfileAdministracionUsuarios) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<ProfileBloc>().add(OnNavigateToAdministracion());
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<ProfileBloc>().add(OnNavigateToInitial());
                },
              );
            }
          },
        ),
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileInitial) {
              return const Text("Mi Perfil");
            } else if (state is ProfileUpdate) {
              return const Text("Modificar perfil");
            } else if (state is ProfileEditVehicles) {
              return const Text("Mis Ventas");
            } else if (state is ProfileUpdateVehicle) {
              return const Text("Actualizar Vehiculo");
            } else if (state is ProfileUpdateVehicleSuccess) {
              return const Text("Mi Perfil");
            } else if (state is ProfileLoading) {
              return const Text("Cargando");
            } else if (state is ProfileUpdateSuccess) {
              return const Text("Mi perfil");
            } else if (state is ProfileDeleteSuccess) {
              return const Text("Éxito al eliminar la cuenta");
            } else if (state is ProfileCerrarSesionSuccess) {
              return const Text("Éxito al cerrar sesión");
            } else if (state is ProfileAdministracion) {
              return const Text("Panel de Administración");
            } else if (state is ProfileAdministracionVerificaciones) {
              return const Text("Verificar vehiculos");
            } else if (state is ProfileAdministracionUsuarios) {
              return const Text("Gestión de Usuarios");
            } else {
              return const Text("Error desconocido");
            }
          },
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          switch (state) {
            case ProfileLoading():
              return const Center(child: CircularProgressIndicator());
            case ProfileInitial():
              return ProfileInitialScreen(usuario: state.usuario,);
            case ProfileUpdate():
              return ProfileUpdateUsuarioScreen(
                user: state.user,
                usuario: state.usuario,
              );
            case ProfileEditVehicles():
              return ProfileEditVehiclesScreen(vehiculos: state.vehiculos!);
            case ProfileUpdateVehicle():
              return ProfileVehicleDetailScreen(vehiculo: state.vehiculo);
            case ProfileUpdateSuccess():
              return ProfileInitialScreen(usuario: state.usuario,);
            case ProfileDeleteSuccess():
              return ProfileCerrarSesionSuccessScreen(
                mensaje: "¡Cuenta borrada con éxito!",
              );
            case ProfileCerrarSesionSuccess():
              return ProfileCerrarSesionSuccessScreen(
                mensaje: "¡Sesión cerrada con éxito!",
              );
            case ProfileUpdateVehicleSuccess():
              return ProfileEditVehiclesScreen(vehiculos: state.vehiculos!);
            case ProfileError():
              return ProfileErrorScreen(failure: state.failure);
            case ProfileAdministracion():
              return ProfileAdministracionScreen(usuario: state.usuario);
            case ProfileAdministracionVerificaciones():
              return ProfileAdministracionVerificacionesScreen(vehiculos: state.vehiculos);
            case ProfileAdministracionUsuarios():
              return ProfileAdministracionUsuariosScreen(usuarios: state.usuarios);
          }
        },
      ),
      bottomNavigationBar: NavigationWidget.customBottonNavigationBar(
        context,
        4,
      ),
    );
  }
}
