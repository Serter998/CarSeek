import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class UsuarioModel extends Usuario{
  UsuarioModel({
    required super.id,
    required super.userId,
    required super.nombre,
    super.telefono,
    super.ubicacion,
    super.reputacion,
    super.fechaRegistro,
    super.fechaActualizacion,
    required super.tipoUsuario,
  });
  
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id_usuario'],
      userId: json['user_id'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      ubicacion: json['ubicacion'],
      reputacion: json['reputacion']?.toInt() ?? 0,
      fechaRegistro: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
      tipoUsuario: TipoUsuarioExtension.fromString(json['tipo_usuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario' : id,
      'user_id' : userId,
      'nombre' : nombre,
      'telefono' : telefono ?? '',
      'ubicacion' : ubicacion ?? '',
      'reputacion' : reputacion ?? 0,
      'tipo_usuario' : tipoUsuario.name,
    };
  }

  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
        id: usuario.id,
        userId: usuario.userId,
        nombre: usuario.nombre,
        telefono: usuario.telefono,
        ubicacion: usuario.ubicacion,
        reputacion: usuario.reputacion,
        fechaRegistro: usuario.fechaRegistro,
        fechaActualizacion: usuario.fechaActualizacion,
        tipoUsuario: usuario.tipoUsuario);
  }
}
