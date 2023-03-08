import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transactions.dart';
import 'package:personal_expenses/widgets/transactions_list.dart';

import 'models/transactions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expences',
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Colors.purple,
              error: Colors.pink,
            ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              labelLarge: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: "0xW", title: "Shopping", amount: 250, date: DateTime.now()),
    /* Transaction(
        id: "5xW", title: "School Expences", amount: 125, date: DateTime.now()),
    Transaction(
        id: "00A", title: "New Phone", amount: 350, date: DateTime.now()) */
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(const Duration(days: 7)),
      );
    }).toList();
  }

  double get calculateTotalAmount {
    return _recentTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  void _addNewTransaction(
      String txnTitle, double txnAmount, DateTime chosenDate) {
    final newTxn = Transaction(
      id: DateTime.now().toString(),
      title: txnTitle,
      amount: txnAmount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.insert(0, newTxn);
      calculateTotalAmount;
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (builderContext) {
          return NewTransaction(addNewTransaction: _addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expences'),
        actions: [
          IconButton(
              onPressed: () => _startNewTransaction(context),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                child: Text(
                  "Total is: $calculateTotalAmount",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Chart(recentTransaction: _recentTransactions),
              TransacationsList(
                  userTransactions: _userTransactions,
                  deleteTransaction: _deleteTransaction)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewTransaction(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
