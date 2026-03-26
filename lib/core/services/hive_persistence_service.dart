import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';

class HivePersistenceService implements IPersistenceService {
  final Box<dynamic> box;

  HivePersistenceService({ required this.box});

  @override
  Future<List<dynamic>> getAll() async {
    final data = box.values.toList();
    return data;
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await box.put(key, value);
  }

  @override
  Future<void> putAll(Map<String, dynamic> entries) async {
    await box.putAll(entries);
  }

  @override
  Stream<List<dynamic>> watchAll() {
    return box.watch().map((_) => box.values.toList());
  }

}