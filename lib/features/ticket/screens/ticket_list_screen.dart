import 'package:flutter/material.dart';
import '../../../shared/services/dummy_data_service.dart';
import '../../../shared/services/session_service.dart';
import '../../../shared/widgets/shared_widgets.dart';
import 'ticket_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TicketListScreen
// ─────────────────────────────────────────────────────────────────────────────

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});
  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  String _query = '';

  final _tabs = ['Semua', 'Pending', 'Diproses', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Filter pipeline ────────────────────────────────────────────────────────
  // Step 1: DummyDataService.getTicketsForCurrentUser() → filter berdasarkan role
  // Step 2: filter berdasarkan status (tab)
  // Step 3: filter berdasarkan query search
  List<Map<String, dynamic>> _filtered(String? status) {
    return DummyDataService.getTicketsForCurrentUser().where((t) {
      final matchStatus = status == null || t['status'] == status;
      final matchSearch = _query.isEmpty ||
          t['title'].toLowerCase().contains(_query.toLowerCase()) ||
          t['id'].toLowerCase().contains(_query.toLowerCase()) ||
          t['category'].toLowerCase().contains(_query.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Judul berbeda per role
    final title = SessionService.canManageTickets ? 'Semua Laporan' : 'Laporan Saya';

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title),
          // Tampilkan total laporan yang terlihat
          Text('${_filtered(null).length} laporan',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withOpacity(0.5))),
        ]),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Cari laporan...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); })
                      : null,
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: -8, vertical: 6),
              labelColor: Colors.white,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              dividerColor: Colors.transparent,
            ),
          ]),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TicketTab(tickets: _filtered(null)),
          _TicketTab(tickets: _filtered('Pending')),
          _TicketTab(tickets: _filtered('Diproses')),
          _TicketTab(tickets: _filtered('Selesai')),
        ],
      ),
    );
  }
}

class _TicketTab extends StatelessWidget {
  final List<Map<String, dynamic>> tickets;
  const _TicketTab({required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_rounded,
        title: 'Tidak Ada Laporan',
        subtitle: SessionService.canManageTickets
            ? 'Tidak ada laporan dengan filter ini.'
            : 'Anda belum memiliki laporan dengan filter ini.',
      );
    }
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: tickets.length,
        itemBuilder: (ctx, i) => TicketCard(
          ticket: tickets[i],
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) => TicketDetailScreen(ticketId: tickets[i]['id']))),
        ),
      ),
    );
  }
}
