abstract class IPersistenceService {
  Future<List<dynamic>> getAll();
  Future<void> put(String key, dynamic value);
  Future<void> putAll(Map<String, dynamic> entries);
  Stream<List<dynamic>> watchAll();
}