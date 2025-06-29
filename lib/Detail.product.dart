import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  const ProductDetailPage({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF843B3B),
        elevation: 0,
        title: Text(
          productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                _getImageForProduct(productName),
                height: 160,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Kaos Erigo Bekas",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Rp100.000",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text("Warna", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children:
                  [
                    Colors.white,
                    Colors.black,
                    Colors.blue,
                    Color(0xFFA0522D),
                  ].map((color) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(backgroundColor: color, radius: 15),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Model:\nTinggi 185-186 cm\nBerat 75 kg\nUkuran XL\n*Toleransi setiap size 1-2 cm*",
            ),
            const SizedBox(height: 10),
            const Text(
              "Detail Produk",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF843B3B),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF3EAEA),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check, color: Color(0xFF843B3B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Bahan: Katun Combed 30s",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, color: Color(0xFF843B3B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Kondisi: 90% mulus, tanpa cacat",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, color: Color(0xFF843B3B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Ukuran: XL (Lebar dada 55cm, Panjang 74cm)",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, color: Color(0xFF843B3B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Bonus: Stiker Erigo original",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur pembelian belum tersedia'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF843B3B),
                minimumSize: const Size(double.infinity, 50),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Beli Sekarang",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Color(0xFF843B3B)),
            const SizedBox(height: 20),
            // Produk Lainnya
            const Text(
              "Produk Lainnya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF843B3B),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _OtherProductCard(
                  title: "Sepatu Compas",
                  imageUrl: "assets/sepatu.hitam.jpg",
                  price: "Rp150.000",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const ProductDetailPage(
                              productName: "Sepatu Compas",
                            ),
                      ),
                    );
                  },
                ),
                _OtherProductCard(
                  title: "Tas Ori Second",
                  imageUrl: "assets/tas.jpg",
                  price: "Rp300.000",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const ProductDetailPage(
                              productName: "Tas Ori Second",
                            ),
                      ),
                    );
                  },
                ),
                _OtherProductCard(
                  title: "Jam Casio Like New",
                  imageUrl: "assets/Jam.Hitam.jpg",
                  price: "Rp200.000",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const ProductDetailPage(
                              productName: "Jam Casio Like New",
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Card produk lain (mini)
class _OtherProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final VoidCallback onTap;
  const _OtherProductCard({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imageUrl,
                height: 40,
                width: 80,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 40,
                      width: 80,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
