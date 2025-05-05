import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/create_vehiculo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sell_event.dart';

part 'sell_state.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final CreateVehiculoUseCase _createVehiculoUseCase;

  SellBloc(this._createVehiculoUseCase) : super(SellCreate()) {
    on<OnSetTituloEvent>((event, emit) {
      emit(SellCreateTitulo(titulo: event.titulo));
    });

    on<OnSetCaracteristicasEvent>((event, emit) {
      emit(
        SellCreateCaracteristicas(
          descripcion: event.descripcion,
          anio: event.anio,
          combustibleSeleccionado: event.combustibleSeleccionado,
          cv: event.cv,
          km: event.km,
          marca: event.marca,
          modelo: event.modelo,
          tipoEtiqueta: event.tipoEtiqueta,
          titulo: event.titulo,
        ),
      );
    });

    on<OnCreateSellEvent>((event, emit) async {
      emit(SellLoading());

      final resp = await _createVehiculoUseCase(event.vehiculo);

      resp.fold(
        (f) => emit(SellError(failure: f)),
        (_) => emit(SellCreateSuccess()),
      );
    });

    on<ResetSellEvent>((event, emit) {
      emit(SellCreate());
    });
  }
}
