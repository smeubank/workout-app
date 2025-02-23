import 'package:workout_tracker/core/config/supabase_config.dart';
import '../../domain/models/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import 'package:uuid/uuid.dart';

class SupabaseExerciseRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> getExercises() async {
    final response = await SupabaseConfig.client
        .from('exercises')
        .select()
        .order('name');
    
    return response.map((json) => Exercise.fromJson(json)).toList();
  }

  @override
  Future<Exercise> getExerciseById(String id) async {
    final response = await SupabaseConfig.client
        .from('exercises')
        .select()
        .eq('id', id)
        .single();
    
    return Exercise.fromJson(response);
  }

  @override
  Future<Exercise> createExercise(Exercise exercise) async {
    final uuid = const Uuid().v4();
    final response = await SupabaseConfig.client
        .from('exercises')
        .insert({
          'id': uuid,
          'name': exercise.name,
          'description': exercise.description,
          'category': exercise.category,
          'equipment': exercise.equipment,
          'wger_id': exercise.id,  // Store original Wger ID
        })
        .select()
        .single();
    
    return Exercise.fromJson(response);
  }

  @override
  Future<Exercise> updateExercise(Exercise exercise) async {
    final response = await SupabaseConfig.client
        .from('exercises')
        .update(exercise.toJson())
        .eq('id', exercise.id)
        .select()
        .single();
    
    return Exercise.fromJson(response);
  }

  @override
  Future<void> deleteExercise(String id) async {
    await SupabaseConfig.client
        .from('exercises')
        .delete()
        .eq('id', id);
  }
} 