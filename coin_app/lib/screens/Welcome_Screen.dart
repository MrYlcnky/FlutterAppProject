import 'dart:async';
import 'package:flutter/material.dart';
import 'coin_category_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Timer'ı başlatın
    Timer(Duration(seconds: 3), () {
      // Timer bittiğinde Coin Category Screen'e geçiş yapın
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CoinCategoryScreen(),
        ),
      );
    });

    return WillPopScope(
      // Geri tuşunun işlevselliğini kontrol etmek için WillPopScope kullanın
      onWillPop: () async {
        // Geri tuşuna basıldığında işlevsel olmamasını sağlayın
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 48, 46, 46),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'bitcoin.jpg',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome To The ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 204, 14),
                ),
              ),
              Text(
                'Coin Application',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 204, 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
