import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/exercise.dart';
import '../cubit/exercises_cubit.dart';

class SelectExercisesPage extends StatefulWidget {
  final List<Exercise> initiallySelected;

  const SelectExercisesPage({
    super.key,
    this.initiallySelected = const [],
  });

  @override
  State<SelectExercisesPage> createState() => _SelectExercisesPageState();
}

class _SelectExercisesPageState extends State<SelectExercisesPage> {
  late final Set<String> _selectedExerciseIds;

  @override
  void initState() {
    super.initState();
    _selectedExerciseIds = widget.initiallySelected.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExercisesCubit()..loadExercises(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Exercises'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _selectedExerciseIds.toList());
              },
              child: const Text('Done'),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryFilter(),
            Expanded(
              child: _buildExercisesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search exercises...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          context.read<ExercisesCubit>().searchExercises(value);
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<ExercisesCubit, ExercisesState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildCategoryChip(context, null, 'All'),
              _buildCategoryChip(context, 'Strength', 'Strength'),
              _buildCategoryChip(context, 'Cardio', 'Cardio'),
              _buildCategoryChip(context, 'Flexibility', 'Flexibility'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(BuildContext context, String? category, String label) {
    return BlocBuilder<ExercisesCubit, ExercisesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            label: Text(label),
            selected: state is ExercisesLoaded && 
                     state.selectedCategory == category,
            onSelected: (selected) {
              context.read<ExercisesCubit>().filterByCategory(selected ? category : null);
            },
          ),
        );
      },
    );
  }

  Widget _buildExercisesList() {
    return BlocBuilder<ExercisesCubit, ExercisesState>(
      builder: (context, state) {
        if (state is ExercisesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExercisesError) {
          return Center(child: Text(state.message));
        }

        if (state is ExercisesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = state.filteredExercises[index];
              return Card(
                child: CheckboxListTile(
                  title: Text(exercise.name),
                  subtitle: exercise.description != null
                      ? Text(
                          exercise.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  secondary: Icon(_getCategoryIcon(exercise.category)),
                  value: _selectedExerciseIds.contains(exercise.id),
                  onChanged: (selected) {
                    setState(() {
                      if (selected ?? false) {
                        _selectedExerciseIds.add(exercise.id);
                      } else {
                        _selectedExerciseIds.remove(exercise.id);
                      }
                    });
                  },
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
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
}