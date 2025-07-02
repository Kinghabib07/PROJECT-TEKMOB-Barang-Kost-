import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  // URL API
  final String _baseUrl = 'https://fakestoreapi.com/products';

  // Fungsi untuk mengambil semua produk dari API
  Future<List<dynamic>> fetchAllProducts() async {
    try {
      // Kirim permintaan GET ke API
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Decode JSON menjadi List
        final List<dynamic> data = json.decode(response.body);
        // Bersihkan setiap data produk
        return data.map((product) => _cleanProductData(product)).toList();
      } else {
        throw Exception('Gagal mengambil data produk. Kode error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Tidak bisa terhubung ke server: $e');
    }
  }

  // Fungsi untuk mengambil detail produk berdasarkan ID dari API
  Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    try {
      // Kirim permintaan GET ke API untuk produk tertentu
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        // Decode JSON menjadi Map
        final Map<String, dynamic> data = json.decode(response.body);
        // Bersihkan data produk
        return _cleanProductData(data);
      } else {
        throw Exception('Gagal mengambil detail produk. Kode error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Tidak bisa terhubung ke server: $e');
    }
  }

  // Fungsi untuk membersihkan dan memvalidasi data produk
  Map<String, dynamic> _cleanProductData(Map<String, dynamic> product) {
    // Ambil gambar dari key 'image' (sesuai struktur API Fake Store)
    String image = product['image'] ?? 'https://via.placeholder.com/300';

    // Safely handle price conversion
    dynamic rawPrice = product['price'];
    double price = 0.0;
    
    if (rawPrice is double) {
      price = rawPrice;
    } else if (rawPrice is int) {
      price = rawPrice.toDouble();
    } else if (rawPrice is String) {
      price = double.tryParse(rawPrice) ?? 0.0;
    }

    return {
      'id': product['id'] ?? 0,
      'nama': (product['title'] ?? 'Produk Tanpa Nama').toString(),
      'kategori': (product['category'] ?? 'Tidak ada kategori').toString(),
      'harga': price,
      'deskripsi': (product['description'] ?? 'Tidak ada deskripsi').toString(),
      'gambar': image,
    };
  }
}