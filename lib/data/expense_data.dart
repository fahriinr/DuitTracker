import 'package:belajar_bloc/data/hive_database.dart';
import 'package:belajar_bloc/datetime/date_time_helper.dart';
import 'package:belajar_bloc/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDatabase();
  void prepareData() {
    // if there exists data, get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    db.saveData(overallExpenseList);

    notifyListeners();
  }

  //get weekday (mon, tues, wed) from dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return '';
    }
  }

  //get the date for the start of the week ( sunday )
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /*
     
    convert overall list of expense into a daily expense summary

    e.g.

    overallExpense = 
    [
    
    [ food, 2025/01/12, Rp50000 ],
    [ drinks, 2025/01/12, Rp10000 ],
    [ food, 2025/01/14, Rp50000 ],
    [ drinks, 2025/01/15, Rp10000 ],
    [ food, 2025/01/16, Rp12000 ],
    [ drinks, 2025/01/16, Rp10000 ],
    [ shopping, 2025/01/16, Rp550000 ],
    [ drinks, 2025/01/24, Rp50000 ],
    
    ]

    ->

    DailyExpenseSummary = 
    [
    
      [ 20250112: Rp60000],
      [ 20250114: Rp50000],
      [ 20250115: Rp10000],
      [ 20250116: Rp572000],
      [ 20250124: Rp50000],

    
    ]
  */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.tryParse(expense.amount) ?? 0.0;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }

  String calculateTotalExpenseSummary() {
    double total = 0;

    for (var expense in overallExpenseList) {
      double amount = double.parse(expense.amount);

      total += amount;
    }
    return total.toStringAsFixed(0);
  }
}
