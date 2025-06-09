import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/generic_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:car_seek/share/domain/repositories/conversacion_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'vehicle_detail_event.dart';
part 'vehicle_detail_state.dart';

class VehicleDetailBloc extends Bloc<VehicleDetailEvent, VehicleDetailState> {
  final ConversacionRepository conversacionRepository;

  VehicleDetailBloc({required this.conversacionRepository})
      : super(VehicleDetailInitial()) {
    on<ContactSellerEvent>((event, emit) async {
      emit(VehicleDetailLoading());

      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        emit(VehicleDetailError(message: 'Debes iniciar sesión para contactar'));
        return;
      }

      if (currentUser.id == event.vehiculo.idUsuario) {
        emit(VehicleDetailError(message: 'No puedes enviarte mensajes a ti mismo'));
        return;
      }

      final result = await conversacionRepository.getConversacionByUsuariosYNombre(
        usuario1: currentUser.id,
        usuario2: event.vehiculo.idUsuario,
        nombre: event.vehiculo.titulo,
      );


      if (result.isLeft()) {
        final failure = result.swap().getOrElse(() => const GenericFailure());
        emit(VehicleDetailError(message: 'Error al buscar conversación: ${failure.message}'));
        return;
      }

      var conversacionExistente = result.getOrElse(() => null);

      if (conversacionExistente == null) {
        final nuevaConversacion = ConversacionModel(
          id: '',
          nombre: event.vehiculo.titulo,
          usuario1: currentUser.id,
          usuario2: event.vehiculo.idUsuario,
          createdAt: DateTime.now(),
        );

        final createResult = await conversacionRepository.createConversacion(nuevaConversacion);

        if (createResult.isLeft()) {
          emit(VehicleDetailError(message: 'Error al crear conversación'));
          return;
        }

        final nuevoResult = await conversacionRepository.getConversacionByUsuariosYNombre(
          usuario1: currentUser.id,
          usuario2: event.vehiculo.idUsuario,
          nombre: event.vehiculo.titulo,
        );

        conversacionExistente = nuevoResult.getOrElse(() => null);
      }

      if (conversacionExistente != null) {
        emit(VehicleDetailNavigateToChat(conversacion: conversacionExistente));
      }
    });
  }
}
