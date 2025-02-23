import 'package:flutter/material.dart';
import 'package:workout_tracker/features/workouts/domain/models/workout_template.dart';
import 'package:workout_tracker/features/exercises/presentation/pages/select_exercises_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/workouts_cubit.dart';
import 'package:workout_tracker/core/widgets/error_boundary.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/features/exercises/domain/models/exercise.dart';
import 'package:workout_tracker/features/exercises/presentation/cubit/exercises_cubit.dart';
import 'package:workout_tracker/features/workouts/domain/models/template_exercise.dart';
import 'package:workout_tracker/features/workouts/presentation/cubit/workouts_cubit.dart';
import 'package:workout_tracker/core/config/supabase_config.dart';

class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Description must be less than 500 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: BlocBuilder<WorkoutsCubit, WorkoutsState>(
        builder: (context, state) {
          if (state is! WorkoutsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Workout'),
              actions: [
                if (state is! WorkoutsSaving)
                  TextButton(
                    onPressed: () => _saveWorkout(),
                    child: const Text('Save'),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            body: _buildForm(context, state.selectedExercises, state),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<Exercise> exercises, WorkoutsState state) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            validator: _validateName,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a name for your workout',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            validator: _validateDescription,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter a description for your workout',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildExercisesList(exercises),
        ],
      ),
    );
  }

  Widget _buildExercisesList(List<Exercise> exercises) {
    return OutlinedButton.icon(
      onPressed: () => _selectExercises(context),
      icon: const Icon(Icons.add),
      label: const Text('Add Exercises'),
    );
  }

  Future<void> _selectExercises(BuildContext context) async {
    if (context.read<WorkoutsCubit>().state is! WorkoutsLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Unable to load exercises')),
      );
      return;
    }

    final currentState = context.read<WorkoutsCubit>().state as WorkoutsLoaded;
    
    final selectedIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectExercisesPage(
          initiallySelected: currentState.selectedExercises,
        ),
      ),
    );
    
    if (selectedIds != null && mounted) {
      try {
        final exercises = await context.read<ExercisesCubit>().getExercisesByIds(selectedIds);
        context.read<WorkoutsCubit>().updateSelectedExercises(exercises);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load exercises: $e')),
          );
        }
      }
    }
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final state = context.read<WorkoutsCubit>().state;
      if (state is! WorkoutsLoaded) return;

      final templateId = const Uuid().v4();
      final templateExercises = state.selectedExercises.map((exercise) {
        final config = state.exerciseConfigs[exercise.id];
        return TemplateExercise(
          id: const Uuid().v4(),
          templateId: templateId,
          exerciseId: exercise.id,
          sets: config?.sets ?? 3,
          reps: config?.reps ?? 10,
          orderIndex: state.selectedExercises.indexOf(exercise),
        );
      }).toList();

      final template = WorkoutTemplate(
        id: templateId,
        userId: SupabaseConfig.client.auth.currentUser?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        exercises: templateExercises,
      );

      try {
        await context.read<WorkoutsCubit>().createWorkout(template);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save workout: $e')),
        );
      }
    }
  }
} 