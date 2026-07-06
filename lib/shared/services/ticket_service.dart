import 'history_service.dart';
import 'notification_service.dart';
import 'supabase_service.dart';

class TicketService {
  // =========================================================
  // CREATE TICKET
  // =========================================================

  static Future<Map<String, dynamic>?> createTicket(
      Map<String, dynamic> ticketData) async {
    try {
      final ticketId = SupabaseService.uuid.v4();

      ticketData['id'] = ticketId;
      ticketData['status'] = 'Open';
      ticketData['current_stage'] = 'Tiket berhasil dibuat';
      ticketData['created_at'] = DateTime.now().toIso8601String();
      ticketData['updated_at'] = DateTime.now().toIso8601String();

      await SupabaseService.client.from('tickets').insert(ticketData);

      // History pertama
      await HistoryService.addHistory(
        ticketId: ticketId,
        actorId: ticketData['user_id'],
        actorName: 'Customer',
        status: 'Open',
        title: 'Tiket berhasil dibuat',
        description: 'Pengguna berhasil membuat tiket.',
        location: ticketData['location'] ?? '-',
      );

      // Notifikasi ke semua admin
      final admins = await SupabaseService.client
          .from('users')
          .select()
          .eq('role', 'admin');

      for (final admin in admins) {
        await NotificationService.sendNotification(
          ticketId: ticketId,
          targetUserId: admin['id'],
          title: 'Tiket Baru',
          message: 'Terdapat tiket baru yang menunggu penanganan.',
          type: 'ticket_created',
        );
      }

      return ticketData;
    } catch (e) {
      print("CREATE TICKET ERROR : $e");
      return null;
    }
  }

  // =========================================================
  // ASSIGN PETUGAS
  // =========================================================

  static Future<void> assignTicketToStaff({
    required String ticketId,
    required String petugasId,
    required String petugasName,
  }) async {
    await SupabaseService.client.from('tickets').update({
      'assigned_to_id': petugasId,
      'status': 'Assigned',
      'current_stage': 'Petugas telah ditugaskan',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', ticketId);

    await HistoryService.addHistory(
      ticketId: ticketId,
      actorId: petugasId,
      actorName: petugasName,
      status: 'Assigned',
      title: 'Petugas ditugaskan',
      description: '$petugasName menerima penugasan.',
      location: 'Helpdesk',
    );

    await NotificationService.sendNotification(
      ticketId: ticketId,
      targetUserId: petugasId,
      title: 'Penugasan Baru',
      message: 'Anda mendapatkan tiket baru.',
      type: 'assigned',
    );
  }

  // =========================================================
  // UPDATE STATUS
  // =========================================================

  static Future<void> updateTicketStatus({
    required String ticketId,
    required String actorId,
    required String actorName,
    required String status,
    required String stage,
    String description = '',
    String location = '-',
  }) async {
    await SupabaseService.client.from('tickets').update({
      'status': status,
      'current_stage': stage,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', ticketId);

    await HistoryService.addHistory(
      ticketId: ticketId,
      actorId: actorId,
      actorName: actorName,
      status: status,
      title: stage,
      description: description,
      location: location,
    );

    final ticket = await SupabaseService.client
        .from('tickets')
        .select('user_id')
        .eq('id', ticketId)
        .single();

    await NotificationService.sendNotification(
      ticketId: ticketId,
      targetUserId: ticket['user_id'],
      title: 'Status Ticket Berubah',
      message: stage,
      type: 'status_update',
    );
  }

  // =========================================================
  // GET TICKET BY ID
  // =========================================================

  static Future<Map<String, dynamic>?> getTicketById(
      String ticketId) async {
    return await SupabaseService.client
        .from('tickets')
        .select()
        .eq('id', ticketId)
        .maybeSingle();
  }

  // =========================================================
  // USER TICKETS
  // =========================================================

  static Future<List<Map<String, dynamic>>> getMyTickets(
      String userId) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(result);
  }

  // =========================================================
  // HELPDESK TICKETS
  // =========================================================

  static Future<List<Map<String, dynamic>>> getAssignedTickets(
      String petugasId) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .eq('assigned_to_id', petugasId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(result);
  }
}