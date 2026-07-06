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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              const SizedBox(height: 8),

              const Text(
                "Masukkan email yang terdaftar beserta password baru.",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _newCtrl,
                obscureText: _hideNew,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideNew = !_hideNew;
                      });
                    },
                    icon: Icon(
                      _hideNew
                          ? Icons.visibility_off
                          : Icons.visibility,
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

              const SizedBox(height: 18),

              TextFormField(
                controller: _confirmCtrl,
                obscureText: _hideConfirm,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideConfirm = !_hideConfirm;
                      });
                    },
                    icon: Icon(
                      _hideConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
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

              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Reset Password"),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "*Demo Version\nReset password dilakukan berdasarkan email tanpa OTP. "
                "Pada implementasi produksi sebaiknya menggunakan verifikasi email atau OTP.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}