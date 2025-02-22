import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/features/exercises/domain/models/exercise.dart';
import 'package:workout_tracker/features/exercises/data/repositories/wger_exercise_repository.dart';

abstract class ExercisesState {}

class ExercisesInitial extends ExercisesState {}
class ExercisesLoading extends ExercisesState {}
class ExercisesLoaded extends ExercisesState {
  final List<Exercise> exercises;
  final String? searchQuery;
  final String? selectedCategory;

  ExercisesLoaded(this.exercises, {this.searchQuery, this.selectedCategory});

  List<Exercise> get filteredExercises {
    return exercises.where((exercise) {
      final matchesSearch = searchQuery?.isEmpty ?? true ||
          exercise.name.toLowerCase().contains(searchQuery!.toLowerCase());
      final matchesCategory = selectedCategory == null ||
          exercise.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
}
class ExercisesError extends ExercisesState {
  final String message;
  ExercisesError(this.message);
}

class ExerciseValidationError extends ExercisesError {
  final Map<String, String> fieldErrors;
  
  ExerciseValidationError(String message, this.fieldErrors) : super(message);
}

class ExerciseDeleted extends ExercisesLoaded {
  final Exercise deletedExercise;
  
  ExerciseDeleted(
    super.exercises, {
    required this.deletedExercise,
    super.searchQuery,
    super.selectedCategory,
  });
}

class ExercisesCubit extends Cubit<ExercisesState> {
  final _repository = WgerExerciseRepository();
  String? _searchQuery;
  String? _selectedCategory;
  Exercise? _lastDeletedExercise;

  ExercisesCubit() : super(ExercisesInitial());

  Future<void> loadExercises() async {
    try {
      emit(ExercisesLoading());
      final exercises = await _repository.getExercises();
      emit(ExercisesLoaded(exercises, 
        searchQuery: _searchQuery, 
        selectedCategory: _selectedCategory
      ));
    } catch (e) {
      emit(ExercisesError(e.toString()));
    }
  }

  void searchExercises(String query) {
    print('Searching for: $query');
    _searchQuery = query;
    if (state is ExercisesLoaded) {
      final currentState = state as ExercisesLoaded;
      print('Current exercises count: ${currentState.exercises.length}');
      emit(ExercisesLoaded(
        currentState.exercises,
        searchQuery: query,
        selectedCategory: _selectedCategory,
      ));
    } else {
      print('State is not ExercisesLoaded: $state');
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    if (state is ExercisesLoaded) {
      final currentState = state as ExercisesLoaded;
      emit(ExercisesLoaded(
        currentState.exercises,
        searchQuery: _searchQuery,
        selectedCategory: category,
      ));
    }
  }

  Future<bool> updateExercise(Exercise exercise) async {
    try {
      emit(ExercisesLoading());
      
      // Validate exercise
      final errors = _validateExercise(exercise);
      if (errors.isNotEmpty) {
        emit(ExerciseValidationError('Invalid exercise data', errors));
        return false;
      }

      await _repository.updateExercise(exercise);
      await loadExercises();
      return true;
    } catch (e) {
      emit(ExercisesError(e.toString()));
      return false;
    }
  }

  Future<bool> deleteExercise(String id) async {
    try {
      if (state is ExercisesLoaded) {
        final currentState = state as ExercisesLoaded;
        final exercise = currentState.exercises.firstWhere((e) => e.id == id);
        _lastDeletedExercise = exercise;

        // Remove from current state immediately (optimistic update)
        final updatedExercises = List<Exercise>.from(currentState.exercises)
          ..removeWhere((e) => e.id == id);

        emit(ExerciseDeleted(
          updatedExercises,
          deletedExercise: exercise,
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
        ));

        // Actually delete from backend
        await _repository.deleteExercise(id);
        return true;
      }
      return false;
    } catch (e) {
      emit(ExercisesError(e.toString()));
      return false;
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedExercise != null && state is ExercisesLoaded) {
      try {
        await _repository.createExercise(_lastDeletedExercise!);
        await loadExercises();
        _lastDeletedExercise = null;
      } catch (e) {
        emit(ExercisesError(e.toString()));
      }
    }
  }

  Future<bool> testConnection() async {
    try {
      emit(ExercisesLoading());
      await _repository.getExercises();
      emit(ExercisesLoaded([], searchQuery: _searchQuery, selectedCategory: _selectedCategory));
      return true;
    } catch (e) {
      emit(ExercisesError(e.toString()));
      return false;
    }
  }

  Future<bool> createExercise(Exercise exercise) async {
    try {
      emit(ExercisesLoading());
      
      final errors = _validateExercise(exercise);
      if (errors.isNotEmpty) {
        emit(ExerciseValidationError('Invalid exercise data', errors));
        return false;
      }

      await _repository.createExercise(exercise);
      await loadExercises();
      return true;
    } catch (e) {
      emit(ExercisesError(e.toString()));
      return false;
    }
  }

  Map<String, String> _validateExercise(Exercise exercise) {
    final errors = <String, String>{};
    
    if (exercise.name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }
    
    if (exercise.name.length > 50) {
      errors['name'] = 'Name must be less than 50 characters';
    }
    
    if (exercise.description != null && exercise.description!.length > 500) {
      errors['description'] = 'Description must be less than 500 characters';
    }
    
    return errors;
  }
} 