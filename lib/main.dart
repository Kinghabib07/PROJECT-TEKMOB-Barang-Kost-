// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'login_page.dart';
//tes
void main() {
  runApp(const TokoAnakKosApp());
}

class TokoAnakKosApp extends StatelessWidget {
  const TokoAnakKosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Anak Kos',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: const Center(
        child: Text(
          'Selamat datang di Toko Anak Kos!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
