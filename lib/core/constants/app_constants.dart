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
  static const String statusOpen        = 'Open';
  static const String statusAssigned    = 'Assigned';
  static const String statusInProgress  = 'In Progress';
  static const String statusClose       = 'Close';

  // Ticket priority
  static const String priorityLow    = 'Rendah';
  static const String priorityMedium = 'Sedang';
  static const String priorityHigh   = 'Tinggi';

  // Ticket category — sesuai tema Smart Pujasera Helpdesk
  static const List<String> ticketCategories = [
    'Listrik',
    'Air',
    'Kebersihan',
    'Internet',
    'Peralatan',
    'AC',
    'Lainnya',
  ];

  // Department list — sesuai tema pujasera
  static const List<String> departments = [
    'Tenant Bakso',
    'Tenant Soto',
    'Tenant Ayam Geprek',
    'Kasir',
    'Cleaning Service',
    'Keamanan',
    'Manajemen',
  ];
}
