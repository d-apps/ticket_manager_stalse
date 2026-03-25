import 'package:hive_ce/hive.dart';
import '../../domain/enums/ticket_priority.dart';
import '../../domain/enums/ticket_status.dart';
import 'ticket_model.dart';

class TicketModelAdapter extends TypeAdapter<TicketModel> {
  @override
  final int typeId = 0;

  @override
  TicketModel read(BinaryReader reader) {
    return TicketModel(
      id: reader.readString(),
      createdAt: DateTime.parse(reader.readString()),
      customerName: reader.readString(),
      message: reader.readString(),
      status: TicketStatus.fromString(reader.readString()),
      priority: TicketPriority.fromString(reader.readString()),
      category: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, TicketModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeString(obj.customerName);
    writer.writeString(obj.message);
    writer.writeString(obj.status.title);
    writer.writeString(obj.priority.title);
    writer.writeString(obj.category);
  }
}