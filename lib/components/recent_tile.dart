import 'package:flutter/material.dart';
import 'package:spendwise/models/transaction_model.dart';

class RecentTile extends StatelessWidget {
  final TransactionModel transaction;
  const RecentTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              transaction.inIncome ? Icons.trending_up : Icons.trending_down,
              color: transaction.inIncome ? Colors.green : Colors.red,
            ),
            Text(
              transaction.category,
              style: TextStyle(
                  color: Color(0xFF272973), fontFamily: 'Jura', fontSize: 15),
            ),
            Text(
              "Rs ${transaction.amount.toString()}0",
              style: TextStyle(
                  color: Color(0xFF272973),
                  fontFamily: 'Jura',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
