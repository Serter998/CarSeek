import 'package:car_seek/core/errors/auth_failure.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/use_cases/usuario/cerrar_sesion_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/delete_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_all_users_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_usuario_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_user_by_id_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/update_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/delete_vehiculo_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_all_vehiculos_by_current_user.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_all_vehiculos_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/update_vehiculo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../share/domain/use_cases/usuario/delete_other_user_usecase.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CerrarSesionUseCase _cerrarSesionUseCase;
  final DeleteUserUsecase _deleteUserUseCase;
  final DeleteOtherUserUsecase _deleteOtherUserUsecase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetCurrentUsuarioUseCase _getCurrentUsuarioUseCase;
  final GetUserByIdUsecase _getUserByIdUseCase;
  final UpdateUserUsecase _updateUserUseCase;
  final GetAllVehiculosByCurrentUserUseCase
  _getAllVehiculosByCurrentUserUseCase;
  final UpdateVehiculoUseCase _updateVehiculoUseCase;
  final DeleteVehiculoUseCase _deleteVehiculoUseCase;
  final GetAllVehiculosUseCase _getAllVehiculosUseCase;
  final GetAllUsersUsecase _getAllUsersUsecase;

  ProfileBloc(
    this._cerrarSesionUseCase,
    this._deleteUserUseCase,
    this._getCurrentUserUseCase,
    this._getCurrentUsuarioUseCase,
    this._getUserByIdUseCase,
    this._updateUserUseCase,
    this._getAllVehiculosByCurrentUserUseCase,
    this._updateVehiculoUseCase,
    this._deleteVehiculoUseCase,
    this._getAllVehiculosUseCase,
    this._getAllUsersUsecase,
    this._deleteOtherUserUsecase,
  ) : super(ProfileLoading()) {
    Future.microtask(() => add(OnLoadInitialProfileEvent()));

    on<OnLoadInitialProfileEvent>((event, emit) async {
      final resp = await _getCurrentUsuarioUseCase();
      await Future.delayed(Duration(milliseconds: 200));

      resp.fold(
            (f) {
          if (f is UserNotFoundFailure) {
            emit(ProfileCerrarSesionSuccess());
          } else {
            emit(ProfileError(failure: f));
          }
        },
            (usuario) => emit(ProfileInitial(usuario: usuario)),
      );
    });


    on<OnCerrarSesionEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _cerrarSesionUseCase();

      resp.fold(
        (f) => emit(ProfileError(failure: f)),
        (u) => emit(ProfileCerrarSesionSuccess()),
      );
    });

    on<OnUpdateUsuarioEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _getCurrentUsuarioUseCase();
      Usuario? usuario;
      resp.fold((f) => emit(ProfileError(failure: f)), (u) {
        usuario = u;
      });

      if (usuario != null) {
        final resp2 = await _updateUserUseCase(event.usuario);

        resp2.fold(
          (f) => emit(ProfileError(failure: f)),
          (u) => emit(ProfileUpdateSuccess(usuario: usuario!)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener el usuario.",
            ),
          ),
        );
      }
    });

    on<OnDeleteCurrentUsuarioEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp1 = await _getCurrentUsuarioUseCase();
      Usuario? usuario;
      resp1.fold((f) => usuario = null, (u) => usuario = u);

      if (usuario != null) {
        final resp2 = await _deleteUserUseCase(usuario!.id);

        resp2.fold(
          (f) => emit(ProfileError(failure: f)),
          (u) => emit(ProfileDeleteSuccess()),
        );
      } else {
        ServerFailure failure = ServerFailure(
          customMessage: "Error al obtener el usuario",
        );
        emit(ProfileError(failure: failure));
      }
    });

    on<OnDeleteUsuarioEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _getCurrentUsuarioUseCase();
      Usuario? usuario;

      resp.fold((f) => emit(ProfileError(failure: f)), (u) => usuario = u);

      if (usuario != null) {
        final resp2 = await _deleteOtherUserUsecase(event.usuario.id);

        resp2.fold(
          (f) => emit(ProfileError(failure: f)),
          (u) => emit(ProfileAdministracion(usuario: usuario!)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener el usuario",
            ),
          ),
        );
      }
    });

    on<OnNavigateToInitial>((event, emit) async {
      final resp = await _getCurrentUsuarioUseCase();
      resp.fold(
        (f) => emit(ProfileError(failure: f)),
        (usuario) => emit(ProfileInitial(usuario: usuario)),
      );
    });

    on<OnNavigateToUpdate>((event, emit) async {
      final resp1 = await _getCurrentUserUseCase();
      User? user;
      Failure? failure;
      resp1.fold((f) {
        user = null;
        failure = f;
      }, (u) => user = u);

      if (user != null) {
        final resp2 = await _getCurrentUsuarioUseCase();
        resp2.fold(
          (f) => emit(ProfileError(failure: f)),
          (u) => emit(ProfileUpdate(usuario: u, user: user!)),
        );
      } else {
        emit(ProfileError(failure: failure!));
      }
    });

    on<OnEditVehicleEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _updateVehiculoUseCase(event.vehiculo);
      final resp2 = await _getAllVehiculosByCurrentUserUseCase();
      List<Vehiculo>? vehiculos;
      resp2.fold((f) => emit(ProfileError(failure: f)), (v) {
        vehiculos = v;
      });
      if (vehiculos != null) {
        resp.fold(
          (f) => emit(ProfileError(failure: f)),
          (v) => emit(ProfileEditVehicles(vehiculos: vehiculos)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los vehiculos",
            ),
          ),
        );
      }
    });

    on<OnEnterEditVehicleEvent>((event, emit) async {
      final resp = await _getAllVehiculosByCurrentUserUseCase();
      resp.fold(
        (f) => emit(ProfileError(failure: f)),
        (v) => emit(ProfileEditVehicles(vehiculos: v)),
      );
    });

    on<OnNavigateToUpdateVehicle>((event, emit) async {
      emit(ProfileUpdateVehicle(vehiculo: event.vehiculo));
    });

    on<OnDeleteVehiculoEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _deleteVehiculoUseCase(event.vehiculo.idVehiculo);
      final resp2 = await _getAllVehiculosByCurrentUserUseCase();
      List<Vehiculo>? vehiculos;
      resp2.fold((f) => emit(ProfileError(failure: f)), (v) {
        vehiculos = v;
      });
      if (vehiculos != null) {
        resp.fold(
          (f) => emit(ProfileError(failure: f)),
          (v) => emit(ProfileEditVehicles(vehiculos: vehiculos)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los vehiculos",
            ),
          ),
        );
      }
    });

    on<OnNavigateToUpdateVehicles>((event, emit) async {
      final resp = await _getAllVehiculosByCurrentUserUseCase();
      List<Vehiculo>? vehiculos;
      resp.fold((f) => emit(ProfileError(failure: f)), (v) {
        vehiculos = v;
      });
      if (vehiculos != null) {
        emit(ProfileEditVehicles(vehiculos: vehiculos));
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los vehiculos",
            ),
          ),
        );
      }
    });

    on<OnNavigateToAdministracion>((event, emit) async {
      final resp = await _getCurrentUsuarioUseCase();
      Usuario? usuario;
      resp.fold((f) => emit(ProfileError(failure: f)), (v) {
        usuario = v;
      });
      if (usuario != null) {
        emit(ProfileAdministracion(usuario: usuario!));
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener el usuario",
            ),
          ),
        );
      }
    });

    on<OnNavigateToAdministracionVerificaciones>((event, emit) async {
      final resp = await _getAllVehiculosUseCase();
      List<Vehiculo>? vehiculos;
      resp.fold((f) => emit(ProfileError(failure: f)), (v) {
        vehiculos = v;
      });
      if (vehiculos != null) {
        emit(ProfileAdministracionVerificaciones(vehiculos: vehiculos!));
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los vehículos",
            ),
          ),
        );
      }
    });

    on<OnEditVerificacionEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _updateVehiculoUseCase(event.vehiculo);
      final resp2 = await _getAllVehiculosUseCase();
      List<Vehiculo>? vehiculos;
      resp2.fold((f) => emit(ProfileError(failure: f)), (v) {
        vehiculos = v;
      });
      if (vehiculos != null) {
        resp.fold(
          (f) => emit(ProfileError(failure: f)),
          (v) =>
              emit(ProfileAdministracionVerificaciones(vehiculos: vehiculos)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los vehiculos",
            ),
          ),
        );
      }
    });

    on<OnNavigateToAdministracionUsuarios>((event, emit) async {
      final resp = await _getAllUsersUsecase();
      List<Usuario>? usuarios;
      resp.fold((f) => emit(ProfileError(failure: f)), (v) {
        usuarios = v;
      });
      if (usuarios != null) {
        emit((ProfileAdministracionUsuarios(usuarios: usuarios)));
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los usuarios",
            ),
          ),
        );
      }
    });

    on<OnEditUsuarioEvent>((event, emit) async {
      emit(ProfileLoading());

      final resp = await _updateUserUseCase(event.usuario);
      final resp2 = await _getAllUsersUsecase();
      List<Usuario>? usuarios;
      resp2.fold((f) => emit(ProfileError(failure: f)), (u) {
        usuarios = u;
      });
      if (usuarios != null) {
        resp.fold(
          (f) => emit(ProfileError(failure: f)),
          (v) => emit(ProfileAdministracionUsuarios(usuarios: usuarios)),
        );
      } else {
        emit(
          ProfileError(
            failure: ServerFailure(
              customMessage: "Error al obtener los usuarios",
            ),
          ),
        );
      }
    });
  }
}
