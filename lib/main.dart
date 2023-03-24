import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transactions.dart';
import 'package:personal_expenses/widgets/transactions_list.dart';

import 'models/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expences',
            home: const MyHomePage(),
            theme: CupertinoThemeData(
              primaryColor: Colors.deepOrange[400],
              textTheme: const CupertinoTextThemeData(
                textStyle: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
          )
        : MaterialApp(
            title: 'Personal Expences',
            home: const MyHomePage(),
            theme: ThemeData(
              colorScheme: ThemeData.light().colorScheme.copyWith(
                    primary: Colors.deepOrange[400],
                    error: Colors.pink[400],
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
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    Transaction(
      id: "0xW",
      title: "Shopping",
      amount: 250,
      date: DateTime.now(),
    ),
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

  List <Widget> _buildLandScapeContent(MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Show Chart"),
        Switch.adaptive(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            }),
      ],
    ), _showChart
                    ? SizedBox(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.8,
                        child: Chart(recentTransaction: _recentTransactions),
                      )
                    : txListWidget];
  }

  List <Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: Chart(recentTransaction: _recentTransactions),
    ), txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Personal Expences'),
      actions: [
        IconButton(
          onPressed: () => _startNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    final mediaQuery = MediaQuery.of(context);
    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransacationsList(
          userTransactions: _userTransactions,
          deleteTransaction: _deleteTransaction),
    );
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final pageBody = SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape) ..._buildLandScapeContent(mediaQuery, appBar, txListWidget),
              if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
             ],
          ),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: false,
              middle: const Text("Personal Expences"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startNewTransaction(context),
                )
              ]),
            ),
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startNewTransaction(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
          );
  }
}
