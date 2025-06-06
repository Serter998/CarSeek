import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ConversacionSource {
  Future<List<ConversacionModel>?> getAllConversacionesByCurrentUser();
  Future<void> createConversacion(ConversacionModel conversacion);
  Future<void> deleteConversacion(String id);
  Future<ConversacionModel?> getConversacionByUsuariosYNombre({
    required String usuario1,
    required String usuario2,
    required String nombre,
  });
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

  @override
  Future<ConversacionModel?> getConversacionByUsuariosYNombre({
    required String usuario1,
    required String usuario2,
    required String nombre,
  }) async {
    final response = await supabaseClient
        .from('conversaciones')
        .select()
        .or(
        'and(usuario1.eq.$usuario1,usuario2.eq.$usuario2),and(usuario1.eq.$usuario2,usuario2.eq.$usuario1)'
    )
        .eq('nombre', nombre)
        .maybeSingle();

    if (response == null) return null;
    return ConversacionModel.fromJson(response);
  }
}