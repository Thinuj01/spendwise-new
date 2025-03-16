// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String category;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late bool inIncome;

  @HiveField(3)
  late DateTime date;

  TransactionModel(
      {required this.category,
      required this.amount,
      required this.inIncome,
      required this.date});
}
