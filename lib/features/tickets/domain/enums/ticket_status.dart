enum TicketStatus {
  all,
  open,
  closed;

  String get title {
    switch (this) {
      case all:
        return "Todos";
      case open:
        return "Aberto";
      case closed:
        return "Fechado";
    }
  }

  factory TicketStatus.fromString(String value){
    switch (value) {
      case 'all':
        return all;
      case 'open':
        return open;
      case 'closed':
        return closed;
      default:
        throw Exception('Invalid ticket status: $value');
    }
  }

}