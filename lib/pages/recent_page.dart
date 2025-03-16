import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendwise/components/recent_page_tile.dart';
import 'package:spendwise/models/transaction_model.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final _myBox = Hive.box("transactions");
  List<TransactionModel> transactions = [];
  List<TransactionModel> filteredTransactions = [];
  String selectedCategory = "All";
  String selectedType = "All"; // "Income", "Expense"
  DateTime? selectedDate; // Null means "All Dates"

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
        applyFilters();
      });
    }
  }

  // Extract unique categories from transactions
  List<String> getCategories() {
    Set<String> categories = {"All"}; // Always include "All" as an option
    for (var transaction in transactions) {
      if (selectedType == "All" ||
          (selectedType == "Income" && transaction.inIncome) ||
          (selectedType == "Expense" && !transaction.inIncome)) {
        categories.add(transaction.category);
      }
    }
    return categories.toList();
  }

  void applyFilters() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        bool matchesCategory = selectedCategory == "All" ||
            transaction.category == selectedCategory;
        bool matchesType = selectedType == "All" ||
            (selectedType == "Income" && transaction.inIncome) ||
            (selectedType == "Expense" && !transaction.inIncome);
        bool matchesDate = selectedDate == null ||
            (transaction.date.year == selectedDate!.year &&
                transaction.date.month == selectedDate!.month &&
                transaction.date.day == selectedDate!.day);
        return matchesCategory && matchesType && matchesDate;
      }).toList();
    });
  }

  void deleteTransaction(BuildContext context, TransactionModel transaction) {
    setState(() {
      _myBox.delete(transaction.key); // Remove from Hive
      transactions.remove(transaction); // Remove from list
      applyFilters(); // Reapply filters after deletion
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Transaction deleted"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Type Filter
              SizedBox(
                width: 300,
                child: DropdownButton<String>(
                  value: selectedType,
                  isExpanded: true,
                  alignment: Alignment.centerRight,
                  items: ["All", "Income", "Expense"]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      selectedCategory =
                          "All"; // Reset category when type changes
                      applyFilters();
                    });
                  },
                  style: TextStyle(
                      fontFamily: 'Jura',
                      color: Color(0xFF272973),
                      fontSize: 15),
                ),
              ),

              // Category Filter
              SizedBox(
                width: 300,
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  alignment: Alignment.centerRight,
                  items: getCategories()
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      applyFilters();
                    });
                  },
                  style: TextStyle(
                      fontFamily: 'Jura',
                      color: Color(0xFF272973),
                      fontSize: 15),
                ),
              ),

              // Date Filter
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          applyFilters();
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today, color: Color(0xFF272973)),
                    label: Text(
                      selectedDate == null
                          ? "All Dates"
                          : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                      style: TextStyle(
                          fontFamily: 'Jura',
                          color: Color(0xFF272973),
                          fontSize: 15),
                    ),
                  ),
                  if (selectedDate != null)
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                          applyFilters();
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
        ),

        // Transaction List
        Expanded(
          child: filteredTransactions.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    TransactionModel transaction = filteredTransactions[index];
                    return RecentPageTile(
                      transaction: transaction,
                      deleteFunction: (context) =>
                          deleteTransaction(context, transaction),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Transactions found.",
                    style: TextStyle(
                        fontFamily: 'Jura',
                        color: Color(0xFF272973),
                        fontSize: 15),
                  ),
                ),
        ),
      ],
    );
  }
}
