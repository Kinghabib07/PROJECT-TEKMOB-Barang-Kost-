import 'package:flutter/material.dart';

/// Widget untuk menampilkan section promo dan featured content
class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Promo Spesial",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200, // Increased height
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8C2B2B),
                Color(0xFFB83A3A),
                Color(0xFF8C2B2B),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8C2B2B).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Content with Flexible sizing
              Padding(
                padding: const EdgeInsets.all(20), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Important!
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "🔥 HOT DEAL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Slightly smaller
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced spacing
                    const Flexible( // Wrap with Flexible
                      child: Text(
                        "Diskon Hingga 70%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22, // Slightly smaller
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    const Flexible( // Wrap with Flexible
                      child: Text(
                        "Untuk semua kategori produk pilihan\nkhusus anak kos!",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13, // Slightly smaller
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12), // Reduced spacing
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to promo page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Halaman promo akan segera hadir!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8C2B2B),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: const Size(0, 36), // Set minimum height
                      ),
                      child: const Text(
                        "Lihat Promo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13, // Slightly smaller
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
