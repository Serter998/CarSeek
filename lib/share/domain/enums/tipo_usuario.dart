enum TipoUsuario { cliente, administrador, mecanico;

  String get nombre {
    switch (this) {
      case TipoUsuario.cliente:
        return 'Cliente';
      case TipoUsuario.administrador:
        return 'Administrador';
      case TipoUsuario.mecanico:
        return 'Mecánico';
    }
  }
}

extension TipoUsuarioExtension on TipoUsuario {
  String get name {
    switch (this) {
      case TipoUsuario.cliente:
        return 'cliente';
      case TipoUsuario.administrador:
        return 'administrador';
      case TipoUsuario.mecanico:
        return 'mecanico';
    }
  }

  static TipoUsuario fromString(String value) {
    switch (value) {
      case 'cliente':
        return TipoUsuario.cliente;
      case 'administrador':
        return TipoUsuario.administrador;
      case 'mecanico':
        return TipoUsuario.mecanico;
      default:
        throw ArgumentError('Invalid tipo_usuario value: $value');
    }
  }
}
