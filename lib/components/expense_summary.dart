import 'package:belajar_bloc/bar%20graph/bar_graph.dart';
import 'package:belajar_bloc/data/expense_data.dart';
import 'package:belajar_bloc/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  //calculate max amount in bar graph
  double calculateTheMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();
    // get largest which is at the end of sorted list
    // and increase the cap slightly so the graph looks almost full

    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  // calculate the week total
  String calculateTotalWeek(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of this week
    String sunday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 6)),
    );

    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Column(
            children: [
              // week total
              Padding(
                padding: const EdgeInsets.only(bottom: 25, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Week Total: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp${calculateTotalWeek(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}",
                    ),
                  ],
                ),
              ),
              // bar graph
              SizedBox(
                height: 200,
                child: MyBarGraph(
                  maxY: calculateTheMax(
                    value,
                    sunday,
                    monday,
                    tuesday,
                    wednesday,
                    thursday,
                    friday,
                    saturday,
                  ),
                  sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                  monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                  tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                  wedAmount:
                      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                  thurAmount:
                      value.calculateDailyExpenseSummary()[thursday] ?? 0,
                  friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                  satAmount:
                      value.calculateDailyExpenseSummary()[saturday] ?? 0,
                ),
              ),
            ],
          ),
    );
  }
}
