import 'package:connect_four_test/models/board.dart';
import 'package:connect_four_test/models/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Board', () {
    test('should initialize with empty cells', () {
      final board = Board(rows: 6, columns: 7);
      for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 7; j++) {
          expect(board.getCell(i, j), equals(Player.none));
        }
      }
    });

    test('should validate moves correctly', () {
      final board = Board(rows: 6, columns: 7);
      expect(board.isValidMove(0), isTrue);
      expect(board.isValidMove(6), isTrue);
      expect(board.isValidMove(7), isFalse);
      expect(board.isValidMove(-1), isFalse);
    });

    test('should place piece at the bottom of the column', () {
      final board = Board(rows: 6, columns: 7);
      board.placePiece(3, Player.yellow);
      expect(board.getCell(5, 3), equals(Player.yellow));
      expect(board.getCell(4, 3), equals(Player.none));
    });

    test('should stack pieces in the same column', () {
      final board = Board(rows: 6, columns: 7);
      board.placePiece(3, Player.yellow);
      board.placePiece(3, Player.red);
      expect(board.getCell(5, 3), equals(Player.yellow));
      expect(board.getCell(4, 3), equals(Player.red));
      expect(board.getCell(3, 3), equals(Player.none));
    });

    test('should not allow moves in full columns', () {
      final board = Board(rows: 6, columns: 7);
      for (int i = 0; i < 6; i++) {
        expect(board.isValidMove(0), isTrue);
        board.placePiece(0, Player.yellow);
      }
      expect(board.isValidMove(0), isFalse);
    });
  });
}
