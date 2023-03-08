import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '/models/transactions.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.recentTransaction});
  final List<Transaction> recentTransaction;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalWeekSpending {
    return groupedTransactionValues.fold(
        0,
        (previousValue, element) =>
            previousValue + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((txn) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: txn['Day'] as String,
                  spendingAmount: txn['amount'] as double,
                  spendingPercentageOfTotal:
                      (txn['amount'] as double) / totalWeekSpending,
                ),
              );
            }).toList(),
          ),
      ),
      );
  }
}
