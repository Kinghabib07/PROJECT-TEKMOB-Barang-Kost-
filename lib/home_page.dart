// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'Detail.product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C2B2B),
        elevation: 0,
        toolbarHeight: 120,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Hai, Anak Kos!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
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
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF8C2B2B), size: 32),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Category
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryItem(title: 'Pakaian', icon: Icons.checkroom),
                CategoryItem(title: 'Sepatu', icon: Icons.directions_run),
                CategoryItem(title: 'Tas', icon: Icons.work_outline),
                CategoryItem(title: 'Jam', icon: Icons.watch),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Terbaru Terbaru",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Products
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ProductCard(
                title: "Kaos Erigo Bekas",
                price: "Rp100.000",
                imagePath: "assets/erigo.jpg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const ProductDetailPage(
                            productName: "Kaos Erigo Bekas",
                          ),
                    ),
                  );
                },
              ),
              ProductCard(
                title: "Sepatu Compas",
                price: "Rp150.000",
                imagePath: "assets/sepatu.Hitam.jpg",
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
              ProductCard(
                title: "Tas Ori Second",
                price: "Rp300.000",
                imagePath: "assets/tas.jpg",
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
              ProductCard(
                title: "Jam Casio Like New",
                price: "Rp200.000",
                imagePath: "assets/jam.jpg",
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF8C2B2B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const CategoryItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.black),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
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
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Terbaru",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 6,
                  right: 6,
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text("☆☆☆☆☆ (0)", style: TextStyle(fontSize: 12)),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(price, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
