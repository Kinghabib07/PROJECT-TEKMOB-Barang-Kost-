import 'package:flutter/material.dart';
import 'checkoutpage.dart';
import 'payment_page.dart';

class CartStorage extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const CartStorage({super.key, required this.products});

  @override
  State<CartStorage> createState() => _CartStorageState();
  static List<Map<String, dynamic>> cartItems = [];

  // Optional: method untuk menambah produk ke cart
  static void addToCart(Map<String, dynamic> product) {
    cartItems.add(product);
  }

  // Optional: method untuk menghapus produk dari cart
  static void removeFromCart(Map<String, dynamic> product) {
    cartItems.remove(product);
  }
}

class _CartStorageState extends State<CartStorage> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.generate(widget.products.length, (_) => true);
  }

  int _parsePrice(dynamic price) {
    if (price is int) return price;
    if (price is double) return price.toInt();
    if (price is String) return int.tryParse(price.replaceAll('.', '')) ?? 0;
    return 0;
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (int i = 0; i < widget.products.length; i++) {
      if (checked[i]) {
        total += _parsePrice(widget.products[i]['price']);
      }
    }

    bool hasProducts = widget.products.isNotEmpty;
    bool hasChecked = checked.any((element) => element);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: hasProducts
          ? Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      final String title = product['title'] ?? 'Tanpa Nama';
                      final int price = _parsePrice(product['price']);
                      final String image = (product['images'] is List && product['images'].isNotEmpty)
                          ? product['images'][0]
                          : 'https://via.placeholder.com/150';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.network(
                                image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked[index] = !checked[index];
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: checked[index] ? const Color(0xFF843B3B) : Colors.grey[300],
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: checked[index]
                                                ? const Icon(Icons.check, color: Colors.white, size: 18)
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('pilihan', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Text('Rp${_formatPrice(price)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Harga', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            Text('Rp${_formatPrice(total)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: hasChecked
                            ? () {
                                final selected = <Map<String, dynamic>>[];
                                for (int i = 0; i < widget.products.length; i++) {
                                  if (checked[i]) {
                                    selected.add(widget.products[i]);
                                  }
                                }
                                if (selected.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentPage(products: selected),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF843B3B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          minimumSize: const Size(140, 44),
                        ),
                        child: const Text('Checkout', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            )
          : const Center(
              child: Text('Keranjang Anda masih kosong', style: TextStyle(fontSize: 18)),
            ),
    );
  }
}
