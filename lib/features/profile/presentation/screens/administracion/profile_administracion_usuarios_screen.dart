import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/profile/presentation/widgets/usuario_card.dart';
import 'package:car_seek/features/profile/presentation/widgets/usuario_detalle_sheet.dart';
import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:car_seek/share/domain/enums/filtro_usuario.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAdministracionUsuariosScreen extends StatefulWidget {
  final List<Usuario>? usuarios;

  const ProfileAdministracionUsuariosScreen({
    super.key,
    required this.usuarios,
  });

  @override
  State<ProfileAdministracionUsuariosScreen> createState() =>
      _ProfileAdministracionUsuariosScreenState();
}

class _ProfileAdministracionUsuariosScreenState
    extends State<ProfileAdministracionUsuariosScreen> {
  String _busqueda = '';
  TipoUsuarioFiltro _filtroSeleccionado = TipoUsuarioFiltro.todos;

  List<Usuario> get _usuariosFiltrados {
    return widget.usuarios!.where((usuario) {
      final coincideBusqueda = usuario.nombre.toLowerCase().contains(
        _busqueda.toLowerCase(),
      );

      final coincideTipo =
          _filtroSeleccionado == TipoUsuarioFiltro.todos ||
          usuario.tipoUsuario == mapFiltroATipoUsuario(_filtroSeleccionado);

      return coincideBusqueda && coincideTipo;
    }).toList();
  }

  TipoUsuario? mapFiltroATipoUsuario(TipoUsuarioFiltro filtro) {
    switch (filtro) {
      case TipoUsuarioFiltro.administrador:
        return TipoUsuario.administrador;
      case TipoUsuarioFiltro.cliente:
        return TipoUsuario.cliente;
      case TipoUsuarioFiltro.todos:
      default:
        return null;
    }
  }

  void _mostrarDetalle(Usuario usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => UsuarioDetalleSheet(
            usuario: usuario,
            onCambiarTipo: (nuevoTipo) {
              setState(() {
                final index = widget.usuarios!.indexWhere(
                  (u) => u.id == usuario.id,
                );
                if (index != -1) {
                  widget.usuarios![index] = UsuarioModel.fromEntity(
                    Usuario(
                      id: usuario.id,
                      userId: usuario.userId,
                      nombre: usuario.nombre,
                      telefono: usuario.telefono,
                      ubicacion: usuario.ubicacion,
                      reputacion: usuario.reputacion,
                      fechaRegistro: usuario.fechaRegistro,
                      fechaActualizacion: DateTime.now(),
                      tipoUsuario: nuevoTipo,
                    ),
                  );
                }

                Usuario usuarioActualizado = Usuario(
                  id: usuario.id,
                  userId: usuario.userId,
                  nombre: usuario.nombre,
                  telefono: usuario.telefono,
                  ubicacion: usuario.ubicacion,
                  reputacion: usuario.reputacion,
                  fechaRegistro: usuario.fechaRegistro,
                  fechaActualizacion: DateTime.now(),
                  tipoUsuario: nuevoTipo,
                );

                context.read<ProfileBloc>().add(
                  OnEditUsuarioEvent(usuario: usuarioActualizado),
                );

                CustomSnackBar.show(
                  context: context,
                  message: "Tipo de usuario actualizado a ${nuevoTipo.nombre}.",
                  backgroundColor: Colors.white10,
                );
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildBusquedaYFiltro(context),
          Expanded(
            child:
                _usuariosFiltrados.isEmpty
                    ? const Center(child: Text('No se encontraron usuarios.'))
                    : ListView.builder(
                      itemCount: _usuariosFiltrados.length,
                      itemBuilder: (_, index) {
                        final usuario = _usuariosFiltrados[index];
                        return UsuarioCard(
                          usuario: usuario,
                          onTap: () => _mostrarDetalle(usuario),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusquedaYFiltro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _busqueda = value),
              decoration: InputDecoration(
                hintText: 'Buscar usuario...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          PopupMenuButton<TipoUsuarioFiltro>(
            initialValue: _filtroSeleccionado,
            onSelected: (filtro) {
              setState(() {
                _filtroSeleccionado = filtro;
              });
            },
            itemBuilder:
                (_) => [
                  PopupMenuItem(
                    value: TipoUsuarioFiltro.todos,
                    child: Row(
                      children: [
                        if (_filtroSeleccionado == TipoUsuarioFiltro.todos)
                          Icon(Icons.check, size: 18),
                        if (_filtroSeleccionado != TipoUsuarioFiltro.todos)
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text(TipoUsuarioFiltro.todos.nombre),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TipoUsuarioFiltro.cliente,
                    child: Row(
                      children: [
                        if (_filtroSeleccionado == TipoUsuarioFiltro.cliente)
                          Icon(Icons.check, size: 18),
                        if (_filtroSeleccionado != TipoUsuarioFiltro.cliente)
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text(TipoUsuarioFiltro.cliente.nombre),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TipoUsuarioFiltro.administrador,
                    child: Row(
                      children: [
                        if (_filtroSeleccionado ==
                            TipoUsuarioFiltro.administrador)
                          Icon(Icons.check, size: 18),
                        if (_filtroSeleccionado !=
                            TipoUsuarioFiltro.administrador)
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text(TipoUsuarioFiltro.administrador.nombre),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TipoUsuarioFiltro.mecanico,
                    child: Row(
                      children: [
                        if (_filtroSeleccionado == TipoUsuarioFiltro.mecanico)
                          Icon(Icons.check, size: 18),
                        if (_filtroSeleccionado != TipoUsuarioFiltro.mecanico)
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text(TipoUsuarioFiltro.mecanico.nombre),
                      ],
                    ),
                  ),
                ],
            icon: Icon(Icons.filter_list_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tooltip: 'Filtrar tipo',
          ),
        ],
      ),
    );
  }
}
