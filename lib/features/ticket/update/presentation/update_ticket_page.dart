import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/core/mixins/alert_mixin.dart';
import 'package:ticket_manager_stalse/core/routes/app_routes.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_state.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_cubit.dart';
import '../../add/presentation/widgets/ticket_add_or_update_form.dart';
import '../../tickets/domain/entities/ticket_entity.dart';

class UpdateTicketPage extends StatelessWidget with AlertMixin {
  final TicketEntity ticket;

  const UpdateTicketPage({
    required this.ticket,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateTicketCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Ticket"),
        centerTitle: false,
      ),
      body: BlocListener<UpdateTicketCubit, UpdateTicketState>(
        listener: (context, state){
          if(state is ErrorUpdateTicketState){
            showErrorSnackBar(context, state.message);
          }
          if(state is SuccessUpdateTicketState){
            Navigator.popUntil(
                context, (route) => route.settings.name == AppRoutes.base.route
            );
            context.read<TicketsCubit>().getTickets();
            showSuccessSnackBar(context, 'Ticket resolvido com sucesso!');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TicketAddOrUpdateForm(
              ticket: ticket,
              onSave: (TicketEntity ticket){
                cubit.updateTicket(ticket);
              },
          )
        ),
      ),
    );
  }
}
