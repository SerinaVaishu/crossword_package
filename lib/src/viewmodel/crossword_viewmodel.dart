import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/crossword_model.dart';

class CrosswordViewModel extends ChangeNotifier {
  final CrosswordPuzzle puzzle;
  late List<List<GridCell>> grid;

  int? _selectedRow;
  int? _selectedCol;
  ClueDirection _currentDirection = ClueDirection.across;
  bool _showHints = false;
  bool _isLoading = true;

  // Getters
  int? get selectedRow => _selectedRow;
  int? get selectedCol => _selectedCol;
  ClueDirection get currentDirection => _currentDirection;
  bool get showHints => _showHints;
  bool get isLoading => _isLoading;

  /// Callback when the puzzle is completed.
  final VoidCallback? onCompleted;

  CrosswordViewModel({
    required this.puzzle,
    this.onCompleted,
  }) {
    _initializeGrid();
    _isLoading = false;
  }

  void _initializeGrid() {
    grid = List.generate(
      puzzle.gridSize,
      (r) => List.generate(
        puzzle.gridSize,
        (c) => GridCell(row: r, col: c, associatedClues: []),
      ),
    );

    for (var clue in puzzle.clues) {
      for (int i = 0; i < clue.length; i++) {
        int r = clue.direction == ClueDirection.across ? clue.row : clue.row + i;
        int c = clue.direction == ClueDirection.across ? clue.col + i : clue.col;

        if (r < puzzle.gridSize && c < puzzle.gridSize) {
          String char = clue.answer[i].toUpperCase();
          int? clueNum = (i == 0) ? clue.number : grid[r][c].clueNumber;

          grid[r][c] = GridCell(
            row: r,
            col: c,
            correctLetter: char,
            currentLetter: grid[r][c].currentLetter,
            clueNumber: clueNum,
            associatedClues: [...grid[r][c].associatedClues, clue],
          );
        }
      }
    }

    if (puzzle.clues.isNotEmpty) {
      selectCell(puzzle.clues.first.row, puzzle.clues.first.col);
    }
  }

  void selectCell(int r, int c) {
    if (grid[r][c].isBlock) return;

    if (_selectedRow == r && _selectedCol == c) {
      _toggleDirection();
    } else {
      _selectedRow = r;
      _selectedCol = c;

      var clues = grid[r][c].associatedClues;
      if (clues.isNotEmpty) {
        if (!clues.any((clue) => clue.direction == _currentDirection)) {
          _currentDirection = clues.first.direction;
        }
      }
    }
    notifyListeners();
  }

  void _toggleDirection() {
    if (_selectedRow == null || _selectedCol == null) return;
    var clues = grid[_selectedRow!][_selectedCol!].associatedClues;
    if (clues.length > 1) {
      _currentDirection = _currentDirection == ClueDirection.across
          ? ClueDirection.down
          : ClueDirection.across;
    }
  }

  void updateLetter(String letter) {
    if (_selectedRow == null || _selectedCol == null) return;

    grid[_selectedRow!][_selectedCol!].currentLetter = letter.toUpperCase();
    
    if (isPuzzleCompleted()) {
       onCompleted?.call();
    } else {
      _moveToNextCell();
    }
    
    notifyListeners();
  }

  void _moveToNextCell() {
    var currentClue = selectedClue;
    if (currentClue == null) return;

    int nextR = _selectedRow!;
    int nextC = _selectedCol!;

    if (_currentDirection == ClueDirection.across) {
      nextC++;
    } else {
      nextR++;
    }

    if (nextR < puzzle.gridSize &&
        nextC < puzzle.gridSize &&
        !grid[nextR][nextC].isBlock) {
      _selectedRow = nextR;
      _selectedCol = nextC;
    }
  }

  void deleteLetter() {
    if (_selectedRow == null || _selectedCol == null) return;

    if (grid[_selectedRow!][_selectedCol!].currentLetter != null) {
      grid[_selectedRow!][_selectedCol!].currentLetter = null;
    } else {
      _moveToPreviousCell();
    }
    notifyListeners();
  }

  void _moveToPreviousCell() {
    var currentClue = selectedClue;
    if (currentClue == null) return;

    int prevR = _selectedRow!;
    int prevC = _selectedCol!;

    if (_currentDirection == ClueDirection.across) {
      prevC--;
    } else {
      prevR--;
    }

    if (prevR >= 0 && prevC >= 0 && !grid[prevR][prevC].isBlock) {
      _selectedRow = prevR;
      _selectedCol = prevC;
    }
  }

  void toggleHints() {
    _showHints = !_showHints;
    notifyListeners();
  }

  bool isCellSelected(int r, int c) => _selectedRow == r && _selectedCol == c;

  bool isCellInCurrentClue(int r, int c) {
    var currentClue = selectedClue;
    if (currentClue == null) return false;

    if (currentClue.direction == ClueDirection.across) {
      return r == currentClue.row &&
          c >= currentClue.col &&
          c < currentClue.col + currentClue.length;
    } else {
      return c == currentClue.col &&
          r >= currentClue.row &&
          r < currentClue.row + currentClue.length;
    }
  }

  bool isClueCompleted(CrosswordClue clue) {
    for (int i = 0; i < clue.length; i++) {
      int r = clue.direction == ClueDirection.across ? clue.row : clue.row + i;
      int c = clue.direction == ClueDirection.across ? clue.col + i : clue.col;

      // Bounds check to avoid RangeError
      if (r < 0 || r >= puzzle.gridSize || c < 0 || c >= puzzle.gridSize) {
        continue;
      }

      if (grid[r][c].currentLetter != clue.answer[i].toUpperCase()) {
        return false;
      }
    }
    return true;
  }

  bool isPuzzleCompleted() {
    for (var clue in puzzle.clues) {
      if (!isClueCompleted(clue)) return false;
    }
    return true;
  }

  int get completedCluesCount {
    int count = 0;
    for (var clue in puzzle.clues) {
      if (isClueCompleted(clue)) count++;
    }
    return count;
  }

  CrosswordClue? get selectedClue {
    if (_selectedRow == null || _selectedCol == null) return null;
    final cell = grid[_selectedRow!][_selectedCol!];
    return cell.associatedClues.firstWhereOrNull(
      (c) => c.direction == _currentDirection,
    ) ?? cell.associatedClues.firstOrNull;
  }

  List<CrosswordClue> get acrossClues =>
      puzzle.clues.where((c) => c.direction == ClueDirection.across).toList();

  List<CrosswordClue> get downClues =>
      puzzle.clues.where((c) => c.direction == ClueDirection.down).toList();
}
