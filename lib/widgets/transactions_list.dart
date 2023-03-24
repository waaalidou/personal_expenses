import 'package:flutter/material.dart';
import '/models/transactions.dart';
import 'transaction_card.dart';

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
              child: LayoutBuilder(
                builder: (ctx, constraints) => Column(
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
                      height: constraints.maxHeight * .6,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) => TransactionCard(
                key: ValueKey(_userTransactions[index].id),
                userTransactions: _userTransactions[index],
                deleteTransaction: deleteTransaction,
              ),
              itemCount: _userTransactions.length,
            ),
    );
  }
}
