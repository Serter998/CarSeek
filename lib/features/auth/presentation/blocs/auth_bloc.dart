import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/use_cases/cerrar_sesion_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/delete_credentials_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/get_current_user_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/load_credentials_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/save_credentials_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CerrarSesionUseCase _cerrarSesionUseCase;
  final SaveCredentialsUsecase _saveCredentialsUsecase;
  final LoadCredentialsUsecase _loadCredentialsUsecase;
  final DeleteCredentialsUsecase _deleteCredentialsUsecase;

  AuthBloc(
    this._registerUseCase,
    this._loginUseCase,
    this._getCurrentUserUseCase,
    this._cerrarSesionUseCase,
    this._deleteCredentialsUsecase,
    this._loadCredentialsUsecase,
    this._saveCredentialsUsecase,
  ) : super(AuthInitial()) {
    on<OnRegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _registerUseCase(
        event.email,
        event.password,
        event.nombre,
        event.telefono,
        event.ubicacion,
      );

      resp.fold(
        (f) => emit(AuthError(failure: f)),
        (u) => emit(AuthRegisterSuccess()),
      );
    });

    on<OnLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _loginUseCase(event.email, event.password);

      resp.fold(
        (f) => emit(AuthError(failure: f)),
        (u) => emit(AuthLoginSuccess(user: u)),
      );
    });

    on<OnCheckUserLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _getCurrentUserUseCase();

      resp.fold((f) => emit(AuthError(failure: f)), (u) {
        if (u != null) {
          emit(AuthLoginSuccess(user: u));
        } else {
          emit(AuthInitial());
        }
      });
    });

    on<OnCloseSessionEvent>((event, emit) async {
      final resp = await _cerrarSesionUseCase();

      resp.fold((f) => emit(AuthError(failure: f)), (r) => emit(AuthInitial()));
    });

    on<OnNavigateToRegisterEvent>((event, emit) {
      emit(AuthRegister());
    });

    on<OnNavigateToLoginEvent>((event, emit) {
      emit(AuthInitial());
    });

    on<OnNavigateToForgotPasswordEvent>((event, emit) {
      emit(AuthForgotPassword());
    });
  }
}
