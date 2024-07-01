import 'package:connect_four_test/models/board.dart';
import 'package:connect_four_test/models/game.dart';
import 'package:connect_four_test/models/player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Four',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game(board: Board(rows: 6, columns: 7));
  }

  void resetGame() {
    setState(() {
      game = Game(board: Board(rows: 6, columns: 7));
    });
  }

  Widget buildPlayerToken(Player player, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: player == Player.yellow ? Colors.yellow : Colors.red,
        border: Border.all(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Four')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (game.winner == null && !game.isDraw)
                              const Text('Current Player: ', style: TextStyle(fontSize: 18)),
                            if (game.winner != null)
                              Text(
                                'Player ${game.winner == Player.yellow ? "Yellow" : "Red"} wins! ',
                                style: const TextStyle(fontSize: 18),
                              ),
                            if (game.isDraw)
                              const Text(
                                'It\'s a draw!',
                                style: TextStyle(fontSize: 18),
                              ),
                            buildPlayerToken(game.winner ?? game.currentPlayer, 30),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 7 / 6,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: game.board.columns,
                            ),
                            itemCount: game.board.rows * game.board.columns,
                            itemBuilder: (context, index) {
                              int row = index ~/ game.board.columns;
                              int col = index % game.board.columns;
                              return GestureDetector(
                                onTap: () {
                                  if (game.winner == null && !game.isDraw) {
                                    setState(() {
                                      game.makeMove(col);
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: game.board.getCell(row, col) == Player.yellow
                                        ? Colors.yellow
                                        : game.board.getCell(row, col) == Player.red
                                            ? Colors.red
                                            : Colors.white,
                                    border: Border.all(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: resetGame,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              child: Text(
                                game.winner != null || game.isDraw ? 'New Game' : 'Reset Game',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
