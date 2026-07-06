import 'supabase_service.dart';

class AuthService {
  static Future<Map<String, dynamic>?> login(
      String email,
      String password) async {
    final result = await SupabaseService.client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    return result;
  }
}