import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/exercise.dart';
import '../cubit/exercises_cubit.dart';
import '../pages/edit_exercise_page.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../pages/exercise_details_page.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  Future<bool> _confirmDelete(BuildContext context) async {
    return showConfirmationDialog(
      context: context,
      title: 'Delete Exercise',
      content: 'Are you sure you want to delete "${exercise.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    return showConfirmationDialog(
      context: context,
      title: 'Discard Changes',
      content: 'Are you sure you want to discard your changes?',
      confirmLabel: 'Discard',
      isDestructive: true,
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(exercise: exercise),
      ),
    );

    if (result == null && context.mounted) {
      // User pressed back button
      final shouldDiscard = await _confirmDiscard(context);
      if (shouldDiscard && context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Dismissible(
        key: Key(exercise.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => _confirmDelete(context),
        onDismissed: (direction) {
          context.read<ExercisesCubit>().deleteExercise(exercise.id);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailsPage(exercise: exercise),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (exercise.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          exercise.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (exercise.category != null) ...[
                            Icon(
                              _getCategoryIcon(exercise.category!),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(exercise.category!),
                            const SizedBox(width: 16),
                          ],
                          if (exercise.equipment != null && 
                              exercise.equipment!.isNotEmpty) ...[
                            const Icon(Icons.fitness_center, size: 16),
                            const SizedBox(width: 4),
                            Text(exercise.equipment!.join(', ')),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await _handleEdit(context);
                    } else if (value == 'delete') {
                      if (await _confirmDelete(context)) {
                        if (context.mounted) {
                          context.read<ExercisesCubit>().deleteExercise(exercise.id);
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
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
} 