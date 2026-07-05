import '../../../core/services/supabase_service.dart';
import '../models/report_model.dart';

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
    // Generate business code R001, R002, ...
    final countResult = await SupabaseService.client
        .from('ticket_reports')
        .select('id');
    final seq = (countResult.length + 1).toString().padLeft(3, '0');
    final businessCode = 'R$seq';

    await SupabaseService.client.from('ticket_reports').insert({
      'id': SupabaseService.uuid.v4(),
      'code': businessCode,
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

  // =========================================================
  // GET REPORT
  // =========================================================

  static Future<ReportModel?> getReport(
      String ticketId) async {
    final result = await SupabaseService.client
        .from('ticket_reports')
        .select()
        .eq('ticket_id', ticketId)
        .maybeSingle();

    if (result == null) return null;

    return ReportModel.fromJson(result);
  }
}