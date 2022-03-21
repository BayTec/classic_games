import 'package:flutter/material.dart';
import 'package:six_dice/game/game.dart';
import 'package:six_dice/player/player.dart';
import 'package:six_dice/player/widget_player/widget_player.dart';
import 'package:six_dice/widget/winners_widget.dart';

class WidgetGame extends StatefulWidget implements Game {
  final List<WidgetPlayer> _players;
  final List<Player> winners;

  WidgetGame(this._players, {Key? key})
      : winners = [],
        super(key: key);

  @override
  State<WidgetGame> createState() => _WidgetGameState();

  @override
  void play() {}

  @override
  List<WidgetPlayer> players() => _players;
}

class _WidgetGameState extends State<WidgetGame> {
  WidgetPlayer? currentPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          onPressed: () async {
            bool quit = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Quit'),
                    content:
                        const Text('Are you shure you want to quit the game?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Quit',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (quit) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Scores'),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.players().length,
            itemBuilder: (context, index) {
              final player = widget.players()[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(player.name()),
                    const Text(':'),
                    Text(player.score().toString()),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          currentPlayer ??= widget.players().first;
          bool turn = true;

          int startIndex = widget
              .players()
              .indexWhere((element) => element.name() == currentPlayer!.name());

          do {
            for (int i = startIndex; i < widget.players().length; i++) {
              currentPlayer = widget.players()[i];

              turn = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => currentPlayer!.widget(),
                    ),
                  ) ??
                  true;

              if (currentPlayer!.score() >= 5000) {
                widget.winners.add(currentPlayer!);
              }

              setState(() {});

              if (!turn) {
                break;
              }
            }

            startIndex = 0;

            if (turn && widget.winners.isNotEmpty) {
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WinnersWidget(widget.winners)));
              break;
            }
          } while (turn);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
