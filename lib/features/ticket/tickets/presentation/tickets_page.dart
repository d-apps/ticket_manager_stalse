import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/core/routes/app_routes.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/widgets/ticket_tile.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_cubit.dart';
import '../../add/presentation/add_ticket_page.dart';
import '../domain/entities/ticket_entity.dart';
import '../domain/enums/ticket_status.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({ super.key});

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
        Navigator.pushNamed(context, AppRoutes.addTicket.route);
      },
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    ),
        );
  }

  Widget makeList(List<TicketEntity> tickets) => ListView.separated(
    separatorBuilder: (_, _) => Divider(color: Colors.transparent, height: 8),
    itemCount: tickets.length,
    itemBuilder: (context, index){
      return TicketTile(
          ticket: tickets[index],
      );
    },
  );
}