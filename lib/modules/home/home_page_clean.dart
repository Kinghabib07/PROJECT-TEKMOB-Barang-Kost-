import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import 'widgets/modern_search_bar.dart';
import 'widgets/categories_section.dart';
import 'widgets/featured_section.dart';
import 'widgets/modern_app_bar.dart';
import 'widgets/modern_bottom_navigation.dart';
import 'widgets/product_grid_section.dart';

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
      appBar: const ModernAppBar(),
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
              
              // Products section modular
              FutureBuilder<List<dynamic>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  return ProductGridSection(
                    products: filteredProducts,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                    error: snapshot.hasError ? snapshot.error.toString() : null,
                    onRetry: () {
                      setState(() {
                        _initializeProducts();
                      });
                    },
                  );
                },
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ModernBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation in the widget itself
        },
      ),
    );
  }
}
