import 'package:flutter/material.dart';
import 'package:crossword_puzzle/crossword_puzzle.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossword Puzzle Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CrosswordExample(),
    );
  }
}

class CrosswordExample extends StatefulWidget {
  const CrosswordExample({super.key});

  @override
  State<CrosswordExample> createState() => _CrosswordExampleState();
}

class _CrosswordExampleState extends State<CrosswordExample> {
  late CrosswordPuzzle _puzzle;

  @override
  void initState() {
    super.initState();
    _puzzle = CrosswordPuzzle(
      title: "Flutter Fun",
      gridSize: 7,
      clues: [
        CrosswordClue(
          number: 1,
          question: "A mobile UI toolkit from Google",
          answer: "FLUTTER",
          row: 0,
          col: 0,
          direction: ClueDirection.across,
        ),
        CrosswordClue(
          number: 2,
          question: "Fast, object-oriented language",
          answer: "DART",
          row: 2,
          col: 3,
          direction: ClueDirection.down,
        ),
        CrosswordClue(
          number: 3,
          question: "Basic building block of Flutter UI",
          answer: "WIDGET",
          row: 2,
          col: 1,
          direction: ClueDirection.across,
        ),
        CrosswordClue(
          number: 4,
          question: "Command to fetch packages",
          answer: "PUB",
          row: 4,
          col: 0,
          direction: ClueDirection.across,
        ),
        CrosswordClue(
          number: 5,
          question: "Software Development Kit",
          answer: "SDK",
          row: 4,
          col: 4,
          direction: ClueDirection.across,
        ),
      ],
      level: "Intermediate",
      points: 50,
    );
  }

  void _onPuzzleCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations! 🎉"),
        content: const Text("You have successfully completed the crossword puzzle."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("AWESOME"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FE),
      appBar: AppBar(
        title: const Text("Crossword Puzzle"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: CrosswordPuzzleWidget(
        puzzle: _puzzle,
        onCompleted: _onPuzzleCompleted,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _puzzle.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Consumer<CrosswordViewModel>(
              builder: (context, vm, _) {
                return Text(
                  "${vm.completedCluesCount} of ${_puzzle.clues.length} clues completed",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
            ),
          ],
        ),
        footer: Consumer<CrosswordViewModel>(
          builder: (context, viewModel, child) {
            final isDone = viewModel.isPuzzleCompleted();
            return ElevatedButton(
              onPressed: () {
                if (!isDone) {
                  // Example action: Show a snackbar with remaining clues
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Keep going! ${viewModel.puzzle.clues.length - viewModel.completedCluesCount} clues left.",
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                } else {
                  _onPuzzleCompleted();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone ? const Color(0xFF00B14F) : const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isDone ? "Puzzle Solved!" : "Check Progress",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
