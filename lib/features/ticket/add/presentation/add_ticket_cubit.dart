import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_cubit_state.dart';

import '../../tickets/domain/entities/ticket_entity.dart';
import '../../tickets/domain/usecases/add_or_update_ticket_usecase.dart';

class AddTicketCubit extends Cubit<AddTicketState>{
  final IAddOrUpdateTicketUseCase _addOrUpdateTicketUseCase;

  AddTicketCubit({ required IAddOrUpdateTicketUseCase addOrUpdateTicketUseCase })
      : _addOrUpdateTicketUseCase = addOrUpdateTicketUseCase,
        super(AddTicketInitialState());

  Future<void> addTicket(TicketEntity ticket) async {
    final result = await _addOrUpdateTicketUseCase(ticket);
    result.fold(
          (failure) => emit(ErrorAddTicketState(failure.message)),
          (_){
            emit(SuccessAddTicketState());
          },
    );
  }

}