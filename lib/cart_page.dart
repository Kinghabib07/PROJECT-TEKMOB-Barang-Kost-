import 'package:flutter/material.dart';
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  final List<String> products;
  const CartPage({super.key, this.products = const []});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.generate(widget.products.length, (index) => false);
  }

  String _getImageForProduct(String name) {
    switch (name) {
      case 'Kaos Erigo Bekas':
        return 'assets/erigo.jpg';
      case 'Sepatu Compas':
        return 'assets/sepatu.hitam.jpg';
      case 'Tas Ori Second':
        return 'assets/tas.jpg';
      case 'Jam Casio Like New':
        return 'assets/Jam.Hitam.jpg';
      default:
        return 'assets/erigo.jpg';
    }
  }

  String _getPriceForProduct(String name) {
    switch (name) {
      case 'Kaos Erigo Bekas':
        return '100.000';
      case 'Sepatu Compas':
        return '250.000';
      case 'Tas Ori Second':
        return '150.000';
      case 'Jam Casio Like New':
        return '200.000';
      default:
        return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasProducts = widget.products.isNotEmpty;
    final hasChecked = checked.any((c) => c);
    int total = 0;
    for (int i = 0; i < widget.products.length; i++) {
      if (checked[i]) {
        total += int.tryParse(_getPriceForProduct(widget.products[i]).replaceAll('.', '')) ?? 0;
      }
    }
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
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
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
                              child: Image.asset(
                                _getImageForProduct(widget.products[index]),
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
                                            widget.products[index],
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
                                    Text(
                                      'Rp${_getPriceForProduct(widget.products[index])}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[400]!),
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove, size: 16),
                                                onPressed: () {},
                                              ),
                                              const Text('1', style: TextStyle(fontSize: 13)),
                                              IconButton(
                                                icon: const Icon(Icons.add, size: 16),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                            Text('Rp${total.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: hasChecked
                            ? () {
                                final checkedProducts = <Map<String, String>>[];
                                for (int i = 0; i < widget.products.length; i++) {
                                  if (checked[i]) {
                                    checkedProducts.add({
                                      'name': widget.products[i],
                                      'image': _getImageForProduct(widget.products[i]),
                                      'price': _getPriceForProduct(widget.products[i]),
                                    });
                                  }
                                }
                                if (checkedProducts.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentPage(products: checkedProducts),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF843B3B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.home, color: Colors.white),
                      Icon(Icons.shopping_cart, color: Colors.white),
                      Icon(Icons.person, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            )
          : const Center(
              child: Text(
                'Keranjang Anda masih kosong',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
