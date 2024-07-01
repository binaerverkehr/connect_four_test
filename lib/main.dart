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
      debugShowCheckedModeBanner: false,
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
  late Game _game;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _game = Game(board: Board(rows: 6, columns: 7));
    });
  }

  Widget _buildPlayerToken(Player player, double size) {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGameStatus(),
              const SizedBox(height: 30),
              AspectRatio(
                aspectRatio: 7 / 6,
                child: _buildGameBoard(),
              ),
              const SizedBox(height: 80),
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_game.winner == null && !_game.isDraw)
          Row(
            children: [
              const Text('Current Player: ', style: TextStyle(fontSize: 18)),
              _buildPlayerToken(_game.winner ?? _game.currentPlayer, 30),
            ],
          ),
        if (_game.winner != null)
          Row(
            children: [
              _buildPlayerToken(_game.winner ?? _game.currentPlayer, 30),
              const SizedBox(width: 10),
              const Text(
                'wins! ',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        if (_game.isDraw)
          const Text(
            'It\'s a draw!',
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }

  Widget _buildGameBoard() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _game.board.columns,
      ),
      itemCount: _game.board.rows * _game.board.columns,
      itemBuilder: (context, index) {
        int row = index ~/ _game.board.columns;
        int col = index % _game.board.columns;
        return GestureDetector(
          onTap: () {
            if (_game.winner == null && !_game.isDraw) {
              setState(() {
                _game.makeMove(col);
              });
            }
          },
          child: _buildBoardCell(row, col),
        );
      },
    );
  }

  Widget _buildBoardCell(int row, int col) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _game.board.getCell(row, col) == Player.yellow
            ? Colors.yellow
            : _game.board.getCell(row, col) == Player.red
                ? Colors.red
                : Colors.white,
        border: Border.all(color: Colors.black),
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Text(
        _game.winner != null || _game.isDraw ? 'New Game' : 'Reset Game',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
