import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';

import '../../tickets/domain/enums/ticket_status.dart';
import '../../tickets/presentation/ticket_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TicketsCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TicketLoadedState && state.tickets.isNotEmpty) {

              final tickets = state.tickets;
              final openCount = tickets
                  .where((t) => t.status == TicketStatus.open)
                  .length;

              final closedCount = tickets
                  .where((t) => t.status == TicketStatus.closed)
                  .length;

              return makePieChart(openCount: openCount, closedCount: closedCount);
            }

            return Center(child: Text("Sem dados"));
          },
        ),
      ),
    );
  }

  Widget makePieChart({
    required int openCount,
  required int closedCount,
}) => Container(
    padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text("Tickets abertos e fechados"),
      const SizedBox(height: 15),
      SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green[300],
                  value: openCount.toDouble(),
                  title: 'Abertos\n$openCount',
                  titleStyle: TextStyle(fontWeight: FontWeight.bold)
                ),
                PieChartSectionData(
                  color: Colors.blue[300],
                  value: closedCount.toDouble(),
                  title: 'Fechados\n$closedCount',
                  titleStyle: TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
        ),
    ],
  ),
);



}
