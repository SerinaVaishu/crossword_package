import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/crossword_viewmodel.dart';
import '../models/crossword_model.dart';

class ClueList extends StatelessWidget {
  const ClueList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CrosswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CLUES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: 1.2,
              ),
            ),
            TextButton.icon(
              onPressed: viewModel.toggleHints,
              icon: Icon(
                viewModel.showHints ? Icons.lightbulb : Icons.lightbulb_outline,
                size: 18,
                color: const Color(0xFF3D65EA),
              ),
              label: Text(
                viewModel.showHints ? "Hide Hints" : "Show Hints",
                style: const TextStyle(
                  color: Color(0xFF3D65EA),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFDBE9FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ClueCategoryWidget(
          title: 'ACROSS',
          clues: viewModel.acrossClues,
          selectedClue: viewModel.selectedClue,
          onClueTap: (clue) => viewModel.selectCell(clue.row, clue.col),
        ),
        const SizedBox(height: 24),
        _ClueCategoryWidget(
          title: 'DOWN',
          clues: viewModel.downClues,
          selectedClue: viewModel.selectedClue,
          onClueTap: (clue) => viewModel.selectCell(clue.row, clue.col),
        ),
      ],
    );
  }
}

class _ClueCategoryWidget extends StatelessWidget {
  final String title;
  final List<CrosswordClue> clues;
  final CrosswordClue? selectedClue;
  final Function(CrosswordClue) onClueTap;

  const _ClueCategoryWidget({
    required this.title,
    required this.clues,
    this.selectedClue,
    required this.onClueTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        ...clues.map((clue) {
          final isSelected = selectedClue == clue;
          final isCompleted = context.read<CrosswordViewModel>().isClueCompleted(clue);

          return InkWell(
            onTap: () => onClueTap(clue),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                  ? const Color(0xFFDBEAFE) 
                  : (isCompleted ? const Color(0xFFF0FDF4) : Colors.white),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected 
                    ? const Color(0xFF3B82F6) 
                    : (isCompleted ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0)),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${clue.number}.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clue.question,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF22C55E),
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
