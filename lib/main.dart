// ignore_for_file: depend_on_referenced_packages

// routing pada aplikasi

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';  // DISABLED FOR DEMO
// import 'firebase_options.dart';  // DISABLED FOR DEMO
import 'services/cart_service.dart';
import 'services/auth_service.dart';
// import 'widgets/auth_wrapper.dart';  // DISABLED FOR DEMO
import 'modules/auth/login_page.dart';
import 'modules/home/home_page.dart';
import 'modules/home/widgets/detailproduct.dart'; 
 // jika ada file lain untuk detail

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TEMPORARILY DISABLE Firebase until proper configuration
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('✅ Firebase initialized successfully');
  // } catch (e) {
  //   print('❌ Firebase initialization failed: $e');
  // }
  
  runApp(const TokoAnakKosApp());
}

class TokoAnakKosApp extends StatelessWidget {
  const TokoAnakKosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Toko Anak Kos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: const Color(0xFFFDFDFD),
          useMaterial3: true,
        ),
        // Use Login page directly for demo mode
        home: const LoginScreen(),
        // Daftar route
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomePage(),
          '/detail': (context) => const ProductDetailPage(productId: 1),
        },
      ),
    );
  }
}
