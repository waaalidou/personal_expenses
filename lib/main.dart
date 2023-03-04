import 'package:flutter/material.dart';
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
        primarySwatch: Colors.green,
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
    Transaction(
        id: "5xW", title: "School Expences", amount: 125, date: DateTime.now()),
    Transaction(
        id: "00A", title: "New Phone", amount: 350, date: DateTime.now())
  ];

  void _addNewTransaction(String txnTitle, double txnAmount) {
    final newTxn = Transaction(
      id: DateTime.now().toString(),
      title: txnTitle,
      amount: txnAmount,
      date: DateTime.now(),
    );
    setState(() {
      _userTransactions.insert(0, newTxn);
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor ,
                child: const Text(
                  "Chart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              TransacationsList(
                userTransactions: _userTransactions,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewTransaction(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
