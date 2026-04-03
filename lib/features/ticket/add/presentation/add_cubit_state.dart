sealed class AddTicketState {}

class AddTicketInitialState extends AddTicketState {}

class SuccessAddTicketState extends AddTicketState {}

  class ErrorAddTicketState extends AddTicketState {
  final String message;
  ErrorAddTicketState(this.message);
}