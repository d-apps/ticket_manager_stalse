import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/add_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/get_tickets_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import '../domain/usecases/update_ticket_usecase.dart';

class TicketsCubit extends Cubit<TicketState> {
  final IGetTicketsUseCase _getTicketsUseCase;
  final IAddTicketUseCase _addTicketUseCase;
  final IUpdateTicketUseCase _updateTicketUseCase;

  TicketsCubit({
    required IGetTicketsUseCase getTicketsUseCase,
    required IAddTicketUseCase addTicketUseCase,
    required IUpdateTicketUseCase updateTicketUseCase
  })
    : _getTicketsUseCase = getTicketsUseCase,
      _addTicketUseCase = addTicketUseCase,
      _updateTicketUseCase = updateTicketUseCase,
        super(TicketEmptyState());

  List<TicketEntity> _allTickets = [];
  TicketStatus currentStatus = TicketStatus.all;
  SortBy sortBy = SortBy.none;

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
              emit(TicketLoadedState(tickets));
            }
      },
    );
  }

  Future<void> addTicket(TicketEntity ticket) async {
    emit(TicketLoadingState());
    final result = await _addTicketUseCase(ticket);
    result.fold(
          (failure) => emit(TicketErrorState(failure.message)),
          (_) => getTickets(),
    );
  }

  void filterByStatus(TicketStatus status) {
    if(status == TicketStatus.all){
      clearFilters();
      return;
    }

    final filtered =
    _allTickets.where((t) => t.status == status).toList();

    emit(TicketLoadedState(filtered));
  }

  void clearFilters() {
    emit(TicketLoadedState(_allTickets));
  }

  void sort(){
    switch(sortBy){
      case SortBy.none:
        clearFilters();
        break;
      case SortBy.date:
        sortByDate();
        break;
      case SortBy.priority:
        sortByPriority();
        break;
    }
  }

  void sortByDate({bool descending = true}) {
    final sorted = [..._allTickets];

    sorted.sort((a, b) => descending
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));

    emit(TicketLoadedState(sorted));
  }

  void sortByPriority({bool descending = true}) {
    final sorted = [..._allTickets];

    sorted.sort((a, b) => descending
        ? b.priority.index.compareTo(a.priority.index)
        : a.priority.index.compareTo(b.priority.index));

    emit(TicketLoadedState(sorted));
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