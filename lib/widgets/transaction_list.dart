import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  //const TransactionList({Key? key}) : super(key: key);

  final List<Transaction> transaction;
  final Function deleteTx;

  // ignore: use_key_in_widget_constructors
  const TransactionList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    //print('build -> list');
    return transaction.isEmpty
        ? LayoutBuilder(
            builder: ((ctx, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.15,
                    child: Text(
                      'No Transactions!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  SizedBox(
                    height: constraints.maxHeight * 0.8,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }),
          )
        : ListView(
            children: transaction
                .map((tx) =>
                    TransactionItem(key: ValueKey(tx.id),transaction: tx, deleteTx: deleteTx))
                .toList());

    // ListView.builder(
    //     itemBuilder: (ctx, index) {
    //       return TransactionItem(transaction: transaction[index], deleteTx: deleteTx);
    //     },
    //     itemCount: transaction.length,
    //   );
  }
}
