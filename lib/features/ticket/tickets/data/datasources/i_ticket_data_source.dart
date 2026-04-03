import '../models/ticket_model.dart';

abstract class ITicketDataSource {
  Future<List<TicketModel>> getAll();
  Future<void> add(TicketModel ticket);
  Future<void> delete(String id);
  Future<void> seed();
}