import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/core/extensions/date_formatter.dart';
import 'package:ticket_manager_stalse/core/mixins/alert_mixin.dart';
import 'package:ticket_manager_stalse/core/routes/app_routes.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_state.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_cubit.dart';
import '../../tickets/domain/entities/ticket_entity.dart';
import '../../tickets/domain/enums/ticket_status.dart';
import '../../tickets/presentation/tickets_cubit.dart';
import '../../tickets/presentation/widgets/category_widget.dart';
import '../../tickets/presentation/widgets/priority_widget.dart';
import '../../update/presentation/update_ticket_state.dart';
import '../../update/presentation/update_ticket_page.dart';

class TicketDetailPage extends StatelessWidget with AlertMixin {
  final TicketEntity ticket;

  const TicketDetailPage({
    required this.ticket,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final updateTicketCubit = context.read<UpdateTicketCubit>();
    final ticketDetailCubit = context.read<TicketDetailCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Ticket"),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(
                    context,
                    AppRoutes.updateTicket.route,
                    arguments: ticket
                );
              },
              icon: Icon(Icons.edit)
          ),
          IconButton(
              onPressed: (){
                ticketDetailCubit.deleteTicket(ticket.id);
              },
              icon: Icon(Icons.delete)
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TicketDetailCubit, TicketDetailState>(
            listener: (context, state){
              if(state is ErrorTicketDetailState){
                showErrorSnackBar(context, state.message);
              }
              if(state is DeletedTicketDetailState){
                Navigator.pop(context);
                context.read<TicketsCubit>().getTickets();
                showSuccessSnackBar(context, 'Ticket excluído com sucesso!');
              }
            },
          ),
          /// add for when marked as resolved
          BlocListener<UpdateTicketCubit, UpdateTicketState>(
            listener: (context, state){
              if(state is ErrorUpdateTicketState){
                showErrorSnackBar(context, state.message);
              }
              if(state is SuccessUpdateTicketState){
                Navigator.popUntil(
                    context, (route) => route.settings.name == AppRoutes.base.route
                );
                context.read<TicketsCubit>().getTickets();
                showSuccessSnackBar(context, 'Ticket atualizado com sucesso!');
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TICKET ID:", style: TextStyle(fontSize: 10)),
              Text(ticket.id, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Wrap(
                spacing: 8,
                children: [
                  PriorityWidget(ticket.priority),
                  CategoryWidget(ticket.category),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Cliente"),
                subtitle: Text(ticket.customerName),
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Data de criação"),
                subtitle: Text(ticket.createdAt.toIso8601String().format()),
              ),
              const SizedBox(height: 10),
              Text("Mensagem", style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 5),
              Text(ticket.message),
              const SizedBox(height: 10),
              Text("Status: ${ticket.status.title}"),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){
                        updateTicketCubit.updateTicket(ticket.copyWith(status: TicketStatus.closed));
                      },
                      child: Text("Marcar como Resolvido", style: TextStyle(color: Colors.white))
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
