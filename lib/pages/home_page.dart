import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/components/bottom_nav_bar.dart';
import 'package:spendwise/components/transaction_box.dart';
import 'package:spendwise/pages/insight_page.dart';
import 'package:spendwise/pages/recent_page.dart';
import 'package:spendwise/pages/statistic_page.dart';

import '../models/transaction_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Key _insightPageKey = UniqueKey(); // Unique key to force rebuild

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void createNewTransaction() async {
    bool? shouldRefresh = await showDialog(
      context: context,
      builder: (context) => TransactionBox(),
    );

    if (shouldRefresh == true) {
      setState(() {
        _insightPageKey = UniqueKey(); // Change key to rebuild InsightPage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      InsightPage(key: _insightPageKey), // Assign key here
      const StatisticPage(),
      RecentPage()
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF272973),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: createNewTransaction,
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: IconButton(
                onPressed: Scaffold.of(context).openDrawer,
                icon: Icon(Icons.menu, color: Color(0xFF272973)),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF272973),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset('lib/images/logo white.png', height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 40),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text("Home",
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Jura')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.white),
                    title: Text("About",
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Jura')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Updated list with a dynamic key
    );
  }
}
