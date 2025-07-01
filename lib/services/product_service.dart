// lib/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  // Ganti dengan base URL Platzi Fake Store API untuk produk
  final String _baseUrl = 'https://api.escuelajs.co/api/v1/products';
  final String _categoriesUrl = 'https://api.escuelajs.co/api/v1/categories';

  /// Ambil semua produk dari Platzi Fake Store API
  /// Mendukung pagination (limit dan offset)
  /// Default: limit 20, offset 0
  Future<List<dynamic>> fetchAllProducts({int limit = 1000, int offset = 0}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$limit&offset=$offset'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data; // Platzi API langsung mengembalikan list produk
      } else {
        throw Exception('Gagal memuat produk dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke Platzi Fake Store API: $e');
    }
  }

  /// Ambil produk berdasarkan ID kategori
  /// [categoryId] : ID kategori produk yang ingin diambil
  /// Mendukung pagination (limit dan offset)
  Future<List<dynamic>> fetchProductsByCategory(int categoryId, {int limit = 1000, int offset = 0}) async {
    try {
      // Platzi API: 'products' endpoint juga bisa difilter berdasarkan 'categoryId'
      final response = await http.get(Uri.parse('$_baseUrl/?categoryId=$categoryId&limit=$limit&offset=$offset'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Gagal memuat produk berdasarkan kategori dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke Platzi Fake Store API berdasarkan kategori: $e');
    }
  }

  /// Ambil detail produk berdasarkan ID dari Platzi Fake Store API
  /// [id] : ID produk yang ingin diambil
  Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data; // Langsung mengembalikan objek produk
      } else {
        throw Exception('Gagal memuat detail produk dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke Platzi Fake Store API untuk detail produk: $e');
    }
  }

  /// Ambil semua kategori dari Platzi Fake Store API
  Future<List<dynamic>> fetchAllCategories() async {
    try {
      final response = await http.get(Uri.parse(_categoriesUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Gagal memuat kategori dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke Platzi Fake Store API untuk kategori: $e');
    }
  }

  /// Mencari produk berdasarkan judul (nama)
  /// [title] : Kata kunci pencarian judul produk
  /// [limit] : Jumlah produk yang ingin diambil per halaman
  /// [offset] : Jumlah produk yang ingin dilewati (offset)
  Future<List<dynamic>> searchProductsByTitle(String title, {int limit = 1000, int offset = 0}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?title=$title&limit=$limit&offset=$offset'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Gagal mencari produk dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke Platzi Fake Store API untuk pencarian: $e');
    }
  }
}