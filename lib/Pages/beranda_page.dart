import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../models/task.dart';
import 'tambah_tugas_penting_page.dart';
import 'tambah_tugas_biasa_page.dart';
import 'daftar_tugas_page.dart';

class BerandaPage extends StatefulWidget {
  final String username;

  const BerandaPage({super.key, this.username = 'User'});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int tugasSelesai = 0; 
  int belumSelesai = 0; 

  List<_ChartPoint> _chartData = const [
    _ChartPoint('Sen', 0),
    _ChartPoint('Sel', 0),
    _ChartPoint('Rab', 0),
    _ChartPoint('Kam', 0),
    _ChartPoint('Jum', 0),
    _ChartPoint('Sab', 0),
    _ChartPoint('Min', 0),
  ];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    try {
      final completed = await DatabaseHelper.instance.getCompletedTasks();

      
      final Map<int, int> counts = {for (var i = 1; i <= 7; i++) i: 0};

      for (final t in completed) {
        if (t.tanggal == null) continue;
        DateTime? dt;
        try {
          dt = DateTime.parse(t.tanggal!);
        } catch (e) {
          continue;
        }
        final wk = dt.weekday; 
        counts[wk] = (counts[wk] ?? 0) + 1;
      }

      final labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      final data = List<_ChartPoint>.generate(7, (i) {
        final wk = i + 1; 
        return _ChartPoint(labels[i], (counts[wk] ?? 0).toDouble());
      });

      setState(() {
        _chartData = data;
      });
    } catch (e) {
      
      return;
    }
  }

  String _formatToday() {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final now = DateTime.now();
    return '${days[now.weekday == 7 ? 0 : now.weekday]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sapaan
              Text(
                'Halo, ${widget.username}! 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatToday(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Card Tugas Selesai & Belum Selesai
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'TUGAS SELESAI',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '12',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'BELUM SELESAI',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '8',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card Grafik
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TUGAS SELESAI / HARI',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final maxVal = _chartData.isNotEmpty
                                ? _chartData
                                      .map((e) => e.value)
                                      .reduce(math.max)
                                : 1.0;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: _chartData.map((item) {
                                final double barMaxHeight = 110;
                                final double height = (maxVal > 0)
                                    ? (item.value / maxVal) * barMaxHeight
                                    : 6.0;
                                final double displayHeight = height < 6
                                    ? 6
                                    : height;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          height: displayHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.teal.shade300,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item.label,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Row 1
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/tambah_penting');
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah Tugas Penting',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/tambah_biasa');
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah Tugas Biasa',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Tombol Row 2
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/daftar');
                      },
                      icon: const Icon(Icons.list, color: Colors.white),
                      label: const Text(
                        'Daftar Tugas',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pengaturan');
                      },
                      icon: const Icon(Icons.settings, color: Colors.white),
                      label: const Text(
                        'Pengaturan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartPoint {
  final String label;
  final double value;

  const _ChartPoint(this.label, this.value);
}
