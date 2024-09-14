import 'package:hive/hive.dart';

class ZakatCalculationDataBase{


  List<Map<String, dynamic>> savedDataList = [];
  final _boxZakat = Hive.box('boxZakat');


}