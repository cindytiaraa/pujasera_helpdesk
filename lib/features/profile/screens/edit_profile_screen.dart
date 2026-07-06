import 'package:flutter/material.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_utils.dart';
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

    @override
    Widget build(BuildContext context) {
      
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profil"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 42,
                  child: Text(
                    SessionService.userAvatar,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                labelText: "Nama",
                prefixIcon: Icon(Icons.person),
                ),
                validator: (value){
                  if(value==null || value.trim().isEmpty){
                    return "Nama wajib diisi";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: SessionService.userEmail,
                enabled: false,
                decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                ),
              ),
              const 
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                labelText: "Nomor HP",
                prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deptCtrl,
                decoration: const InputDecoration(
                labelText: "Departemen",
                prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: SessionService.userRole,
                enabled: false,
                decoration: const InputDecoration(
                labelText: "Role",
                prefixIcon: Icon(Icons.verified_user),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: SessionService.userCode,
                enabled: false,
                decoration: const InputDecoration(
                labelText: "Kode User",
                prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Simpan",
                        ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}