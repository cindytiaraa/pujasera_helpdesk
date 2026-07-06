import 'package:flutter/material.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _deptCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _nameCtrl =
        TextEditingController(text: SessionService.userName);
    _phoneCtrl =
        TextEditingController(text: SessionService.userPhone);
    _deptCtrl =
        TextEditingController(text: SessionService.userDept);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final user = await ProfileService.updateProfile(
      userId: SessionService.userId,
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      department: _deptCtrl.text.trim(),
    );

    setState(() => _saving = false);
    if (user == null) {
      if (!mounted) return;
      AppUtils.showSnackBar(
        context,
        "Gagal memperbarui profil",
        isError: true,
      );

      return;
    }

    SessionService.saveUser(user);
    if (!mounted) return;
    AppUtils.showSnackBar(
      context,
      "Profil berhasil diperbarui",
    );
    Navigator.pop(context, true);
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Header dengan avatar, mengikuti gaya Profile Screen ──────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withBlue(220),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: UserAvatar(
                    initials: SessionService.userName.isNotEmpty
                        ? SessionService.userName.trim()[0].toUpperCase()
                        : 'U',
                    size: 76,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionLabel('Informasi Pribadi'),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                    validator: (value){
                      if(value==null || value.trim().isEmpty){
                        return "Nama wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: SessionService.userEmail,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Nomor HP",
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _deptCtrl,
                    decoration: const InputDecoration(
                      labelText: "Departemen",
                      prefixIcon: Icon(Icons.business_outlined, size: 20),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionLabel('Informasi Akun'),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: SessionService.userRole,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Role",
                      prefixIcon: Icon(Icons.verified_user_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: SessionService.userCode,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Kode User",
                      prefixIcon: Icon(Icons.tag_rounded, size: 20),
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Simpan Perubahan"),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
