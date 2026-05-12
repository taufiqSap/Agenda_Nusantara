import 'package:flutter/material.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final TextEditingController passwordSaatIniController =
      TextEditingController();
  final TextEditingController passwordBaruController = TextEditingController();

  // nanti ambil dari database, sementara hardcode
  String passwordTersimpan = 'user';

  void simpanPassword() {
    if (passwordSaatIniController.text == passwordTersimpan) {
      setState(() {
        passwordTersimpan = passwordBaruController.text;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password berhasil diubah')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password saat ini salah!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul section
            const Text(
              'GANTI PASSWORD',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Password Saat Ini
            const Text(
              'PASSWORD SAAT INI',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordSaatIniController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '••••',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password Baru
            const Text(
              'PASSWORD BARU',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordBaruController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '••••••••',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan Password
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpanPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SIMPAN PASSWORD',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Section Developer
            const Text(
              'DEVELOPER',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                 
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'taufiqsatriaji', 
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'NIM: 2241760142', 
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'DEVELOPER APLIKASI',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
