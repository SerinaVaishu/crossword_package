import 'package:flutter/foundation.dart';

/// Direction of a crossword clue.
enum ClueDirection { across, down }

/// Represents a single clue in the crossword.
class CrosswordClue {
  /// The number displayed in the grid for this clue.
  final int number;

  /// The clue/question text.
  final String question;

  /// The correct answer for this clue.
  final String answer;

  /// The starting row in the grid (0-indexed).
  final int row;

  /// The starting column in the grid (0-indexed).
  final int col;

  /// The direction of the clue (across or down).
  final ClueDirection direction;

  CrosswordClue({
    required this.number,
    required this.question,
    required this.answer,
    required this.row,
    required this.col,
    required this.direction,
  });

  /// Length of the answer.
  int get length => answer.length;

  /// Helper to convert from JSON
  factory CrosswordClue.fromJson(Map<String, dynamic> json) {
    return CrosswordClue(
      number: json['number'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      row: json['row'] as int,
      col: json['col'] as int,
      direction: json['direction'] == 'across'
          ? ClueDirection.across
          : ClueDirection.down,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'question': question,
        'answer': answer,
        'row': row,
        'col': col,
        'direction': direction == ClueDirection.across ? 'across' : 'down',
      };
}

/// Represents the entire crossword puzzle.
class CrosswordPuzzle {
  /// Unique identifier or title for the puzzle.
  final String title;

  /// The dimension of the square grid (e.g., 10 for a 10x10 grid).
  final int gridSize;

  /// List of clues for the puzzle.
  final List<CrosswordClue> clues;

  /// Difficulty level (optional).
  final String? level;

  /// Reward points for completing (optional).
  final int? points;

  CrosswordPuzzle({
    required this.title,
    required this.gridSize,
    required this.clues,
    this.level,
    this.points,
  });

  factory CrosswordPuzzle.fromJson(Map<String, dynamic> json) {
    return CrosswordPuzzle(
      title: json['title'] as String,
      gridSize: json['gridSize'] as int,
      clues: (json['clues'] as List)
          .map((e) => CrosswordClue.fromJson(e as Map<String, dynamic>))
          .toList(),
      level: json['level'] as String?,
      points: json['points'] as int?,
    );
  }
}

/// Represents a single cell in the crossword grid.
class GridCell {
  final int row;
  final int col;

  /// The correct letter for this cell (null for blocks).
  final String? correctLetter;

  /// The current letter entered by the user.
  String? currentLetter;

  /// The number to display in the corner (null if no clue starts here).
  final int? clueNumber;

  /// The clues that pass through this cell.
  final List<CrosswordClue> associatedClues;

  GridCell({
    required this.row,
    required this.col,
    this.correctLetter,
    this.currentLetter,
    this.clueNumber,
    required this.associatedClues,
  });

  /// True if this cell is a solid block (not part of any clue).
  bool get isBlock => correctLetter == null;

  /// True if the user has entered the correct letter.
  bool get isCorrect =>
      currentLetter != null && currentLetter == correctLetter?.toUpperCase();
}
