import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_create_caracteristics_screen.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_create_submit_screen.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_create_success_screen.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_create_title_screen.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SellBloc>(context).add(OnResetSellEvent());
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Acción al presionar
          },
          icon: Icon(Icons.close),
        ),
        title: BlocBuilder<SellBloc, SellState>(
          builder: (context, state) {
            if (state is SellCreate ||
                state is SellCreateTitulo ||
                state is SellCreateCaracteristicas) {
              return const Text("Crear una venta");
            } else if (state is SellLoading) {
              return const Text("Cargando");
            } else if (state is SellCreateSuccess) {
              return const Text("Venta creada exitosamente");
            } else if (state is SellError) {
              return const Text("Error");
            } else {
              return const Text("Estado no contemplado");
            }
          },
        ),
      ),
      body: BlocBuilder<SellBloc, SellState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case const (SellLoading):
              return const Center(child: CircularProgressIndicator());
            case const (SellCreate):
              return SellCreateTitleScreen(titulo: (state as SellCreate).titulo,);
            case const (SellCreateTitulo):
              return SellCreateCaracteristicsScreen(
                titulo: (state as SellCreateTitulo).titulo,
                marca: (state).marca,
                modelo: (state).modelo,
                anio: (state).anio,
                km: (state).km,
                tipoCombustible: (state).combustibleSeleccionado,
                cv: (state).cv,
                tipoEtiqueta: (state).tipoEtiqueta,
                descripcion: (state).descripcion,
              );
            case const (SellCreateCaracteristicas):
              return SellCreateSubmitScreen(
                titulo: (state as SellCreateCaracteristicas).titulo,
                marca: (state).marca,
                modelo: (state).modelo,
                anio: (state).anio,
                km: (state).km,
                tipoCombustible: (state).combustibleSeleccionado,
                cv: (state).cv,
                tipoEtiqueta: (state).tipoEtiqueta,
                descripcion: (state).descripcion,
              );
            case const (SellCreateSuccess):
              return SellCreateSuccessScreen();
            case const (SellError):
              return SellErrorScreen(failure: (state as SellError).failure,);
            default:
              return const Center(child: Text("Estado no contemplado"));
          }
        },
      ),
    );
  }
}
