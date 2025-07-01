import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import 'widgets/detailproduct.dart';
import 'widgets/cart_page.dart'; // Pastikan file ini ada

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> futureProducts;
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    futureProducts = ProductService().fetchAllProducts();
    futureProducts.then((products) {
      setState(() {
        allProducts = products;
        filteredProducts = products;
      });
    }).catchError((error) {
      print('Gagal memuat produk: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          const Text(
            "Produk Terbaru",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<dynamic>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              } else {
                return _buildProductList();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF8C2B2B),
      elevation: 0,
      toolbarHeight: 100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      title: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hai, Anak Kos!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Cari barang bekas favoritmu di sini",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF8C2B2B), size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(255, 119, 119, 119).withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            filteredProducts = allProducts.where((product) {
              final title = product['title']?.toString().toLowerCase() ?? '';
              final query = value.toLowerCase();
              return title.contains(query);
            }).toList();
          });
        },
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Cari produk...',
          border: InputBorder.none,
        ),
      ),
    );
  }

 Widget _buildProductList() {
  // Cek jika filteredProducts kosong setelah pencarian
  if (filteredProducts.isEmpty && searchController.text.isNotEmpty) {
    return const Center(child: Text('Tidak ada produk yang cocok dengan pencarian Anda.'));
  } else if (filteredProducts.isEmpty) {
    // Jika filteredProducts kosong dan tidak ada input search, berarti tidak ada produk sama sekali
    return const Center(child: Text('Tidak ada produk ditemukan.'));
  }

  return Wrap(
    spacing: 16,
    runSpacing: 16,
    children: filteredProducts.map((product) {
      // Pastikan casting aman dan null-safe
      final String title = product['title']?.toString() ?? 'Tanpa Nama';
      final double priceValue = (product['price'] as num?)?.toDouble() ?? 0.0;
      final String formattedPrice = _formatPriceSimple(priceValue); // Gunakan fungsi format harga

      // Mengambil gambar pertama dari array 'images'
      final String imagePath = (product['images'] != null && product['images'] is List && (product['images'] as List).isNotEmpty)
          ? (product['images'] as List)[0].toString() // Pastikan elemennya juga di-cast ke String
          : 'https://via.placeholder.com/150';

      // --- Perbaikan Utama: Ambil ID produk ---
      final int productId = product['id'] as int? ?? 0; // Pastikan ID ada dan bertipe int
      // --- Akhir Perbaikan Utama ---

      return ProductCard(
        title: title,
        price: "Rp $formattedPrice", // Tambahkan "Rp" di sini
        imagePath: imagePath,
        onTap: () {
          // --- Perbaikan Utama: Teruskan ID produk ke ProductDetailPage ---
          Navigator.push(
            context,
            MaterialPageRoute(
              // Pastikan ProductDetailPage Anda sudah disesuaikan untuk menerima `productId`
              // seperti yang kita bahas sebelumnya.
              builder: (_) => ProductDetailPage(productId: productId),
            ),
          );
          // --- Akhir Perbaikan Utama ---
        },
      );
    }).toList(),
  );
}

  Widget _buildBottomNavigationBar() {
   return BottomNavigationBar(
    currentIndex: 0,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
    backgroundColor: const Color(0xFF843B3B),
    onTap: (index) {
      if (index == 1) {
        // Tombol tengah, arahkan ke CartPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CartPage(products: []), // Kirim data produk jika perlu
          ),
        );
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.storefront), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
    ],
  );
}
}

String _formatPriceSimple(double price) {
  return price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
}
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(price, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
