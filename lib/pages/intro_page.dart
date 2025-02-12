import 'package:flutter/material.dart';
import 'package:spendwise/pages/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/logo y.png',
              height: 130,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Spend Wise",
              style: TextStyle(
                  fontFamily: 'Jura',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF272973)),
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              'Take Control of Your Finances with SpendWise!',
              style: TextStyle(
                fontFamily: 'Jura',
                fontSize: 15,
                color: Color(0xFF272973),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  )),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                    color: Color(0xFF272973),
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(15),
                child: Text(
                  "Start Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Jura',
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
