import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../modules/auth/login_page.dart';
import '../modules/home/home_page.dart';

/// Widget yang mengelola routing berdasarkan authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            // Show loading screen while checking auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF893939),
                  ),
                ),
              );
            }

            // If user is signed in, show home page
            if (snapshot.hasData && snapshot.data != null) {
              return const HomePage();
            }

            // If user is not signed in, show login page
            return const LoginScreen();
          },
        );
      },
    );
  }
}
