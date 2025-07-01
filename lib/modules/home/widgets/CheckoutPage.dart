import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  void _submitPayment() {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        paymentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua kolom.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Logika kirim pembayaran bisa ditambahkan di sini (misalnya simpan ke database / API)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pembayaran untuk ${widget.product['title']} berhasil.'),
        backgroundColor: Colors.green,
      ),
    );

    // Kembali ke halaman sebelumnya atau ke home
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.product['title'] ?? 'Produk';
    final price = widget.product['price']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pembayaran'),
        backgroundColor: const Color(0xFF843B3B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produk: $title', style: const TextStyle(fontSize: 16)),
            Text('Harga: Rp $price',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: paymentController,
              decoration: const InputDecoration(
                labelText: 'Metode Pembayaran (e.g. COD, Transfer, e-Wallet)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF843B3B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
