import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  /// Judul produk
  final String title;

  /// Harga dalam format string ("Rp xxx.xxx")
  final String price;

  /// URL gambar produk
  final String imagePath;

  /// Callback saat card ditekan
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
    // Hitung lebar kartu berdasarkan ukuran layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 48) / 2; // 16 padding kiri-kanan + 16 spacing antar kartu

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
