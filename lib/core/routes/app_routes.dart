import 'package:flutter/cupertino.dart';

import '../../features/base/presentation/base_page.dart';
import '../../features/ticket/add/presentation/add_ticket_page.dart';
import '../../features/ticket/detail/presentation/ticket_detail_page.dart';
import '../../features/ticket/tickets/domain/entities/ticket_entity.dart';
import '../../features/ticket/update/presentation/update_ticket_page.dart';

enum AppRoutes {
  base('/'),
  addTicket('/add-ticket'),
  updateTicket('/update-ticket'),
  ticketDetails('/ticket-details');

  final String route;
  const AppRoutes(this.route);

  static Map<String, WidgetBuilder> makeRoutes(){
    return {
      base.route: (context) => const BasePage(),
      addTicket.route: (context) => const AddTicketPage(),
      updateTicket.route: (context){
        final ticket = ModalRoute.of(context)!.settings.arguments as TicketEntity;
        return UpdateTicketPage(ticket: ticket);
      },
      ticketDetails.route: (context) {
        final ticket = ModalRoute.of(context)!.settings.arguments as TicketEntity;
        return TicketDetailPage(ticket: ticket);
      }
    };
  }

}