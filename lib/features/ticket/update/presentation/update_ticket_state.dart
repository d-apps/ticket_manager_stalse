sealed class UpdateTicketState {}

class UpdateTicketInitialState extends UpdateTicketState {}

class SuccessUpdateTicketState extends UpdateTicketState {}

  class ErrorUpdateTicketState extends UpdateTicketState {
  final String message;
  ErrorUpdateTicketState(this.message);
}