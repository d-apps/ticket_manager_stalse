import 'package:flutter/material.dart';
import 'package:ticket_manager_stalse/features/dashboard/presentation/dashboard_page.dart';

import '../../ticket/tickets/presentation/tickets_page.dart';

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
            const TicketsPage(),
            const DashboardPage(),
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
