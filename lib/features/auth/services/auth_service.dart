import '../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

class AuthService {
  // =========================================================
  // LOGIN
  // =========================================================

  static Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final result = await SupabaseService.client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    if (result == null) return null;

    return UserModel.fromJson(result);
  }

  // =========================================================
  // REGISTER
  // =========================================================

  static Future<UserModel?> register({
    required String name,
    required String email,
    required String phone,
    required String department,
    required String password,
  }) async {
    final initials = name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .take(2)
        .join();

    // Generate business code U001, U002, ...
    final countResult = await SupabaseService.client
        .from('users')
        .select('id');
    final seq = (countResult.length + 1).toString().padLeft(3, '0');
    final businessCode = 'U$seq';

    final data = {
      'id': SupabaseService.uuid.v4(),
      'code': businessCode,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'user',
      'department': department,
      'avatar': initials,
      'password': password,
    };

    await SupabaseService.client
        .from('users')
        .insert(data);

    return UserModel.fromJson(data);
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  static Future<void> logout() async {
    // Session dibersihkan oleh SessionService.
    return;
  }

  // =========================================================
  // RESET PASSWORD
  // =========================================================

  static Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final user = await SupabaseService.client
        .from('users')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      return false;
    }

    await SupabaseService.client
        .from('users')
        .update({
          'password': newPassword,
        })
        .eq('email', email);

    return true;
  }
}