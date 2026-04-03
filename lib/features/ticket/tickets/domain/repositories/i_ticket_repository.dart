import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/ticket_entity.dart';

abstract class ITicketRepository {
  Future<Either<Failure, List<TicketEntity>>> getAll();
  Future<Either<Failure, void>> addOrUpdate(TicketEntity ticket);
  Future<Either<Failure, void>> deleteTicket(String id);
}