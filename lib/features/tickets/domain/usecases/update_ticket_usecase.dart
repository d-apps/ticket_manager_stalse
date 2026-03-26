import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ticket_entity.dart';
import '../repositories/i_ticket_repository.dart';

abstract class IUpdateTicketUseCase {
  Future<Either<Failure, void>> call(TicketEntity ticket);
}

class UpdateTicketUseCase implements IUpdateTicketUseCase {
  final ITicketRepository _repository;

  UpdateTicketUseCase({ required ITicketRepository repository })
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(TicketEntity ticket) {
    return _repository.add(ticket);
  }
}