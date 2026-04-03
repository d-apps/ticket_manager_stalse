import 'package:dartz/dartz.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import 'package:ticket_manager_stalse/core/extensions/ticket_entity_mapper.dart';

import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/i_ticket_repository.dart';
import '../datasources/i_ticket_data_source.dart';

class TicketRepository implements ITicketRepository {
  final ITicketDataSource _dataSource;

  TicketRepository({ required ITicketDataSource dataSource }) :
        _dataSource = dataSource;

  @override
  Future<Either<Failure, List<TicketEntity>>> getAll() async {
    try {
      final tickets = await _dataSource.getAll();
      return Right(tickets);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdate(TicketEntity ticket) async {
    try {
      await _dataSource.add(ticket.toModel());
      return Right(null);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTicket(String id) async {
    try {
      await _dataSource.delete(id);
      return Right(null);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

}