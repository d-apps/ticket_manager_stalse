import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_cubit_state.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/domain/usecases/delete_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_state.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_state.dart';

import '../../tickets/domain/entities/ticket_entity.dart';
import '../../tickets/domain/usecases/add_or_update_ticket_usecase.dart';

class TicketDetailCubit extends Cubit<TicketDetailState>{
  final IDeleteTicketUseCase _deleteTicketUseCase;

  TicketDetailCubit({
    required IDeleteTicketUseCase deleteTicketUseCase,
  }) :
        _deleteTicketUseCase = deleteTicketUseCase,
          super(TicketDetailInitialState());

  Future<void> deleteTicket(String id) async {
    final result = await _deleteTicketUseCase(id);
    result.fold(
          (failure) => emit(ErrorTicketDetailState(failure.message)),
          (_){
            emit(DeletedTicketDetailState());
      },
    );
  }

}