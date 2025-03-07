import 'package:flutter/material.dart';
import 'package:merchantfe/screens/splash_screen_2.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SplashScreen2(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1357A6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/images/merchantlogo.png', width: 450),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, bottom: 100),
            child: Text(
              "PT Bank Mandiri (Persero) Tbk. berizin dan diawasi oleh Otoritas Jasa Keuangan (OJK) dan Bank Indonesia (BI), serta merupakan peserta penjaminan Lembaga Penjamin Simpanan (LPS).",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
