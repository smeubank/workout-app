import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/exercise.dart';
import '../cubit/exercises_cubit.dart';

class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({super.key});

  @override
  State<CreateExercisePage> createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  final List<String> _selectedEquipment = [];
  bool _isSaving = false;
  String? _nameError;
  String? _descriptionError;

  final List<String> _categories = ['Strength', 'Cardio', 'Flexibility'];
  final List<String> _availableEquipment = [
    'Dumbbells',
    'Barbell',
    'Kettlebell',
    'Resistance Bands',
    'Body Weight',
    'Machine',
    'Cable',
    'Medicine Ball',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExercisesCubit(),
      child: BlocListener<ExercisesCubit, ExercisesState>(
        listener: (context, state) {
          if (state is ExerciseValidationError) {
            setState(() {
              _nameError = state.fieldErrors['name'];
              _descriptionError = state.fieldErrors['description'];
            });
          } else if (state is ExercisesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Exercise'),
            actions: [
              BlocBuilder<ExercisesCubit, ExercisesState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: state is ExercisesLoading
                        ? null
                        : () => _saveExercise(context),
                    child: state is ExercisesLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  );
                },
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
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    border: const OutlineInputBorder(),
                    errorText: _nameError,
                  ),
                  maxLength: 50,
                  onChanged: (_) {
                    if (_nameError != null) {
                      setState(() => _nameError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: const OutlineInputBorder(),
                    errorText: _descriptionError,
                  ),
                  maxLines: 3,
                  maxLength: 500,
                  onChanged: (_) {
                    if (_descriptionError != null) {
                      setState(() => _descriptionError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Equipment Required:'),
                Wrap(
                  spacing: 8.0,
                  children: _availableEquipment.map((equipment) {
                    return FilterChip(
                      label: Text(equipment),
                      selected: _selectedEquipment.contains(equipment),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedEquipment.add(equipment);
                          } else {
                            _selectedEquipment.remove(equipment);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveExercise(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final exercise = Exercise(
        id: '', // Will be generated by Supabase
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        equipment: _selectedEquipment.isEmpty ? null : _selectedEquipment,
      );

      final success = await context.read<ExercisesCubit>().createExercise(exercise);
      
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }
} 