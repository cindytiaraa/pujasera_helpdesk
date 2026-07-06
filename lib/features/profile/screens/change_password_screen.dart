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
		return Scaffold(
			appBar: AppBar(title: const Text('Ubah Password')),
			body: Padding(
				padding: const EdgeInsets.all(20),
				child: Form(
					key: _formKey,
					child: Column(children: [
						TextFormField(
							controller: _oldCtrl,
							obscureText: true,
							decoration: const InputDecoration(labelText: 'Password Lama'),
							validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
						),
						const SizedBox(height: 12),
						TextFormField(
							controller: _newCtrl,
							obscureText: true,
							decoration: const InputDecoration(labelText: 'Password Baru'),
							validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
						),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Wajib diisi';
                }
                return null;
              },
            ),
						const SizedBox(height: 20),
						SizedBox(
							width: double.infinity,
							child: ElevatedButton(
								onPressed: _submitting ? null : _submit,
								child: _submitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan'),
							),
						)
					]),
				),
			),
		);
	}
}
