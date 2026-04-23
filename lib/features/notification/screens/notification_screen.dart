import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/services/dummy_data_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../../ticket/screens/ticket_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationScreen
// ─────────────────────────────────────────────────────────────────────────────

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> get _notifs =>
      DummyDataService.getNotificationsForCurrentUser();

  void _markAllRead() {
    DummyDataService.markAllNotificationsRead();
    setState(() {});
    AppUtils.showSnackBar(context, 'Semua notifikasi ditandai dibaca');
  }

  IconData _icon(String type) {
    switch (type) {
      case 'status_update': return Icons.update_rounded;
      case 'resolved':      return Icons.check_circle_rounded;
      case 'comment':       return Icons.chat_bubble_rounded;
      case 'assigned':      return Icons.assignment_ind_rounded;
      default:              return Icons.notifications_rounded;
    }
  }

  Color _color(String type) {
    switch (type) {
      case 'status_update': return AppTheme.processColor;
      case 'resolved':      return AppTheme.doneColor;
      case 'comment':       return AppTheme.infoColor;
      case 'assigned':      return Colors.purple;
      default:              return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final notifs  = _notifs;
    final unread  = notifs.where((n) => n['isRead'] == false).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Notifikasi'),
          if (unread > 0)
            Text('$unread belum dibaca',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400,
                    color: theme.colorScheme.primary)),
        ]),
        automaticallyImplyLeading: false,
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Baca Semua',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? EmptyState(
              icon: Icons.notifications_off_rounded,
              title: 'Tidak Ada Notifikasi',
              subtitle: 'Notifikasi akan muncul ketika ada pembaruan laporan.',
            )
          : RefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: notifs.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor),
                itemBuilder: (ctx, i) {
                  final n      = notifs[i];
                  final isRead = n['isRead'] as bool;
                  final type   = n['type'] as String;
                  final color  = _color(type);

                  return InkWell(
                    onTap: () {
                      DummyDataService.markNotificationRead(n['id']);
                      setState(() {});
                      if (n['ticketId'] != null) {
                        Navigator.push(ctx, MaterialPageRoute(
                            builder: (_) => TicketDetailScreen(ticketId: n['ticketId'])));
                      }
                    },
                    child: Container(
                      color: isRead ? Colors.transparent : theme.colorScheme.primary.withOpacity(0.04),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                          child: Icon(_icon(type), color: color, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(n['title'],
                                style: TextStyle(fontSize: 13,
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w700))),
                            if (!isRead)
                              Container(width: 8, height: 8,
                                  decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                          ]),
                          const SizedBox(height: 4),
                          Text(n['message'],
                              style: TextStyle(fontSize: 12, height: 1.4,
                                  color: theme.colorScheme.onSurface.withOpacity(isRead ? 0.45 : 0.65)),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(children: [
                            if (n['ticketId'] != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(n['ticketId'],
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(AppUtils.timeAgo(DateTime.parse(n['createdAt'])),
                                style: TextStyle(fontSize: 11,
                                    color: theme.colorScheme.onSurface.withOpacity(0.35))),
                          ]),
                        ])),
                        if (n['ticketId'] != null)
                          Icon(Icons.chevron_right_rounded, size: 18,
                              color: theme.colorScheme.onSurface.withOpacity(0.25)),
                      ]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
