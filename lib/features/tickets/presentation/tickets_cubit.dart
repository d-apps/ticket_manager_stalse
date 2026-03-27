import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/add_or_update_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/get_tickets_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';

class TicketsCubit extends Cubit<TicketState> {
  final IGetTicketsUseCase _getTicketsUseCase;
  final IAddOrUpdateTicketUseCase _addOrUpdateTicketUseCase;

  TicketsCubit({
    required IGetTicketsUseCase getTicketsUseCase,
    required IAddOrUpdateTicketUseCase addOrUpdateTicketUseCase,
  })
    : _getTicketsUseCase = getTicketsUseCase,
      _addOrUpdateTicketUseCase = addOrUpdateTicketUseCase,
        super(TicketEmptyState());

  List<TicketEntity> _allTickets = [];
  TicketStatus currentStatus = TicketStatus.all;
  SortBy sortBy = SortBy.date;

  Future<void> getTickets() async {
    emit(TicketLoadingState());
    final result = await _getTicketsUseCase();
    result.fold(
          (failure) => emit(TicketErrorState(failure.message)),
          (tickets) {
            _allTickets = tickets;

            if (tickets.isEmpty) {
              emit(TicketEmptyState());
            } else {
              _applyFiltersAndSort();
            }
      },
    );
  }

  Future<void> addTicket(TicketEntity ticket) async {
    final result = await _addOrUpdateTicketUseCase(ticket);
    result.fold(
          (failure) => emit(TicketErrorState(failure.message)),
          (_) => getTickets(),
    );
  }

  Future<void> updateTicket(TicketEntity ticket) async {
    final result = await _addOrUpdateTicketUseCase(ticket);
    result.fold(
          (failure) => emit(TicketErrorState(failure.message)),
          (_) => getTickets(),
    );
  }

  void filterByStatus(TicketStatus status) {
    currentStatus = status;
    _applyFiltersAndSort();
  }

  void changeSort(SortBy sort) {
    sortBy = sort;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<TicketEntity> result = [..._allTickets];

    // filter
    if (currentStatus != TicketStatus.all) {
      result = result.where((t) => t.status == currentStatus).toList();
    }

    // order
    switch (sortBy) {
      case SortBy.date:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortBy.priority:
        result.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortBy.none:
        break;
    }

    emit(TicketLoadedState(result));
  }

}

enum SortBy {
  none,
  date,
  priority;

  String get title {
    switch (this) {
      case none:
        return "Nenhum";
      case date:
        return "Ordenar por data";
      case priority:
        return "Ordenar por prioridade";
    }
  }
}