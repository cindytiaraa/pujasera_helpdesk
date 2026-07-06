import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
	const ChangePasswordScreen({super.key});

	@override
	State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
	final _formKey = GlobalKey<FormState>();
	final _oldCtrl = TextEditingController();
	final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
	bool _submitting = false;

  bool _hideOld = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

	@override
	void dispose() {
		_oldCtrl.dispose();
		_newCtrl.dispose();
    _confirmCtrl.dispose();
		super.dispose();
	}

	Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newCtrl.text != _confirmCtrl.text) {
      AppUtils.showSnackBar(
        context,
        "Konfirmasi password tidak sama",
        isError: true,
      );
      return;
    }

    setState(() => _submitting = true);

    final success = await AuthService.changePassword(
      userId: SessionService.userId,
      oldPassword: _oldCtrl.text.trim(),
      newPassword: _newCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => _submitting = false);

    if (!success) {
      AppUtils.showSnackBar(
        context,
        "Password lama tidak sesuai",
        isError: true,
      );
      return;
    }

    AppUtils.showSnackBar(
      context,
      "Password berhasil diperbarui",
    );

    Navigator.pop(context);
  }

	@override
	Widget build(BuildContext context) {
    final theme = Theme.of(context);
		return Scaffold(
			appBar: AppBar(
        title: const Text('Ubah Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
			body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.password_rounded,
                      size: 34, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 20),
                Text('Ubah Password',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Pastikan password baru mudah diingat dan aman.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              ]),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: _oldCtrl,
                  obscureText: _hideOld,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_hideOld
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _hideOld = !_hideOld),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newCtrl,
                  obscureText: _hideNew,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_hideNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _hideNew = !_hideNew),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _hideConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    prefixIcon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_hideConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Simpan Password'),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
		);
	}
}
