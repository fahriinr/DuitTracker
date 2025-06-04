import 'package:belajar_bloc/models/expense_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // reference out box
  final _myBox = Hive.box("expense_database");

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    // Hive can only store String and DateTime, and not custom objects like ExpenseItem
    // convert expenseItem objects into types that can be stored in db

    /*

    allExpense = 
    
    [
      ExpenseItem (name / amount / dateTime)
      ..
    ]
   
    -->
    [
    
    [name, amount, dateTime]
    ..

    ]

    */

    List<List<dynamic>> allExpenseFormatted = [];

    for (var expense in allExpense) {
      // convert each expenseItem into a list storable types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }
    // finnaly lets store in our database!
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  // read data
  List<ExpenseItem> readData() {
    /*

    data is stored in Hive as a list of string + dateTime, we need to convert out savcd data into ExpenseItem objects
    
    savedData = 

    [

    [name, amount, dateTime]
    ..

    ]

    --> 
    [

    ExpenseItem ( name / amount / dateTime )
    ..

    ]
    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpense = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to overall list of expenses
      allExpense.add(expense);
    }
    return allExpense;
  }
}
