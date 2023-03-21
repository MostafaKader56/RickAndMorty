import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../core/constants/my_colors.dart';
import '../../data/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  const CharacterDetailsScreen({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getCharacterQuotes(
        character.name!,
        character.status!,
        character.species!,
        character.type!,
        character.gender!);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chracterInfo('Status: ', character.status!),
                      widgitsDivider(260),
                      chracterInfo('Species: ', character.species!),
                      widgitsDivider(250),
                      character.type!.isEmpty
                          ? Container()
                          : chracterInfo('Type: ', character.type!),
                      character.type!.isEmpty
                          ? Container()
                          : widgitsDivider(275),
                      chracterInfo('Gender: ', character.gender!),
                      widgitsDivider(255),
                      chracterInfo('Location: ', character.location!.name!),
                      widgitsDivider(240),
                      chracterInfo('Origin: ', character.origin!.name!),
                      widgitsDivider(260),
                      SizedBox(height: 20.0),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkQuotesAreLoaded(state);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 500.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.name!,
          style: TextStyle(
            color: MyColors.myWhite,
          ),
        ),
        background: Hero(
          tag: character.id!,
          child: Image.network(
            character.image!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget chracterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
              text: title,
              style: TextStyle(
                color: MyColors.myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )),
          TextSpan(
              text: value,
              style: TextStyle(
                color: MyColors.myWhite,
                fontSize: 16.0,
              )),
        ],
      ),
    );
  }

  Widget widgitsDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30.0,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkQuotesAreLoaded(CharactersState state) {
    if (state is CharacterQuotesLoaded) {
      return diplayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget diplayRandomQuoteOrEmptySpace(CharacterQuotesLoaded state) {
    var quotes = state.characters;
    if (quotes.isNotEmpty) {
      int randomQuotesIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: MyColors.myWhite,
            shadows: [
              Shadow(
                  blurRadius: 7, color: MyColors.myYellow, offset: Offset(0, 0))
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuotesIndex].id.toString()),
              // FlickerAnimatedText('Flicker Frenzy'),
              // FlickerAnimatedText('Night Vibes On'),
              // FlickerAnimatedText('C\'est La Vie !'),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }
}
