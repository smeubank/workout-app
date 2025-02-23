import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/exercise.dart';
import '../cubit/workouts_cubit.dart';

class ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;

  const ExerciseList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      onReorder: (oldIndex, newIndex) {
        context.read<WorkoutsCubit>().reorderExercises(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          key: ValueKey(exercise.id),
          child: ListTile(
            leading: const Icon(Icons.drag_handle),
            title: Text(exercise.name),
            subtitle: Text(exercise.description),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                context.read<WorkoutsCubit>().removeExercise(exercise);
              },
            ),
          ),
        );
      },
    );
  }
} 