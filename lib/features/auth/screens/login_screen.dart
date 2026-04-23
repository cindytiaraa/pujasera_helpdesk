import 'package:flutter/material.dart';
import '../../../shared/services/dummy_data_service.dart';
import '../../../shared/services/session_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  bool _obscure    = true;
  bool _isLoading  = false;

  late final AnimationController _anim;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    _anim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
    // Default ke akun user untuk demo
    _emailCtrl.text    = 'cindy@pujasera.id';
    _passwordCtrl.text = '123456';
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── LOGIN LOGIC ────────────────────────────────────────────────────────────
  // Flow: validasi form → cari user di DummyDataService → simpan ke SessionService
  //       → arahkan ke DashboardScreen (tanpa bisa back ke login)
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000)); // simulasi network

    final user = DummyDataService.findUser(
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (!mounted) return;
    if (user != null) {
      // ✅ Login berhasil: simpan sesi lalu navigasi ke Dashboard
      SessionService.login(user);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false, // hapus semua history → tidak bisa back ke login
      );
    } else {
      // ❌ Login gagal
      setState(() => _isLoading = false);
      AppUtils.showSnackBar(context, 'Email atau password salah.', isError: true);
    }
  }

  // // ── Quick-fill akun demo ───────────────────────────────────────────────────
  // void _fillDemo(String email, String password) {
  //   setState(() {
  //     _emailCtrl.text    = email;
  //     _passwordCtrl.text = password;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // ── Logo ──────────────────────────────────────────────
                    Center(
                      child: Column(children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.primaryColor.withBlue(200)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 20, offset: const Offset(0, 8),
                            )],
                          ),
                          child: const Icon(Icons.support_agent_rounded, size: 42, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text('Smart Pujasera',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Helpdesk E-Ticketing',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      ]),
                    ),
                    const SizedBox(height: 48),

                    // ── Form ──────────────────────────────────────────────
                    Text('Masuk ke Akun',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Gunakan email dan password yang terdaftar',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5))),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!v.contains('@')) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined, size: 20),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password wajib diisi';
                        if (v.length < 6) return 'Password minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Masuk'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        child: const Text('Daftar Akun Baru'),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Demo accounts ─────────────────────────────────────
                    // Container(
                    //   padding: const EdgeInsets.all(14),
                    //   decoration: BoxDecoration(
                    //     color: AppTheme.infoColor.withOpacity(0.08),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(color: AppTheme.infoColor.withOpacity(0.25)),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(children: [
                    //         Icon(Icons.info_outline_rounded, size: 14, color: AppTheme.infoColor),
                    //         const SizedBox(width: 6),
                    //         Text('Akun Demo — tap untuk mengisi otomatis',
                    //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    //                 color: AppTheme.infoColor)),
                    //       ]),
                    //       const SizedBox(height: 10),
                    //       _DemoTile(
                    //         role: 'User',
                    //         desc: 'Buat & lihat laporan milik sendiri',
                    //         email: 'budi@pujasera.id',
                    //         password: '123456',
                    //         color: Colors.blue,
                    //         onTap: _fillDemo,
                    //       ),
                    //       const SizedBox(height: 6),
                    //       _DemoTile(
                    //         role: 'Helpdesk',
                    //         desc: 'Lihat semua laporan, ubah status',
                    //         email: 'sari@pujasera.id',
                    //         password: '123456',
                    //         color: Colors.orange,
                    //         onTap: _fillDemo,
                    //       ),
                    //       const SizedBox(height: 6),
                    //       _DemoTile(
                    //         role: 'Admin',
                    //         desc: 'Semua akses + assign laporan',
                    //         email: 'admin@pujasera.id',
                    //         password: 'admin123',
                    //         color: Colors.purple,
                    //         onTap: _fillDemo,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Demo tile widget ──────────────────────────────────────────────────────────
// class _DemoTile extends StatelessWidget {
//   final String role, desc, email, password;
//   final Color color;
//   final void Function(String email, String password) onTap;

//   const _DemoTile({
//     required this.role, required this.desc,
//     required this.email, required this.password,
//     required this.color, required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => onTap(email, password),
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.06),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Row(children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(role,
//                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
//           ),
//           const SizedBox(width: 10),
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(email, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//               Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//             ],
//           )),
//           Icon(Icons.touch_app_rounded, size: 14, color: color.withOpacity(0.5)),
//         ]),
//       ),
//     );
//   }
// }
