import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const TiketKitaApp());
}

// ============================================================
// ABSTRACT CLASS & MODEL TIKET
// ============================================================

abstract class Tiket {
  final String id;
  final String nama;
  final double harga;
  int stok;
  final String rute;
  final String jam;
  final double rating;

  Tiket({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.rute,
    required this.jam,
    this.rating = 4.8,
  });

  String deskripsi();

  String formatRupiah(double angka) {
    final String nilai = angka.toStringAsFixed(0);
    final StringBuffer hasil = StringBuffer();
    int hitung = 0;

    for (int i = nilai.length - 1; i >= 0; i--) {
      hasil.write(nilai[i]);
      hitung++;
      if (hitung == 3 && i != 0) {
        hasil.write('.');
        hitung = 0;
      }
    }
    return 'Rp ${hasil.toString().split('').reversed.join()}';
  }
}

// ============================================================
// MIXIN BISA DISKON
// ============================================================

mixin BisaDiskon on Tiket {
  double hitungHargaDiskon(double persen) {
    if (!validasiDiskon(persen)) {
      throw Exception('Persentase diskon tidak valid');
    }
    return harga - (harga * persen / 100);
  }

  bool validasiDiskon(double persen) {
    return persen > 0 && persen <= 50;
  }
}

// ============================================================
// SUBCLASS 1 - TIKET EKONOMI
// ============================================================

class TiketEkonomi extends Tiket {
  final String fasilitas;

  TiketEkonomi({
    required super.id,
    required super.nama,
    required super.harga,
    required super.stok,
    required super.rute,
    required super.jam,
    super.rating,
    required this.fasilitas,
  });

  @override
  String deskripsi() {
    return 'Kelas Ekonomi • $fasilitas';
  }
}

// ============================================================
// SUBCLASS 2 - TIKET VIP
// ============================================================

class TiketVIP extends Tiket with BisaDiskon {
  final String fasilitas;

  TiketVIP({
    required super.id,
    required super.nama,
    required super.harga,
    required super.stok,
    required super.rute,
    required super.jam,
    super.rating,
    required this.fasilitas,
  });

  @override
  String deskripsi() {
    return 'Kelas VIP • $fasilitas';
  }
}

// ============================================================
// CUSTOM EXCEPTION
// ============================================================

class TiketHabisException implements Exception {
  final String pesan;
  TiketHabisException(this.pesan);

  @override
  String toString() => pesan;
}

class TiketTidakAdaException implements Exception {
  final String pesan;
  TiketTidakAdaException(this.pesan);

  @override
  String toString() => pesan;
}

// ============================================================
// SERVICE TIKET
// ============================================================

class TiketService {
  Future<List<Tiket>> ambilDaftarTiket() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      TiketVIP(
        id: 'VIP001',
        nama: 'Argo Parahyangan VIP',
        harga: 350000,
        stok: 4,
        rute: 'Jakarta (GMR) → Bandung (BD)',
        jam: '08:00 - 10:45',
        rating: 4.9,
        fasilitas: 'Kursi Reclining + Makanan + Lounge VIP',
      ),
      TiketEkonomi(
        id: 'ECO001',
        nama: 'Serayu Ekspres',
        harga: 120000,
        stok: 8,
        rute: 'Jakarta (PSE) → Purwokerto',
        jam: '09:15 - 15:30',
        rating: 4.7,
        fasilitas: 'AC + Wi-Fi Gratis + Stopkontak',
      ),
      TiketVIP(
        id: 'VIP002',
        nama: 'Gajayana Luxury VIP',
        harga: 650000,
        stok: 2,
        rute: 'Jakarta (GMR) → Malang (ML)',
        jam: '18:40 - 06:15',
        rating: 5.0,
        fasilitas: 'Sleeper Seat + Dinner + Welcome Drink',
      ),
      TiketEkonomi(
        id: 'ECO002',
        nama: 'Taksaka Ekonomi Plus',
        harga: 210000,
        stok: 1,
        rute: 'Jakarta (GMR) → Yogyakarta (YK)',
        jam: '14:00 - 21:10',
        rating: 4.8,
        fasilitas: 'Kursi Ergonomis + Bagasi 20kg',
      ),
      TiketVIP(
        id: 'VIP003',
        nama: 'Argo Bromo Anggrek VIP',
        harga: 520000,
        stok: 3,
        rute: 'Jakarta (GMR) → Surabaya (SBI)',
        jam: '20:30 - 04:45',
        rating: 4.9,
        fasilitas: 'Entertainment Screen + Lunch Box Premium',
      ),
    ];
  }

  Future<String> pesanTiket(Tiket tiket, {int jumlah = 1}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (tiket.stok < jumlah) {
      throw TiketHabisException(
        'Stok tiket ${tiket.nama} tidak mencukupi (Sisa stok: ${tiket.stok}).',
      );
    }

    tiket.stok -= jumlah;
    return 'Pemesanan $jumlah tiket ${tiket.nama} berhasil!';
  }
}

// ============================================================
// MAIN APP & THEME
// ============================================================

class TiketKitaApp extends StatelessWidget {
  const TiketKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TiketKita',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF1E40AF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF),
          primary: const Color(0xFF1E40AF),
          secondary: const Color(0xFF10B981),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shadowColor: Color(0x0F000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

// ============================================================
// MAIN PAGE (WITH BOTTOM NAVIGATION BAR)
// ============================================================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TiketService service = TiketService();
  late Future<List<Tiket>> futureTiket;

  int selectedMenu = 0;
  String searchQuery = '';
  String selectedCategory = 'Semua';
  final Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    futureTiket = service.ambilDaftarTiket();
  }

  void refreshData() {
    setState(() {
      futureTiket = service.ambilDaftarTiket();
    });
  }

  void bukaDetail(Tiket tiket) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTiketPage(tiket: tiket, service: service),
      ),
    );

    if (updated == true) {
      setState(() {});
    }
  }

  void toggleFavorite(String id) {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.confirmation_number,
                size: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text('TiketKita'),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 26),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Belum ada notifikasi baru.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedMenu,
          onTap: (index) {
            setState(() {
              selectedMenu = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1E40AF),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              activeIcon: Icon(Icons.confirmation_number_rounded),
              label: 'Tiket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer_rounded),
              label: 'Promo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedMenu) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildTiketTab();
      case 2:
        return _buildPromoTab();
      case 3:
        return _buildAccountTab();
      default:
        return _buildHomeTab();
    }
  }

  // ==========================================================
  // TAB 1: BERANDA
  // ==========================================================

  Widget _buildHomeTab() {
    return FutureBuilder<List<Tiket>>(
      future: futureTiket,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1E40AF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 70,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gagal Memuat Data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: refreshData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final allTickets = snapshot.data ?? [];
        final filteredTickets = _filterTickets(allTickets);

        return RefreshIndicator(
          onRefresh: () async => refreshData(),
          color: const Color(0xFF1E40AF),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GREETING BANNER
                _buildHeaderGreeting(),
                const SizedBox(height: 20),

                // SEARCH BOX
                _buildSearchBox(),
                const SizedBox(height: 20),

                // CATEGORY CHIPS FILTER
                _buildCategoryChips(allTickets),
                const SizedBox(height: 20),

                // PROMO BANNER
                _buildPromoBanner(),
                const SizedBox(height: 24),

                // COUNTDOWN TIMER
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFFDC2626),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Flash Sale Berakhir Dalam',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const CountdownWidget(),
                const SizedBox(height: 24),

                // TICKET SECTION HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilihan Tiket Perjalanan',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${filteredTickets.length} tiket ditemukan',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedMenu = 1;
                        });
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // LIST OF TICKETS
                if (filteredTickets.isEmpty)
                  _buildEmptyState()
                else
                  ...filteredTickets.map((tiket) {
                    return TicketCard(
                      tiket: tiket,
                      isFavorite: favoriteIds.contains(tiket.id),
                      onFavoriteToggle: () => toggleFavorite(tiket.id),
                      onTap: () => bukaDetail(tiket),
                    );
                  }),
                const SizedBox(height: 16),

                // INFORMATION FOOTER
                _buildInfoFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Tiket> _filterTickets(List<Tiket> list) {
    return list.where((t) {
      final matchesSearch =
          t.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.rute.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == 'Semua' ||
          (selectedCategory == 'VIP' && t is TiketVIP) ||
          (selectedCategory == 'Ekonomi' && t is TiketEkonomi);
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Widget _buildHeaderGreeting() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Selamat Datang 👋',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  'Mau Pergi Ke Mana?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, size: 14, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  'VIP Gold',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (val) {
          setState(() {
            searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari nama tiket atau tujuan kota...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1E40AF)),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
              : Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Color(0xFF1E40AF),
                    size: 20,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<Tiket> list) {
    final ecoCount = list.whereType<TiketEkonomi>().length;
    final vipCount = list.whereType<TiketVIP>().length;

    final categories = [
      {'name': 'Semua', 'count': list.length, 'icon': Icons.apps},
      {'name': 'Ekonomi', 'count': ecoCount, 'icon': Icons.train},
      {'name': 'VIP', 'count': vipCount, 'icon': Icons.workspace_premium},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                cat['icon'] as IconData,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              label: Text('${cat['name']} (${cat['count']})'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = cat['name'] as String;
                  });
                }
              },
              selectedColor: const Color(0xFF1E40AF),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF334155),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF1E40AF)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PROMO VOUCHER 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Diskon Hingga 20%\nPerjalanan VIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMenu = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Klaim Promo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.card_giftcard, size: 75, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 60,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tiket Tidak Ditemukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba ubah kata kunci pencarian atau kategori filter Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedCategory = 'Semua';
              });
            },
            child: const Text('Reset Filter'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF1E40AF),
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Jaminan pemesanan tiket resmi, aman 100%, dan tanpa biaya tersembunyi di TiketKita.',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TAB 2: SEMUA TIKET
  // ==========================================================

  Widget _buildTiketTab() {
    return FutureBuilder<List<Tiket>>(
      future: futureTiket,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allTickets = snapshot.data ?? [];
        final filteredTickets = _filterTickets(allTickets);

        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Katalog Tiket Lengkap',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih tiket perjalanan impianmu dengan fasilitas terbaik.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            const SizedBox(height: 16),

            _buildSearchBox(),
            const SizedBox(height: 14),
            _buildCategoryChips(allTickets),
            const SizedBox(height: 16),

            if (filteredTickets.isEmpty)
              _buildEmptyState()
            else
              ...filteredTickets.map((t) {
                return TicketCard(
                  tiket: t,
                  isFavorite: favoriteIds.contains(t.id),
                  onFavoriteToggle: () => toggleFavorite(t.id),
                  onTap: () => bukaDetail(t),
                );
              }),
          ],
        );
      },
    );
  }

  // ==========================================================
  // TAB 3: PROMO & VOUCHER
  // ==========================================================

  Widget _buildPromoTab() {
    final promos = [
      {
        'code': 'VIPLUXURY10',
        'title': 'Diskon 10% Kelas VIP',
        'desc': 'Hemat hingga Rp 50.000 khusus untuk tiket kereta kelas VIP.',
        'icon': Icons.workspace_premium,
        'color': Colors.amber,
      },
      {
        'code': 'HEMAT20',
        'title': 'Promo Perjalanan Hemat 20%',
        'desc': 'Potongan harga spesial untuk pemesanan tiket pertama.',
        'icon': Icons.local_offer,
        'color': Colors.blue,
      },
      {
        'code': 'WEEKENDSERU',
        'title': 'Voucher Akhir Pekan',
        'desc': 'Potongan Rp 25.000 untuk keberangkatan Sabtu & Minggu.',
        'icon': Icons.card_giftcard,
        'color': Colors.teal,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kupon & Promo Spesial 🎁',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gunakan kode promo berikut saat memesan tiket.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          ...promos.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: (p['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      p['icon'] as IconData,
                      color: p['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p['desc'] as String,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Kode: ${p['code']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF1E40AF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: Color(0xFF1E40AF),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Kode promo "${p['code']}" berhasil disalin!',
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================================
  // TAB 4: AKUN
  // ==========================================================

  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // PROFILE CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.person, size: 40, color: Color(0xFF1E40AF)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haslina D Nurdin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'haslina@example.com',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Member VIP Gold ⭐',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF1E40AF),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // WALLET CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo TiketPay',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp 450.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur isi ulang saldo segera hadir!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_card, size: 16),
                  label: const Text('Top Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // MENU OPTIONS
          _accountTile(Icons.history_rounded, 'Riwayat Pemesanan', () {
            _showHistoryModal(context);
          }),
          _accountTile(Icons.favorite_border_rounded, 'Tiket Favorit', () {
            setState(() {
              selectedMenu = 1;
            });
          }),
          _accountTile(Icons.help_outline_rounded, 'Pusat Bantuan', () {}),
          _accountTile(Icons.settings_outlined, 'Pengaturan Aplikasi', () {}),
          _accountTile(Icons.logout_rounded, 'Keluar', () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Logout berhasil.')));
          }, isDanger: true),
        ],
      ),
    );
  }

  Widget _accountTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger ? Colors.red : const Color(0xFF1E40AF),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDanger ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Pemesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Argo Parahyangan VIP'),
              subtitle: const Text('Kode: TKT-884912 • Selesai'),
              trailing: const Text(
                'Rp 350.000',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WIDGET TICKET CARD
// ============================================================

class TicketCard extends StatelessWidget {
  final Tiket tiket;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.tiket,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool vip = tiket is TiketVIP;
    double hargaAkhir = tiket.harga;

    if (vip) {
      final TiketVIP tiketVip = tiket as TiketVIP;
      if (tiketVip.validasiDiskon(10)) {
        hargaAkhir = tiketVip.hitungHargaDiskon(10);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: vip ? Colors.amber.shade200 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP HEADER BADGES & FAVORITE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: vip
                            ? const Color(0xFFFFFBEB)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: vip ? Colors.amber : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            vip ? Icons.workspace_premium : Icons.train,
                            color: vip
                                ? Colors.amber.shade800
                                : const Color(0xFF1E40AF),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vip ? 'VIP (Diskon 10%)' : 'Ekonomi',
                            style: TextStyle(
                              color: vip
                                  ? Colors.amber.shade900
                                  : const Color(0xFF1E40AF),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${tiket.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 22,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // TICKET NAME & ROUTE
            Text(
              tiket.nama,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tiket.rute,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  tiket.jam,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: Color(0xFFF1F5F9)),

            // PRICE & STOCK FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vip)
                      Text(
                        tiket.formatRupiah(tiket.harga),
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      tiket.formatRupiah(hargaAkhir),
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tiket.stok <= 2
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tiket.stok > 0 ? 'Stok: ${tiket.stok}' : 'Habis',
                    style: TextStyle(
                      color: tiket.stok <= 2
                          ? Colors.red
                          : Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // BUTTON ACTION
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: tiket.stok > 0 ? onTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  tiket.stok > 0 ? 'Pesan Sekarang' : 'Tiket Habis',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL TIKET PAGE
// ============================================================

class DetailTiketPage extends StatefulWidget {
  final Tiket tiket;
  final TiketService service;

  const DetailTiketPage({
    super.key,
    required this.tiket,
    required this.service,
  });

  @override
  State<DetailTiketPage> createState() => _DetailTiketPageState();
}

class _DetailTiketPageState extends State<DetailTiketPage> {
  bool sedangMemesan = false;
  int jumlahTiket = 1;

  Future<void> prosesPemesanan() async {
    setState(() {
      sedangMemesan = true;
    });

    try {
      final String hasil = await widget.service.pesanTiket(
        widget.tiket,
        jumlah: jumlahTiket,
      );

      if (!mounted) return;

      // SHOW SUCCESS BOTTOM SHEET MODAL
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pemesanan Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                hasil,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close sheet
                    Navigator.pop(
                      context,
                      true,
                    ); // Return to home with refresh flag
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        ),
      );
    } on TiketHabisException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMemesan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool vip = widget.tiket is TiketVIP;
    double hargaSatuan = widget.tiket.harga;

    if (vip) {
      final TiketVIP tiketVip = widget.tiket as TiketVIP;
      hargaSatuan = tiketVip.hitungHargaDiskon(10);
    }

    final double totalHarga = hargaSatuan * jumlahTiket;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Detail Pemesanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER HERO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    vip ? Icons.workspace_premium : Icons.train,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.tiket.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kode ID: ${widget.tiket.id}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ROUTE TIMELINE CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Rute & Jadwal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.tiket.rute,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        color: Color(0xFF1E40AF),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Jam: ${widget.tiket.jam}',
                        style: const TextStyle(color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QUANTITY SELECTOR
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jumlah Tiket',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Pilih jumlah penumpang',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: jumlahTiket > 1
                            ? () {
                                setState(() {
                                  jumlahTiket--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF1E40AF),
                      ),
                      Text(
                        '$jumlahTiket',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: jumlahTiket < widget.tiket.stok
                            ? () {
                                setState(() {
                                  jumlahTiket++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF1E40AF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FACILITIES CHECKLIST
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fasilitas Tiket',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '• ${widget.tiket.deskripsi()}',
                    style: const TextStyle(color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '• Jaminan Tempat Duduk Terjamin',
                    style: TextStyle(color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '• Gratis Reschedule S&K',
                    style: TextStyle(color: Color(0xFF334155)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  widget.tiket.formatRupiah(totalHarga),
                  style: const TextStyle(
                    color: Color(0xFF1E40AF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: sedangMemesan || widget.tiket.stok <= 0
                  ? null
                  : prosesPemesanan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: sedangMemesan
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Konfirmasi Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COUNTDOWN WIDGET (FLASH SALE)
// ============================================================

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Stream<int> countdown;

  @override
  void initState() {
    super.initState();
    countdown = Stream.periodic(
      const Duration(seconds: 1),
      (i) => 3600 - i, // 1 jam countdown
    ).take(3601);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: countdown,
      builder: (context, snapshot) {
        int totalSeconds = snapshot.data ?? 3600;
        if (totalSeconds < 0) totalSeconds = 0;

        final int hours = totalSeconds ~/ 3600;
        final int minutes = (totalSeconds % 3600) ~/ 60;
        final int seconds = totalSeconds % 60;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _countTile(hours.toString().padLeft(2, '0'), 'Jam'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                ':',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _countTile(minutes.toString().padLeft(2, '0'), 'Menit'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                ':',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _countTile(seconds.toString().padLeft(2, '0'), 'Detik'),
          ],
        );
      },
    );
  }

  Widget _countTile(String val, String unit) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
