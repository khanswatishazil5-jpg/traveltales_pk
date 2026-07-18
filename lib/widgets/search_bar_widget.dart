import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum SearchMode { places, people }

/// Search field + Places/People toggle used at the top of ExploreScreen.
class TravelSearchBar extends StatelessWidget {
  final SearchMode mode;
  final ValueChanged<SearchMode> onModeChanged;
  final ValueChanged<String> onChanged;

  const TravelSearchBar({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: 'Search places or travelers…',
            prefixIcon: Icon(Icons.search, color: AppColors.ink),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: 'Places',
                selected: mode == SearchMode.places,
                onTap: () => onModeChanged(SearchMode.places),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ModeButton(
                label: 'People',
                selected: mode == SearchMode.people,
                onTap: () => onModeChanged(SearchMode.people),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.ink : Colors.transparent,
        foregroundColor: selected ? AppColors.paper : AppColors.ink,
        side: const BorderSide(color: AppColors.ink, width: 1.4),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 0.5)),
    );
  }
}
