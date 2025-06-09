import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/chat/presentation/blocs/chat_bloc.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ChatInitialScreen extends StatefulWidget {
  final List<Conversacion>? conversaciones;

  const ChatInitialScreen({super.key, required this.conversaciones});

  @override
  State<ChatInitialScreen> createState() => _ChatInitialScreenState();
}

class _ChatInitialScreenState extends State<ChatInitialScreen> {
  late List<Conversacion> _conversaciones;

  @override
  void initState() {
    super.initState();
    _conversaciones = List.from(widget.conversaciones ?? []);
  }

  void _abrirConversacion(Conversacion conversacion) {
    context.read<ChatBloc>().add(OnOpenChatEvent(conversacion: conversacion));
  }

  Future<bool> _confirmarEliminarConversacion() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar conversación?'),
        content: const Text(
            'Esta conversación se eliminará permanentemente. ¿Deseas continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _eliminarConversacion(Conversacion conversacion) {
    setState(() {
      _conversaciones.removeWhere((c) => c.id == conversacion.id);
      context.read<ChatBloc>().add(OnDeleteConversacionEvent(conversacion: conversacion));
      CustomSnackBar.show(
        context: context,
        message: "Chat borrado con éxito.",
        backgroundColor: AppColors.primary,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    if (_conversaciones.isEmpty) {
      return const Center(
        child: Text(
          'No hay conversaciones aún.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _conversaciones.length,
          itemBuilder: (context, index) {
            final conversacion = _conversaciones[index];

            return Dismissible(
              key: Key(conversacion.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                final confirmed = await _confirmarEliminarConversacion();
                if (confirmed) {
                  _eliminarConversacion(conversacion);
                }
                return confirmed;
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 28,
                ),
              ),
              child: GestureDetector(
                onTap: () => _abrirConversacion(conversacion),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        child: Text(
                          conversacion.nombre.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversacion.nombre,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Creado: ${dateFormat.format(conversacion.createdAt!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}