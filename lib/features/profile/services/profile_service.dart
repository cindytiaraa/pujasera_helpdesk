import '../../../core/services/supabase_service.dart';
import '../../auth/models/user_model.dart';

class ProfileService {
  // =========================================================
  // GET PROFILE
  // =========================================================

  static Future<UserModel?> getProfile(
      String userId) async {
    final result = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (result == null) return null;

    return UserModel.fromJson(result);
  }

  // =========================================================
  // UPDATE PROFILE
  // =========================================================

  static Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    String? phone,
  }) async {
    await SupabaseService.client.from('users').update({
      'name': name,
      'email': email,
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  // =========================================================
  // GET HELPDESK LIST
  // =========================================================

  static Future<List<UserModel>> getHelpdeskList() async {
    final result = await SupabaseService.client
        .from('users')
        .select()
        .eq('role', 'helpdesk')
        .order('name');

    return result.map(UserModel.fromJson).toList();
  }
}