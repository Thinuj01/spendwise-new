import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xFF272973),
        backgroundColor: Colors.grey[100],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Image.asset('lib/images/logo y.png', height: 150),
            SizedBox(height: 20),
            Text("SpendWise",
                style: TextStyle(
                    fontFamily: 'Jura',
                    color: Color(0xFF272973),
                    fontSize: 30)),
            SizedBox(height: 5),
            Text("Version 1.0.0",
                style: TextStyle(
                    fontFamily: 'Jura',
                    color: Color(0xFF272973),
                    fontSize: 15)),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                  "SpendWise is your go-to app for managing income and expenses with ease. Track transactions, categorize spending, and gain insights to take control of your finances effortlessly.",
                  style: TextStyle(
                    fontFamily: 'Jura',
                    color: Color(0xFF272973),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
