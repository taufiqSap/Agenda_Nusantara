class Task {
  int? id;
  String judul;
  String deskripsi;
  String? tanggal; 
  String kategori; 
  int selesai;

  Task({
    this.id,
    required this.judul,
    required this.deskripsi,
    this.tanggal,
    required this.kategori,
    this.selesai = 0,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'kategori': kategori,
      'selesai': selesai,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      judul: map['judul'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      tanggal: map['tanggal'] as String?,
      kategori: map['kategori'] as String? ?? 'biasa',
      selesai: map['selesai'] as int? ?? 0,
    );
  }
}
