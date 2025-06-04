import 'package:belajar_bloc/data/expense_data.dart';
import 'package:belajar_bloc/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  // open hive box
  await Hive.openBox("expense_database");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder:
          (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          ),
    );
  }
}
