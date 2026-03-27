import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/ticket_add/presentation/widgets/ticket_add_or_update_form.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';

class TicketAddPage extends StatelessWidget {
  const TicketAddPage({ super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Ticket"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TicketAddOrUpdateForm(onSave: (TicketEntity ticket){
          context.read<TicketsCubit>().addTicket(ticket);
          Navigator.pop(context);
        }),
      ),
    );
  }
}
