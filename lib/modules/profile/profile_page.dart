import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_stats.dart';
import 'edit_profile_page.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

/// Halaman profil pengguna dengan desain modern dan fitur lengkap
/// Menampilkan informasi pengguna, statistik, dan menu navigasi
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  // Controller untuk animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Data pengguna yang akan diambil dari Firebase Auth dan Firestore
  Map<String, dynamic> _userData = {
    'name': 'Loading...',
    'email': 'Loading...',
    'phone': '',
    'university': '',
    'joinDate': '',
    'profileImage': 'https://via.placeholder.com/150/8C2B2B/FFFFFF?text=U',
    'isVerified': false,
  };

  // Statistik pengguna
  final Map<String, int> _userStats = {
    'totalOrders': 24,
    'totalSaved': 156000,
    'favoriteItems': 12,
    'reviewsGiven': 8,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  /// Load user data from Firebase
  Future<void> _loadUserData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userData = await authService.getUserData();
      
      if (userData != null && mounted) {
        setState(() {
          _userData = {
            'name': userData['name'] ?? 'User',
            'email': userData['email'] ?? '',
            'phone': userData['phone'] ?? '',
            'university': userData['university'] ?? '',
            'joinDate': userData['createdAt']?.toDate().toString().split(' ')[0] ?? '',
            'profileImage': userData['photoURL'] ?? 'https://via.placeholder.com/150/8C2B2B/FFFFFF?text=${userData['name']?.substring(0, 1) ?? 'U'}',
            'isVerified': authService.currentUser?.emailVerified ?? false,
          };
        });
      } else {
        // Use current user from Firebase Auth if Firestore data is not available
        final currentUser = authService.currentUser;
        if (currentUser != null && mounted) {
          setState(() {
            _userData = {
              'name': currentUser.displayName ?? 'User',
              'email': currentUser.email ?? '',
              'phone': '',
              'university': '',
              'joinDate': currentUser.metadata.creationTime?.toString().split(' ')[0] ?? '',
              'profileImage': currentUser.photoURL ?? 'https://via.placeholder.com/150/8C2B2B/FFFFFF?text=${currentUser.displayName?.substring(0, 1) ?? 'U'}',
              'isVerified': currentUser.emailVerified,
            };
          });
        }
      }
    } catch (e) {
      // Handle error silently or show error message
      debugPrint('Error loading user data: $e');
    }
  }

  /// Inisialisasi animasi untuk entrance effect
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    // Mulai animasi
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildProfileContent(),
            ),
          );
        },
      ),
    );
  }

  /// Membangun konten utama halaman profil
  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center the profile card
                Center(
                  child: ProfileHeader(userData: _userData),
                ),
                const SizedBox(height: 24),
                ProfileStats(userStats: _userStats),
                const SizedBox(height: 24),
                _buildMenuSection(),
                const SizedBox(height: 24),
                _buildLogoutSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Membangun SliverAppBar dengan gradient background
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8C2B2B),
              Color(0xFF6B1F1F),
              Color(0xFF4A1515),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            'Profil Saya',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () => _navigateToEditProfile(),
          tooltip: 'Edit Profil',
        ),
      ],
    );
  }

  /// Membangun section menu navigasi
  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Pesanan Saya',
                subtitle: 'Lihat riwayat pesanan',
                onTap: () => _showComingSoon('Pesanan'),
                showBadge: _userStats['totalOrders']! > 0,
                badgeCount: _userStats['totalOrders']!,
              ),
              
              const Divider(height: 1, indent: 16, endIndent: 16),
              
              ProfileMenuItem(
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                subtitle: 'Produk favorit saya',
                onTap: () => _showComingSoon('Wishlist'),
                showBadge: _userStats['favoriteItems']! > 0,
                badgeCount: _userStats['favoriteItems']!,
              ),
              
              const Divider(height: 1, indent: 16, endIndent: 16),
              
              ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Alamat',
                subtitle: 'Kelola alamat pengiriman',
                onTap: () => _showComingSoon('Alamat'),
              ),
              
              const Divider(height: 1, indent: 16, endIndent: 16),
              
              ProfileMenuItem(
                icon: Icons.payment_outlined,
                title: 'Metode Pembayaran',
                subtitle: 'Kelola pembayaran',
                onTap: () => _showComingSoon('Pembayaran'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Section kedua
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi 1.0.0',
                onTap: () => _showAboutDialog(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Membangun section logout
  Widget _buildLogoutSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
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
          onTap: () => _showLogoutDialog(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Keluar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigasi ke halaman edit profil
  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(userData: _userData),
      ),
    ).then((updatedData) {
      if (updatedData != null) {
        setState(() {
          _userData.addAll(updatedData);
        });
      }
    });
  }

  /// Menampilkan dialog coming soon untuk fitur yang belum tersedia
  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.construction, color: Colors.orange),
              const SizedBox(width: 8),
              Text('$feature Segera Hadir'),
            ],
          ),
          content: Text(
            'Fitur $feature sedang dalam pengembangan dan akan segera tersedia dalam update berikutnya.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Menampilkan dialog tentang aplikasi
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8C2B2B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Tentang Aplikasi'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Toko Anak Kos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplikasi marketplace khusus untuk mahasiswa dan anak kos. '
                'Temukan barang bekas berkualitas dengan harga terjangkau.',
              ),
              const SizedBox(height: 16),
              const Text(
                '© 2025 Toko Anak Kos. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF8C2B2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Menampilkan dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  /// Melakukan proses logout menggunakan Firebase Auth
  void _performLogout() async {
    try {
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      // Logout dari Firebase Auth
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Berhasil keluar dari akun'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        
        // Navigate to login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}