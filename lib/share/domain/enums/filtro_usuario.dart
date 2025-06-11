enum TipoUsuarioFiltro {
  todos,
  cliente,
  administrador,
  mecanico,
}

extension TipoUsuarioFiltroExtension on TipoUsuarioFiltro {
  String get nombre {
    switch (this) {
      case TipoUsuarioFiltro.todos:
        return 'Todos';
      case TipoUsuarioFiltro.cliente:
        return 'Cliente';
      case TipoUsuarioFiltro.administrador:
        return 'Administrador';
      case TipoUsuarioFiltro.mecanico:
        return 'Mecánico';
    }
  }
}