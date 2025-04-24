class Vehiculo {
  final String idVehiculo;
  final String idUsuario;
  final String marca;
  final String modelo;
  final int anio;
  final double precio;
  final String? ubicacion;
  final String? descripcion;
  final String? imagen;
  final bool? destacado;
  final bool? verificado;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  Vehiculo({
    required this.idVehiculo,
    required this.idUsuario,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    this.ubicacion,
    this.descripcion,
    this.imagen,
    this.destacado,
    this.verificado,
    this.fechaCreacion,
    this.fechaActualizacion,
  });
}