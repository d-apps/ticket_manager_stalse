enum TicketStatus {
  open,
  closed;

  String get title {
    switch (this) {
      case open:
        return "Aberto";
      case closed:
        return "Fechado";
    }
  }

  factory TicketStatus.fromString(String value){
    switch (value) {
      case 'open':
        return open;
      case 'closed':
        return closed;
      default:
        throw Exception('Invalid ticket status: $value');
    }
  }

}