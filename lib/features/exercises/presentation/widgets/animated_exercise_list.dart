import 'package:flutter/material.dart';
import '../../domain/models/exercise.dart';
import 'exercise_card.dart';

class AnimatedExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  final GlobalKey<AnimatedListState> listKey;

  const AnimatedExerciseList({
    super.key,
    required this.exercises,
    required this.listKey,
  });

  @override
  State<AnimatedExerciseList> createState() => _AnimatedExerciseListState();
}

class _AnimatedExerciseListState extends State<AnimatedExerciseList> {
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: widget.listKey,
      initialItemCount: widget.exercises.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ExerciseCard(exercise: widget.exercises[index]),
            ),
          ),
        );
      },
    );
  }
} 