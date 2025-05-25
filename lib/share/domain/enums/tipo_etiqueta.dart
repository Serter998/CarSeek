enum TipoEtiqueta { eco, c, b, sin_etiqueta;

  String get nombre {
    switch (this) {
      case TipoEtiqueta.eco:
        return 'Eco';
      case TipoEtiqueta.c:
        return 'C';
      case TipoEtiqueta.b:
        return 'B';
      case TipoEtiqueta.sin_etiqueta:
        return 'Sin etiqueta';
    }
  }}

extension TipoEtiquetaExtension on TipoEtiqueta {
  String get name {
    switch (this) {
      case TipoEtiqueta.eco:
        return 'eco';
      case TipoEtiqueta.c:
        return 'c';
      case TipoEtiqueta.b:
        return 'b';
      case TipoEtiqueta.sin_etiqueta:
        return 'sin_etiqueta';
    }
  }

  static TipoEtiqueta fromString(String value) {
    switch (value) {
      case 'Eco':
        return TipoEtiqueta.eco;
      case 'C':
        return TipoEtiqueta.c;
      case 'B':
        return TipoEtiqueta.b;
      case 'Sin etiqueta':
        return TipoEtiqueta.sin_etiqueta;
      default:
        throw ArgumentError('Invalid tipo_etiqueta value: $value');
    }
  }
}
