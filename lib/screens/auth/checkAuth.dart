import 'package:denta_incomes/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay to show the splash
    await Future.delayed(const Duration(seconds: 1));
    
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (isLoggedIn) {
      // Try to refresh token to ensure it's still valid
      try {
        await AuthService.getRefreshToken();
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Token refresh failed, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.local_hospital,
                color: Color(0xFF4F46E5),
                size: 50,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Dental Incomes',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}