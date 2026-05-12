import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../models/task.dart';

class TambahTugasPentingPage extends StatefulWidget {
  const TambahTugasPentingPage({super.key});

  @override
  State<TambahTugasPentingPage> createState() => _TambahTugasPentingPageState();
}

class _TambahTugasPentingPageState extends State<TambahTugasPentingPage> {
  DateTime? tanggalDipilih;
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Tugas Penting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // warna tombol back
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label PENTING
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PENTING',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Jatuh Tempo
            const Text(
              'TANGGAL JATUH TEMPO',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    tanggalDipilih = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      tanggalDipilih != null
                          ? '${tanggalDipilih!.day} ${_namaBulan(tanggalDipilih!.month)} ${tanggalDipilih!.year}'
                          : 'Pilih tanggal',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Judul Tugas
            const Text(
              'JUDUL TUGAS',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Submit laporan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi
            const Text(
              'DESKRIPSI',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan tugas...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final task = Task(
                    judul: judulController.text,
                    deskripsi: deskripsiController.text,
                    tanggal: tanggalDipilih?.toIso8601String(),
                    kategori: 'penting',
                    selesai: 0,
                  );
                  await DatabaseHelper.instance.insertTask(task);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SIMPAN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // fungsi bantu nama bulan
  String _namaBulan(int bulan) {
    const bulanList = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return bulanList[bulan - 1];
  }
}
