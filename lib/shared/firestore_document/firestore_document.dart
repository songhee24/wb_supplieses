class FirestoreDocument<T> {
  final String id;
  final T data;

  FirestoreDocument({required this.id, required this.data});
}