import 'package:flutter/material.dart';
import '../../domain/models/workout.dart';
import '../../domain/models/workout_template.dart';

class WorkoutCard extends StatelessWidget {
  final dynamic workout;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTemplate = workout is WorkoutTemplate;
    final String title = workout.name;
    final String? description = workout.description;
    final DateTime date = isTemplate ? workout.createdAt : workout.startedAt;
    final int exerciseCount = workout.exercises.length;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text('$exerciseCount exercises'),
                  const Spacer(),
                  Text(
                    _formatDate(date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 