part of 'chat_bloc.dart';

sealed class ChatEvent {}

final class OnLoadInitialChatsEvent extends ChatEvent {}

final class OnOpenChatEvent extends ChatEvent {
  final Conversacion conversacion;

  OnOpenChatEvent({required this.conversacion});
}

final class OnDeleteConversacionEvent extends ChatEvent {
  final Conversacion conversacion;

  OnDeleteConversacionEvent({required this.conversacion});
}

final class OnSendMessageEvent extends ChatEvent {
  final Mensaje mensaje;
  final Conversacion conversacion;

  OnSendMessageEvent({required this.mensaje, required this.conversacion});
}

final class OnDeleteMessageEvent extends ChatEvent {
  final Mensaje mensaje;
  final Conversacion conversacion;

  OnDeleteMessageEvent({required this.mensaje, required this.conversacion});
}
