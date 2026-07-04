import 'history_service.dart';
import '../../notification/services/notification_service.dart';
import '../../../core/services/supabase_service.dart';
import '../models/ticket_model.dart';
import '../../auth/models/user_model.dart';

class TicketService {
  // =========================================================
  // CREATE TICKET
  // =========================================================

  static Future<TicketModel?> createTicket(
      TicketModel ticket) async {
    try {
      final ticketId = SupabaseService.uuid.v4();

      final newTicket = ticket.copyWith(
        id: ticketId,
        status: 'Open',
        currentStage: 'Tiket berhasil dibuat',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await SupabaseService.client
          .from('tickets')
          .insert(newTicket.toJson());

      // History pertama
      await HistoryService.addHistory(
        ticketId: ticketId,
        actorId: newTicket.userId,
        actorName: 'Customer',
        status: 'Open',
        title: 'Tiket berhasil dibuat',
        description: 'Pengguna berhasil membuat tiket.',
        location: newTicket.location,
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

      return newTicket;
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
      'status': 'In Progress',
      'current_stage': 'Sedang dikerjakan Helpdesk',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', ticketId);

    await HistoryService.addHistory(
      ticketId: ticketId,
      actorId: petugasId,
      actorName: petugasName,
      status: 'In Progress',
      title: 'Helpdesk mulai menangani tiket',
      description: '$petugasName mulai mengerjakan tiket.',
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
  // GET ALL TICKETS
  // =========================================================

  static Future<List<TicketModel>> getAllTickets() async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .order('created_at', ascending: false);

    return result
        .map<TicketModel>((json) => TicketModel.fromJson(json))
        .toList();
  }

  // =========================================================
  // GET TICKET BY ID
  // =========================================================

  static Future<TicketModel?> getTicketById(String ticketId) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .eq('id', ticketId)
        .maybeSingle();

    if (result == null) return null;

    return TicketModel.fromJson(result);
  }

  // =========================================================
  // USER TICKETS
  // =========================================================

  static Future<List<TicketModel>> getMyTickets(
      String userId) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return result.map<TicketModel>((json) => TicketModel.fromJson(json)).toList();
  }

// =========================================================
// GET ASSIGNED TICKETS
// =========================================================

  static Future<List<TicketModel>> getAssignedTickets(
      String helpdeskId) async {
    final result = await SupabaseService.client
        .from('tickets')
        .select()
        .eq('assigned_to_id', helpdeskId)
        .order('created_at', ascending: false);

    return result.map<TicketModel>((json) => TicketModel.fromJson(json)).toList();
  }
  // =========================================================
  // GET HELPDESK LIST
  // =========================================================

  static Future<List<UserModel>> getHelpdeskList() async {
    final result = await SupabaseService.client
        .from('users')
        .select()
        .eq('role', 'helpdesk');

    return result
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
  }

  // =========================================================
  // ACCEPT TICKET
  // =========================================================
  static Future<void> acceptTicket({
    required String ticketId,
    required String adminId,
    required String adminName,
  }) async {
    await SupabaseService.client.from('tickets').update({
      'status': 'Assigned',
      'current_stage': 'Tiket diterima Admin',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', ticketId);

    await HistoryService.addHistory(
      ticketId: ticketId,
      actorId: adminId,
      actorName: adminName,
      status: 'Assigned',
      title: 'Tiket diterima Admin',
      description: 'Admin menerima tiket dan siap melakukan penugasan.',
      location: 'Admin',
    );
  }

  // =========================================================
  // FINISH TICKET
  // =========================================================
  static Future<void> finishTicket({
    required String ticketId,
    required String helpdeskId,
    required String helpdeskName,
  }) async {
    await SupabaseService.client.from('tickets').update({
      'status': 'Close',
      'current_stage': 'Pekerjaan telah selesai',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', ticketId);

    await HistoryService.addHistory(
      ticketId: ticketId,
      actorId: helpdeskId,
      actorName: helpdeskName,
      status: 'Close',
      title: 'Pekerjaan selesai',
      description: '$helpdeskName telah menyelesaikan pekerjaan.',
      location: 'Helpdesk',
    );

    final ticket = await SupabaseService.client
        .from('tickets')
        .select('user_id')
        .eq('id', ticketId)
        .single();

    await NotificationService.sendNotification(
      ticketId: ticketId,
      targetUserId: ticket['user_id'],
      title: 'Tiket Selesai',
      message: 'Laporan Anda telah selesai dikerjakan.',
      type: 'ticket_closed',
    );
  }
}