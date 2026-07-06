import 'supabase_service.dart';

class HistoryService {
  static Future<void> addHistory({
    required String ticketId,
    required String actorId,
    required String actorName,
    required String status,
    required String title,
    required String description,
    required String location,
  }) async {
    await SupabaseService.client.from('ticket_history').insert({
      'id': SupabaseService.uuid.v4(),
      'ticket_id': ticketId,
      'actor_id': actorId,
      'actor_name': actorName,
      'status': status,
      'title': title,
      'description': description,
      'location': location,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getTicketHistory(
      String ticketId) async {
    final result = await SupabaseService.client
        .from('ticket_history')
        .select()
        .eq('ticket_id', ticketId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(result);
  }
}