import 'package:dartz/dartz.dart';
import '../api/charcters_web_services.dart';
import '../models/QWE.dart';
import '../models/character.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    final allData = await charactersWebServices.getAllCharacters();
    Qwe a = Qwe.fromJson(allData);
    return a.results?.map((e) => Character.fromResult(e)).toList() ?? [];
  }

  Future<List<Character>> getCharacterQuotes(String name, String status,
      String species, String type, String gender) async {
    final allData = await charactersWebServices.getCharacterQuotes(
        name, status, species, type, gender);
    return allData.map((e) => Character.fromJson(e)).toList();
  }
}
