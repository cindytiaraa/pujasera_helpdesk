import 'supabase_service.dart';

class NotificationService {
  static Future<void> sendNotification({
    required String ticketId,
    required String targetUserId,
    required String title,
    required String message,
    required String type,
  }) async {
    await SupabaseService.client.from('notifications').insert({
      'id': SupabaseService.uuid.v4(),
      'ticket_id': ticketId,
      'target_user_id': targetUserId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}