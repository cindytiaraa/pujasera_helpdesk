import 'supabase_service.dart';

class ReportService {
  static Future<void> createReport({
    required String ticketId,
    required String resolvedBy,
    required String resolution,
    required String resolutionNote,
    required int durationMinutes,
    int? customerRating,
    String? customerFeedback,
  }) async {
    await SupabaseService.client.from('ticket_reports').insert({
      'id': SupabaseService.uuid.v4(),
      'ticket_id': ticketId,
      'resolved_by': resolvedBy,
      'resolution': resolution,
      'resolution_note': resolutionNote,
      'duration_minutes': durationMinutes,
      'customer_rating': customerRating,
      'customer_feedback': customerFeedback,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<Map<String, dynamic>?> getReport(
      String ticketId) async {
    final result = await SupabaseService.client
        .from('ticket_reports')
        .select()
        .eq('ticket_id', ticketId)
        .maybeSingle();

    return result;
  }
}