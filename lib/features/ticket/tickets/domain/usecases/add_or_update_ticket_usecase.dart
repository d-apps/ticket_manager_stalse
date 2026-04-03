import 'package:dartz/dartz.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import '../entities/ticket_entity.dart';
import '../repositories/i_ticket_repository.dart';

abstract class IAddOrUpdateTicketUseCase {
  Future<Either<Failure, void>> call(TicketEntity ticket);
}

class AddOrUpdateTicketUseCase implements IAddOrUpdateTicketUseCase {
  final ITicketRepository _repository;

  AddOrUpdateTicketUseCase({ required ITicketRepository repository })
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(TicketEntity ticket) async {
    return await _repository.addOrUpdate(ticket);
  }

}