import 'package:flutter/material.dart';
import 'package:spendwise/models/transaction_model.dart';
import 'package:intl/intl.dart';

class RecentPageTile extends StatelessWidget {
  TransactionModel transaction;
  RecentPageTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(transaction.date),
                  style: TextStyle(
                      fontFamily: 'Jura',
                      fontSize: 12,
                      color: Color(0xFF272973)),
                ),
                Text(
                  DateFormat('hh:mm a').format(transaction.date),
                  style: TextStyle(
                      fontFamily: 'Jura',
                      fontSize: 12,
                      color: Color(0xFF272973)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  transaction.inIncome
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: transaction.inIncome ? Colors.green : Colors.red,
                ),
                Text(
                  transaction.category,
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontFamily: 'Jura',
                      fontSize: 15),
                ),
                Text(
                  transaction.amount.toString(),
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontFamily: 'Jura',
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
