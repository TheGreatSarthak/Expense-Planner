import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
import '../widgets/chart.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'OpenSans',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> with WidgetsBindingObserver {
  //const MyApp({Key? key}) : super(key: key);

  final List<Transaction> _userTransactions = [];

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   super.didChangeAppLifecycleState(state);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Transaction> get _recent {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,AppBar appBar,Widget txListWidget){
    return [SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).primaryColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            ),_showChart
                ? SizedBox(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.8,
                    child: Card(
                      color: Theme.of(context).primaryColorLight,
                      child: Chart(_recent),
                    ),
                  )
                : txListWidget];
  }
  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,AppBar appBar,Widget txListWidget){
    return [SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Card(
                color: Theme.of(context).primaryColorLight,
                child: Chart(_recent),
              ),
            ),txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    //print('build -> homepage');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              "Expense Planner",
              style: TextStyle(fontFamily: 'Quicksand'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: const Icon(CupertinoIcons.add),
                )
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text(
              "Expense Planner",
              style: TextStyle(fontFamily: 'Quicksand'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar as AppBar, txListWidget),
          if (!isLandscape)
            ..._buildPortraitContent(mediaQuery, appBar as AppBar, txListWidget),
        ],
      ),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'OpenSans',
        textTheme: ThemeData().textTheme.copyWith(
              titleMedium: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor),
            ),
      ),
      home: Platform.isIOS
          ? CupertinoPageScaffold(child: pageBody)
          : Scaffold(
              appBar: appBar,
              body: pageBody,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => _startAddNewTransaction(context),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
    );
  }
}
