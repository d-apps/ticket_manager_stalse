import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';

class HivePersistenceService<T> implements IPersistenceService<T> {
  final Box<T> box;

  HivePersistenceService({ required this.box});

  @override
  Future<List<T>> getAll() async {
    final data = box.values.toList();
    return data;
  }

  @override
  Future<void> put(String key, T value) async {
    await box.put(key, value);
  }

  @override
  Future<void> putAll(Map<String, T> entries) async {
    await box.putAll(entries);
  }

  @override
  Stream<List<T>> watchAll() {
    return box.watch().map((_) => box.values.toList());
  }

}