import 'package:flutter/material.dart';


class ChartBar extends StatelessWidget {

  final String label;
  final double spendingAmount;
  final double spendingPercOfTotal;
  const ChartBar(this.label, this.spendingAmount, this.spendingPercOfTotal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('build -> bar');
    return LayoutBuilder(builder: ((ctx, constraints) {
      return Column(
        children: [
          SizedBox(
              height: constraints.maxHeight * 0.1,
              child: FittedBox(
                  child: Text('₹${spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.7,
            width: 20,
            child:
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPercOfTotal,
                child: Container(
                  width: 18,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ]),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
              height: constraints.maxHeight * 0.1,
              child: FittedBox(child: Text(label)))
        ],
      );
    }));
  }
}
