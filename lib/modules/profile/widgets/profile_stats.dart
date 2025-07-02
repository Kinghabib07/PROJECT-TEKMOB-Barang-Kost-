import 'package:flutter/material.dart';

/// Widget untuk menampilkan statistik pengguna dalam bentuk kartu-kartu menarik
class ProfileStats extends StatelessWidget {
  final Map<String, int> userStats;

  const ProfileStats({
    super.key,
    required this.userStats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        
        // Grid statistik
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildStatCard(
              icon: Icons.shopping_cart_outlined,
              title: 'Total Pesanan',
              value: userStats['totalOrders']?.toString() ?? '0',
              color: Colors.blue,
              gradient: [Colors.blue.shade400, Colors.blue.shade600],
            ),
            _buildStatCard(
              icon: Icons.savings_outlined,
              title: 'Total Hemat',
              value: _formatCurrency(userStats['totalSaved'] ?? 0),
              color: Colors.green,
              gradient: [Colors.green.shade400, Colors.green.shade600],
            ),
            _buildStatCard(
              icon: Icons.favorite_outline,
              title: 'Favorit',
              value: userStats['favoriteItems']?.toString() ?? '0',
              color: Colors.red,
              gradient: [Colors.red.shade400, Colors.red.shade600],
            ),
            _buildStatCard(
              icon: Icons.star_outline,
              title: 'Review Diberikan',
              value: userStats['reviewsGiven']?.toString() ?? '0',
              color: Colors.orange,
              gradient: [Colors.orange.shade400, Colors.orange.shade600],
            ),
          ],
        ),
      ],
    );
  }

  /// Membuat kartu statistik individual
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Implementasi navigasi ke detail statistik
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon dengan background circle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Nilai statistik
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 4),
                
                // Judul statistik
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Memformat nilai mata uang
  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      double millions = amount / 1000000;
      return '${millions.toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      double thousands = amount / 1000;
      return '${thousands.toStringAsFixed(0)}K';
    } else {
      return amount.toString();
    }
  }
}
