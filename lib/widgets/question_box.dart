import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The tappable "Ask about this trip" box under each post.
/// Collapsed by default; expands to show question chips (Cost, Best time,
/// Tips, Story, ...) and the poster's answer for whichever chip is selected.
class QuestionBox extends StatefulWidget {
  final Map<String, String> qa;
  const QuestionBox({super.key, required this.qa});

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  bool _open = false;
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.gold, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ask about this trip',
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink, fontSize: 13),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.expand_more, color: AppColors.ink, size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: widget.qa.keys.map((q) {
                      final sel = _selected == q;
                      return ChoiceChip(
                        label: Text(q, style: TextStyle(fontSize: 10.5, color: sel ? AppColors.paper : AppColors.ink)),
                        selected: sel,
                        onSelected: (_) => setState(() => _selected = q),
                        selectedColor: AppColors.ink,
                        backgroundColor: AppColors.paper,
                        shape: StadiumBorder(side: BorderSide(color: AppColors.ink)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selected == null
                          ? 'Tap a question to see the answer.'
                          : widget.qa[_selected]!,
                      style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.charcoal),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}
