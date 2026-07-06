import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;

  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newCtrl.text != _confirmCtrl.text) {
      AppUtils.showSnackBar(
        context,
        "Konfirmasi password tidak sama.",
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);

    final success = await AuthService.resetPassword(
      email: _emailCtrl.text.trim(),
      newPassword: _newCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (!success) {
      AppUtils.showSnackBar(
        context,
        "Email tidak ditemukan.",
        isError: true,
      );
      return;
    }

    AppUtils.showSnackBar(
      context,
      "Password berhasil direset.",
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 8),

              // ── Icon header, konsisten dengan gaya Login ─────────────
              Center(
                child: Column(children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_reset_rounded,
                        size: 36, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 20),
                  Text('Lupa Password?',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    "Masukkan email terdaftar beserta password baru Anda.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ]),
              ),

              const SizedBox(height: 32),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _newCtrl,
                obscureText: _hideNew,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideNew = !_hideNew;
                      });
                    },
                    icon: Icon(
                      _hideNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Minimal 6 karakter";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmCtrl,
                obscureText: _hideConfirm,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
                  prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideConfirm = !_hideConfirm;
                      });
                    },
                    icon: Icon(
                      _hideConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Konfirmasi password wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Reset Password"),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Demo Version — reset password dilakukan berdasarkan email tanpa OTP. "
                      "Pada implementasi produksi sebaiknya menggunakan verifikasi email atau OTP.",
                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
