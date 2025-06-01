import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:car_seek/share/domain/entities/mensaje.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/use_cases/conversacion/delete_conversacion_usecase.dart';
import 'package:car_seek/share/domain/use_cases/conversacion/get_all_conversaciones_by_current_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/mensaje/create_mensaje_usecase.dart';
import 'package:car_seek/share/domain/use_cases/mensaje/delete_mensaje_usecase.dart';
import 'package:car_seek/share/domain/use_cases/mensaje/get_all_mensajes_by_conversacion_usecase.dart';
import 'package:car_seek/share/domain/use_cases/mensaje/update_mensaje_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_usuario_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DeleteConversacionUsecase _deleteConversacionUsecase;
  final GetAllConversacionesByCurrentUserUseCase
  _getAllConversacionesByCurrentUserUseCase;
  final CreateMensajeUsecase _createMensajeUsecase;
  final DeleteMensajeUsecase _deleteMensajeUsecase;
  final GetAllMensajesByConversacionUsecase
  _getAllMensajesByConversacionUsecase;
  final UpdateMensajeUsecase _updateMensajeUsecase;
  final GetCurrentUsuarioUseCase _getCurrentUsuarioUseCase;

  ChatBloc(
    this._deleteConversacionUsecase,
    this._getAllConversacionesByCurrentUserUseCase,
    this._createMensajeUsecase,
    this._deleteMensajeUsecase,
    this._getAllMensajesByConversacionUsecase,
    this._updateMensajeUsecase,
    this._getCurrentUsuarioUseCase,
  ) : super(ChatLoading()) {
    Future.microtask(() => add(OnLoadInitialChatsEvent()));

    on<OnLoadInitialChatsEvent>((event, emit) async {
      emit(ChatLoading());
      final resp = await _getAllConversacionesByCurrentUserUseCase();
      resp.fold(
        (f) => emit(ChatError(failure: f)),
        (c) => emit(ChatInitial(conversaciones: c)),
      );
    });

    on<OnDeleteConversacionEvent>((event, emit) async {
      emit(ChatLoading());
      final resp = await _deleteConversacionUsecase(event.conversacion.id);
      resp.fold(
            (f) => emit(ChatError(failure: f)),
            (d) => (),
      );
      final resp2 = await _getAllConversacionesByCurrentUserUseCase();
      resp2.fold(
            (f) => emit(ChatError(failure: f)),
            (c) => emit(ChatInitial(conversaciones: c)),
      );
    });

    on<OnOpenChatEvent>((event, emit) async {
      emit(ChatLoading());
      final resp = await _getCurrentUsuarioUseCase();
      Usuario? usuario;
      resp.fold(
            (f) => emit(ChatError(failure: f)),
            (u) => usuario = u
      );

      if(usuario != null) {
        final resp2 = await _getAllMensajesByConversacionUsecase(
          event.conversacion.id,
        );
        resp2.fold(
              (f) => emit(ChatError(failure: f)),
              (m) => emit(OpenChat(mensajes: m, currentUserId: usuario!.id, conversacion: event.conversacion)),
        );
      } else {
        emit(ChatError(failure: ServerFailure(customMessage: "Error al obtener el usuario.")));
      }
    });

    on<OnSendMessageEvent>((event, emit) async {
      final resp = await _createMensajeUsecase(event.mensaje);
      bool created = false;
      resp.fold(
            (f) => emit(ChatError(failure: f)),
            (c) => created = true,
      );
      if(created) {
        final resp2 = await _getCurrentUsuarioUseCase();
        Usuario? usuario;
        resp2.fold(
                (f) => emit(ChatError(failure: f)),
                (u) => usuario = u
        );

        if(usuario != null) {
          final resp3 = await _getAllMensajesByConversacionUsecase(
            event.conversacion.id,
          );
          resp3.fold(
                (f) => emit(ChatError(failure: f)),
                (m) => emit(OpenChat(mensajes: m, currentUserId: usuario!.id, conversacion: event.conversacion)),
          );
        } else {
          emit(ChatError(failure: ServerFailure(customMessage: "Error al obtener el usuario.")));
        }
      } else {
        emit(ChatError(failure: ServerFailure(customMessage: "Error al crear el mensaje.")));
      }
    });

    on<OnDeleteMessageEvent>((event, emit) async {
      final resp = await _deleteMensajeUsecase(event.mensaje.id!);
      bool deleted = false;
      resp.fold(
            (f) => emit(ChatError(failure: f)),
            (d) => deleted = true,
      );
      if(deleted) {
        final resp2 = await _getCurrentUsuarioUseCase();
        Usuario? usuario;
        resp2.fold(
                (f) => emit(ChatError(failure: f)),
                (u) => usuario = u
        );

        if(usuario != null) {
          final resp3 = await _getAllMensajesByConversacionUsecase(
            event.conversacion.id,
          );
          resp3.fold(
                (f) => emit(ChatError(failure: f)),
                (m) => emit(OpenChat(mensajes: m, currentUserId: usuario!.id, conversacion: event.conversacion)),
          );
        } else {
          emit(ChatError(failure: ServerFailure(customMessage: "Error al obtener el usuario.")));
        }
      } else {
        emit(ChatError(failure: ServerFailure(customMessage: "Error al crear el mensaje.")));
      }
    });
  }
}
