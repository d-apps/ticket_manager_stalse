import 'dart:math';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';
import '../../domain/enums/ticket_priority.dart';
import '../../domain/enums/ticket_status.dart';
import '../models/ticket_model.dart';
import 'i_ticket_data_source.dart';

class TicketLocalDataSource implements ITicketDataSource {
  final IPersistenceService _persistence;

  TicketLocalDataSource({
    required IPersistenceService persistence
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
      final data = await _persistence.getAll();
      if (data.isNotEmpty) return;

      final random = Random();
      final tickets = <TicketModel>[];

      for (int i = 0; i < 10; i++) {
        final ticket = TicketModel(
          id: "TKT-000$i",
          createdAt: DateTime.now().subtract(Duration(days: i)),
          customerName: 'Cliente $i',
          message: 'Estou com o problema no...',
          status: i % 2 == 0 ? TicketStatus.open : TicketStatus.closed,
          priority: TicketPriority.values[random.nextInt(3)],
          category: ['Financeiro', 'Dúvida Técnica', 'Reclamação'][random.nextInt(3)],
        );

        tickets.add(ticket);
      }

      final entries = _makeEntries(tickets);
      await _persistence.putAll(entries);
    } catch(e){
      throw Exception('Failed to populate the local database: $e');
    }
  }

  Map<String, Map> _makeEntries(List<TicketModel> tickets) {
    final entries = <String, Map>{};
    for (final ticket in tickets) {
      entries[ticket.id] = ticket.toJson();
    }
    return entries;
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _persistence.delete(id);
    } catch(e){
      throw Exception('Failed to delete ticket: $e');
    }
  }

}