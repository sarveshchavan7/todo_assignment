abstract class Repository<T> {
  Future<void> add(T data);
  Future<void> delete(T data);
  Future<void> update(T data);
  Future<List<T>> viewAll();
}
