import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/transactions.dart';

class TransacationsList extends StatelessWidget {
  const TransacationsList(
      {super.key,
      List<Transaction> userTransactions = const [],
      required this.deleteTransaction})
      : _userTransactions = userTransactions;
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _userTransactions.isEmpty
          ? SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No transactions Yet',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w800,
                        fontSize: 28),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 250,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
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
                          "\$${_userTransactions[index].amount}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      _userTransactions[index].title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(DateFormat.yMMMd()
                        .format(_userTransactions[index].date)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          deleteTransaction(_userTransactions[index].id),
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              },
              itemCount: _userTransactions.length,
            ),
    );
  }
}
