abstract class IPersistenceService<T> {
  Future<List<T>> getAll();
  Future<void> put(String key, T value);
  Future<void> putAll(Map<String, T> entries);
  Stream<List<T>> watchAll();
}