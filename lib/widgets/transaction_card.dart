import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({
    super.key,
    required Transaction userTransactions,
    required this.deleteTransaction,
  }) : _userTransaction = userTransactions;

  final Transaction _userTransaction;
  final Function deleteTransaction;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late Color _bgColor;
  @override
  void initState() {
    const colorsList = [
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.green,
    ];
    _bgColor = colorsList[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 4,
      child: ListTile(
        leading: FittedBox(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              "\$${widget._userTransaction.amount}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          widget._userTransaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget._userTransaction.date)),
        trailing: MediaQuery.of(context).size.width > 400
            ? ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: null,
                icon: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      widget.deleteTransaction(widget._userTransaction.id),
                  color: Theme.of(context).colorScheme.error,
                ),
                label: const Text("Delete TXN"),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.deleteTransaction(
                  widget._userTransaction.id,
                ),
                color: Theme.of(context).colorScheme.error,
              ),
      ),
    );
  }
}
