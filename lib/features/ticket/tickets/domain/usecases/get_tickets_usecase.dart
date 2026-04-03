import 'package:dartz/dartz.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import '../entities/ticket_entity.dart';
import '../repositories/i_ticket_repository.dart';

abstract class IGetTicketsUseCase {
  Future<Either<Failure, List<TicketEntity>>> call();
}

class GetTicketsUseCase implements IGetTicketsUseCase {
  final ITicketRepository _repository;

  GetTicketsUseCase({ required ITicketRepository repository })
      : _repository = repository;


  @override
  Future<Either<Failure, List<TicketEntity>>> call() async {
    return await _repository.getAll();
  }

}