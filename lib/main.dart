// ignore_for_file: depend_on_referenced_packages

// routing pada aplikasi


import 'package:flutter/material.dart';
// import 'modules/auth/login_page.dart';
import 'modules/home/home_page.dart';
import 'modules/home/widgets/detailproduct.dart'; 
 // jika ada file lain untuk detail

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
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        useMaterial3: true,
      ),
      // Routing awal
      initialRoute: '/',
      // Daftar route
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const ProductDetailPage(productId: 1),

         // jika ada file dengan nama ini
      },
    );
  }
}
