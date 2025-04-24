import 'package:car_seek/share/domain/entities/vehiculo.dart';

class VehiculoModel extends Vehiculo {
  VehiculoModel({
    required super.idVehiculo,
    required super.idUsuario,
    required super.marca,
    required super.modelo,
    required super.anio,
    required super.precio,
    super.ubicacion,
    super.descripcion,
    super.imagen,
    super.destacado,
    super.verificado,
    super.fechaCreacion,
    super.fechaActualizacion,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      idVehiculo: json['id_vehiculo'],
      idUsuario: json['id_usuario'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['año'],
      precio: json['precio'].toDouble(),
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      destacado: json['destacado'] ?? false,
      verificado: json['verificado'] ?? false,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_vehiculo': idVehiculo,
      'id_usuario': idUsuario,
      'marca': marca,
      'modelo': modelo,
      'año': anio,
      'precio': precio,
      'ubicacion': ubicacion ?? '',
      'descripcion': descripcion ?? '',
      'imagen': imagen ?? '',
      'destacado': destacado ?? false,
      'verificado': verificado ?? false,
    };
  }

  factory VehiculoModel.fromEntity(Vehiculo vehiculo) {
    return VehiculoModel(
      idVehiculo: vehiculo.idVehiculo,
      idUsuario: vehiculo.idUsuario,
      marca: vehiculo.marca,
      modelo: vehiculo.modelo,
      anio: vehiculo.anio,
      precio: vehiculo.precio,
      ubicacion: vehiculo.ubicacion,
      descripcion: vehiculo.descripcion,
      imagen: vehiculo.imagen,
      destacado: vehiculo.destacado,
      verificado: vehiculo.verificado,
      fechaCreacion: vehiculo.fechaCreacion,
      fechaActualizacion: vehiculo.fechaActualizacion,
    );
  }
}
