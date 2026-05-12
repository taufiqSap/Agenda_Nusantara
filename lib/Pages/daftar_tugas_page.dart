import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../models/task.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  List<Task> daftarTugas = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      daftarTugas = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView.builder(
          itemCount: daftarTugas.length,
          itemBuilder: (context, index) {
            final tugas = daftarTugas[index];
            final bool isPenting = tugas.kategori == 'penting';
            final bool isSelesai = tugas.selesai == 1;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Checkbox(
                  value: isSelesai,
                  onChanged: (value) async {
                    tugas.selesai = (value ?? false) ? 1 : 0;
                    await DatabaseHelper.instance.updateTask(tugas);
                    setState(() {});
                  },
                ),
                title: Text(
                  tugas.judul,
                  style: TextStyle(
                    decoration: isSelesai
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isSelesai ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${tugas.tanggal ?? ''} · ${isPenting ? 'Penting' : 'Biasa'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: isPenting ? Colors.red : Colors.green,
                  size: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
