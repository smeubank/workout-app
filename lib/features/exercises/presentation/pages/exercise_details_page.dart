import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/exercise.dart';
import '../cubit/exercises_cubit.dart';
import '../pages/edit_exercise_page.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _handleEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: 'Description',
              content: exercise.description ?? 'No description provided',
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Category',
              content: exercise.category ?? 'Uncategorized',
              icon: _getCategoryIcon(exercise.category),
            ),
            if (exercise.equipment != null && exercise.equipment!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Equipment Required',
                content: exercise.equipment!.join(', '),
                icon: Icons.fitness_center,
              ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // TODO: Add to workout
              },
              icon: const Icon(Icons.add),
              label: const Text('Add to Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.self_improvement;
      default:
        return Icons.sports_gymnastics;
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(exercise: exercise),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context); // Return to exercises list
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Exercise',
      content: 'Are you sure you want to delete "${exercise.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      final success = await context.read<ExercisesCubit>().deleteExercise(exercise.id);
      if (success && context.mounted) {
        Navigator.pop(context);
      }
    }
  }
} 