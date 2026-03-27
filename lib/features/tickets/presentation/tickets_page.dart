import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/widgets/ticket_tile.dart';

import '../../ticket_add/presentation/ticket_add_page.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<TicketsCubit>()..getTickets(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<TicketsCubit>();

          return Scaffold(
            appBar: AppBar(
              title: Text("Tickets", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),),
              centerTitle: false,
              actions: [
                PopupMenuButton<TicketStatus>(
                  icon: Icon(Icons.filter_list, color: Theme
                      .of(context)
                      .primaryColor,),
                  initialValue: cubit.currentStatus,
                  onSelected: (newStatus) {
                    setState(() {
                      cubit.currentStatus = newStatus;
                    });
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
                PopupMenuButton<SortBy>(
                  icon: Icon(Icons.sort, color: Theme
                      .of(context)
                      .primaryColor),
                  initialValue: cubit.sortBy,
                  onSelected: (value) {
                    setState(() {
                      cubit.sortBy = value;
                    });
                    cubit.sort();
                  },
                  itemBuilder: (context) => SortBy.values
                            .map((item) =>
                            PopupMenuItem<SortBy>(
                              value: item,
                              child: Text(item.title),
                            )).toList(),
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
                    MaterialPageRoute(builder: (_) => BlocProvider.value(
                        value: context.read<TicketsCubit>(),
                        child: TicketAddPage()
                    ))
                );
              },
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget makeList(List<TicketEntity> tickets) => ListView.separated(
    separatorBuilder: (_, __) => Divider(color: Colors.transparent, height: 8),
    itemCount: tickets.length,
    shrinkWrap: true,
    itemBuilder: (context, index){
      return TicketTile(tickets[index]);
    },
  );
}