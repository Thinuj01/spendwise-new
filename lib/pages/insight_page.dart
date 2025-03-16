import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/components/recent_tile.dart';
import 'package:spendwise/models/transaction_model.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  final _myBox = Hive.box("transactions");
  List<dynamic> transactions = [];
  double _mainBalance = 0;

  @override
  void initState() {
    super.initState();
    loadTransactions();
    generatingMainBalance();
  }

  void loadTransactions() {
    if (Hive.isBoxOpen('transactions')) {
      setState(() {
        transactions = _myBox.values.toList();

        transactions.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void generatingMainBalance() {
    for (TransactionModel transaction in transactions) {
      if (transaction.inIncome) {
        setState(() {
          _mainBalance = _mainBalance + transaction.amount;
        });
      } else {
        setState(() {
          _mainBalance = _mainBalance - transaction.amount;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.all(20),
                    width: 325,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xFF272973)),
                        color: Color(0xFF272973),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text(
                          'Wallet Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jura',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Rs ${_mainBalance.toString()}0",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Jura',
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Icon(
                    Icons.history,
                    color: Color(0xFF272973),
                    size: 40,
                  ),
                  Text(
                    "Recent Income & Expenses",
                    style: TextStyle(
                        fontFamily: 'Jura',
                        color: Color(0xFF272973),
                        fontSize: 15),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: transactions.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Prevents conflicts
                            itemCount: transactions.length >= 4
                                ? 4
                                : transactions.length,
                            itemBuilder: (context, index) {
                              TransactionModel transaction =
                                  transactions[index];
                              return RecentTile(
                                transaction: transaction,
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
                  SizedBox(height: 75)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
