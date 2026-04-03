sealed class TicketDetailState {}

class TicketDetailInitialState extends TicketDetailState {}

class DeletedTicketDetailState extends TicketDetailState {}

  class ErrorTicketDetailState extends TicketDetailState {
  final String message;
  ErrorTicketDetailState(this.message);
}