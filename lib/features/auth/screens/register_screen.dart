import 'package:flutter/material.dart';
import '../../../shared/services/dummy_data_service.dart';
import '../../../shared/services/session_service.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simulate registration (add to dummy list)
    final initials = _nameController.text.trim().split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .take(2)
        .join();

    final newUser = {
      'id': 'U${DummyDataService.users.length + 1}'.padLeft(4, '0'),
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'role': 'user',
      'department': _departmentController.text.trim(),
      'avatar': initials,
      'password': _passwordController.text.trim(),
    };

    DummyDataService.users.add(newUser);
    SessionService.login(newUser);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.12),
                      theme.colorScheme.secondary.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_add_alt_1_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buat Akun Baru',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Isi data diri Anda untuk mendaftar',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              _buildSectionLabel('Informasi Pribadi'),
              const SizedBox(height: 12),

              // Name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.badge_outlined, size: 20),
                  hintText: 'Masukkan nama lengkap',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nama wajib diisi';
                  if (v.length < 3) return 'Nama minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                  hintText: 'nama@pujasera.id',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                  hintText: '08xxxxxxxxxx',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nomor HP wajib diisi';
                  if (v.length < 10) return 'Nomor HP tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Department
              TextFormField(
                controller: _departmentController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Departemen / Bagian',
                  prefixIcon: Icon(Icons.business_outlined, size: 20),
                  hintText: 'Contoh: Keuangan, IT, SDM',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Departemen wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionLabel('Keamanan Akun'),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                      const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password wajib diisi';
                  if (v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Confirm password
              TextFormField(
                controller: _confirmPassController,
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleRegister(),
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  prefixIcon:
                      const Icon(Icons.lock_reset_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return 'Konfirmasi password wajib diisi';
                  if (v != _passwordController.text)
                    return 'Password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Register button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Daftar Sekarang'),
                ),
              ),
              const SizedBox(height: 16),

              // Login link
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Masuk di sini',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
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
}
