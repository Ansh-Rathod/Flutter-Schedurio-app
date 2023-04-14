import 'package:hive/hive.dart';

/// HiveContract is an abstract class that defines the methods that can be used
/// to access the hive box methods
abstract class HiveContract<E> {
  // default hive box methods
  ///init hive box
  Future<void> init();

  ///close hive box
  Future<void> dispose();

  // write new value
  /// add new value to hive box
  Future<void> add(E element);

  /// put new value to hive box
  Future<void> put(dynamic key, E element);

  /// write new value to hive box
  Future<void> write(String key, E value);

  /// write all values to hive box
  Future<void> writeAll(String key, Map<dynamic, E> value);

  // get value
  /// check if key exists in hive box
  bool hasKey(String key);

  /// get value from hive box
  E? get(String key);

  /// get value from hive box at index
  Future<dynamic> keyAt(int index);

  /// get value from hive box at index
  Future<E?> getAt(int index);

  //  remove methods
  /// remove value from hive box
  Future<void> remove(dynamic key);

  /// delete value from hive box at index
  Future<void> deleteAt(int index);

  /// clear hive box
  Future<void> clear();

  // get all entries
  /// get all entries from hive box
  dynamic get entries;

  /// get all keys from hive box
  Iterable<E> get values;
}

/// HiveStorageImplementation is a class that implements HiveContract and is used to access the hive box methods
class HiveStorageImplementation<E> implements HiveContract<E> {
  /// Implements HiveContract
  HiveStorageImplementation(this._box);

  final Box<E> _box;

  @override
  dynamic get entries => _box.toMap();

  @override
  Future<void> init() async {
    _guard();
  }

  @override
  Future<void> dispose() async {
    _guard();
    await _box.close();
  }

  @override
  Future<dynamic> keyAt(int index) async {
    _guard();
    return await _box.keyAt(index);
  }

  @override
  Future<E?> getAt(int index) async {
    _guard();
    return _box.getAt(index);
  }

  @override
  Future<void> deleteAt(int index) async {
    _guard();
    return await _box.deleteAt(index);
  }

  @override
  bool hasKey(String key) {
    _guard();
    return _box.containsKey(key);
  }

  @override
  E? get(String key) {
    _guard();
    return _box.get(key);
  }

  @override
  Future<void> remove(dynamic key) async {
    print(key);
    print(key is int);
    print(key is String);
    _guard();
    await _box.delete(key);
  }

  @override
  Future<void> write(String key, E value) async {
    _guard();
    await _box.put(key, value);
  }

  @override
  Future<void> clear() async {
    _guard();
    await _box.clear();
  }

  @override
  Future<void> writeAll(String key, Map<dynamic, E> value) async {
    _guard();
    await _box.putAll(value);
  }

  void _guard() {
    assert(_box.isOpen, 'Box with name ${_box.name} is not open');
  }

  @override
  Future<void> add(E element) {
    _guard();
    return _box.add(element);
  }

  @override
  Future<void> put(key, E element) {
    _guard();
    return _box.put(key, element);
  }

  @override
  Iterable<E> get values => _box.values;
}
