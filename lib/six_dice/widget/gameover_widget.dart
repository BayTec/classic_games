import 'package:flutter/material.dart';
import 'package:classic_games/six_dice/player/player.dart';
import 'package:classic_games/six_dice/widget/finished_players_widget.dart';

class GameoverWidget extends StatelessWidget {
  final List<List<Player>> finischedPlayers;

  const GameoverWidget(this.finischedPlayers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish'),
      ),
      body: Column(
        children: [
          FinishedPlayersWidget(finischedPlayers: finischedPlayers),
        ],
      ),
    );
  }
}
