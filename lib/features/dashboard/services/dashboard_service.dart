import '../../../core/services/supabase_service.dart';
import '../../ticket/models/ticket_model.dart';

class DashboardService {
  // =========================================================
  // GET DASHBOARD STATISTICS
  // =========================================================

  static Future<Map<String, int>> getStatistics() async {
    final tickets =
        await SupabaseService.client.from('tickets').select('status');

    int open = 0;
    int assigned = 0;
    int inProgress = 0;
    int close = 0;

    for (final ticket in tickets) {
      switch (ticket['status']) {
        case 'Open':
          open++;
          break;

        case 'Assigned':
          assigned++;
          break;

        case 'In Progress':
          inProgress++;
          break;

        case 'Close':
          close++;
          break;
      }
    }

    return {
      'total': tickets.length,
      'open': open,
      'assigned': assigned,
      'in_progress': inProgress,
      'close': close,
    };
  }

  // =========================================================
  // GET RECENT TICKETS
  // =========================================================

  static Future<List<TicketModel>> getRecentTickets({
    int limit = 5,
  }) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);

    return result.map(TicketModel.fromJson).toList();
  }
}