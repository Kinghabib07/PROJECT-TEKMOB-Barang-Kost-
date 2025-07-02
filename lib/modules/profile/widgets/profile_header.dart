import 'package:flutter/material.dart';

/// Widget header profil yang menampilkan foto, nama, dan informasi dasar pengguna
class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeader({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture dengan border dan badge
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8C2B2B),
                      const Color(0xFF6B1F1F),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage(
                      userData['profileImage'] ?? 
                      'https://via.placeholder.com/150/8C2B2B/FFFFFF?text=AK',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint('Error loading profile image: $exception');
                    },
                    child: userData['profileImage'] == null
                        ? Text(
                            _getInitials(userData['name'] ?? 'AK'),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              
              // Verified badge
              if (userData['isVerified'] == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade500,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // User Name
          Text(
            userData['name'] ?? 'Nama Pengguna',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // University
          if (userData['university'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8C2B2B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF8C2B2B).withOpacity(0.3),
                ),
              ),
              child: Text(
                userData['university'],
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF8C2B2B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Contact Information
          Column(
            children: [
              _buildContactItem(
                Icons.email_outlined,
                userData['email'] ?? 'email@domain.com',
              ),
              const SizedBox(height: 8),
              _buildContactItem(
                Icons.phone_outlined,
                userData['phone'] ?? '+62 xxx-xxxx-xxxx',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Member since
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bergabung sejak ${_formatJoinDate(userData['joinDate'])}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membuat item kontak dengan icon dan teks
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Mendapatkan inisial dari nama pengguna
  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0].substring(0, 2).toUpperCase();
    }
    return 'AK';
  }

  /// Memformat tanggal bergabung
  String _formatJoinDate(String? joinDate) {
    if (joinDate == null) return 'Tidak diketahui';
    
    try {
      DateTime date = DateTime.parse(joinDate);
      List<String> months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Tidak diketahui';
    }
  }
}
