

import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  void saveString(String key, String value) => _box.write(key, value);

  String? readString(String key) => _box.read(key);

  void remove(String key) => _box.remove(key);

  void saveMap(String key, Map<String, dynamic> map) => _box.write(key, map);

  Map<String, dynamic>? readMap(String key) =>
      _box.read(key)?.cast<String, dynamic>();
}


