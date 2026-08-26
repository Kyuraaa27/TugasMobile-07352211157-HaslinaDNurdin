import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

final List<Map<String, dynamic>> buku = [
  {
    'judul': 'Laskar Pelangi',
    'pengarang': 'Andrea Hirata',
    'tahun': 2005,
    'rating': 4.8,
    'tersedia': true,
    'genre': 'Novel',
    'catatan': 'Buku dalam kondisi baik.',
  },
  {
    'judul': 'Bumi Manusia',
    'pengarang': 'Pramoedya Ananta Toer',
    'tahun': 1980,
    'rating': 4.7,
    'tersedia': false,
    'genre': 'Sejarah',
    'catatan': null,
  },
  {
    'judul': 'Negeri 5 Menara',
    'pengarang': 'Ahmad Fuadi',
    'tahun': 2009,
    'rating': 4.3,
    'tersedia': true,
    'genre': 'Novel',
    'catatan': null,
  },
  {
    'judul': 'Atomic Habits',
    'pengarang': 'James Clear',
    'tahun': 2018,
    'rating': 4.6,
    'tersedia': true,
    'genre': 'Motivasi',
    'catatan': 'Buku baru.',
  },
  {
    'judul': 'Clean Code',
    'pengarang': 'Robert Martin',
    'tahun': 2008,
    'rating': 4.4,
    'tersedia': false,
    'genre': 'Pemrograman',
    'catatan': null,
  },
  {
    'judul': 'Filosofi Teras',
    'pengarang': 'Henry Manampiring',
    'tahun': 2018,
    'rating': 3.9,
    'tersedia': true,
    'genre': 'Filsafat',
    'catatan': null,
  },
];

String kategoriRating(double rating) {
  if (rating >= 4.5) {
    return 'Sangat Baik';
  } else if (rating >= 3.5) {
    return 'Baik';
  } else {
    return 'Cukup';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Katalog(),
    );
  }
}

class Katalog extends StatefulWidget {
  const Katalog({super.key});

  @override
  State<Katalog> createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
  String cari = '';

  @override
  Widget build(BuildContext context) {
    final hasil = buku.where(
      (b) => b['judul'].toString().toLowerCase().contains(cari.toLowerCase()),
    );

    final Set<String> genre = buku.map((b) => b['genre'] as String).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Buku Perpustakaan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul buku...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => cari = value),
            ),
          ),

          Wrap(
            spacing: 6,
            children: genre.map((g) => Chip(label: Text(g))).toList(),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: hasil.length,
              itemBuilder: (context, index) {
                final b = hasil.elementAt(index);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      b['judul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${b['pengarang']} | ${b['tahun']}\n'
                      '⭐ ${b['rating']} - ${kategoriRating(b['rating'])}',
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b['tersedia'] ? 'Tersedia' : 'Dipinjam',
                          style: TextStyle(
                            color: b['tersedia'] ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Detail(buku: b),
                              ),
                            );
                          },
                          child: const Text('Detail'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Detail extends StatefulWidget {
  final Map<String, dynamic> buku;

  const Detail({super.key, required this.buku});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    final b = widget.buku;
    final String? catatan = b['catatan'];

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              b['judul'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Pengarang: ${b['pengarang']}'),
            Text('Tahun: ${b['tahun']}'),
            Text('Genre: ${b['genre']}'),
            Text('Rating: ${b['rating']}'),
            Text('Status: ${b['tersedia'] ? 'Tersedia' : 'Dipinjam'}'),
            const SizedBox(height: 20),
            const Text(
              'Catatan Peminjam:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(catatan ?? 'Tidak ada catatan'),
          ],
        ),
      ),
    );
  }
}
