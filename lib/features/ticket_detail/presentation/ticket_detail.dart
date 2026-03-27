import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/core/extensions/date_formatter.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/widgets/category_widget.dart';

import '../../ticket_update/presentation/ticket_update_page.dart';
import '../../tickets/domain/enums/ticket_status.dart';
import '../../tickets/presentation/widgets/priority_widget.dart';

class TicketDetail extends StatelessWidget {
  final TicketEntity ticket;
  const TicketDetail({ required this.ticket, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Ticket"),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketUpdatePage(ticket: ticket),
                  ),
                );
              },
              icon: Icon(Icons.edit)
          )
        ],
      ),
      body: Padding(
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
                      context.read<TicketsCubit>().updateTicket(
                          ticket.copyWith(status: TicketStatus.closed
                          )
                      );
                      Navigator.pop(context);
                    },
                    child: Text("Marcar como Resolvido")
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
