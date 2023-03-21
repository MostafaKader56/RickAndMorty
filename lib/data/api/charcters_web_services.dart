import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/constants/strings.dart';
import '../models/QWE.dart';

class CharactersWebServices {
  late Dio dio;

  CharactersWebServices() {
    BaseOptions baseOptions = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10));
    dio = Dio(baseOptions);
  }

  Future<Map<String, dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('character');
      print("AZX:R> " + response.data.toString());
      return response.data;
    } catch (e) {
      print("AZX:E> " + e.toString());
      return Map();
    }
  }

  Future<List<dynamic>> getCharacterQuotes(String name, String status,
      String species, String type, String gender) async {
    try {
      Response response = await dio.get('character', queryParameters: {
        'name': name,
        'status': status,
        'species': species,
        'type': type,
        'gender': gender,
      });
      print("QWE:R> " + response.data.toString());
      return response.data['results'];
    } catch (e) {
      print("QWE:E> " + e.toString());
      return [];
    }
  }
}
