// ==========================================
// SISTEM MANAJEMEN TOKO ONLINE
// OOP & ASYNC DART
// ==========================================

// ABSTRACT CLASS
abstract class Produk {
  String id;
  String nama;
  double harga;
  int stok;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
  });

  // Abstract method
  String deskripsi();
}

// ==========================================
// MIXIN BISA DISKON
// ==========================================

mixin BisaDiskon {
  double hitungHargaDiskon(double persen) {
    if (persen < 0 || persen > 100) {
      throw ValidasiDiskonException("Diskon harus berada antara 0 sampai 100%");
    }

    return 0;
  }

  void validasiDiskon(double persen) {
    if (persen < 0 || persen > 100) {
      throw ValidasiDiskonException("Persentase diskon tidak valid!");
    }
  }
}

// ==========================================
// PRODUK DIGITAL
// ==========================================

class ProdukDigital extends Produk with BisaDiskon {
  double ukuranMB;
  String formatFile;

  ProdukDigital({
    required super.id,
    required super.nama,
    required super.harga,
    required super.stok,
    required this.ukuranMB,
    required this.formatFile,
  });

  @override
  String deskripsi() {
    return "Produk Digital: $nama | "
        "Ukuran: ${ukuranMB}MB | "
        "Format: $formatFile";
  }

  @override
  double hitungHargaDiskon(double persen) {
    validasiDiskon(persen);
    return harga - (harga * persen / 100);
  }
}

// ==========================================
// PRODUK FISIK
// ==========================================

class ProdukFisik extends Produk with BisaDiskon {
  double beratGram;
  String dimensi;

  ProdukFisik({
    required super.id,
    required super.nama,
    required super.harga,
    required super.stok,
    required this.beratGram,
    required this.dimensi,
  });

  @override
  String deskripsi() {
    return "Produk Fisik: $nama | "
        "Berat: ${beratGram}gram | "
        "Dimensi: $dimensi";
  }

  @override
  double hitungHargaDiskon(double persen) {
    validasiDiskon(persen);
    return harga - (harga * persen / 100);
  }
}

// ==========================================
// CUSTOM EXCEPTION
// ==========================================

class StokHabisException implements Exception {
  String message;

  StokHabisException(this.message);

  @override
  String toString() {
    return "StokHabisException: $message";
  }
}

class ProdukTidakAdaException implements Exception {
  String message;

  ProdukTidakAdaException(this.message);

  @override
  String toString() {
    return "ProdukTidakAdaException: $message";
  }
}

class ValidasiDiskonException implements Exception {
  String message;

  ValidasiDiskonException(this.message);

  @override
  String toString() {
    return "ValidasiDiskonException: $message";
  }
}

// ==========================================
// CLASS KERANJANG
// ==========================================

class Keranjang {
  List<Produk> produkList = [];

  void tambah(Produk produk) {
    if (produk.stok <= 0) {
      throw StokHabisException("Stok produk ${produk.nama} sudah habis.");
    }

    produkList.add(produk);

    // Mengurangi stok
    produk.stok--;

    print("Produk '${produk.nama}' berhasil ditambahkan.");
  }

  void hapus(String id) {
    try {
      Produk produk = produkList.firstWhere((item) => item.id == id);

      produkList.remove(produk);

      // Mengembalikan stok
      produk.stok++;

      print("Produk '${produk.nama}' berhasil dihapus.");
    } catch (e) {
      throw ProdukTidakAdaException(
        "Produk dengan ID $id tidak ada di keranjang.",
      );
    }
  }

  double totalHarga() {
    double total = 0;

    for (var produk in produkList) {
      total += produk.harga;
    }

    return total;
  }

  void tampilkanKeranjang() {
    print("\n========== KERANJANG ==========");

    if (produkList.isEmpty) {
      print("Keranjang kosong.");
      return;
    }

    for (var produk in produkList) {
      print(
        "${produk.id} | ${produk.nama} | "
        "Rp${produk.harga.toStringAsFixed(0)}",
      );
    }

    print("-------------------------------");
    print("Total: Rp${totalHarga().toStringAsFixed(0)}");
  }
}

// ==========================================
// CLASS TOKO SERVICE
// ==========================================

class TokoService {
  List<Produk> daftarProduk = [];

  // CREATE
  Future<void> tambahProduk(Produk produk) async {
    await Future.delayed(const Duration(seconds: 1));

    daftarProduk.add(produk);

    print("Produk '${produk.nama}' berhasil ditambahkan ke toko.");
  }

  // READ
  Future<List<Produk>> ambilProduk() async {
    await Future.delayed(const Duration(seconds: 1));

    return daftarProduk;
  }

  // UPDATE
  Future<void> updateProduk(
    String id,
    String namaBaru,
    double hargaBaru,
    int stokBaru,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      Produk produk = daftarProduk.firstWhere((item) => item.id == id);

      produk.nama = namaBaru;
      produk.harga = hargaBaru;
      produk.stok = stokBaru;

      print("Produk berhasil diperbarui.");
    } catch (e) {
      throw ProdukTidakAdaException("Produk dengan ID $id tidak ditemukan.");
    }
  }

  // DELETE
  Future<void> hapusProduk(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      Produk produk = daftarProduk.firstWhere((item) => item.id == id);

      daftarProduk.remove(produk);

      print("Produk '${produk.nama}' berhasil dihapus.");
    } catch (e) {
      throw ProdukTidakAdaException("Produk dengan ID $id tidak ditemukan.");
    }
  }

  // CHECKOUT
  Future<void> prosesCheckout(Keranjang keranjang) async {
    try {
      print("\nMemproses checkout...");

      await Future.delayed(const Duration(seconds: 2));

      if (keranjang.produkList.isEmpty) {
        throw ProdukTidakAdaException("Keranjang masih kosong.");
      }

      print("Checkout berhasil!");
      print(
        "Total pembayaran: "
        "Rp${keranjang.totalHarga().toStringAsFixed(0)}",
      );
    } catch (e) {
      print("Checkout gagal: $e");
    }
  }
}

// ==========================================
// MAIN PROGRAM
// ==========================================

Future<void> main() async {
  print("====================================");
  print("     SISTEM MANAJEMEN TOKO ONLINE");
  print("====================================");

  try {
    // Membuat produk digital
    ProdukDigital ebook = ProdukDigital(
      id: "D001",
      nama: "E-Book Dart",
      harga: 50000,
      stok: 5,
      ukuranMB: 10,
      formatFile: "PDF",
    );

    // Membuat produk fisik
    ProdukFisik laptop = ProdukFisik(
      id: "F001",
      nama: "Laptop",
      harga: 7000000,
      stok: 3,
      beratGram: 1500,
      dimensi: "30x20x2 cm",
    );

    // Service
    TokoService toko = TokoService();

    // CREATE
    await toko.tambahProduk(ebook);
    await toko.tambahProduk(laptop);

    // READ
    print("\n========== DAFTAR PRODUK ==========");

    List<Produk> produk = await toko.ambilProduk();

    for (var item in produk) {
      print(
        "${item.id} | "
        "${item.nama} | "
        "Rp${item.harga.toStringAsFixed(0)} | "
        "Stok: ${item.stok}",
      );

      print(item.deskripsi());
    }

    // DISKON
    print("\n========== DISKON ==========");

    double hargaDiskon = ebook.hitungHargaDiskon(10);

    print(
      "Harga ${ebook.nama} setelah diskon 10%: "
      "Rp${hargaDiskon.toStringAsFixed(0)}",
    );

    // KERANJANG
    Keranjang keranjang = Keranjang();

    keranjang.tambah(ebook);
    keranjang.tambah(laptop);

    keranjang.tampilkanKeranjang();

    // CHECKOUT
    await toko.prosesCheckout(keranjang);

    // UPDATE
    print("\n========== UPDATE PRODUK ==========");

    await toko.updateProduk("D001", "E-Book Dart Lengkap", 75000, 10);

    // DELETE
    print("\n========== HAPUS PRODUK ==========");

    await toko.hapusProduk("F001");

    print("\nProgram selesai.");
  } catch (e) {
    print("Terjadi kesalahan: $e");
  }
}
