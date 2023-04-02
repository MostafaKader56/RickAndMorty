import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/models/character.dart';
import '../../data/repositories/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  final CharactersRepository charactersRepository;
  List<Character>? characters;
  List<Character>? loadedCharacters;

  void getAllCharcters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
  }

  void getCharacterQuotes(
      String name, String status, String species, String type, String gender) {
    charactersRepository
        .getCharacterQuotes(name, status, species, type, gender)
        .then((loadedCharacters) {
      emit(CharacterQuotesLoaded(loadedCharacters));
    });
  }
}
