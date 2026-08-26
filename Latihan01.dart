import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileCardPage(),
  );
}

class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ── VARIABEL & TIPE DATA ──────────────────────────
    // Setiap variabel punya tipe yang SESUAI dengan jenis datanya
    final String nama = 'Yasir Muin'; // String → teks
    final String jurusan = 'Teknik Informatika'; // String → teks
    final int umur = 21; // int → angka bulat
    final double ipk = 3.78; // double → angka desimal
    final int totalSks = 118; // int → angka bulat
    final bool statusAktif = true; // bool → logika (aktif/tidak)
    final bool sudahLulus = false; // bool → logika

    return Scaffold(
      appBar: AppBar(title: const Text('Kartu Profil Mahasiswa')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 12),

                // Variabel String LANGSUNG ditampilkan sebagai teks
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(jurusan, style: const TextStyle(color: Colors.grey)),
                const Divider(height: 24),

                // Variabel int/double ditampilkan via string interpolation
                Text('Umur: $umur tahun'),
                Text('IPK: $ipk'), // double tampil apa adanya
                Text('Total SKS: $totalSks'),

                const SizedBox(height: 12),

                // Variabel bool dipakai untuk MENENTUKAN tampilan (ternary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    // bool 'statusAktif' menentukan WARNA badge
                    color: statusAktif
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    // bool 'statusAktif' menentukan TEKS badge
                    statusAktif ? 'Mahasiswa Aktif' : 'Non-Aktif',
                    style: TextStyle(
                      color: statusAktif
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
