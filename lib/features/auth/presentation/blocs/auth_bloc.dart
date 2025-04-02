import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;

  AuthBloc(this._registerUseCase, this._loginUseCase) : super(AuthInitial()) {
    on<OnRegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _registerUseCase(event.email, event.password, event.nombre, event.telefono, event.ubicacion);

      resp.fold(
            (f) => emit(AuthError(failure: f)),
            (u) => emit(AuthSuccess(user: u)),
      );
    });

    on<OnLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final resp = await _loginUseCase(event.email, event.password);

      resp.fold(
            (f) => emit(AuthError(failure: f)),
            (u) => emit(AuthSuccess(user: u)),
      );
    });

    on<OnNavigateToRegisterEvent>((event, emit) {
      emit(AuthRegister());
    });

    on<OnNavigateToLoginEvent>((event, emit) {
      emit(AuthInitial());
    });
  }
}