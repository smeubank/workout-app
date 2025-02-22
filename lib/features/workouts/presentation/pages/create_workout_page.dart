import 'package:flutter/material.dart';
import 'package:workout_tracker/features/workouts/domain/models/workout_template.dart';
import 'package:workout_tracker/features/exercises/presentation/pages/select_exercises_page.dart';

class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
        actions: [
          TextButton(
            onPressed: _saveWorkout,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a workout name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final selectedIds = await Navigator.push<List<String>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectExercisesPage(),
                  ),
                );
                if (selectedIds != null) {
                  // TODO: Update workout exercises
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Exercises'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save workout using repository
      Navigator.pop(context);
    }
  }
} 