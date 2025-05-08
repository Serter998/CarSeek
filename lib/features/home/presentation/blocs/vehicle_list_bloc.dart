import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_all_vehiculos_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculos_filtrados_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vehicle_list_event.dart';
part 'vehicle_list_state.dart';

class VehicleListBloc extends Bloc<VehicleListEvent, VehicleListState> {
  final GetAllVehiculosUseCase getAllVehiculosUseCase;
  final GetVehiculosFiltradosUseCase getVehiculosFiltradosUseCase;

  VehicleListBloc(
      this.getAllVehiculosUseCase,
      this.getVehiculosFiltradosUseCase,
      ) : super(VehicleListInitial()) {
    on<LoadAllVehiculosEvent>((event, emit) async {
      emit(VehicleListLoading());

      final result = await getAllVehiculosUseCase();

      result.fold(
            (failure) {
          print("Error al obtener vehículos: ${failure.message}");
          emit(VehicleListError(failure: failure));
        },
            (vehiculos) => emit(VehicleListLoaded(vehiculos: vehiculos)),
      );
    });

    on<FilterVehiculosEvent>((event, emit) async {
      emit(VehicleListLoading());

      final result = await getVehiculosFiltradosUseCase(
        query: event.query,
        filtro: event.filtro,
      );

      result.fold(
            (failure) => emit(VehicleListError(failure: failure)),
            (vehiculos) {
          emit(VehicleListLoaded(vehiculos: vehiculos));
        },
      );
    });
  }
}


