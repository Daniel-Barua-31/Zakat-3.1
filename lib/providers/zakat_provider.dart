import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ZakatProvider extends ChangeNotifier {
  late Box<Map> _box;
  late Box<Map> _advanceDonationBox;
  List<Map<String, dynamic>> _zakatData = []; // Zakat Calculation Data
  List<Map<String, dynamic>> _advanceDonationData = []; // Advance Donation Data
  bool _isLoading = true;

  List<Map<String, dynamic>> get zakatData => _zakatData;
  List<Map<String, dynamic>> get advanceDonationData => _advanceDonationData;
  bool get isLoading => _isLoading;

  ZakatProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox<Map>('zakatDistribution');
    _advanceDonationBox = await Hive.openBox<Map>('advanceDonation');
    await _loadZakatData();
  }

  Future<void> _loadZakatData() async {
    _zakatData = _box.values.map((e) => Map<String, dynamic>.from(e)).toList();
    _advanceDonationData = _advanceDonationBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
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

  Future<Box<Map>> _getAdvanceDonationBox() async {
    if (!Hive.isBoxOpen('advanceDonation')) {
      return await Hive.openBox<Map>('advanceDonation');
    }
    return Hive.box<Map>('advanceDonation');
  }

  Future<void> addAdvanceDonation(Map<String, dynamic> data) async {
    final key = await _advanceDonationBox.add(Map<String, dynamic>.from(data));
    data['key'] = key;
    _advanceDonationData.add(data);
    notifyListeners();
  }

  Future<void> deleteZakatData(int index) async {
    await _box.deleteAt(index);
    _zakatData.removeAt(index);
    notifyListeners();
  }

  Future<void> deleteAdvanceDonation(int index) async {
    await _advanceDonationBox.deleteAt(index);
    _advanceDonationData.removeAt(index);
    notifyListeners();
  }
}
