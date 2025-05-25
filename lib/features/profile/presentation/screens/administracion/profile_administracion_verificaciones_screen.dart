import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/profile/presentation/widgets/buscador_vehiculo.dart';
import 'package:car_seek/features/profile/presentation/widgets/filtro_verificacion_menu.dart';
import 'package:car_seek/features/profile/presentation/widgets/vehiculo_card.dart';
import 'package:car_seek/features/profile/presentation/widgets/vehiculo_detalle_sheet.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAdministracionVerificacionesScreen extends StatefulWidget {
  final List<Vehiculo>? vehiculos;

  const ProfileAdministracionVerificacionesScreen({
    super.key,
    required this.vehiculos,
  });

  @override
  State<ProfileAdministracionVerificacionesScreen> createState() =>
      _ProfileAdministracionVerificacionesScreenState();
}

class _ProfileAdministracionVerificacionesScreenState
    extends State<ProfileAdministracionVerificacionesScreen> {
  bool mostrarVerificados = false;
  String query = '';

  List<Vehiculo> get vehiculosFiltrados {
    return widget.vehiculos!
        .where((v) => mostrarVerificados ? (v.verificado == true) : (v.verificado != true))
        .where((v) => v.titulo.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _aprobarVehiculo(Vehiculo vehiculo) {
    final vehiculoActualizado = _crearVehiculoActualizado(vehiculo, true);

    context.read<ProfileBloc>().add(
      OnEditVerificacionEvent(vehiculo: vehiculoActualizado),
    );

    CustomSnackBar.show(
      context: context,
      message: "Vehículo verificado con éxito.",
      backgroundColor: Colors.white10,
    );
    Navigator.pop(context);
  }

  void _rechazarVehiculo(Vehiculo vehiculo) {
    final vehiculoActualizado = _crearVehiculoActualizado(vehiculo, false);

    context.read<ProfileBloc>().add(
      OnEditVerificacionEvent(vehiculo: vehiculoActualizado),
    );

    CustomSnackBar.show(
      context: context,
      message: "Vehículo rechazado con éxito.",
      backgroundColor: Colors.white10,
    );
    Navigator.pop(context);
  }


  Vehiculo _crearVehiculoActualizado(Vehiculo original, bool verificado) {
    return Vehiculo(
      idVehiculo: original.idVehiculo,
      idUsuario: original.idUsuario,
      titulo: original.titulo,
      marca: original.marca,
      modelo: original.modelo,
      anio: original.anio,
      kilometros: original.kilometros,
      tipoCombustible: original.tipoCombustible,
      cv: original.cv,
      tipoEtiqueta: original.tipoEtiqueta,
      precio: original.precio,
      ubicacion: original.ubicacion,
      descripcion: original.descripcion,
      imagenes: original.imagenes,
      destacado: original.destacado,
      verificado: verificado,
      fechaCreacion: original.fechaCreacion,
      fechaActualizacion: DateTime.now(),
    );
  }

  void _mostrarDetallesVehiculo(Vehiculo vehiculo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return VehiculoDetalleSheet(
          vehiculo: vehiculo,
          onAprobar: _aprobarVehiculo,
          onRechazar: _rechazarVehiculo,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BuscadorVehiculo(
                    onChanged: (val) => setState(() => query = val),
                  ),
                ),
                const SizedBox(width: 12),
                FiltroVerificacionMenu(
                  mostrarVerificados: mostrarVerificados,
                  onChanged: (val) => setState(() => mostrarVerificados = val),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: vehiculosFiltrados.isEmpty
                  ? Center(child: Text('No hay vehículos que coincidan.'))
                  : ListView.builder(
                itemCount: vehiculosFiltrados.length,
                itemBuilder: (context, index) {
                  final vehiculo = vehiculosFiltrados[index];
                  return VehiculoCard(
                    vehiculo: vehiculo,
                    onTap: () => _mostrarDetallesVehiculo(vehiculo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
