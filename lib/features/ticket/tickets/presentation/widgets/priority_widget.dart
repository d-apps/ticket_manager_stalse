import 'package:flutter/material.dart';

import '../../domain/enums/ticket_priority.dart';

class PriorityWidget extends StatelessWidget {
  final TicketPriority priority;
  const PriorityWidget(this.priority, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
      label: Text(
        priority.title.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold, color: makeTextColor(), fontSize: 12),
      ),
      backgroundColor: makeBackgroundColor(),
    );
  }

  Color makeTextColor(){
    switch (priority) {
      case TicketPriority.low:
        return Colors.green[800]!;
      case TicketPriority.medium:
        return Colors.black;
      case TicketPriority.high:
        return Colors.red[800]!;
    }
  }

  Color makeBackgroundColor(){
    switch (priority) {
      case TicketPriority.low:
        return Colors.green[100]!;
      case TicketPriority.medium:
        return Colors.orange[100]!;
      case TicketPriority.high:
        return Colors.red[100]!;
    }
  }

}
