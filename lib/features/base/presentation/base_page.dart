import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';

import '../../tickets/presentation/tickets_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IndexedStack(
          index: index,
          children: [
            TicketsPage(),
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            activeIcon: Icon(Icons.confirmation_num),
            label: 'Tickets',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        onTap: (value){
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
