import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Pages/beranda_page.dart';
import 'Pages/login_page.dart';
import 'Pages/daftar_tugas_page.dart';
import 'Pages/pengaturan_page.dart';
import 'Pages/tambah_tugas_penting_page.dart';
import 'Pages/tambah_tugas_biasa_page.dart';
import 'Database/db_helper.dart';
import 'models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeDatabaseFactory();
  runApp(const MyApp());
  _seedDefaultUser();
}

void _initializeDatabaseFactory() {
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

Future<void> _seedDefaultUser() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  // Create the default login only once, after the UI is already on screen.
  final userExists = await dbHelper.userExists('taufiqsatriaji');
  if (!userExists) {
    final defaultUser = User(username: 'taufiqsatriaji', password: 'password');
    await dbHelper.insertUser(defaultUser);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sertfikasi Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/beranda': (context) => const BerandaPage(),
        '/daftar': (context) => const DaftarTugasPage(),
        '/pengaturan': (context) => const PengaturanPage(),
        '/tambah_penting': (context) => const TambahTugasPentingPage(),
        '/tambah_biasa': (context) => const TambahTugasBiasaPage(),
      },
    );
  }
}
