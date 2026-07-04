import '../../core/services/session_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DummyDataService
// Sumber data dummy di seluruh aplikasi.
// Semua filter berbasis role ada di sini — screen tinggal panggil method.
// ─────────────────────────────────────────────────────────────────────────────

class DummyDataService {

  // ── USERS ──────────────────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> users = [
    {
      'id': 'U001',
      'name': 'Cindy',
      'email': 'cindy@pujasera.id',
      'phone': '081234567890',
      'role': 'user',
      'department': 'Pengunjung',
      'avatar': 'C',
      'password': '123456',
    },
    {
      'id': 'U002',
      'name': 'Barata',
      'email': 'barata@pujasera.id',
      'phone': '081311112222',
      'role': 'helpdesk',
      'department': 'Pelayanan',
      'avatar': 'B',
      'password': '123456',
    },
    {
      'id': 'U003',
      'name': 'Admin',
      'email': 'admin@pujasera.id',
      'phone': '081200000001',
      'role': 'admin',
      'department': 'Manajemen',
      'avatar': 'A',
      'password': 'admin123',
    },
  ];

  // Daftar helpdesk yang bisa dipilih saat assign (untuk admin)
  static List<Map<String, dynamic>> get helpdeskList =>
      users.where((u) => u['role'] == 'helpdesk').toList();

  // ── TICKETS ────────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> tickets = [
    {
      'id': 'TKT-20260001',
      'title': 'Pesanan makanan belum datang',
      'description': 'Saya sudah menunggu lebih dari 30 menit, tetapi pesanan belum datang.',
      'category': 'Pelayanan',
      'priority': 'Tinggi',
      'status': 'Diproses',
      'userId': 'U001',
      'userName': 'Cindy',
      'assignedToId': 'U002',
      'assignedTo': 'Barata',
      'createdAt': '2026-04-15T12:30:00',
      'updatedAt': '2026-04-15T13:00:00',
      'location': 'Meja 12',
      'attachments': [],
      'comments': [
        {
          'id': 'C001',
          'userId': 'U002',
          'userName': 'Barata',
          'role': 'helpdesk',
          'text': 'Sedang kami cek ke tenant terkait.',
          'createdAt': '2026-04-15T12:45:00',
        }
      ],
    },
    {
      'id': 'TKT-20260002',
      'title': 'Meja kotor belum dibersihkan',
      'description': 'Meja masih kotor dari pengunjung sebelumnya.',
      'category': 'Kebersihan',
      'priority': 'Sedang',
      'status': 'Pending',
      'userId': 'U001',
      'userName': 'Cindy',
      'assignedToId': null,
      'assignedTo': null,
      'createdAt': '2026-04-16T14:00:00',
      'updatedAt': '2026-04-16T14:00:00',
      'location': 'Meja 5',
      'attachments': [],
      'comments': [],
    },
    {
      'id': 'TKT-20260003',
      'title': 'Pesanan tidak sesuai',
      'description': 'Saya pesan ayam goreng, tapi yang datang ayam bakar.',
      'category': 'Makanan',
      'priority': 'Tinggi',
      'status': 'Selesai',
      'userId': 'U001',
      'userName': 'Cindy',
      'assignedToId': 'U002',
      'assignedTo': 'Barata',
      'createdAt': '2026-04-14T10:00:00',
      'updatedAt': '2026-04-14T10:30:00',
      'location': 'Meja 2',
      'attachments': [],
      'comments': [
        {
          'id': 'C002',
          'userId': 'U002',
          'userName': 'Barata',
          'role': 'helpdesk',
          'text': 'Pesanan sudah diganti sesuai.',
          'createdAt': '2026-04-14T10:20:00',
        }
      ],
    },
    {
      'id': 'TKT-20260004',
      'title': 'Minuman habis',
      'description': 'Stok minuman es teh habis di tenant.',
      'category': 'Ketersediaan',
      'priority': 'Rendah',
      'status': 'Pending',
      'userId': 'U001',
      'userName': 'Cindy',
      'assignedToId': null,
      'assignedTo': null,
      'createdAt': '2026-04-17T11:00:00',
      'updatedAt': '2026-04-17T11:00:00',
      'location': 'Tenant A',
      'attachments': [],
      'comments': [],
    },
  ];

  // ── NOTIFICATIONS ──────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> notifications = [
    {
      'id': 'N001',
      'ticketId': 'TKT-20260001',
      'targetUserId': 'U001', // notif untuk user
      'title': 'Laporan Anda sedang diproses',
      'message': 'Teknisi Barata telah menerima laporan TKT-20260001 dan akan segera menangani masalah Anda.',
      'type': 'status_update',
      'isRead': false,
      'createdAt': '2026-04-15T09:15:00',
    },
    {
      'id': 'N002',
      'ticketId': 'TKT-20260003',
      'targetUserId': 'U001', // notif untuk user
      'title': 'Laporan Anda telah diselesaikan',
      'message': 'Laporan TKT-20260003 telah diselesaikan. Silakan verifikasi.',
      'type': 'resolved',
      'isRead': true,
      'createdAt': '2026-04-10T13:30:00',
    },
    {
      'id': 'N003',
      'ticketId': 'TKT-20260001',
      'targetUserId': 'U001',   //notif untuk user
      'title': 'Komentar baru pada laporan Anda',
      'message': 'Barata menambahkan komentar pada laporan TKT-20260001.',
      'type': 'comment',
      'isRead': false,
      'createdAt': '2026-04-15T09:15:00',
    },
    {
      'id': 'N004',
      'ticketId': 'TKT-20260001',
      'targetUserId': 'U003',           // notif untuk Sari (helpdesk)
      'title': 'Laporan baru ditugaskan kepada Anda',
      'message': 'Admin menugaskan laporan TKT-20260001 kepada Anda untuk ditangani.',
      'type': 'assigned',
      'isRead': false,
      'createdAt': '2026-04-15T08:45:00',
    },
    {
      'id': 'N005',
      'ticketId': 'TKT-20260005',
      'targetUserId': 'U004',           // notif untuk Doni (helpdesk)
      'title': 'Laporan baru ditugaskan kepada Anda',
      'message': 'Admin menugaskan laporan TKT-20260005 kepada Anda untuk ditangani.',
      'type': 'assigned',
      'isRead': true,
      'createdAt': '2026-04-17T13:30:00',
    },
    {
      'id': 'N006',
      'ticketId': 'TKT-20260002',
      'targetUserId': 'U001',           // notif untuk user
      'title': 'Laporan berhasil dibuat',
      'message': 'Laporan TKT-20260002 telah dibuat dan menunggu penanganan.',
      'type': 'created',
      'isRead': true,
      'createdAt': '2026-04-16T14:00:00',
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
        .where((t) => t['userId'] == SessionService.userId)
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
        .where((t) => t['assignedToId'] == helpdeskId)
        .toList();
  }

  /// Cari laporan by ID — hanya kembalikan jika user berhak lihat
  static Map<String, dynamic>? findTicketById(String id) {
    try {
      final ticket = tickets.firstWhere((t) => t['id'] == id);
      // user biasa hanya boleh lihat laporan miliknya
      if (SessionService.isUser && ticket['userId'] != SessionService.userId) {
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
    tickets[idx]['updatedAt'] = DateTime.now().toIso8601String();
    return true;
  }

  /// Assign laporan ke helpdesk — hanya admin
  static bool assignTicket(String ticketId, String helpdeskId, String helpdeskName) {
    if (!SessionService.canAssignTickets) return false;
    final idx = tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) return false;
    tickets[idx]['assignedToId'] = helpdeskId;
    tickets[idx]['assignedTo']   = helpdeskName;
    tickets[idx]['updatedAt']    = DateTime.now().toIso8601String();
    // Otomatis ubah status ke Diproses jika sebelumnya Pending
    if (tickets[idx]['status'] == 'Pending') {
      tickets[idx]['status'] = 'Diproses';
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
    final newTicket = {
      'id': _generateTicketId(),
      'userId':   SessionService.userId,
      'userName': SessionService.userName,
      'assignedToId': null,
      'assignedTo':   null,
      'status':    'Pending',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'comments':  <Map<String, dynamic>>[],
      ...data,
    };
    tickets.insert(0, newTicket);
    // Notifikasi ke pembuat laporan
    _addNotification(
      ticketId: newTicket['id'],
      targetUserId: SessionService.userId,
      title: 'Laporan berhasil dibuat',
      message: 'Laporan ${newTicket['id']} sedang menunggu penanganan.',
      type: 'created',
    );
    return newTicket;
  }

  /// Tambah komentar — semua role boleh
  static bool addComment(String ticketId, String text) {
    final idx = tickets.indexWhere((t) => t['id'] == ticketId);
    if (idx == -1) return false;
    final comment = {
      'id':        'C${DateTime.now().millisecondsSinceEpoch}',
      'userId':    SessionService.userId,
      'userName':  SessionService.userName,
      'role':      SessionService.userRole,
      'text':      text,
      'createdAt': DateTime.now().toIso8601String(),
    };
    (tickets[idx]['comments'] as List).add(comment);
    return true;
  }

  // ── Notifications — berbasis role ───────────────────────────────────────────
  //
  // User hanya melihat notifikasi miliknya (targetUserId == currentUserId).
  // Helpdesk melihat notifikasi yang ditujukan padanya.
  // Admin melihat semua notifikasi (tidak difilter).
  // ─────────────────────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> getNotificationsForCurrentUser() {
    if (SessionService.isAdmin) {
      return List<Map<String, dynamic>>.from(notifications);
    }
    return notifications
        .where((n) => n['targetUserId'] == SessionService.userId)
        .toList();
  }

  static int getUnreadCount() {
    return getNotificationsForCurrentUser()
        .where((n) => n['isRead'] == false)
        .length;
  }

  static void markNotificationRead(String id) {
    final idx = notifications.indexWhere((n) => n['id'] == id);
    if (idx != -1) notifications[idx]['isRead'] = true;
  }

  static void markAllNotificationsRead() {
    for (final n in notifications) {
      if (n['targetUserId'] == SessionService.userId || SessionService.isAdmin) {
        n['isRead'] = true;
      }
    }
  }

  // ── Dashboard stats — berbasis role ────────────────────────────────────────
  static Map<String, dynamic> getDashboardStats() {
    final myTickets = getTicketsForCurrentUser();
    return {
      'total':   myTickets.length,
      'pending': myTickets.where((t) => t['status'] == 'Pending').length,
      'process': myTickets.where((t) => t['status'] == 'Diproses').length,
      'done':    myTickets.where((t) => t['status'] == 'Selesai').length,
      'unreadNotifications': getUnreadCount(),
    };
  }

  // ── Private helpers ─────────────────────────────────────────────────────────
  static String _generateTicketId() {
    final now = DateTime.now();
    final seq = (tickets.length + 1).toString().padLeft(4, '0');
    return 'TKT-${now.year}$seq';
  }

  static void _addNotification({
    required String ticketId,
    required String targetUserId,
    required String title,
    required String message,
    required String type,
  }) {
    notifications.insert(0, {
      'id':           'N${DateTime.now().millisecondsSinceEpoch}',
      'ticketId':     ticketId,
      'targetUserId': targetUserId,
      'title':        title,
      'message':      message,
      'type':         type,
      'isRead':       false,
      'createdAt':    DateTime.now().toIso8601String(),
    });
  }
}
