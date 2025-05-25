enum TipoCombustible {
  gasolina,
  diesel,
  hibrido,
  hibrido_enchufable,
  electrico;

  String get nombre {
    switch (this) {
      case TipoCombustible.gasolina:
        return 'Gasolina';
      case TipoCombustible.diesel:
        return 'Diesel';
      case TipoCombustible.hibrido:
        return 'Híbrido';
      case TipoCombustible.hibrido_enchufable:
        return 'Híbrido enchufable';
      case TipoCombustible.electrico:
        return 'Eléctrico';
    }
  }
}

extension TipoCombustibleExtension on TipoCombustible {
  String get name {
    switch (this) {
      case TipoCombustible.gasolina:
        return 'gasolina';
      case TipoCombustible.diesel:
        return 'diesel';
      case TipoCombustible.hibrido:
        return 'hibrido';
      case TipoCombustible.hibrido_enchufable:
        return 'hibrido_enchufable';
      case TipoCombustible.electrico:
        return 'electrico';
    }
  }

  static TipoCombustible fromString(String value) {
    switch (value) {
      case 'Gasolina':
        return TipoCombustible.gasolina;
      case 'Diesel':
        return TipoCombustible.diesel;
      case 'Híbrido':
        return TipoCombustible.hibrido;
      case 'Híbrido enchufable':
        return TipoCombustible.hibrido_enchufable;
      case 'Eléctrico':
        return TipoCombustible.electrico;
      default:
        throw ArgumentError('Invalid tipo_combustible value: $value');
    }
  }
}
