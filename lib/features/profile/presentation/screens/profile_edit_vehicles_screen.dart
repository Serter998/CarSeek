import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/profile/presentation/widgets/vehiculo_card.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditVehiclesScreen extends StatelessWidget {
  final List<Vehiculo> vehiculos;

  const ProfileEditVehiclesScreen({super.key, required this.vehiculos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vehiculos.isEmpty
          ? const Center(
        child: Text(
          'No tienes vehículos para editar.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        itemCount: vehiculos.length,
        itemBuilder: (context, index) {
          final vehiculo = vehiculos[index];
          return VehiculoCard(
            vehiculo: vehiculo,
            onTap: () {
              context.read<ProfileBloc>().add(
                OnNavigateToUpdateVehicle(vehiculo: vehiculo),
              );
            },
          );
        },
      ),
    );
  }
}
