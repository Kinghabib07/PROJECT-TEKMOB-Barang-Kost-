import 'package:flutter/material.dart';
import '../../../services/product_service.dart';
import 'cart_page.dart';        // Pastikan file ini ada
import 'CheckoutPage.dart'; // Pastikan file ini ada
import 'cart_storage.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ProductService().fetchProductDetail(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final product = snapshot.data!;
        final title = product['title'] ?? 'Tanpa Nama';
        final price = product['price']?.toString() ?? '0';
        final image = (product['images'] as List).isNotEmpty
            ? product['images'][0]
            : 'https://via.placeholder.com/150';

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: const Color.fromARGB(255, 88, 0, 0),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Image.network(image, height: 300),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("Rp $price", style: const TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 10),
              Text(product['description'] ?? '', textAlign: TextAlign.justify),
              const SizedBox(height: 30),

              // Tombol Aksi
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                     onPressed: () {
  // Simpan produk ke dalam penyimpanan global CartStorage
  CartStorage.cartItems.add(product);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Produk ditambahkan ke keranjang")),
  );
},

 icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text("Keranjang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutPage(product: product),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text("Beli Sekarang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF843B3B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
