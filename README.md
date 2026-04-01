# crossword_puzzle

[![Pub Version](https://img.shields.io/pub/v/crossword_puzzle?color=blue)](https://pub.dev/packages/crossword_puzzle)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A highly customizable and dynamic crossword puzzle package for Flutter. Build complex crossword grids with ease, supporting clues, hints, and custom styling.

## 🧩 Features

- **Dynamic Grid Mapping**: Automatically maps clues to the grid based on coordinates and direction.
- **Across/Down Clue Lists**: Categorized lists that automatically highlight the active clue.
- **Success Indicators**: Green checkmarks appear next to clues as they are completed correctly.
- **Built-in Hint System**: Show correct letters in empty cells with a single toggle.
- **Rich Customization**: control every aspect (colors, fonts, borders, spacing) via `CrosswordStyle`.
- **Keyboard Interaction**: Full support for typing, deleting, and automatic cursor movement.
- **Responsive**: Works seamlessly across mobile platforms (Android, iOS).

## 🚀 Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  crossword_puzzle: ^0.0.1
```

Import the package in your Dart code:

```dart
import 'package:crossword_puzzle/crossword_puzzle.dart';
```

## 📖 Usage

Define your puzzle and pass it to the `CrosswordPuzzleWidget`:

```dart
final myPuzzle = CrosswordPuzzle(
  title: "Flutter Basics",
  gridSize: 7,
  clues: [
    CrosswordClue(
      number: 1,
      question: "Mobile framework from Google",
      answer: "FLUTTER",
      row: 0, col: 0,
      direction: ClueDirection.across,
    ),
    CrosswordClue(
      number: 2,
      question: "Fast language",
      answer: "DART",
      row: 0, col: 3,
      direction: ClueDirection.down,
    ),
  ],
);

CrosswordPuzzleWidget(
  puzzle: myPuzzle,
  onCompleted: () => print("Puzzle Solved!"),
  style: CrosswordStyle(
    selectedCellColor: Colors.blueAccent,
    cellBorderRadius: 4,
  ),
)
```

## 🎨 Custom Styling

You can fully customize the look and feel using `CrosswordStyle`:

| Property | Description |
| :--- | :--- |
| `selectedCellColor` | Background color of the active cell |
| `highlightColor` | Background color of the active clue's cells |
| `blockColor` | Color of the non-playable grid cells |
| `cellBorderRadius` | Rounded corners for each cell |
| `gridSpacing` | Gap between the cells |

## 🕹️ Full Example

Check out the [example directory](example/lib/main.dart) for a complete, production-ready implementation including progress tracking and success dialogs.

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on the [GitHub repository](https://github.com/SerinaVaishu/crossword_package).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
