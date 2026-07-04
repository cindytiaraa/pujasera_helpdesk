import '../../../core/services/supabase_service.dart';
import '../models/comment_model.dart';

class CommentService {
  // =========================================================
  // ADD COMMENT
  // =========================================================

  static Future<void> addComment({
    required String ticketId,
    required String userId,
    required String userName,
    required String role,
    required String text,
  }) async {
    await SupabaseService.client.from('comments').insert({
      'id': SupabaseService.uuid.v4(),
      'ticket_id': ticketId,
      'user_id': userId,
      'user_name': userName,
      'role': role,
      'text': text,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // =========================================================
  // GET COMMENTS BY TICKET
  // =========================================================

  static Future<List<CommentModel>> getComments(
      String ticketId) async {
    final result = await SupabaseService.client
        .from('comments')
        .select()
        .eq('ticket_id', ticketId)
        .order('created_at', ascending: true);

    return result
        .map<CommentModel>((json) => CommentModel.fromJson(json))
        .toList();
  }

  // =========================================================
  // DELETE COMMENT (Optional)
  // =========================================================

  static Future<void> deleteComment(String commentId) async {
    await SupabaseService.client
        .from('comments')
        .delete()
        .eq('id', commentId);
  }
}