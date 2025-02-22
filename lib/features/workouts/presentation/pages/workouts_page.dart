import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/features/workouts/presentation/cubit/workouts_cubit.dart';
import 'package:workout_tracker/features/workouts/presentation/widgets/workout_card.dart';
import 'create_workout_page.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutsCubit()..loadWorkouts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateWorkoutPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<WorkoutsCubit, WorkoutsState>(
          builder: (context, state) {
            if (state is WorkoutsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is WorkoutsError) {
              return Center(child: Text(state.message));
            }
            
            if (state is WorkoutsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.workouts.length,
                itemBuilder: (context, index) {
                  final workout = state.workouts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WorkoutCard(workout: workout),
                  );
                },
              );
            }
            
            return const SizedBox();
          },
        ),
      ),
    );
  }
} 