import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const PaymentPage({super.key, required this.products});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String address = 'Bib';
  String addressDetail = 'Jl. Letkol Iskandar Kec. Ilir Tim. I, Kota Palembang, Sumatera Selatan 30125';
  String phone = '0822 8872 1580';

  void _editAddress() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: address);
        final detailController = TextEditingController(text: addressDetail);
        final phoneController = TextEditingController(text: phone);
        return AlertDialog(
          title: const Text('Edit Alamat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'No. HP'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'detail': detailController.text,
                  'phone': phoneController.text,
                });
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        address = result['name'] ?? address;
        addressDetail = result['detail'] ?? addressDetail;
        phone = result['phone'] ?? phone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var p in widget.products) {
    final dynamic price = p['price'];

    if (price is int) {
      total += price;
    } else if (price is double) {
      total += price.toInt();
    } else if (price is String) {
      total += int.tryParse(price.replaceAll('.', '')) ?? 0;
    }
  }

    int shipping = 5000;
    int grandTotal = total + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Alamat Pengiriman', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _editAddress,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(addressDetail),
                            Text(phone),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Tambahkan alamat pengiriman', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Metode Pengiriman', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Image.asset('assets/gojek.png', width: 24, height: 24, errorBuilder: (c, e, s) => const Icon(Icons.local_shipping)),
                    const SizedBox(width: 8),
                    const Text('Gojek'),
                    const Spacer(),
                    const Text('FREE', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Icon(Icons.expand_more, color: Colors.grey[400]),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Metode pembayaran', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Icon(Icons.radio_button_checked, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Image.asset('assets/dana.png', width: 24, height: 24, errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet)),
                    const SizedBox(width: 8),
                    const Text('Dana'),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.grey)),
                  Text('Rp${total.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}', style: const TextStyle(color: Color(0xFF843B3B), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Biaya Pengiriman', style: TextStyle(color: Colors.grey)),
                  Text('Rp5000', style: TextStyle(color: Color(0xFFFD7E14))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Harga', style: TextStyle(color: Colors.grey)),
                  Text('Rp${grandTotal.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}', style: const TextStyle(color: Color(0xFFFD7E14), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Pembayaran Berhasil'),
                        content: const Text('Terima kasih sudah berbelanja!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF843B3B),
                    shape: const StadiumBorder(),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
