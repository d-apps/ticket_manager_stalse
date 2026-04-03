import 'package:dartz/dartz.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import '../../../tickets/domain/repositories/i_ticket_repository.dart';

abstract class IDeleteTicketUseCase {
  Future<Either<Failure, void>> call(String id);
}

class DeleteTicketUseCase implements IDeleteTicketUseCase {
  final ITicketRepository _repository;

  DeleteTicketUseCase({ required ITicketRepository repository })
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await _repository.deleteTicket(id);
  }

}