import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_cubit_state.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/domain/usecases/delete_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_state.dart';

import '../../tickets/domain/entities/ticket_entity.dart';
import '../../tickets/domain/usecases/add_or_update_ticket_usecase.dart';

class UpdateTicketCubit extends Cubit<UpdateTicketState>{
  final IAddOrUpdateTicketUseCase _addOrUpdateTicketUseCase;

  UpdateTicketCubit({
    required IAddOrUpdateTicketUseCase addOrUpdateTicketUseCase,
  }) : _addOrUpdateTicketUseCase = addOrUpdateTicketUseCase,
          super(UpdateTicketInitialState());

  Future<void> updateTicket(TicketEntity ticket) async {
    final result = await _addOrUpdateTicketUseCase(ticket);
    result.fold(
          (failure) => emit(ErrorUpdateTicketState(failure.message)),
          (_){
            emit(SuccessUpdateTicketState());
      },
    );
  }

}