import 'package:flutter/material.dart';

/// Style configuration for the Crossword PUzzle.
class CrosswordStyle {
  /// Background color of the grid.
  final Color gridBackgroundColor;

  /// Background color of a block (black cell).
  final Color blockColor;

  /// Background color of a normal white cell.
  final Color cellColor;

  /// Background color of the selected cell.
  final Color selectedCellColor;

  /// Background color of cells that are part of the currently selected clue.
  final Color highlightColor;

  /// Color of the border around cells.
  final Color cellBorderColor;

  /// Color of the clue number in the cell.
  final Color clueNumberColor;

  /// Color of the text entered in the cell.
  final Color textColor;

  /// Color of the selected cell's text.
  final Color selectedTextColor;

  /// Color of the hint text (shown when showHints is true).
  final Color hintColor;

  /// Font size for the clue number.
  final double clueNumberFontSize;

  /// Font size for the cell text.
  final double cellTextFontSize;

  /// Font weight for the cell text.
  final FontWeight cellTextFontWeight;

  /// Border radius for the cells.
  final double cellBorderRadius;

  /// Spacing between cells in the grid.
  final double gridSpacing;

  const CrosswordStyle({
    this.gridBackgroundColor = Colors.white,
    this.blockColor = const Color(0xFF1E293B), // darkBlueColor2
    this.cellColor = Colors.white,
    this.selectedCellColor = const Color(0xFF60A5FA), // blueColor2
    this.highlightColor = const Color(0xFFDBEAFE), // lightBlueColor4
    this.cellBorderColor = const Color(0xFFE2E8F0), // greyColor2
    this.clueNumberColor = const Color(0xFF64748B), // slateGreyColor2
    this.textColor = const Color(0xFF1E293B), // darkBlueColor2
    this.selectedTextColor = Colors.white,
    this.hintColor = const Color(0x999E9E9E), // greyOpacity9
    this.clueNumberFontSize = 8,
    this.cellTextFontSize = 16,
    this.cellTextFontWeight = FontWeight.bold,
    this.cellBorderRadius = 2,
    this.gridSpacing = 2,
  });
}
