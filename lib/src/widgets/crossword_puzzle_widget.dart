import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crossword_model.dart';
import '../models/crossword_style.dart';
import '../viewmodel/crossword_viewmodel.dart';
import 'crossword_grid.dart';
import 'clue_list.dart';

/// The main Crossword Puzzle widget.
class CrosswordPuzzleWidget extends StatelessWidget {
  /// The puzzle data.
  final CrosswordPuzzle puzzle;

  /// Optional style configuration.
  final CrosswordStyle style;

  /// Callback when the puzzle is completed.
  final VoidCallback? onCompleted;

  /// Optional header widget to display above the grid (e.g., title, progress).
  final Widget? header;

  /// Optional footer widget to display below the clues.
  final Widget? footer;

  const CrosswordPuzzleWidget({
    super.key,
    required this.puzzle,
    this.style = const CrosswordStyle(),
    this.onCompleted,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CrosswordViewModel(
        puzzle: puzzle,
        onCompleted: onCompleted,
      ),
      child: _CrosswordPuzzleBody(
        style: style,
        header: header,
        footer: footer,
      ),
    );
  }
}

class _CrosswordPuzzleBody extends StatefulWidget {
  final CrosswordStyle style;
  final Widget? header;
  final Widget? footer;

  const _CrosswordPuzzleBody({
    required this.style,
    this.header,
    this.footer,
  });

  @override
  State<_CrosswordPuzzleBody> createState() => _CrosswordPuzzleBodyState();
}

class _CrosswordPuzzleBodyState extends State<_CrosswordPuzzleBody> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController(text: ' ');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (!mounted) return;

    final viewModel = context.read<CrosswordViewModel>();
    String text = _controller.text;

    if (text.length > 1) {
      String lastChar = text.characters.last;
      if (RegExp(r'[a-zA-Z]').hasMatch(lastChar)) {
        viewModel.updateLetter(lastChar);
      }
      _resetController();
    } else if (text.isEmpty) {
      viewModel.deleteLetter();
      _resetController();
    }
  }

  void _resetController() {
    _controller.value = const TextEditingValue(
      text: ' ',
      selection: TextSelection.collapsed(offset: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hidden TextField to capture keyboard input
        Positioned(
          left: -100,
          child: SizedBox(
            width: 1,
            height: 1,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        // Main UI
        GestureDetector(
          onTap: () {
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.header != null) widget.header!,
                  const SizedBox(height: 16),
                  CrosswordGrid(style: widget.style),
                  const SizedBox(height: 24),
                  const ClueList(),
                  if (widget.footer != null) ...[
                    const SizedBox(height: 24),
                    widget.footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
