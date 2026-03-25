import 'package:dartz/dartz.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';

import '../../../../core/error/failure.dart';

abstract class ITicketRepository {
  Future<Either<Failure, List<TicketEntity>>> getAll();
  Future<Either<Failure, void>> add(TicketEntity ticket);
}