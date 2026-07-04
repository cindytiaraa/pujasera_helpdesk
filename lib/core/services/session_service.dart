import '../../features/auth/models/user_model.dart';

class SessionService {
  // ─────────────────────────────────────────────────────────────
  // PRIVATE STATE
  // ─────────────────────────────────────────────────────────────

  static UserModel? _currentUser;

  // ─────────────────────────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────────────────────────

  static UserModel? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static String get userId => _currentUser?.id ?? '';
  static String get userName => _currentUser?.name ?? '';
  static String get userEmail => _currentUser?.email ?? '';
  static String get userPhone => _currentUser?.phone ?? '';
  static String get userRole => _currentUser?.role ?? 'user';
  static String get userAvatar => _currentUser?.avatar ?? 'US';
  static String get userDept => _currentUser?.department ?? '';

  // ─────────────────────────────────────────────────────────────
  // ROLE HELPERS
  // ─────────────────────────────────────────────────────────────

  /// User biasa (pelapor)
  static bool get isUser => userRole == 'user';

  /// Helpdesk saja
  static bool get isHelpdeskOnly => userRole == 'helpdesk';

  /// Admin saja
  static bool get isAdmin => userRole == 'admin';

  /// Helpdesk atau Admin
  static bool get canManageTickets =>
      userRole == 'helpdesk' || userRole == 'admin';

  /// Admin saja
  static bool get canAssignTickets => userRole == 'admin';

  /// User saja
  static bool get canCreateTicket => userRole == 'user';

  // Backward compatibility
  static bool get isHelpdesk => canManageTickets;

  // ─────────────────────────────────────────────────────────────
  // AUTH ACTIONS
  // ─────────────────────────────────────────────────────────────

  static void login(UserModel user) {
    _currentUser = user;
  }

  static void logout() {
    _currentUser = null;
  }

  static void updateProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
  }

  // ─────────────────────────────────────────────────────────────
  // ROLE LABEL
  // ─────────────────────────────────────────────────────────────

  static String get roleLabel {
    switch (userRole) {
      case 'admin':
        return 'Administrator';

      case 'helpdesk':
        return 'Helpdesk';

      default:
        return 'Pengguna';
    }
  }
}