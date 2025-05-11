enum FiltroVehiculo {
  verificados,
  precioAsc,
  precioDesc,
  anioDesc,
  anioAsc,
  kilometrosAsc,
}

extension FiltroVehiculoExtension on FiltroVehiculo {
  String get label {
    switch (this) {
      case FiltroVehiculo.verificados:
        return 'Mostrar solo verificados';
      case FiltroVehiculo.precioAsc:
        return 'Precio: menor a mayor';
      case FiltroVehiculo.precioDesc:
        return 'Precio: mayor a menor';
      case FiltroVehiculo.anioDesc:
        return 'Año: más nuevo primero';
      case FiltroVehiculo.anioAsc:
        return 'Año: más antiguo primero';
      case FiltroVehiculo.kilometrosAsc:
        return 'Kilómetros: menor a mayor';
    }
  }
}
