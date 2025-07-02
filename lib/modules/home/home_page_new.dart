import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import 'widgets/detailproduct.dart';
import 'widgets/cart_page.dart';
import 'widgets/modern_search_bar.dart';
import 'widgets/modern_product_card.dart';
import 'widgets/categories_section.dart';
import 'widgets/featured_section.dart';
import '../profile/profile_page.dart';

/// Halaman utama aplikasi yang menampilkan daftar produk
/// dengan desain modern dan modular
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future untuk mengambil data produk dari API
  late Future<List<dynamic>> futureProducts;
  
  // List untuk menyimpan semua produk yang diambil dari API
  List<dynamic> allProducts = [];
  
  // List untuk menyimpan produk yang sudah difilter berdasarkan pencarian
  List<dynamic> filteredProducts = [];
  
  // Controller untuk input field pencarian
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi pengambilan data produk saat widget pertama kali dibuat
    _initializeProducts();
  }

  /// Menginisialisasi pengambilan data produk dari API
  void _initializeProducts() {
    futureProducts = ProductService().fetchAllProducts();
    futureProducts.then((products) {
      setState(() {
        allProducts = products;
        filteredProducts = products; // Tampilkan semua produk di awal
      });
    }).catchError((error) {
      // Log error untuk debugging
      debugPrint('Gagal memuat produk: $error');
    });
  }

  /// Melakukan pencarian produk berdasarkan nama
  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts.where((product) {
          final productName = (product['nama'] ?? '').toString().toLowerCase();
          return productName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    // Membersihkan controller untuk mencegah memory leak
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background modern
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          _initializeProducts();
        },
        color: const Color(0xFF8C2B2B),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Search bar modular
              ModernSearchBar(
                controller: searchController,
                onChanged: _performSearch,
              ),
              
              const SizedBox(height: 24),
              
              // Categories horizontal scroll modular
              const CategoriesSection(),
              
              const SizedBox(height: 24),
              
              // Featured section modular
              const FeaturedSection(),
              
              const SizedBox(height: 24),
              
              // Products section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8C2B2B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Produk Terbaru",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement see all
                          },
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              color: Color(0xFF8C2B2B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Products grid
                    FutureBuilder<List<dynamic>>(
                      future: futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingGrid();
                        } else if (snapshot.hasError) {
                          return _buildErrorWidget(snapshot.error.toString());
                        } else {
                          return _buildProductGrid();
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Membuat widget untuk menampilkan pesan error
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Terjadi kesalahan:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _initializeProducts(); // Coba muat ulang data
              });
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  /// Membuat AppBar dengan desain modern dan gradient
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 120,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8C2B2B),
              Color(0xFFB83A3A),
              Color(0xFF8C2B2B),
            ],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF8C2B2B),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                // Profile section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Greeting dengan animasi
                      Row(
                        children: [
                          const Text(
                            "Hai, Anak Kos! ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "👋",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Subtitle dengan efek
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "🛍️ Temukan barang berkualitas dengan harga terjangkau",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Profile avatar dengan ring
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.yellow],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // Status online indicator
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membuat bottom navigation bar dengan desain modern
  Widget _buildBottomNavigationBar() {
   return Container(
     decoration: BoxDecoration(
       gradient: const LinearGradient(
         colors: [Color(0xFF8C2B2B), Color(0xFFB83A3A)],
       ),
       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
       boxShadow: [
         BoxShadow(
           color: Colors.black.withOpacity(0.1),
           blurRadius: 10,
           offset: const Offset(0, -5),
         ),
       ],
     ),
     child: ClipRRect(
       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
       child: BottomNavigationBar(
         currentIndex: 0,
         selectedItemColor: Colors.white,
         unselectedItemColor: Colors.white60,
         backgroundColor: Colors.transparent,
         elevation: 0,
         type: BottomNavigationBarType.fixed,
         selectedFontSize: 12,
         unselectedFontSize: 11,
         
         onTap: (index) {
           _handleBottomNavigationTap(index);
         },
         
         items: const [
           BottomNavigationBarItem(
             icon: Icon(Icons.home_outlined),
             activeIcon: Icon(Icons.home),
             label: 'Beranda',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.shopping_bag_outlined),
             activeIcon: Icon(Icons.shopping_bag),
             label: 'Keranjang',
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person_outline),
             activeIcon: Icon(Icons.person),
             label: 'Profil',
           ),
         ],
       ),
     ),
   );
 }

  /// Handle tap pada bottom navigation bar
  void _handleBottomNavigationTap(int index) {
    switch (index) {
      case 0:
        // Sudah di halaman home, tidak perlu navigasi
        break;
      case 1:
        // Navigasi ke halaman keranjang
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CartPage(),
          ),
        );
        break;
      case 2:
        // Navigasi ke halaman profil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
        break;
    }
  }

  /// Membuat loading grid dengan shimmer effect
  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8C2B2B)),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Price placeholder
                    Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Membuat grid produk menggunakan ModernProductCard
  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty && searchController.text.isNotEmpty) {
      return _buildEmptySearchResult();
    } else if (filteredProducts.isEmpty) {
      return _buildNoProductsFound();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ModernProductCard(
          title: product['nama'] ?? 'Tanpa Nama',
          price: 'Rp ${product['harga'] ?? 0}',
          imagePath: product['gambar'] ?? 'https://via.placeholder.com/150',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  productId: product['id'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Membuat widget untuk hasil pencarian kosong
  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada produk yang cocok',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba gunakan kata kunci yang berbeda',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// Membuat widget untuk kondisi tidak ada produk sama sekali
  Widget _buildNoProductsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada produk tersedia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
