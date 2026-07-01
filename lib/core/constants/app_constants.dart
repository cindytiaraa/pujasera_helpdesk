class AppConstants {
  static const String appName = 'Smart Pujasera Helpdesk';
  static const String appVersion = '1.0.0';

  // Route names
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDashboard = '/dashboard';
  static const String routeTicketList = '/tickets';
  static const String routeTicketDetail = '/ticket-detail';
  static const String routeCreateTicket = '/create-ticket';
  static const String routeNotification = '/notifications';
  static const String routeProfile = '/profile';

  // Ticket status
  static const String statusPending = 'Pending';
  static const String statusProcess = 'Diproses';
  static const String statusDone = 'Selesai';
  static const String statusCancelled = 'Dibatalkan';

  // Ticket priority
  static const String priorityLow = 'Rendah';
  static const String priorityMedium = 'Sedang';
  static const String priorityHigh = 'Tinggi';

  // Ticket category
  static const List<String> ticketCategories = [
    'Kebersihan',
    'Fasilitas',
    'Tenant/Kios',
    'Pembayaran',
    'Keamanan',
    'Pelayanan',
    'Lainnya',
  ];
}
