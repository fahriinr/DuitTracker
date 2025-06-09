import 'package:belajar_bloc/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseTotal extends StatelessWidget {
  const ExpenseTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final totalExpense =
        Provider.of<ExpenseData>(context).calculateTotalExpenseSummary();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Total Expense: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Rp$totalExpense"),
      ],
    );
  }
}
