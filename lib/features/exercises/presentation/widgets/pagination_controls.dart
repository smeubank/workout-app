import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: hasPreviousPage 
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        Text('Page $currentPage'),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: hasNextPage 
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
} 