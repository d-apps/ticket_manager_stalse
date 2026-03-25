import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'features/tickets/presentation/tickets_page.dart';

void main() async {
  Hive.init(null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TicketsPage(),
    );
  }
}
