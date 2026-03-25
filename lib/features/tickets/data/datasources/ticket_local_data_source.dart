import 'dart:math';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';
import 'package:ticket_manager_stalse/features/tickets/data/datasources/i_ticket_data_source.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import '../models/ticket_model.dart';

class TicketLocalDataSource implements ITicketDataSource {
  final IPersistenceService<Map> _persistence;

  TicketLocalDataSource({
    required IPersistenceService<Map<dynamic, dynamic>> persistence
  }) : _persistence = persistence;

  @override
  Future<List<TicketModel>> getAll() async {
    try {
      final data = await _persistence.getAll();
      return data.map((e) => TicketModel.fromJson(e)).toList();
    } catch(e){
      throw Exception('Failed to get all tickets: $e');
    }
  }

  @override
  Future<void> add(TicketModel ticket) async {
    try {
      await _persistence.put(ticket.id, ticket.toJson());
    } catch(e){
      throw Exception('Failed to get add ticket: $e');
    }
  }

  @override
  Future<void> seed() async {
    try {
      final random = Random();
      final tickets = <TicketModel>[];

      for (int i = 0; i < 10; i++) {
        final ticket = TicketModel(
          id: i.toString(),
          createdAt: DateTime.now().subtract(Duration(days: i)),
          customerName: 'Cliente $i',
          message: 'Ticket mockado $i',
          status: i % 2 == 0 ? TicketStatus.open : TicketStatus.closed,
          priority: TicketPriority.values[random.nextInt(3)],
          category: ['Financeiro', 'Dúvida Técnica', 'Reclamação'][random.nextInt(3)],
        );

        tickets.add(ticket);
      }

      final entries = <String, Map>{};
      for (final ticket in tickets) {
        entries[ticket.id] = ticket.toJson();
      }

      await _persistence.putAll(entries);
    } catch(e){
      throw Exception('Failed to populate the local database: $e');
    }
  }

}