import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/services/session_service.dart';
import '../../../shared/services/supabase_service.dart';
// ─────────────────────────────────────────────────────────────────────────────
// CreateTicketScreen
// ─────────────────────────────────────────────────────────────────────────────

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});
  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _titleCtrl    = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _locationCtrl = TextEditingController();

  String  _category   = AppConstants.ticketCategories.first;
  String  _priority   = AppConstants.priorityMedium;
  bool    _submitting = false;
  String? _imageName;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final newTicket = await SupabaseService.createTicket({
      'id': 'T${DateTime.now().millisecondsSinceEpoch}',
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'category': _category,
      'priority': _priority,
      'status': 'Pending',
      'user_id': SessionService.userId,
      'assigned_to_id': null,
      'location': _locationCtrl.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    setState(() => _submitting = false);

    if (newTicket != null) {
      AppUtils.showSnackBar(context, 'Laporan ${newTicket['id']} berhasil dibuat!');
      Navigator.pop(context);
    } else {
      AppUtils.showSnackBar(context, 'Gagal membuat laporan.', isError: true);
    }
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Pilih Sumber Foto',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _ImageSourceTile(
            icon: Icons.camera_alt_rounded, label: 'Kamera', subtitle: 'Ambil foto langsung',
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _imageName = 'foto_kamera_${DateTime.now().millisecondsSinceEpoch}.jpg');
            },
          ),
          const SizedBox(height: 10),
          _ImageSourceTile(
            icon: Icons.photo_library_rounded, label: 'Galeri', subtitle: 'Pilih dari galeri',
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _imageName = 'foto_galeri_${DateTime.now().millisecondsSinceEpoch}.jpg');
            },
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Guard: hanya user yang boleh buat laporan
    if (!SessionService.canCreateTicket) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buat Laporan Baru')),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.block_rounded, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text('Akses Ditolak', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Hanya pengguna (user) yang dapat membuat laporan baru.\nHelpdesk dan Admin mengelola laporan yang masuk.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
          ]),
        )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Header banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.confirmation_number_rounded, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text('Isi form dengan detail agar dapat ditangani lebih cepat.',
                    style: TextStyle(fontSize: 13, color: theme.colorScheme.primary.withOpacity(0.85)))),
              ]),
            ),
            const SizedBox(height: 24),

            _Label('Informasi Masalah'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Judul Masalah',
                prefixIcon: Icon(Icons.title_rounded, size: 20),
                hintText: 'Contoh: Komputer tidak bisa menyala',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Judul wajib diisi';
                if (v.length < 5) return 'Judul terlalu pendek';
                return null;
              },
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined, size: 20)),
              items: AppConstants.ticketCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _descCtrl,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Lengkap',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.description_outlined, size: 20),
                ),
                hintText: 'Jelaskan masalah secara detail...',
                alignLabelWithHint: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Deskripsi wajib diisi';
                if (v.length < 20) return 'Deskripsi terlalu singkat (min. 20 karakter)';
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _locationCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                hintText: 'Contoh: Gedung A, Lantai 2, Ruang 201',
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Lokasi wajib diisi' : null,
            ),
            const SizedBox(height: 24),

            _Label('Prioritas'),
            const SizedBox(height: 12),
            Row(
              children: [AppConstants.priorityLow, AppConstants.priorityMedium, AppConstants.priorityHigh]
                  .map((p) {
                final isSelected = _priority == p;
                final colors = {AppConstants.priorityLow: Colors.green, AppConstants.priorityMedium: Colors.orange, AppConstants.priorityHigh: Colors.red};
                final icons  = {AppConstants.priorityLow: Icons.arrow_downward_rounded, AppConstants.priorityMedium: Icons.remove_rounded, AppConstants.priorityHigh: Icons.arrow_upward_rounded};
                final c = colors[p]!;
                return Expanded(child: GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? c.withOpacity(0.12) : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? c : theme.brightness == Brightness.dark
                          ? const Color(0xFF3A3A4E) : Colors.grey.shade200, width: isSelected ? 2 : 1),
                    ),
                    child: Column(children: [
                      Icon(icons[p], color: c, size: 20),
                      const SizedBox(height: 4),
                      Text(p, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? c : theme.colorScheme.onSurface.withOpacity(0.5))),
                    ]),
                  ),
                ));
              }).toList(),
            ),
            const SizedBox(height: 24),

            _Label('Lampiran (Opsional)'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _imageName != null ? theme.colorScheme.primary.withOpacity(0.06) : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _imageName != null
                      ? theme.colorScheme.primary.withOpacity(0.4)
                      : theme.brightness == Brightness.dark ? const Color(0xFF3A3A4E) : Colors.grey.shade200),
                ),
                child: _imageName != null
                    ? Row(children: [
                        Icon(Icons.image_rounded, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_imageName!, style: const TextStyle(fontSize: 13))),
                        GestureDetector(
                          onTap: () => setState(() => _imageName = null),
                          child: Icon(Icons.cancel_rounded, color: Colors.red.shade400, size: 20),
                        ),
                      ])
                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            color: theme.colorScheme.onSurface.withOpacity(0.3), size: 22),
                        const SizedBox(width: 10),
                        Text('Tambahkan foto/lampiran',
                            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.4))),
                      ]),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(_submitting ? 'Mengirim...' : 'Kirim Laporan'),
              ),
            ),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 3, height: 16,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
  ]);
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;
  const _ImageSourceTile({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: theme.brightness == Brightness.dark
              ? const Color(0xFF3A3A4E) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: theme.colorScheme.primary, size: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.4))),
          ]),
        ]),
      ),
    );
  }
}
