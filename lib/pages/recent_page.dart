import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/components/recent_page_tile.dart';
import 'package:spendwise/components/recent_tile.dart';
import 'package:spendwise/models/transaction_model.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final _myBox = Hive.box("transactions");
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
    if (Hive.isBoxOpen('transactions')) {
      setState(() {
        transactions = _myBox.values.toList();
        transactions.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            // Allows the ListView to take available space and be scrollable
            child: transactions.length > 0
                ? ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      TransactionModel _transaction = transactions[index];
                      return RecentPageTile(
                        transaction: _transaction,
                      );
                    })
                : Text(
                    "No Transactions made yet.",
                    style: TextStyle(
                        fontFamily: 'Jura',
                        color: Color(0xFF272973),
                        fontSize: 15),
                  ),
          ),
        ],
      ),
    );
  }
}
