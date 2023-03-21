import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../core/constants/my_colors.dart';
import '../../data/models/character.dart';
import '../widgets/chracter_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character>? allChracters;
  List<Character>? searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
          hintText: 'Find a character...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18)),
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = allChracters
        ?.where((character) =>
            character.name!.toLowerCase().contains(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColors.myGrey,
            ))
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        )
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharcters();
  }

  Widget buildBlocWiget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: ((context, state) {
        if (state is CharactersLoaded) {
          allChracters = (state).characters;
          return builLoadedListWidget();
        } else {
          return showLoadingIndicator();
        }
      }),
    );
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget builLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [buildChractersList()],
        ),
      ),
    );
  }

  Widget buildChractersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allChracters?.length
          : searchedForCharacters?.length,
      itemBuilder: (ctx, index) {
        return CharacterItem(
            character: _searchTextController.text.isEmpty
                ? allChracters![index]
                : searchedForCharacters![index]);
      },
    );
  }

  Widget _biuldAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        leading: _isSearching
            ? BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
        title: _isSearching ? _buildSearchField() : _biuldAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWiget();
          } else {
            return buildNoInternetWiget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }

  Widget buildNoInternetWiget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Can\'t connect, Check Internet.',
              style: TextStyle(
                fontSize: 20.0,
                color: MyColors.myGrey,
              ),
            ),
            Image.asset('assets/images/no_internet.png')
          ],
        ),
      ),
    );
  }
}
