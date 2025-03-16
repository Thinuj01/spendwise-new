import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spendwise/models/transaction_model.dart';
import 'package:intl/intl.dart';

class RecentPageTile extends StatelessWidget {
  final TransactionModel transaction;
  final Function(BuildContext) deleteFunction;
  const RecentPageTile(
      {super.key, required this.transaction, required this.deleteFunction});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Delete",
          style: TextStyle(
              color: Color(0xFF272973),
              fontFamily: 'Jura',
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete this transaction?",
          style: TextStyle(
            color: Color(0xFF272973),
            fontFamily: 'Jura',
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: Color(0xFF272973),
                  fontFamily: 'Jura',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              deleteFunction(context); // Proceed with deletion
            },
            child: Text(
              "Delete",
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Jura',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          CustomSlidableAction(
            onPressed: (context) => _confirmDelete(context),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ]),
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
                    "Rs ${transaction.amount.toString()}0",
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
      ),
    );
  }
}
