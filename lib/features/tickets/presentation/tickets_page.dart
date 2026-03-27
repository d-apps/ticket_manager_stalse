import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/widgets/ticket_tile.dart';

import '../../ticket_add/presentation/ticket_add_page.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TicketsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets"),
        centerTitle: false,
        actions: [
          BlocBuilder<TicketsCubit, TicketState>(
            builder: (context, state) => PopupMenuButton<TicketStatus>(
              icon: Icon(Icons.filter_list),
              initialValue: cubit.currentStatus,
              onSelected: (newStatus) {
                cubit.filterByStatus(newStatus);
              },
              itemBuilder: (context) =>
                  TicketStatus.values
                      .map((item) =>
                      PopupMenuItem<TicketStatus>(
                        value: item,
                        child: Text(item.title),
                      )).toList(),
            ),
          ),
          BlocBuilder<TicketsCubit, TicketState>(
            builder: (context, state) => PopupMenuButton<SortBy>(
              icon: Icon(Icons.sort),
              initialValue: cubit.sortBy,
              onSelected: (value) {
                cubit.changeSort(value);
              },
              itemBuilder: (context) => SortBy.values
                  .map((item) =>
                  PopupMenuItem<SortBy>(
                    value: item,
                    child: Text(item.title),
                  )).toList(),
            ),
          )
        ],
      ),
      body: BlocBuilder<TicketsCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TicketLoadedState) {
            return makeList(state.tickets);
          }
          return const Center(child: Text("Nenhum ticket encontrado"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TicketAddPage())
          );
        },
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget makeList(List<TicketEntity> tickets) => ListView.separated(
    separatorBuilder: (_, __) => Divider(color: Colors.transparent, height: 8),
    itemCount: tickets.length,
    itemBuilder: (context, index){
      return TicketTile(tickets[index]);
    },
  );
}