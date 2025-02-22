import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/exercises_cubit.dart';
import '../widgets/exercise_card.dart';
import '../widgets/animated_exercise_list.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: const Center(
        child: Text('Exercises Page - Coming Soon'),
      ),
    );
  }
} 