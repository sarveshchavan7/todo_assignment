abstract class Repository<T> {
  Future<int> add(T data);
  Future<int> delete(T data);
  Future<int> update(T data);
  Future<List<T>> view(Map filter);
}
