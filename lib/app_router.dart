import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/cubit/characters_cubit.dart';
import 'data/api/charcters_web_services.dart';
import 'data/models/character.dart';
import 'data/repositories/characters_repository.dart';
import 'presentation/screens/character_details_screen.dart';
import 'presentation/screens/characters_screen.dart';

import 'core/constants/strings.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharactersScreen(),
          ),
        );
      case characterDetailsScreen:
        final Character character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => CharactersCubit(charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
      default:
    }
  }
}
