// ─────────────────────────────────────────────────────────────────────────────
// SessionService
// Menyimpan data user yang sedang login di memori (in-memory).
// data hilang saat app di-restart.
// ─────────────────────────────────────────────────────────────────────────────

class SessionService {
  // ── Private state ──────────────────────────────────────────────────────────
  static Map<String, dynamic>? _currentUser;

  // ── Getters dasar ──────────────────────────────────────────────────────────
  static Map<String, dynamic>? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  static String get userId     => _currentUser?['id']         ?? '';
  static String get userName   => _currentUser?['name']       ?? '';
  static String get userEmail  => _currentUser?['email']      ?? '';
  static String get userPhone  => _currentUser?['phone']      ?? '';
  static String get userRole   => _currentUser?['role']       ?? 'user';
  static String get userAvatar => _currentUser?['avatar']     ?? 'US';
  static String get userDept   => _currentUser?['department'] ?? '';

  // ── Role helpers ───────────────────────────────────────────────────────────
  /// True jika role == 'user' (pelapor biasa)
  static bool get isUser          => userRole == 'user';

  /// True jika role == 'helpdesk'
  static bool get isHelpdeskOnly  => userRole == 'helpdesk';

  /// True jika role == 'admin'
  static bool get isAdmin         => userRole == 'admin';

  /// True jika bisa mengelola laporan (helpdesk ATAU admin)
  static bool get canManageTickets => userRole == 'helpdesk' || userRole == 'admin';

  /// True jika bisa assign laporan (admin saja)
  static bool get canAssignTickets => userRole == 'admin';

  /// True jika bisa membuat laporan baru (user saja)
  static bool get canCreateTicket  => userRole == 'user';

  // backward-compat alias
  static bool get isHelpdesk => canManageTickets;

  // ── Auth actions ───────────────────────────────────────────────────────────
  static void login(Map<String, dynamic> user) {
    _currentUser = Map<String, dynamic>.from(user);
  }

  static void logout() {
    _currentUser = null;
  }

  static void updateProfile(Map<String, dynamic> updates) {
    if (_currentUser != null) _currentUser!.addAll(updates);
  }

  // ── Label role untuk UI ────────────────────────────────────────────────────
  static String get roleLabel {
    switch (userRole) {
      case 'admin':    return 'Administrator';
      case 'helpdesk': return 'Helpdesk';
      default:         return 'Pengguna';
    }
  }
}
