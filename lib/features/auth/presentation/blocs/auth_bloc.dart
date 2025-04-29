import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/use_cases/usuario/cerrar_sesion_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/load_credentials_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_usuario_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final GetCurrentUsuarioUseCase _getCurrentUsuarioUseCase;
  final CerrarSesionUseCase _cerrarSesionUseCase;
  final LoadCredentialsUsecase _loadCredentialsUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;

  AuthBloc(
      this._registerUseCase,
      this._loginUseCase,
      this._getCurrentUsuarioUseCase,
      this._cerrarSesionUseCase,
      this._loadCredentialsUsecase,
      this._forgotPasswordUsecase
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
            (_) => emit(AuthRegisterSuccess()),
      );
    });

    on<OnLoadCredentialsEvent>((event, emit) async {
      emit(AuthLoading());
      final resp = await _loadCredentialsUsecase();

      resp.fold(
            (_) => emit(AuthInitial()),
            (credentials) => emit(
          AuthInitial(
            savedEmail: credentials['email'],
            savedPassword: credentials['password'],
            hasSavedCredentials: credentials['email'] != null,
          ),
        ),
      );
    });

    on<OnLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _loginUseCase(
        event.email,
        event.password,
        event.rememberMe,
      );

      resp.fold(
            (f) => emit(AuthError(failure: f)),
            (u) => emit(AuthLoginSuccess(user: u)),
      );
    });

    on<OnCheckUserLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _getCurrentUsuarioUseCase();

      resp.fold(
            (f) => emit(AuthInitial()),
            (u) => emit(AuthLoginSuccess(user: u)),
      );
    });

    on<OnCloseSessionEvent>((event, emit) async {
      final resp = await _cerrarSesionUseCase();

      resp.fold(
            (f) => emit(AuthError(failure: f)),
            (_) => emit(AuthInitial()),
      );
    });

    on<OnNavigateToRegisterEvent>((event, emit) => emit(AuthRegister()));
    on<OnNavigateToLoginEvent>((event, emit) => emit(AuthInitial()));
    on<OnNavigateToForgotPasswordEvent>((event, emit) => emit(AuthForgotPassword()));

    on<OnForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
        final resp = await _forgotPasswordUsecase(event.email);

        resp.fold(
            (f) => emit(AuthError(failure: f)),
            (_) => emit(AuthForgotPasswordSuccess(
              message: "Te hemos enviado un enlace para restablecer tu contraseña.",
            )),
        );
      }
    );

    on<OnUpdatePasswordEvent>((event, emit) async {
      emit(AuthLoading());

    });
  }
}
