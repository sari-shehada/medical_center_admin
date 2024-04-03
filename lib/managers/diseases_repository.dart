import 'dart:convert';

import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/shared_prefs_service.dart';
import 'package:medical_center_admin/models/disease.dart';

class DiseasesRepository {
  static Future<List<Disease>>? _diseasesFuture;

  static Future<List<Disease>> get diseases => _diseasesFuture ?? getDiseases();

  static Future<List<Disease>> getDiseases() async {
    _diseasesFuture ??= fetchDiseases();
    return _diseasesFuture!;
  }

  static Future<List<Disease>> fetchDiseases() async {
    var result = _fetchFromSharedPrefs();
    if (result.isEmpty) {
      result = await HttpService.parsedMultiGet(
        endPoint: 'diseases/',
        mapper: Disease.fromMap,
      );
      await SharedPreferencesService.instance.setString(
        key: 'diseases',
        value: jsonEncode(result),
      );
    }

    return result;
  }

  static List<Disease> _fetchFromSharedPrefs() {
    String? result = SharedPreferencesService.instance.getString('diseases');
    if (result == null) {
      return [];
    }
    return (jsonDecode(result) as List)
        .map<Disease>(
          (e) => Disease.fromMap(
            jsonDecode(e) as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
