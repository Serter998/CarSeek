import 'package:car_seek/features/chat/presentation/blocs/chat_bloc.dart';
import 'package:car_seek/features/chat/presentation/screens/chat_error_screen.dart';
import 'package:car_seek/features/chat/presentation/screens/chat_initial_screen.dart';
import 'package:car_seek/features/chat/presentation/screens/chat_mensajes_screen.dart';
import 'package:car_seek/share/domain/entities/conversacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final Conversacion? conversacion;
  const ChatScreen({super.key, this.conversacion});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final chatBloc = context.read<ChatBloc>();
    final state = context.read<ChatBloc>().state;
    if (state is! ChatInitial) {
      context.read<ChatBloc>().add(OnLoadInitialChatsEvent());
    }

    if (widget.conversacion != null) {
      Future.delayed(const Duration(milliseconds: 0), () {
        if (mounted) {
          chatBloc.add(OnOpenChatEvent(conversacion: widget.conversacion!));
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial) {
              return const Icon(Icons.chat);
            } else {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<ChatBloc>().add(OnLoadInitialChatsEvent());
                },
              );
            }
          },
        ),
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial) {
              return const Text("Mis Chats");
            } else if (state is OpenChat) {
              String nombre = state.conversacion.nombre;
              return Text(nombre);
            } else if (state is ChatLoading) {
              return const Text("Cargando");
            } else if (state is ChatError) {
              return const Text("Error");
            } else {
              return const Text("Error desconocido");
            }
          },
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          switch (state) {
            case ChatLoading():
              return const Center(child: CircularProgressIndicator());
            case ChatInitial():
              return ChatInitialScreen(conversaciones: state.conversaciones);
            case OpenChat():
              return ChatMensajesScreen(
                currentUserId: state.currentUserId,
                mensajes: state.mensajes,
                conversacion: state.conversacion,
              );
            case ChatError():
              return ChatErrorScreen(failure: state.failure);
          }
        },
      ),
    );
  }
}
