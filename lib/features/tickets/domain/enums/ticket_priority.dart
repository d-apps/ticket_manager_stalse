enum TicketPriority {
  low,
  medium,
  high;

  String get title {
    switch (this) {
      case low:
        return "Baixo";
      case medium:
        return "Médio";
      case high:
        return "Alta";
    }
  }

  factory TicketPriority.fromString(String value){
    switch (value) {
      case 'low':
        return low;
      case 'medium':
        return medium;
      case 'high':
        return high;
      default:
        throw Exception('Invalid ticket priority: $value');
    }
  }
}