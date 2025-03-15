import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/models/transaction_model.dart';

class TransactionBox extends StatefulWidget {
  const TransactionBox({super.key});

  @override
  State<TransactionBox> createState() => _TransactionBoxState();
}

class _TransactionBoxState extends State<TransactionBox> {
  bool _isIncome = false;
  final _controller = TextEditingController();
  String? _dropDownValue;
  final _myBox = Hive.box("transactions");

  @override
  void initState() {
    super.initState();
    _dropDownValue = _isIncome ? "Other Incomes" : "Other Expences";
  }

  void changeToIncome() {
    setState(() {
      _isIncome = true;
      _dropDownValue = _isIncome ? "Other Incomes" : "Other Expences";
    });
  }

  void changeToExpense() {
    setState(() {
      _isIncome = false;
      _dropDownValue = _isIncome ? "Other Incomes" : "Other Expences";
    });
  }

  void dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropDownValue = selectedValue;
      });
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _myBox.add(transaction);
  }

  void saveTransaction() {
    double? amount = double.tryParse(_controller.text);
    if (_dropDownValue != null && amount != null) {
      addTransaction(TransactionModel(
        category: _dropDownValue!,
        amount: amount,
        inIncome: _isIncome,
        date: DateTime.now(),
      )).then((_) {
        Navigator.pop(context, true); // Pass 'true' to indicate data changed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      content: Container(
        width: 500,
        height: 400,
        child: Column(
          children: [
            Text(
              "Transaction",
              style: TextStyle(
                  color: Color(0xFF272973),
                  fontFamily: 'Jura',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: changeToExpense,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                        color: _isIncome ? Colors.grey[200] : Color(0xFF272973),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF272973), width: 1)),
                    child: Text(
                      "Expense",
                      style: TextStyle(
                        fontFamily: 'Jura',
                        color: _isIncome ? Color(0xFF272973) : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: changeToIncome,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                        color: _isIncome ? Color(0xFF272973) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF272973), width: 1)),
                    child: Text("Income",
                        style: TextStyle(
                            fontFamily: 'Jura',
                            color:
                                _isIncome ? Colors.white : Color(0xFF272973)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Color(0xFF272973), width: 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Text(
                    "Rs",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: TextStyle(
                            color: _isIncome ? Colors.green : Colors.red,
                            fontFamily: 'Jura',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: _isIncome ? Colors.green : Colors.red,
                          fontFamily: 'Jura',
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ".00",
                    style: TextStyle(
                        color: _isIncome ? Colors.green : Colors.red,
                        fontFamily: 'Jura',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                        color: Color(0xFF272973),
                        fontFamily: 'Jura',
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  DropdownButton(
                      dropdownColor: Colors.grey[200],
                      iconEnabledColor: Color(0xFF272973),
                      style: TextStyle(
                          fontFamily: 'Jura',
                          color: Color(0xFF272973),
                          fontSize: 15),
                      items: _isIncome
                          ? const [
                              DropdownMenuItem(
                                child: Text("Salary"),
                                value: "Salary",
                              ),
                              DropdownMenuItem(
                                child: Text("Passive Income"),
                                value: "Passive income",
                              ),
                              DropdownMenuItem(
                                child: Text("Gifts or Bonuses"),
                                value: "Gifts or Bonuses",
                              ),
                              DropdownMenuItem(
                                child: Text("Other Incomes"),
                                value: "Other Incomes",
                              ),
                            ]
                          : const [
                              DropdownMenuItem(
                                child: Text("Transport"),
                                value: "Transport",
                              ),
                              DropdownMenuItem(
                                child: Text("Food"),
                                value: "Food",
                              ),
                              DropdownMenuItem(
                                child: Text("Groceries"),
                                value: "Groceries",
                              ),
                              DropdownMenuItem(
                                child: Text("Housing"),
                                value: "Housing",
                              ),
                              DropdownMenuItem(
                                child: Text("Entertainment"),
                                value: "Entertainment",
                              ),
                              DropdownMenuItem(
                                child: Text("Health"),
                                value: "Health",
                              ),
                              DropdownMenuItem(
                                child: Text("Education"),
                                value: "Education",
                              ),
                              DropdownMenuItem(
                                child: Text("Debt Payments"),
                                value: "Debt Payments",
                              ),
                              DropdownMenuItem(
                                child: Text("Personal Care"),
                                value: "Personal Care",
                              ),
                              DropdownMenuItem(
                                child: Text("Other Expences"),
                                value: "Other Expences",
                              ),
                            ],
                      value: _dropDownValue,
                      onChanged: dropDownCallback)
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            GestureDetector(
              onTap: saveTransaction,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 100,
                decoration: BoxDecoration(
                    color: Color(0xFF272973),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Jura',
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
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
