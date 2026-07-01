import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  // LOGIN
  static Future<Map<String, dynamic>?> login(
      String email,
      String password,
      ) async {
    final result = await client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    return result;
  }

  // CREATE TICKET
  static Future<Map<String, dynamic>?> createTicket(
      Map<String, dynamic> ticketData) async {
    try {
      await client.from('tickets').insert(ticketData);

      return ticketData;
    } catch (e) {
      print('CREATE TICKET ERROR: $e');
      return null;
    }
  }
}