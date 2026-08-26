void main() {
  // 1. Data Mahasiswa (List berisi Map)
  List<Map<String, dynamic>> daftarMahasiswa = [
    {
      'nama': 'Haslina D Nurdin',
      'nilai': [85, 90, 78, 92, 88],
      'absensi': 2,
    },
    {
      'nama': 'Atira Salsabilla',
      'nilai': [55, 60, 58, 52, 45],
      'absensi': 1,
    },
    {
      'nama': 'Rasya Ardila',
      'nilai': [70, 75, 80, 72, 78],
      'absensi': 2,
    },
    {
      'nama': 'Putri Azzahra',
      'nilai': [90, 95, 92, 88, 94],
      'absensi': 1,
    },
    {
      'nama': 'Fahril Husain',
      'nilai': [40, 50, 45, 30, 55],
      'absensi': 5,
    },
  ];

  double totalRataRataKelas = 0;
  int? nilaiTertinggi;
  int? nilaiTerendah;

  print('=== LAPORAN NILAI MAHASISWA ===');

  for (var mhs in daftarMahasiswa) {
    String nama = mhs['nama'];
    List<int> nilai = mhs['nilai'];
    int absensi = mhs['absensi'];

    // Panggil fungsi-fungsi logika
    double rataRata = hitungRataRata(nilai);
    String grade = tentukanGrade(rataRata);
    bool lulus = cekKelulusan(rataRata: rataRata, absensi: absensi);

    // Akumulasi rata-rata untuk statistik kelas
    totalRataRataKelas += rataRata;

    // Perbaikan Logika Null Safety untuk Nilai Tertinggi & Terendah
    for (int n in nilai) {
      if (nilaiTertinggi == null || n > nilaiTertinggi!) {
        nilaiTertinggi = n;
      }
      if (nilaiTerendah == null || n < nilaiTerendah!) {
        nilaiTerendah = n;
      }
    }

    // Tampilkan Laporan
    print('\nNama     : $nama');
    print('Nilai    : $nilai');
    print('Rata-rata: ${rataRata.toStringAsFixed(1)}');
    print('Grade    : $grade');
    print('Absensi  : $absensi kali');
    print('Status   : ${lulus ? "LULUS" : "TIDAK LULUS"}');
  }

  // 2. Tampilkan Statistik Kelas
  double rataRataKelas = totalRataRataKelas / daftarMahasiswa.length;

  print('\n=== STATISTIK KELAS ===');
  print('Nilai Tertinggi : $nilaiTertinggi');
  print('Nilai Terendah  : $nilaiTerendah');
  print('Rata-rata Kelas : ${rataRataKelas.toStringAsFixed(1)}');
}

// Fungsi menghitung rata-rata
double hitungRataRata(List<int> nilai) {
  if (nilai.isEmpty) return 0;
  int total = nilai.reduce((a, b) => a + b);
  return total / nilai.length;
}

// Fungsi menentukan Grade
String tentukanGrade(double rataRata) {
  if (rataRata >= 85) return 'A';
  if (rataRata >= 75) return 'B';
  if (rataRata >= 65) return 'C';
  if (rataRata >= 50) return 'D';
  return 'E';
}

// Fungsi cek kelulusan (rata-rata >= 60 DAN absensi <= 3)
bool cekKelulusan({required double rataRata, required int absensi}) {
  return rataRata >= 60 && absensi <= 3;
}
