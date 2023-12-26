import 'package:flutter/material.dart';
import '../widgets/adaptive_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  // ignore: use_key_in_widget_constructors
  const NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() {
    //print('create state NT');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  // const NewTransaction({Key? key}) : super(key: key);
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime? _selectedDate;

  // _NewTransactionState(){
  //   print("Constructor _NTS");
  // }
  
  // @override
  // void initState() {
  //   print('initState');
  //   super.initState();
  // }

  // @override
  // void didUpdateWidget(covariant NewTransaction oldWidget) {
  //   print("didUpdateWidget");
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void dispose() {
  //   print("dispose");
  //   super.dispose();
  // }


  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
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
    //print('build -> sheet');
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date : ${DateFormat.yMMMd().format(_selectedDate!)}'),
                    ),
                    AdaptiveButton('Chose Date', _presentDatePicker),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Add Transaction'),
                onPressed: submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
