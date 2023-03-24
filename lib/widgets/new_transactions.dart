
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({super.key, required this.addNewTransaction});
  final Function addNewTransaction;
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _tittleControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    final titleValue = _tittleControler.text;
    final amountValue = double.parse(_amountControler.text);
    //
    if (titleValue.isEmpty || amountValue <= 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTransaction(titleValue, amountValue, _selectedDate);
    _tittleControler.text = '';
    _amountControler.text = '';
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                controller: _tittleControler,
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
                controller: _amountControler,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (_selectedDate == null)
                          ? "No Date Chosen"
                          : "Picked Date: ${DateFormat.yMd().format(_selectedDate!)}",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AdaptiveFlatButton(
                    handeler: _presentDatePicker,
                    title: "Pick a Date",
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: submitData,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).textTheme.labelLarge!.color!),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  side: MaterialStateProperty.all(BorderSide.none),
                ),
                child: const Text("Add Transaction"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
