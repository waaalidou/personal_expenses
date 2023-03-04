import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({super.key, required this.addNewTransaction});
  final Function addNewTransaction;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final tittleControler = TextEditingController();

  final amountControler = TextEditingController();

  void submitData() {
    final titleValue = tittleControler.text;
    final amountValue = double.parse(amountControler.text);

    if (titleValue.isEmpty || amountValue <= 0) {
      return;
    }

    widget.addNewTransaction(titleValue, amountValue);
    tittleControler.text = '';
    amountControler.text = '';
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              controller: tittleControler,
              onSubmitted: (_) => submitData,
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              controller: amountControler,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: submitData,
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple),
              ),
              child: const Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
