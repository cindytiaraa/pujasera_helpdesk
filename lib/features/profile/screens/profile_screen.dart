import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/services/session_service.dart';
// removed unused imports
import '../../../shared/widgets/shared_widgets.dart';
import '../../../main.dart';
import '../../auth/screens/login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar Aplikasi',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              SessionService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const stats = {
      'total': 0,
      'pending': 0,
      'done': 0,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: UserAvatar(
                      initials: SessionService.userAvatar,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    SessionService.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    SessionService.userEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRoleLabel(SessionService.userRole),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Ticket Stats ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatBox(
                        label: 'Total',
                        count: stats['total'] ?? 0,
                        color: theme.colorScheme.primary,
                      ),

                      _StatBox(
                        label: 'Pending',
                        count: stats['pending'] ?? 0,
                        color: AppTheme.pendingColor,
                      ),

                      _StatBox(
                        label: 'Selesai',
                        count: stats['done'] ?? 0,
                        color: AppTheme.doneColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Info Items ────────────────────────────────────
                  Card(
                    child: Column(
                      children: [
                        _ProfileTile(
                          icon: Icons.badge_outlined,
                          label: 'Nama Lengkap',
                          value: SessionService.userName,
                        ),
                        Divider(
                            height: 1,
                            color: theme.dividerColor),
                        _ProfileTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: SessionService.userEmail,
                        ),
                        Divider(
                            height: 1,
                            color: theme.dividerColor),
                        _ProfileTile(
                          icon: Icons.phone_outlined,
                          label: 'Nomor HP',
                          value: SessionService.userPhone,
                        ),
                        Divider(
                            height: 1,
                            color: theme.dividerColor),
                        _ProfileTile(
                          icon: Icons.business_outlined,
                          label: 'Departemen',
                          value: SessionService.userDept,
                        ),
                        Divider(
                            height: 1,
                            color: theme.dividerColor),
                        _ProfileTile(
                          icon: Icons.verified_user_outlined,
                          label: 'Role',
                          value: _getRoleLabel(SessionService.userRole),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Settings ──────────────────────────────────────
                  Text(
                    'Pengaturan',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    child: Column(
                      children: [
                        _SettingTile(
                          icon: Icons.notifications_outlined,
                          label: 'Notifikasi',
                          onTap: () => AppUtils.showSnackBar(
                              context, 'Pengaturan notifikasi segera hadir!'),
                        ),
                        Divider(height: 1, color: theme.dividerColor),
                        _SettingTile(
                          icon: Icons.lock_outline_rounded,
                          label: 'Ubah Password',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          ),
                        ),
                        Divider(height: 1, color: theme.dividerColor),
                        _SettingTile(
                          icon: Icons.help_outline_rounded,
                          label: 'Bantuan & FAQ',
                          onTap: () => AppUtils.showSnackBar(
                              context, 'Halaman bantuan segera hadir!'),
                        ),
                        Divider(height: 1, color: theme.dividerColor),
                        Divider(height: 1, color: theme.dividerColor),
                        _DarkModeTile(),
                        Divider(height: 1, color: theme.dividerColor),
                        _SettingTile(
                          icon: Icons.info_outline_rounded,
                          label: 'Tentang Aplikasi',
                          onTap: () => _showAbout(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Logout Button ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.logout_rounded,
                          size: 18, color: Colors.red.shade600),
                      label: Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App version
                  Center(
                    child: Text(
                      'Smart Pujasera Helpdesk v1.0.0',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Administrator';
      case 'helpdesk':
        return 'Helpdesk';
      default:
        return 'Pengguna';
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Smart Pujasera Helpdesk',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Smart Pujasera\nDIV Teknik Informatika - Universitas Airlangga',
      children: [
        const SizedBox(height: 12),
        const Text(
          'Aplikasi helpdesk e-ticketing untuk pelaporan, monitoring, dan penyelesaian masalah di Pusat Pujasera.',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

// ─── DARK MODE TILE ────────────────────────────────────────────────────────
class _DarkModeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = SmartPujaseraApp.of(context);
    final isDark = appState?.isDarkMode ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            size: 18,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isDark ? 'Mode Gelap' : 'Mode Terang',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (_) => appState?.toggleTheme(),
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

// ─── STAT BOX ──────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBox(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PROFILE TILE ──────────────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon,
              size: 18, color: theme.colorScheme.onSurface.withOpacity(0.4)),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const Spacer(),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── SETTING TILE ──────────────────────────────────────────────────────────
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(width: 14),
            Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14))),
            Icon(Icons.chevron_right_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }
}
