import 'package:belajar_bloc/components/expense_summary.dart';
import 'package:belajar_bloc/components/expense_tile.dart';
import 'package:belajar_bloc/data/expense_data.dart';
import 'package:belajar_bloc/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Text controller
  final newWExpenseNameController = TextEditingController();
  final newWExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //preapare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //Add new expense function
  void addNewExpense() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add Expenses"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expense Name
                TextField(
                  controller: newWExpenseNameController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Makan Siang",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                // Expense amount
                TextField(
                  controller: newWExpenseAmountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixText: "Rp",
                    prefixStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: "10000",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            actions: [
              // Cancel button
              MaterialButton(onPressed: cancel, child: Text("Cancel")),
              // Save button
              MaterialButton(onPressed: save, child: Text("Save")),
            ],
          ),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //addExpense save button
  void save() {
    // only save expense if all fields are filled

    if (newWExpenseNameController.text.isNotEmpty &&
        newWExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newWExpenseNameController.text,
        amount: newWExpenseAmountController.text,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(
        context,
        listen: false,
      ).addNewExpense(newExpense);

      Navigator.pop(context);
      clear();
    }
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //Clear controller
  void clear() {
    newWExpenseNameController.clear();
    newWExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              onPressed: addNewExpense,
              child: Icon(Icons.add),
            ),
            body: ListView(
              children: [
                // weekly summary
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),

                const SizedBox(height: 20),
                //expense list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder:
                      (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime,
                        deleteTapped:
                            (p0) =>
                                deleteExpense(value.getAllExpenseList()[index]),
                      ),
                ),
              ],
            ),
          ),
    );
  }
}
