import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/crossword_viewmodel.dart';
import '../models/crossword_model.dart';
import '../models/crossword_style.dart';

class CrosswordGrid extends StatelessWidget {
  final CrosswordStyle style;

  const CrosswordGrid({
    super.key,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CrosswordViewModel>();
    final gridSize = viewModel.puzzle.gridSize;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: style.gridBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: style.gridSpacing,
            mainAxisSpacing: style.gridSpacing,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final r = index ~/ gridSize;
            final c = index % gridSize;
            final cell = viewModel.grid[r][c];

            return _GridCellWidget(
              row: r,
              col: c,
              cell: cell,
              isSelected: viewModel.isCellSelected(r, c),
              isInClue: viewModel.isCellInCurrentClue(r, c),
              showHint: viewModel.showHints,
              onTap: () => viewModel.selectCell(r, c),
              style: style,
            );
          },
        ),
      ),
    );
  }
}

class _GridCellWidget extends StatelessWidget {
  final int row;
  final int col;
  final GridCell cell;
  final bool isSelected;
  final bool isInClue;
  final bool showHint;
  final VoidCallback onTap;
  final CrosswordStyle style;

  const _GridCellWidget({
    required this.row,
    required this.col,
    required this.cell,
    required this.isSelected,
    required this.isInClue,
    required this.showHint,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (cell.isBlock) {
      return Container(
        decoration: BoxDecoration(
          color: style.blockColor,
          borderRadius: BorderRadius.circular(style.cellBorderRadius),
        ),
      );
    }

    Color bgColor = style.cellColor;
    if (isSelected) {
      bgColor = style.selectedCellColor;
    } else if (isInClue) {
      bgColor = style.highlightColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(style.cellBorderRadius),
          border: Border.all(
            color: style.cellBorderColor,
            width: 0.5,
          ),
        ),
        child: Stack(
          children: [
            if (cell.clueNumber != null)
              Positioned(
                top: 1,
                left: 2,
                child: Text(
                  '${cell.clueNumber}',
                  style: TextStyle(
                    fontSize: style.clueNumberFontSize,
                    fontWeight: FontWeight.bold,
                    color: style.clueNumberColor,
                  ),
                ),
              ),
            Center(
              child: Text(
                cell.currentLetter ?? '',
                style: TextStyle(
                  fontSize: style.cellTextFontSize,
                  fontWeight: style.cellTextFontWeight,
                  color: isSelected ? style.selectedTextColor : style.textColor,
                ),
              ),
            ),
            if (showHint && cell.currentLetter == null)
              Positioned(
                right: 2,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    cell.correctLetter ?? '',
                    style: TextStyle(
                      fontSize: style.cellTextFontSize * 0.7,
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                        ? Colors.white.withOpacity(0.6) 
                        : style.textColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
