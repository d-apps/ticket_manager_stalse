import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/core/mixins/alert_mixin.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_ticket_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/widgets/ticket_add_or_update_form.dart';
import '../../tickets/domain/entities/ticket_entity.dart';
import '../../tickets/presentation/tickets_cubit.dart';
import 'add_cubit_state.dart';

class AddTicketPage extends StatelessWidget with AlertMixin {
  const AddTicketPage({ super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTicketCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Ticket"),
        centerTitle: false,
      ),
      body: BlocListener<AddTicketCubit, AddTicketState>(
        listener: (context, state){
          if(state is ErrorAddTicketState){
            showErrorSnackBar(context, state.message);
          }
          if(state is SuccessAddTicketState){
            Navigator.pop(context);
            context.read<TicketsCubit>().getTickets();
            showSuccessSnackBar(context, "Ticket adicionado com sucesso!");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TicketAddOrUpdateForm(
              ticket: null,
              onSave: (TicketEntity ticket){
                cubit.addTicket(ticket);
          }),
        ),
      ),
    );
  }
}
