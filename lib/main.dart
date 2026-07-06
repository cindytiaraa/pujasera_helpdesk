import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pujasera_helpdesk/features/auth/screens/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jdaqsnhgsrppchzlthyi.supabase.co',
    anonKey: 'sb_publishable_ygXEs5EdoiBZyntD8DAdLg_zfuSNYdj',
  );

  await initializeDateFormatting('id_ID', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SmartPujaseraApp());
}

class SmartPujaseraApp extends StatefulWidget {
  const SmartPujaseraApp({super.key});

  static _SmartPujaseraAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SmartPujaseraAppState>();

  @override
  State<SmartPujaseraApp> createState() => _SmartPujaseraAppState();
}

class _SmartPujaseraAppState extends State<SmartPujaseraApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(
            () {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pujasera Helpdesk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}