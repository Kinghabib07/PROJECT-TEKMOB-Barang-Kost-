import 'package:flutter/material.dart';
import '../../../services/cart_service.dart';
import 'cart_item_widget.dart';
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartService _cartService;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showRemoveConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini dari keranjang?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _cartService.removeFromCart(productId);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final products = _cartService.cartItems;
    final bool hasProducts = products.isNotEmpty;
    final bool hasChecked = _cartService.selectedItemCount > 0;
    final int total = _cartService.getTotalPrice();

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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final productId = product['id']?.toString() ?? index.toString();
                      final isChecked = _cartService.checkedItems[productId] ?? true;

                      return CartItemWidget(
                        product: product,
                        isChecked: isChecked,
                        onToggleCheck: () {
                          _cartService.toggleItemCheck(productId);
                        },
                        onRemove: () {
                          _showRemoveConfirmation(context, productId);
                        },
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
                            Text('Rp${_formatPrice(total)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: hasChecked
                            ? () {
                                final selectedProducts = _cartService.getSelectedItems();
                                if (selectedProducts.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentPage(products: selectedProducts),
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
