import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/models/transaction_model.dart';

// ignore: must_be_immutable
class StatisticPage extends StatefulWidget {
  StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final _myBox = Hive.box("transactions");
  List<TransactionModel> transactions = [];
  Map<String, double> incomeDataMap = {};
  Map<String, double> expenseDataMap = {};

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
    if (Hive.isBoxOpen('transactions')) {
      setState(() {
        transactions = _myBox.values.cast<TransactionModel>().toList();
        transactions.sort((a, b) => b.date.compareTo(a.date));
        filterIncomeTransactions();
        filterExpenseTransactions();
      });
    }
  }

  void filterIncomeTransactions() {
    incomeDataMap.clear();
    for (var transaction in transactions) {
      if (transaction.inIncome) {
        if (incomeDataMap.containsKey(transaction.category)) {
          incomeDataMap[transaction.category] =
              incomeDataMap[transaction.category]! + transaction.amount;
        } else {
          incomeDataMap[transaction.category] = transaction.amount;
        }
      }
    }
  }

  void filterExpenseTransactions() {
    expenseDataMap.clear();
    for (var transaction in transactions) {
      if (!transaction.inIncome) {
        if (expenseDataMap.containsKey(transaction.category)) {
          expenseDataMap[transaction.category] =
              expenseDataMap[transaction.category]! + transaction.amount;
        } else {
          expenseDataMap[transaction.category] = transaction.amount;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text('Income Chart',
              style: TextStyle(
                  color: Color(0xFF272973),
                  fontFamily: 'Jura',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          incomeDataMap.isNotEmpty
              ? PieChart(
                  dataMap: incomeDataMap,
                  chartRadius: MediaQuery.of(context).size.width / 2.2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                  ),
                )
              : Text("No Income Transactions",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontFamily: 'Jura',
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
          SizedBox(
            height: 50,
          ),
          Text('Expense Chart',
              style: TextStyle(
                  color: Color(0xFF272973),
                  fontFamily: 'Jura',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          expenseDataMap.isNotEmpty
              ? PieChart(
                  dataMap: expenseDataMap,
                  chartRadius: MediaQuery.of(context).size.width / 2.2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                  ),
                )
              : Text("No Expense Transactions",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontFamily: 'Jura',
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
