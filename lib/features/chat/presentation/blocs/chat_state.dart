part of 'chat_bloc.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState{
  final List<Conversacion>? conversaciones;

  ChatInitial({required this.conversaciones});
}

final class OpenChat extends ChatState {
  final List<Mensaje>? mensajes;
  final String currentUserId;
  final Conversacion conversacion;

  OpenChat({required this.mensajes, required this.currentUserId, required this.conversacion});
}

final class ChatLoading extends ChatState {}

final class ChatError extends ChatState {
  final Failure failure;
  ChatError({required this.failure});
}