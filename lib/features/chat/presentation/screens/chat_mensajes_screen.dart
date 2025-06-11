import 'package:car_seek/share/data/models/mensaje_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:car_seek/share/domain/entities/mensaje.dart';
import '../blocs/chat_bloc.dart';

class ChatMensajesScreen extends StatefulWidget {
  final List<Mensaje>? mensajes;
  final String currentUserId;
  final Conversacion conversacion;

  const ChatMensajesScreen({
    super.key,
    required this.mensajes,
    required this.currentUserId,
    required this.conversacion,
  });

  @override
  State<ChatMensajesScreen> createState() => _ChatMensajesScreenState();
}

class _ChatMensajesScreenState extends State<ChatMensajesScreen> {
  late List<Mensaje> _mensajes;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  late Stream<List<Mensaje>> _mensajesStream;
  late final RealtimeChannel _mensajesChannel;

  @override
  void initState() {
    super.initState();
    _mensajes = List.from(widget.mensajes ?? []);
    _mensajes.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    _setupStream();
    _setupRealtimeUpdates();
  }

  @override
  void dispose() {
    _mensajesChannel.unsubscribe();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupStream() {
    final supabase = Supabase.instance.client;

    _mensajesStream = supabase
        .from('mensajes')
        .stream(primaryKey: ['id'])
        .eq('conversacion_id', widget.conversacion.id)
        .order('created_at')
        .map((data) => data.map((json) => MensajeModel.fromJson(json)).toList());
  }

  void _setupRealtimeUpdates() {
    final supabase = Supabase.instance.client;

    _mensajesChannel = supabase.channel('mensajes_changes')
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'mensajes',
      callback: (payload) {
        final deletedMessage = MensajeModel.fromJson(payload.oldRecord);
        if (deletedMessage.conversacionId == widget.conversacion.id) {
          setState(() {
            _mensajes.removeWhere((m) => m.id == deletedMessage.id);
          });
        }
      },
    )
        .subscribe();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _enviarMensaje() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    final nuevoMensaje = Mensaje(
      conversacionId: widget.conversacion.id,
      senderId: widget.currentUserId,
      context: texto,
    );

    context.read<ChatBloc>().add(
      OnSendMessageEvent(
        mensaje: nuevoMensaje,
        conversacion: widget.conversacion,
      ),
    );

    _controller.clear();

    _scrollToBottom();
  }

  void _confirmarEliminarMensaje(Mensaje mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar mensaje?'),
        content: const Text('Este mensaje se eliminará permanentemente.'),
        actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatBloc>().add(
                OnDeleteMessageEvent(
                  mensaje: mensaje,
                  conversacion: widget.conversacion,
                ),
              );
              _setupStream();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMensaje(Mensaje mensaje) {
    final isMe = mensaje.senderId == widget.currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                mensaje.context,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (isMe)
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmarEliminarMensaje(mensaje);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Mensaje>>(
                  stream: _mensajesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _mensajes = snapshot.data!;
                      _mensajes.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
                      _scrollToBottom();
                    }

                    return _mensajes.isEmpty
                        ? const Center(
                      child: Text(
                        'Aún no hay mensajes en esta conversación.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _mensajes.length,
                      itemBuilder: (context, index) {
                        final mensaje = _mensajes[index];
                        return _buildMensaje(mensaje);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _enviarMensaje(),
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _enviarMensaje,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}