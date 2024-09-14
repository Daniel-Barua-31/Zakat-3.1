import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ZakatProvider extends ChangeNotifier {
  late Box<Map> _box;
  List<Map<String, dynamic>> _zakatData = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get zakatData => _zakatData;
  bool get isLoading => _isLoading;

  ZakatProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox<Map>('zakatDistribution');
    await _loadZakatData();
  }

  Future<void> _loadZakatData() async {
    _zakatData = _box.values.map((e) => Map<String, dynamic>.from(e)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrUpdateZakatData(Map<String, dynamic> data) async {
    final sessionYear = data['sessionYear'];
    final existingIndex =
        _zakatData.indexWhere((item) => item['sessionYear'] == sessionYear);

    if (existingIndex != -1) {
      // Update existing entry
      await _box.putAt(existingIndex, Map<String, dynamic>.from(data));
      _zakatData[existingIndex] = data;
    } else {
      // Add new entry
      final key = await _box.add(Map<String, dynamic>.from(data));
      data['key'] = key;
      _zakatData.add(data);
    }
    notifyListeners();
  }

  Future<void> deleteZakatData(int index) async {
    await _box.deleteAt(index);
    _zakatData.removeAt(index);
    notifyListeners();
  }
}
