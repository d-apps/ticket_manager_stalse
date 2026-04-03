import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_manager_stalse/core/extensions/date_formatter.dart';
import 'package:ticket_manager_stalse/core/routes/app_routes.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/widgets/priority_widget.dart';
import '../../../detail/presentation/ticket_detail_page.dart';
import '../../../update/presentation/update_ticket_cubit.dart';
import '../../domain/entities/ticket_entity.dart';
import 'category_widget.dart';

class TicketTile extends StatelessWidget {
  final TicketEntity ticket;

  const TicketTile({ required this.ticket, super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateTicketCubit>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, color: Theme.of(context).primaryColor),
          ),
          title: Row(
            children: [
              Text(ticket.customerName, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(" • ", style: TextStyle(color: Colors.grey[500])),
              Text(ticket.id, style: TextStyle(color: Colors.grey[600], fontSize: 13))
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  PriorityWidget(ticket.priority),
                  CategoryWidget(ticket.category),
                ],
              ),
              Text(
                ticket.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  Text(ticket.createdAt.toIso8601String().format()),
                  Text(ticket.status.title, style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(
                context,
                AppRoutes.ticketDetails.route,
                arguments: ticket
            );
          },
        ),
      ),
    );
  }
}
