import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/features/exercises/domain/models/exercise.dart';
import 'package:workout_tracker/features/exercises/data/repositories/wger_exercise_repository.dart';
import 'package:sentry/sentry.dart';

class ExercisesState {
  final List<Exercise> exercises;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? searchQuery;
  final String? selectedCategory;

  ExercisesState({
    this.exercises = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.searchQuery,
    this.selectedCategory,
  });

  ExercisesState copyWith({
    List<Exercise>? exercises,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ExercisesState(
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

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

  ExercisesCubit() : super(ExercisesState());

  Future<void> loadPage(int page) async {
    try {
      emit(state.copyWith(isLoading: true));
      final exercises = await _repository.getExercises(page: page);
      
      emit(state.copyWith(
        exercises: exercises,
        currentPage: page,
        isLoading: false,
        hasNextPage: exercises.length == 20,
        hasPreviousPage: page > 1,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> searchExercises(String query) async {
    try {
      emit(state.copyWith(isLoading: true));
      final exercises = await _repository.searchExercises(query);
      
      emit(state.copyWith(
        exercises: exercises,
        searchQuery: query,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
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
      await loadPage(state.currentPage);
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
        await loadPage(state.currentPage);
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
      await loadPage(state.currentPage);
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

  Future<List<Exercise>> getExercisesByIds(List<String> ids) async {
    try {
      final exercises = await _repository.getExercisesByIds(ids);
      return exercises;
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      throw Exception('Failed to load exercises: $e');
    }
  }

  Future<void> loadExercises() async {
    // This is a convenience method that loads the first page
    await loadPage(1);
  }
}