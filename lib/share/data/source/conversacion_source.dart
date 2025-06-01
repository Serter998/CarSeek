import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ConversacionSource {
  Future<List<ConversacionModel>?> getAllConversacionesByCurrentUser();
  Future<void> createConversacion(ConversacionModel conversacion);
  Future<void> deleteConversacion(String id);
}

class ConversacionSourceImpl implements ConversacionSource {
  final String _apiKey;

  ConversacionSourceImpl(this._apiKey);

  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<void> createConversacion(ConversacionModel conversacion) async {
    await supabaseClient.from('conversaciones').insert(conversacion.toJson());
  }

  @override
  Future<void> deleteConversacion(String id) async {
    await supabaseClient.from('conversaciones').delete().eq('id', id);
  }

  @override
  Future<List<ConversacionModel>?> getAllConversacionesByCurrentUser() async {
    String? idUsuario = supabaseClient.auth.currentUser!.id;
    if(idUsuario.isEmpty) {
      throw Exception("No se ha iniciado sesión.");
    }
    final List<dynamic> result = await supabaseClient
        .from('conversaciones')
        .select()
        .or('usuario1.eq.$idUsuario,usuario2.eq.$idUsuario');

    return result.map((json) => ConversacionModel.fromJson(json)).toList();
  }
}