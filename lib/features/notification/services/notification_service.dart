import '../../../../core/services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  // =========================================================
  // SEND NOTIFICATION
  // =========================================================

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

  // =========================================================
  // GET USER NOTIFICATIONS
  // =========================================================

  static Future<List<NotificationModel>> getNotifications(
      String userId) async {
    final result = await SupabaseService.client
        .from('notifications')
        .select()
        .eq('target_user_id', userId)
        .order('created_at', ascending: false);

    return result.map(NotificationModel.fromJson).toList();
  }

  // =========================================================
  // MARK AS READ
  // =========================================================

  static Future<void> markAsRead(String notificationId) async {
    await SupabaseService.client.from('notifications').update({
      'is_read': true,
    }).eq('id', notificationId);
  }

  // =========================================================
  // MARK ALL AS READ
  // =========================================================

  static Future<void> markAllAsRead(String userId) async {
    await SupabaseService.client.from('notifications').update({
      'is_read': true,
    }).eq('target_user_id', userId);
  }

  // =========================================================
  // GET UNREAD COUNT
  // =========================================================

  static Future<int> getUnreadCount(String userId) async {
    final result = await SupabaseService.client
        .from('notifications')
        .select('id')
        .eq('target_user_id', userId)
        .eq('is_read', false);

    return result.length;
  }

  // =========================================================
  // DELETE NOTIFICATION (OPTIONAL)
  // =========================================================

  static Future<void> deleteNotification(String notificationId) async {
    await SupabaseService.client
        .from('notifications')
        .delete()
        .eq('id', notificationId);
  }
}