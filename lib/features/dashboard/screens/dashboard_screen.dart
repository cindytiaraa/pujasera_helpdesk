import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';

import '../../../core/services/session_service.dart';
import '../services/dashboard_service.dart';
import '../../notification/services/notification_service.dart';
import '../../ticket/models/ticket_model.dart';

import '../../../core/services/session_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../ticket/screens/ticket_list_screen.dart';
import '../../ticket/screens/create_ticket_screen.dart';
import '../../ticket/screens/ticket_detail_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../auth/screens/login_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DashboardScreen — shell utama dengan BottomNavigationBar
// ─────────────────────────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  int _unreadCount = 0;
  int _refreshCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await NotificationService.getUnreadCount(SessionService.userId);
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  void _navigate(int index) {
    setState(() => _currentIndex = index);
    _loadUnreadCount();
  }

  void _refresh() {
    setState(() {
      _refreshCount++;
    });
    _loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardHome(
        key: ValueKey(_refreshCount),
        onNavigate: _navigate,
        onRefresh: _refresh,
        unreadCount: _unreadCount,
      ),
      const TicketListScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    // FAB hanya untuk user biasa (buat laporan baru)
    final showFab = SessionService.canCreateTicket;

    return Scaffold(
      body: pages[_currentIndex],

      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
                );
                _refresh();
              },
              child: const Icon(Icons.add_rounded),
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                index: 0,
                current: _currentIndex,
                onTap: _navigate),
            _NavItem(
                icon: Icons.confirmation_number_rounded,
                label: 'Laporan',
                index: 1,
                current: _currentIndex,
                onTap: _navigate),
            const SizedBox(width: 60),
            _NavItem(
                icon: Icons.notifications_rounded,
                label: 'Notifikasi',
                index: 2,
                current: _currentIndex,
                badge: _unreadCount,
                onTap: _navigate),
            _NavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                index: 3,
                current: _currentIndex,
                onTap: _navigate),
          ],
        ),
      ),
    );
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final int badge;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon, required this.label,
    required this.index, required this.current, required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.4);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(clipBehavior: Clip.none, children: [
              Icon(icon, color: color, size: 22),
              if (badge > 0)
                Positioned(
                  right: -6, top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(badge.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
            ]),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ]),
        ),
      ),
    );
  }
}

// ── Dashboard home page ────────────────────────────────────────────────────────
class _DashboardHome extends StatefulWidget {
  final void Function(int) onNavigate;
  final VoidCallback onRefresh;
  final int unreadCount;

  const _DashboardHome({
    super.key,
    required this.onNavigate,
    required this.onRefresh,
    required this.unreadCount,
  });

  @override
  State<_DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<_DashboardHome> {
  Map<String, int> _stats = {
    'total': 0,
    'open': 0,
    'assigned': 0,
    'in_progress': 0,
    'close': 0,
  };
  List<TicketModel> _recentTickets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final stats = await DashboardService.getStatistics();
      final recent = await DashboardService.getRecentTickets(limit: 3);

      if (mounted) {
        setState(() {
          _stats = stats;
          _recentTickets = recent;
        });
      }
    } catch (e) {
      debugPrint('Error loading dashboard stats: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar Aplikasi',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              SessionService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final total = _stats['total'] ?? 0;
    final pending = (_stats['open'] ?? 0) + (_stats['assigned'] ?? 0);
    final process = _stats['in_progress'] ?? 0;
    final done = _stats['close'] ?? 0;

  return Scaffold(
    // Header FIXED di atas — tidak ikut scroll
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: theme.colorScheme.primary,
      toolbarHeight: 70,
      title: Row(children: [
        Image.asset(
          'assets/images/logo.png',
          height: 32,
        ),
        const SizedBox(width: 8),
        UserAvatar(initials: SessionService.userAvatar, size: 36, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat datang,',
                style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
            Text(SessionService.userName,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        )),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(SessionService.roleLabel.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 9,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
      ]),
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primary.withBlue(200)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Smart Pujasera',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Helpdesk E-Ticketing',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number_rounded),
            title: const Text('Laporan'),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Notifikasi'),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(3);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    ),
    // Konten scrollable biasa — bukan CustomScrollView + Sliver
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoleBanner(),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Aplikasi ini digunakan untuk melaporkan keluhan atau permintaan bantuan di area pujasera, seperti masalah pelayanan, kebersihan, atau pesanan.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: SessionService.canManageTickets ? 'Semua Laporan' : 'Laporan Saya',
            actionLabel: 'Lihat Semua',
            onAction: () => widget.onNavigate(1),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5, 
            children: [
              StatCard(label: 'Total',    count: total,   color: theme.colorScheme.primary,   icon: Icons.confirmation_number_rounded, onTap: () => widget.onNavigate(1)),
              StatCard(label: 'Menunggu', count: pending,  color: AppTheme.pendingColor,       icon: Icons.schedule_rounded,           onTap: () => widget.onNavigate(1)),
              StatCard(label: 'Diproses', count: process,  color: AppTheme.processColor,       icon: Icons.build_circle_rounded,       onTap: () => widget.onNavigate(1)),
              StatCard(label: 'Selesai',  count: done,     color: AppTheme.doneColor,          icon: Icons.check_circle_rounded,       onTap: () => widget.onNavigate(1)),
            ],
          ),
          const SizedBox(height: 28),
          SectionHeader(title: 'Akses Cepat'),
          const SizedBox(height: 14),
          _QuickActions(onNavigate: widget.onNavigate, onRefresh: widget.onRefresh, unreadCount: widget.unreadCount),
          const SizedBox(height: 28),
          SectionHeader(
            title: _recentTickets.isEmpty ? 'Laporan Terbaru' : 'Laporan Terbaru (${_recentTickets.length})',
            actionLabel: 'Lihat Semua',
            onAction: () => widget.onNavigate(1),
          ),
          const SizedBox(height: 14),
          if (_recentTickets.isEmpty)
            EmptyState(
              icon: Icons.inbox_rounded,
              title: 'Belum Ada Laporan',
              subtitle: SessionService.canCreateTicket
                  ? 'Buat laporan pertama Anda.'
                  : 'Belum ada laporan yang masuk.',
            )
          else
            ..._recentTickets.map((t) => TicketCard(
              ticket: t.toJson(),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TicketDetailScreen(ticketId: t.id))),
            )),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
}

// ── Role banner ───────────────────────────────────────────────────────────────
// Menampilkan info singkat kemampuan role saat ini
class _RoleBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String info;
    IconData icon;
    Color color;

    if (SessionService.isAdmin) {
      info  = 'Anda dapat melihat semua laporan, mengubah status, dan menugaskan laporan ke helpdesk.';
      icon  = Icons.admin_panel_settings_rounded;
      color = Colors.purple;
    } else if (SessionService.isHelpdeskOnly) {
      info  = 'Anda dapat melihat semua laporan masuk dan memperbarui status penanganan.';
      icon  = Icons.support_agent_rounded;
      color = Colors.orange;
    } else {
      info  = 'Anda dapat membuat laporan dan memantau status laporan milik Anda.';
      icon  = Icons.person_rounded;
      color = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(info,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.85), height: 1.4))),
      ]),
    );
  }
}

// ── Quick actions — berbeda per role ──────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final void Function(int) onNavigate;
  final VoidCallback onRefresh;
  final int unreadCount;
  const _QuickActions({required this.onNavigate, required this.onRefresh, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    // Definisi aksi per role
    final actions = <Map<String, dynamic>>[
      if (SessionService.canCreateTicket) {
        'icon': Icons.add_circle_outline_rounded,
        'label': 'Buat Laporan',
        'color': Theme.of(context).colorScheme.primary,
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()))
            .then((_) => onRefresh()),
      },
      {
        'icon': Icons.list_alt_rounded,
        'label': SessionService.canManageTickets ? 'Semua Laporan' : 'Laporan Saya',
        'color': AppTheme.infoColor,
        'onTap': () => onNavigate(1),
      },
      {
        'icon': Icons.notifications_active_rounded,
        'label': 'Notifikasi',
        'color': AppTheme.warningColor,
        'badge': unreadCount,
        'onTap': () => onNavigate(2),
      },
      if (SessionService.canManageTickets) {
        'icon': Icons.pending_actions_rounded,
        'label': 'Pending',
        'color': AppTheme.pendingColor,
        'onTap': () => onNavigate(1),
      },
      if (!SessionService.canManageTickets) {
        'icon': Icons.track_changes_rounded,
        'label': 'Tracking',
        'color': AppTheme.successColor,
        'onTap': () => onNavigate(1),
      },
    ];

    return Row(
      children: actions.take(4).map((a) {
        final badge = (a['badge'] ?? 0) as int;
        return Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _QuickActionItem(
            icon:   a['icon'] as IconData,
            label:  a['label'] as String,
            color:  a['color'] as Color,
            badge:  badge,
            onTap:  a['onTap'] as VoidCallback,
          ),
        ));
      }).toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int badge;
  final VoidCallback onTap;
  const _QuickActionItem({required this.icon, required this.label,
      required this.color, required this.onTap, this.badge = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.brightness == Brightness.dark
              ? const Color(0xFF2A2A3E) : Colors.grey.shade100),
        ),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            if (badge > 0)
              Positioned(right: -4, top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(badge.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                )),
          ]),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
