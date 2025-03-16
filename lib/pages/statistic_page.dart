import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/models/transaction_model.dart';

// ignore: must_be_immutable
class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  bool _isGeneral = true;
  final _myBox = Hive.box("transactions");
  List<TransactionModel> transactions = [];
  Map<String, double> incomeDataMap = {};
  Map<String, double> expenseDataMap = {};
  Map<String, double> monthlyFilteredIncomeDataMap = {};
  Map<String, double> monthlyFilteredExpenseDataMap = {};
  double totalIncome = 0;
  double totalExpense = 0;
  DateTime selectedMonth = DateTime.now();

  final colorList = <Color>[
    const Color(0xff0c2461),
    const Color(0xff1e3799),
    const Color(0xff0984e3),
    const Color(0xff74b9ff),
    const Color(0xffa29bfe),
  ];

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
        filterMonthlyTransactions(selectedMonth);
        filterMonthlyIncomeTransactions(selectedMonth);
        filterMonthlyExpenseTransactions(selectedMonth);
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

  void filterMonthlyTransactions(DateTime month) {
    totalIncome = 0;
    totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.date.year == month.year &&
          transaction.date.month == month.month) {
        if (transaction.inIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }
    }
    setState(() {});
  }

  void filterMonthlyIncomeTransactions(DateTime month) {
    monthlyFilteredIncomeDataMap.clear();
    for (var transaction in transactions) {
      if (transaction.date.year == month.year &&
          transaction.date.month == month.month &&
          transaction.inIncome) {
        if (monthlyFilteredIncomeDataMap.containsKey(transaction.category)) {
          monthlyFilteredIncomeDataMap[transaction.category] =
              monthlyFilteredIncomeDataMap[transaction.category]! +
                  transaction.amount;
        } else {
          monthlyFilteredIncomeDataMap[transaction.category] =
              transaction.amount;
        }
      }
    }
  }

  void filterMonthlyExpenseTransactions(DateTime month) {
    monthlyFilteredExpenseDataMap.clear();
    for (var transaction in transactions) {
      if (transaction.date.year == month.year &&
          transaction.date.month == month.month &&
          !transaction.inIncome) {
        if (monthlyFilteredExpenseDataMap.containsKey(transaction.category)) {
          monthlyFilteredExpenseDataMap[transaction.category] =
              monthlyFilteredExpenseDataMap[transaction.category]! +
                  transaction.amount;
        } else {
          monthlyFilteredExpenseDataMap[transaction.category] =
              transaction.amount;
        }
      }
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: "Select Month",
    );

    if (picked != null &&
        (picked.year != selectedMonth.year ||
            picked.month != selectedMonth.month)) {
      setState(() {
        selectedMonth = picked;
        filterMonthlyTransactions(selectedMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isGeneral = true;
                  });
                },
                child: Container(
                  width: 150,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isGeneral ? Color(0xFF272973) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2,
                        color: _isGeneral ? Colors.white : Color(0xFF272973)),
                  ),
                  child: Center(
                    child: Text("General",
                        style: TextStyle(
                            color:
                                _isGeneral ? Colors.white : Color(0xFF272973),
                            fontFamily: 'Jura',
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isGeneral = false;
                  });
                },
                child: Container(
                    width: 150,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isGeneral ? Colors.grey[100] : Color(0xFF272973),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: _isGeneral ? Color(0xFF272973) : Colors.white),
                    ),
                    child: Center(
                      child: Text("Monthly",
                          style: TextStyle(
                            color:
                                _isGeneral ? Color(0xFF272973) : Colors.white,
                            fontFamily: 'Jura',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    )),
              ),
            ],
          ),
          if (_isGeneral) ...[
            SizedBox(
              height: 40,
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
                        chartValueStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jura',
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    colorList: colorList,
                    legendOptions: const LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.right,
                      showLegendsInRow: false,
                      legendTextStyle: TextStyle(
                          color: Color(0xFF272973),
                          fontFamily: 'Jura',
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Text("No Income Transactions",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30,
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
                      chartValueStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Jura',
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    colorList: colorList,
                    legendOptions: const LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.right,
                      showLegendsInRow: false,
                      legendTextStyle: TextStyle(
                          color: Color(0xFF272973),
                          fontFamily: 'Jura',
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Text("No Expense Transactions",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
          ] else ...[
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => _selectMonth(context),
              child: Container(
                width: 300,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF272973),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "Select Month: ${DateFormat('MMMM yyyy').format(selectedMonth)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Jura',
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (totalIncome > 0 || totalExpense > 0) ...[
              Text("Income vs Expense",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jura')),
              SizedBox(height: 20),
              PieChart(
                dataMap: {
                  "Income": totalIncome,
                  "Expense": totalExpense,
                },
                chartRadius: MediaQuery.of(context).size.width / 2.2,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  chartValueStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Jura',
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                colorList: colorList,
                legendOptions: const LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  showLegendsInRow: false,
                  legendTextStyle: TextStyle(
                      color: Color(0xFF272973),
                      fontFamily: 'Jura',
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text(
                  "Incomes on ${DateFormat('MMMM yyyy').format(selectedMonth)}",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jura')),
              SizedBox(height: 20),
              if (monthlyFilteredIncomeDataMap.isNotEmpty) ...[
                PieChart(
                  dataMap: monthlyFilteredIncomeDataMap,
                  chartRadius: MediaQuery.of(context).size.width / 2.2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    chartValueStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Jura',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  colorList: colorList,
                  legendOptions: const LegendOptions(
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    showLegendsInRow: false,
                    legendTextStyle: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                Text("No Income Transactions",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
              SizedBox(height: 20),
              Text(
                  "Expenses on ${DateFormat('MMMM yyyy').format(selectedMonth)}",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jura')),
              SizedBox(height: 20),
              if (monthlyFilteredExpenseDataMap.isNotEmpty) ...[
                PieChart(
                  dataMap: monthlyFilteredExpenseDataMap,
                  chartRadius: MediaQuery.of(context).size.width / 2.2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    chartValueStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Jura',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  colorList: colorList,
                  legendOptions: const LegendOptions(
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    showLegendsInRow: false,
                    legendTextStyle: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                Text("No Expense Transactions",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ] else ...[
              Text("No Transactions for Selected Month",
                  style: TextStyle(
                      color: Color(0xFF272973),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ]
          ],
        ]),
      ),
    );
  }
}
