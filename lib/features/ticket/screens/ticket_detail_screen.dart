import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../services/ticket_service.dart';
import '../services/comment_service.dart';
import '../services/history_service.dart';
import '../../notification/services/notification_service.dart';
import '../../../core/services/session_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/ticket_model.dart';
import '../models/comment_model.dart';
import '../../auth/models/user_model.dart';
import '../../profile/services/profile_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TicketDetailScreen
// ─────────────────────────────────────────────────────────────────────────────

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;
  const TicketDetailScreen({super.key, required this.ticketId});
  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _commentCtrl = TextEditingController();
  bool _sending = false;
  TicketModel? _ticket;
  UserModel? _reporter;
  UserModel? _assignedTo;
  List<CommentModel> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      final ticket = await TicketService.getTicketById(widget.ticketId);
      if (ticket != null) {
        final reporter = await ProfileService.getProfile(ticket.userId);
        UserModel? assignedTo;
        if (ticket.assignedToId != null) {
          assignedTo = await ProfileService.getProfile(ticket.assignedToId!);
        }
        final comments = await CommentService.getComments(widget.ticketId);

        if (mounted) {
          setState(() {
            _ticket = ticket;
            _reporter = reporter;
            _assignedTo = assignedTo;
            _comments = comments;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _ticket = null;
          });
        }
      }
    } catch (e) {
      debugPrint('LOAD TICKET DETAILS ERROR: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  // ── Kirim komentar ─────────────────────────────────────────────────────────
  Future<void> _sendComment() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await CommentService.addComment(
        ticketId: widget.ticketId,
        userId: SessionService.userId,
        userName: SessionService.userName,
        role: SessionService.userRole,
        text: text,
      );
      _commentCtrl.clear();
      await _load();
      if (mounted) AppUtils.showSnackBar(context, 'Komentar berhasil dikirim');
    } catch (e) {
      if (mounted) AppUtils.showSnackBar(context, 'Gagal mengirim komentar.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _acceptTicket() async {
    if (_ticket == null) return;

    try {
      await TicketService.acceptTicket(
        ticketId: _ticket!.id,
        adminId: SessionService.userId,
        adminName: SessionService.userName,
      );

      if (!mounted) return;

      AppUtils.showSnackBar(
        context,
        'Ticket berhasil diterima.',
      );

      _load();
    } catch (e) {
      AppUtils.showSnackBar(
        context,
        'Gagal menerima ticket.',
        isError: true,
      );
    }
  }

  // ── Assign laporan — HANYA admin ─────────────────────────────────────────────
  void _showAssignPicker() async {
    if (!SessionService.canAssignTickets) return; // guard
    try {
      final helpdeskList = await TicketService.getHelpdeskList();
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Tugaskan ke Helpdesk',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...helpdeskList.map((h) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: UserAvatar(initials: h.avatar ?? 'HD', size: 36),
              title: Text(h.name),
              subtitle: Text(h.department ?? ''),
              trailing: _ticket?.assignedToId == h.id
                  ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await TicketService.assignTicketToStaff(
                    ticketId: widget.ticketId,
                    petugasId: h.id,
                    petugasName: h.name,
                  );
                  _load();
                  if (mounted) {
                    AppUtils.showSnackBar(context, 'Laporan dikirimkan ke ${h.name}');
                  }
                } catch (e) {
                  if (mounted) {
                    AppUtils.showSnackBar(context, 'Gagal menugaskan laporan.', isError: true);
                  }
                }
              },
            )),
            const SizedBox(height: 8),
          ]),
        ),
      );
    } catch (e) {
      AppUtils.showSnackBar(context, 'Gagal memuat daftar helpdesk.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Laporan'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Laporan null → user tidak berhak atau tidak ditemukan
    if (_ticket == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Laporan'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const EmptyState(
          icon: Icons.lock_outline_rounded,
          title: 'Laporan Tidak Ditemukan',
          subtitle: 'Laporan tidak ada atau Anda tidak memiliki akses untuk melihatnya.',
        ),
      );
    }

    final theme    = Theme.of(context);
    final ticket   = _ticket!;
    final comments = _comments;

    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.id,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (SessionService.canAssignTickets &&
            ticket.status == 'Open')
          TextButton.icon(
            onPressed: _acceptTicket,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Terima"),
          ),

        if (SessionService.canAssignTickets &&
            ticket.status == 'Assigned')
          TextButton.icon(
            onPressed: _showAssignPicker,
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text("Assign"),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Status + prioritas
            Row(children: [
              StatusBadge(status: ticket.status),
              const SizedBox(width: 8),
              PriorityBadge(priority: ticket.priority),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(ticket.category,
                    style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 16),

            // Judul
            Text(ticket.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, height: 1.3)),
            const SizedBox(height: 16),

            // Info card
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _InfoRow(icon: Icons.person_outline_rounded, label: 'Pelapor',    value: _reporter?.name ?? 'Pengguna'),
                const Divider(height: 20),
                _InfoRow(icon: Icons.location_on_outlined,   label: 'Lokasi',     value: ticket.location),
                const Divider(height: 20),
                _InfoRow(icon: Icons.schedule_rounded,       label: 'Dibuat',
                    value: AppUtils.formatDateTime(ticket.createdAt)),
                const Divider(height: 20),
                _InfoRow(icon: Icons.update_rounded,         label: 'Diperbarui',
                    value: ticket.updatedAt != null ? AppUtils.formatDateTime(ticket.updatedAt!) : '-'),
                // Kolom assigned — hanya tampil jika ada & yang lihat adalah helpdesk/admin
                if (SessionService.canManageTickets) ...[
                  const Divider(height: 20),
                  _InfoRow(
                    icon: Icons.support_agent_rounded,
                    label: 'Ditugaskan ke',
                    value: _assignedTo?.name ?? 'Belum ditugaskan',
                  ),
                ],
              ]),
            )),
            const SizedBox(height: 16),

            // Deskripsi
            Text('Deskripsi Masalah',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.brightness == Brightness.dark
                    ? const Color(0xFF2A2A3E) : Colors.grey.shade100),
              ),
              child: Text(ticket.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6, color: theme.colorScheme.onSurface.withOpacity(0.85))),
            ),
            const SizedBox(height: 16),

            // Tracking timeline
            Text('Tracking Status',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _TrackingTimeline(status: ticket.status),
            const SizedBox(height: 20),

            // Komentar
            Row(children: [
              Text('Komentar', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(comments.length.toString(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary)),
              ),
            ]),
            const SizedBox(height: 12),

            if (comments.isEmpty)
              Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('Belum ada komentar',
                    style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.35), fontSize: 13)),
              ))
            else
              ...comments.map((c) => _CommentBubble(comment: c)),

            const SizedBox(height: 20),
          ]),
        )),

        // ── Comment input — semua role ──────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
          ),
          child: Row(children: [
            UserAvatar(initials: SessionService.userAvatar, size: 36),
            const SizedBox(width: 10),
            Expanded(child: TextField(
              controller: _commentCtrl,
              decoration: InputDecoration(
                hintText: 'Tambahkan komentar...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: theme.brightness == Brightness.dark
                      ? const Color(0xFF3A3A4E) : Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendComment(),
              maxLines: null,
            )),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
              child: IconButton(
                onPressed: _sending ? null : _sendComment,
                icon: _sending
                    ? const SizedBox(width: 16, height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.4)),
      const SizedBox(width: 10),
      Text('$label: ', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]);
  }
}

// ── Comment bubble ────────────────────────────────────────────────────────────
class _CommentBubble extends StatelessWidget {
  final CommentModel comment;
  const _CommentBubble({required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme      = Theme.of(context);
    final isHelpdesk = comment.role == 'helpdesk' || comment.role == 'admin';
    final initials   = comment.userName
        .split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    final bubbleColor = isHelpdesk ? AppTheme.processColor : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UserAvatar(initials: initials, size: 34, color: bubbleColor),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(comment.userName,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            if (isHelpdesk)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: bubbleColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(comment.role.toUpperCase(),
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: bubbleColor)),
              ),
            const Spacer(),
            Text(AppUtils.timeAgo(comment.createdAt),
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4))),
          ]),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHelpdesk
                  ? bubbleColor.withOpacity(0.08)
                  : theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(color: isHelpdesk
                  ? bubbleColor.withOpacity(0.2)
                  : theme.brightness == Brightness.dark
                      ? const Color(0xFF2A2A3E) : Colors.grey.shade100),
            ),
            child: Text(comment.text,
                style: TextStyle(fontSize: 13, height: 1.5,
                    color: theme.colorScheme.onSurface.withOpacity(0.85))),
          ),
        ])),
      ]),
    );
  }
}

// ── Tracking timeline ─────────────────────────────────────────────────────────
class _TrackingTimeline extends StatelessWidget {
  final String status;
  const _TrackingTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final stages = [
      {'label': 'Dibuat',    'status': 'Open',  'icon': Icons.add_circle_outline_rounded},
      {'label': 'Diproses',  'status': 'In Progress', 'icon': Icons.build_circle_rounded},
      {'label': 'Selesai',   'status': 'Close',  'icon': Icons.check_circle_rounded},
    ];

    if (status == 'Dibatalkan') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cancelledColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.cancelledColor.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(Icons.cancel_rounded, color: AppTheme.cancelledColor, size: 18),
          const SizedBox(width: 8),
          Text('Laporan ini telah dibatalkan.',
              style: TextStyle(color: AppTheme.cancelledColor, fontSize: 13)),
        ]),
      );
    }

    int currentIdx = 0;
    if (status == 'Assigned' || status == 'In Progress') currentIdx = 1;
    if (status == 'Close')  currentIdx = 2;

    return Row(
      children: List.generate(stages.length * 2 - 1, (i) {
        if (i.isOdd) {
          final isActive = (i ~/ 2) < currentIdx;
          return Expanded(child: Container(height: 2,
              color: isActive ? AppTheme.doneColor : theme.colorScheme.onSurface.withOpacity(0.1)));
        }
        final idx      = i ~/ 2;
        final stage    = stages[idx];
        final isActive = idx <= currentIdx;
        final isCur    = idx == currentIdx;
        final color    = isActive
            ? AppTheme.getStatusColor(stage['status'] as String)
            : theme.colorScheme.onSurface.withOpacity(0.2);

        return Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.12) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: isCur ? 2.5 : 1.5),
            ),
            child: Icon(stage['icon'] as IconData, size: 16, color: color),
          ),
          const SizedBox(height: 6),
          Text(stage['label'] as String,
              style: TextStyle(fontSize: 10, fontWeight: isCur ? FontWeight.w700 : FontWeight.w400,
                  color: isActive ? color : theme.colorScheme.onSurface.withOpacity(0.3)),
              textAlign: TextAlign.center),
        ]);
      }),
    );
  }
}
