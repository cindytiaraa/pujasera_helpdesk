import '../../core/services/session_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DummyDataService
// Sumber data dummy di seluruh aplikasi — tema Smart Pujasera Helpdesk.
// Semua filter berbasis role ada di sini — screen tinggal panggil method.
// ─────────────────────────────────────────────────────────────────────────────

class DummyDataService {

  // ── USERS ──────────────────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> users = [
    {
      'id': 'usr-budi-001',
      'code': 'U001',
      'name': 'Budi Santoso',
      'email': 'budi@pujasera.id',
      'phone': '081234567890',
      'role': 'user',
      'department': 'Tenant Bakso',
      'avatar': 'BS',
      'password': '123456',
    },
    {
      'id': 'usr-siti-002',
      'code': 'U002',
      'name': 'Siti Rahma',
      'email': 'siti@pujasera.id',
      'phone': '081311112222',
      'role': 'helpdesk',
      'department': 'Cleaning Service',
      'avatar': 'SR',
      'password': '123456',
    },
    {
      'id': 'usr-andi-003',
      'code': 'U003',
      'name': 'Andi Pratama',
      'email': 'admin@pujasera.id',
      'phone': '081200000001',
      'role': 'admin',
      'department': 'Manajemen',
      'avatar': 'AP',
      'password': 'admin123',
    },
    {
      'id': 'usr-dewi-004',
      'code': 'U004',
      'name': 'Dewi Lestari',
      'email': 'dewi@pujasera.id',
      'phone': '081399988877',
      'role': 'user',
      'department': 'Tenant Ayam Geprek',
      'avatar': 'DL',
      'password': '123456',
    },
    {
      'id': 'usr-rudi-005',
      'code': 'U005',
      'name': 'Rudi Hermawan',
      'email': 'rudi@pujasera.id',
      'phone': '081766655544',
      'role': 'helpdesk',
      'department': 'Keamanan',
      'avatar': 'RH',
      'password': '123456',
    },
  ];

  // Daftar helpdesk yang bisa dipilih saat assign (untuk admin)
  static List<Map<String, dynamic>> get helpdeskList =>
      users.where((u) => u['role'] == 'helpdesk').toList();

  // ── TICKETS ────────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> tickets = [
    {
      'id': 'tkt-uuid-00001',
      'code': 'T001',
      'title': 'Lampu tenant mati',
      'description': 'Lampu di Tenant Bakso Pak Budi mati sejak pagi. Pengunjung kesulitan melihat menu dan area makan menjadi gelap.',
      'category': 'Listrik',
      'priority': 'Tinggi',
      'status': 'In Progress',
      'user_id': 'usr-budi-001',
      'assigned_to_id': 'usr-siti-002',
      'created_at': '2026-07-01T08:30:00',
      'updated_at': '2026-07-01T09:15:00',
      'location': 'Tenant Bakso - Stand B3',
      'current_stage': 'Sedang dikerjakan Helpdesk',
    },
    {
      'id': 'tkt-uuid-00002',
      'code': 'T002',
      'title': 'AC tidak dingin',
      'description': 'AC di area makan lantai 2 sudah tidak dingin sejak 2 hari yang lalu. Pengunjung merasa tidak nyaman karena panas.',
      'category': 'AC',
      'priority': 'Tinggi',
      'status': 'Open',
      'user_id': 'usr-dewi-004',
      'assigned_to_id': null,
      'created_at': '2026-07-02T10:00:00',
      'updated_at': '2026-07-02T10:00:00',
      'location': 'Area Makan Lantai 2',
      'current_stage': 'Tiket berhasil dibuat',
    },
    {
      'id': 'tkt-uuid-00003',
      'code': 'T003',
      'title': 'Internet putus di area kasir',
      'description': 'Koneksi internet di area kasir utama terputus. Transaksi non-tunai tidak dapat diproses dan antrian pelanggan menumpuk.',
      'category': 'Internet',
      'priority': 'Tinggi',
      'status': 'Assigned',
      'user_id': 'usr-budi-001',
      'assigned_to_id': null,
      'created_at': '2026-07-02T14:00:00',
      'updated_at': '2026-07-02T14:30:00',
      'location': 'Kasir Utama - Lantai 1',
      'current_stage': 'Tiket diterima Admin',
    },
    {
      'id': 'tkt-uuid-00004',
      'code': 'T004',
      'title': 'Saluran air bocor',
      'description': 'Saluran air di area dapur Tenant Soto bocor dan menggenang di lantai. Berpotensi membahayakan karyawan dan pelanggan.',
      'category': 'Air',
      'priority': 'Tinggi',
      'status': 'Close',
      'user_id': 'usr-dewi-004',
      'assigned_to_id': 'usr-rudi-005',
      'created_at': '2026-06-30T07:00:00',
      'updated_at': '2026-06-30T12:00:00',
      'location': 'Tenant Soto - Area Dapur',
      'current_stage': 'Pekerjaan telah selesai',
    },
    {
      'id': 'tkt-uuid-00005',
      'code': 'T005',
      'title': 'Mesin kasir error',
      'description': 'Mesin kasir di stand Tenant Ayam Geprek mengalami error dan tidak bisa mencetak struk. Kasir tidak dapat melayani pembayaran.',
      'category': 'Peralatan',
      'priority': 'Sedang',
      'status': 'Open',
      'user_id': 'usr-budi-001',
      'assigned_to_id': null,
      'created_at': '2026-07-03T11:30:00',
      'updated_at': '2026-07-03T11:30:00',
      'location': 'Tenant Ayam Geprek - Stand C1',
      'current_stage': 'Tiket berhasil dibuat',
    },
    {
      'id': 'tkt-uuid-00006',
      'code': 'T006',
      'title': 'Toilet kotor dan tidak terawat',
      'description': 'Toilet umum lantai 1 dalam kondisi kotor dan bau tidak sedap. Sudah terjadi sejak pagi dan belum ada petugas kebersihan yang membersihkan.',
      'category': 'Kebersihan',
      'priority': 'Sedang',
      'status': 'In Progress',
      'user_id': 'usr-dewi-004',
      'assigned_to_id': 'usr-siti-002',
      'created_at': '2026-07-03T09:00:00',
      'updated_at': '2026-07-03T09:45:00',
      'location': 'Toilet Umum Lantai 1',
      'current_stage': 'Sedang dikerjakan Helpdesk',
    },
  ];

  // ── NOTIFICATIONS ──────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> notifications = [
    {
      'id': 'N001',
      'ticket_id': 'tkt-uuid-00001',
      'target_user_id': 'usr-budi-001',
      'title': 'Laporan Anda sedang dikerjakan',
      'message': 'Siti Rahma telah menerima laporan T001 (Lampu tenant mati) dan sedang menangani.',
      'type': 'status_update',
      'is_read': false,
      'created_at': '2026-07-01T09:15:00',
    },
    {
      'id': 'N002',
      'ticket_id': 'tkt-uuid-00004',
      'target_user_id': 'usr-dewi-004',
      'title': 'Laporan Anda telah selesai',
      'message': 'Laporan T004 (Saluran air bocor) telah selesai dikerjakan. Terima kasih.',
      'type': 'ticket_closed',
      'is_read': true,
      'created_at': '2026-06-30T12:00:00',
    },
    {
      'id': 'N003',
      'ticket_id': 'tkt-uuid-00001',
      'target_user_id': 'usr-siti-002',
      'title': 'Penugasan Baru',
      'message': 'Admin menugaskan laporan T001 (Lampu tenant mati) kepada Anda untuk ditangani.',
      'type': 'assigned',
      'is_read': false,
      'created_at': '2026-07-01T09:00:00',
    },
    {
      'id': 'N004',
      'ticket_id': 'tkt-uuid-00002',
      'target_user_id': 'usr-andi-003',
      'title': 'Tiket Baru Masuk',
      'message': 'Terdapat tiket baru T002 (AC tidak dingin) yang menunggu penanganan.',
      'type': 'ticket_created',
      'is_read': false,
      'created_at': '2026-07-02T10:00:00',
    },
    {
      'id': 'N005',
      'ticket_id': 'tkt-uuid-00003',
      'target_user_id': 'usr-budi-001',
      'title': 'Tiket berhasil dibuat',
      'message': 'Laporan T003 (Internet putus di area kasir) sedang menunggu penanganan admin.',
      'type': 'ticket_created',
      'is_read': true,
      'created_at': '2026-07-02T14:00:00',
    },
    {
      'id': 'N006',
      'ticket_id': 'tkt-uuid-00006',
      'target_user_id': 'usr-siti-002',
      'title': 'Penugasan Baru',
      'message': 'Admin menugaskan laporan T006 (Toilet kotor dan tidak terawat) kepada Anda.',
      'type': 'assigned',
      'is_read': false,
      'created_at': '2026-07-03T09:45:00',
    },
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // QUERY METHODS — selalu gunakan method ini, jangan akses list langsung
  // ══════════════════════════════════════════════════════════════════════════

  // ── Auth ───────────────────────────────────────────────────────────────────
  static Map<String, dynamic>? findUser(String email, String password) {
    try {
      return users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Tickets — berbasis role ─────────────────────────────────────────────────

  /// Laporan yang boleh dilihat oleh user yang sedang login
  static List<Map<String, dynamic>> getTicketsForCurrentUser() {
    if (SessionService.canManageTickets) {
      // helpdesk & admin: semua laporan
      return List<Map<String, dynamic>>.from(tickets);
    }
    // user biasa: hanya laporan miliknya
    return tickets
        .where((t) => t['user_id'] == SessionService.userId)
        .toList();
  }

  /// Filter tambahan: laporan berdasarkan status (null = semua)
  static List<Map<String, dynamic>> getTicketsByStatus(String? status) {
    final base = getTicketsForCurrentUser();
    if (status == null) return base;
    return base.where((t) => t['status'] == status).toList();
  }

  /// Laporan yang sedang ditangani helpdesk tertentu
  static List<Map<String, dynamic>> getTicketsAssignedTo(String helpdeskId) {
    return tickets
        .where((t) => t['assigned_to_id'] == helpdeskId)
        .toList();
  }

  /// Cari laporan by ID — hanya kembalikan jika user berhak lihat
  static Map<String, dynamic>? findTicketById(String id) {
    try {
      final ticket = tickets.firstWhere((t) => t['id'] == id);
      // user biasa hanya boleh lihat laporan miliknya
      if (SessionService.isUser && ticket['user_id'] != SessionService.userId) {
        return null; // tidak berhak
      }
      return ticket;
    } catch (_) {
      return null;
    }
  }

  // ── Ticket mutations ────────────────────────────────────────────────────────

  /// Update status laporan — hanya helpdesk & admin
  static bool updateTicketStatus(String ticketId, String newStatus) {
    if (!SessionService.canManageTickets) return false;
    final idx = tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) return false;
    tickets[idx]['status'] = newStatus;
    tickets[idx]['updated_at'] = DateTime.now().toIso8601String();
    return true;
  }

  /// Assign laporan ke helpdesk — hanya admin
  static bool assignTicket(String ticketId, String helpdeskId, String helpdeskName) {
    if (!SessionService.canAssignTickets) return false;
    final idx = tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) return false;
    tickets[idx]['assigned_to_id'] = helpdeskId;
    tickets[idx]['updated_at']     = DateTime.now().toIso8601String();
    // Ubah status ke In Progress jika sebelumnya Assigned
    if (tickets[idx]['status'] == 'Assigned') {
      tickets[idx]['status'] = 'In Progress';
    }
    // Tambah notifikasi ke helpdesk yang ditugaskan
    _addNotification(
      ticketId: ticketId,
      targetUserId: helpdeskId,
      title: 'Laporan baru ditugaskan kepada Anda',
      message: 'Admin menugaskan laporan $ticketId kepada Anda.',
      type: 'assigned',
    );
    return true;
  }

  /// Tambah laporan baru — hanya user biasa
  static Map<String, dynamic>? createTicket(Map<String, dynamic> data) {
    if (!SessionService.canCreateTicket) return null;
    final seq = (tickets.length + 1).toString().padLeft(3, '0');
    final newTicket = {
      'id': 'tkt-uuid-${DateTime.now().millisecondsSinceEpoch}',
      'code': 'T$seq',
      'user_id':   SessionService.userId,
      'assigned_to_id': null,
      'status':    'Open',
      'current_stage': 'Tiket berhasil dibuat',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      ...data,
    };
    tickets.insert(0, newTicket);
    // Notifikasi ke pembuat laporan
    _addNotification(
      ticketId: newTicket['id'],
      targetUserId: SessionService.userId,
      title: 'Laporan berhasil dibuat',
      message: 'Laporan ${newTicket['code']} sedang menunggu penanganan.',
      type: 'ticket_created',
    );
    return newTicket;
  }

  /// Tambah komentar — semua role boleh
  static bool addComment(String ticketId, String text) {
    final idx = tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) return false;
    final comment = {
      'id':        'C${DateTime.now().millisecondsSinceEpoch}',
      'ticket_id': ticketId,
      'user_id':   SessionService.userId,
      'user_name': SessionService.userName,
      'role':      SessionService.userRole,
      'text':      text,
      'created_at': DateTime.now().toIso8601String(),
    };
    tickets[idx]['comments'] ??= [];
    (tickets[idx]['comments'] as List).add(comment);
    return true;
  }

  // ── Notifications — berbasis role ───────────────────────────────────────────
  static List<Map<String, dynamic>> getNotificationsForCurrentUser() {
    if (SessionService.isAdmin) {
      return List<Map<String, dynamic>>.from(notifications);
    }
    return notifications
        .where((n) => n['target_user_id'] == SessionService.userId)
        .toList();
  }

  static int getUnreadCount() {
    return getNotificationsForCurrentUser()
        .where((n) => n['is_read'] == false)
        .length;
  }

  static void markNotificationRead(String id) {
    final idx = notifications.indexWhere((n) => n['id'] == id);
    if (idx != -1) notifications[idx]['is_read'] = true;
  }

  static void markAllNotificationsRead() {
    for (final n in notifications) {
      if (n['target_user_id'] == SessionService.userId || SessionService.isAdmin) {
        n['is_read'] = true;
      }
    }
  }

  // ── Dashboard stats — berbasis role ────────────────────────────────────────
  static Map<String, dynamic> getDashboardStats() {
    final myTickets = getTicketsForCurrentUser();
    return {
      'total':   myTickets.length,
      'open':    myTickets.where((t) => t['status'] == 'Open').length,
      'assigned': myTickets.where((t) => t['status'] == 'Assigned').length,
      'in_progress': myTickets.where((t) => t['status'] == 'In Progress').length,
      'close':   myTickets.where((t) => t['status'] == 'Close').length,
      'unreadNotifications': getUnreadCount(),
    };
  }

  // ── Private helpers ─────────────────────────────────────────────────────────
  static void _addNotification({
    required String ticketId,
    required String targetUserId,
    required String title,
    required String message,
    required String type,
  }) {
    notifications.insert(0, {
      'id':            'N${DateTime.now().millisecondsSinceEpoch}',
      'ticket_id':     ticketId,
      'target_user_id': targetUserId,
      'title':         title,
      'message':       message,
      'type':          type,
      'is_read':       false,
      'created_at':    DateTime.now().toIso8601String(),
    });
  }
}
