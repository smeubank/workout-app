import 'package:workout_tracker/core/config/supabase_config.dart';
import '../../domain/models/workout.dart';
import '../../domain/models/workout_template.dart';
import '../../domain/models/template_exercise.dart';
import '../../domain/repositories/workout_repository.dart';

class SupabaseWorkoutRepository implements WorkoutRepository {
  // Hardcoded UUID for development
  final String _defaultUserId = '00000000-0000-0000-0000-000000000000';

  @override
  Future<List<WorkoutTemplate>> getWorkoutTemplates() async {
    final response = await SupabaseConfig.client
        .from('workout_templates')
        .select()
        .eq('user_id', _defaultUserId)
        .order('created_at', ascending: false);
    
    return response.map((json) => WorkoutTemplate.fromJson(json)).toList();
  }

  @override
  Future<WorkoutTemplate> createWorkoutTemplate(WorkoutTemplate template) async {
    final response = await SupabaseConfig.client
        .from('workout_templates')
        .insert({
          ...template.toJson(),
          'user_id': _defaultUserId,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();
    
    return WorkoutTemplate.fromJson(response);
  }

  @override
  Future<WorkoutTemplate> updateWorkoutTemplate(WorkoutTemplate template) async {
    final response = await SupabaseConfig.client
        .from('workout_templates')
        .update(template.toJson())
        .eq('id', template.id)
        .select()
        .single();
    
    return WorkoutTemplate.fromJson(response);
  }

  @override
  Future<void> deleteWorkoutTemplate(String templateId) async {
    await SupabaseConfig.client
        .from('workout_templates')
        .delete()
        .eq('id', templateId);
  }

  @override
  Future<WorkoutTemplate> getWorkoutTemplateById(String id) async {
    final response = await SupabaseConfig.client
        .from('workout_templates')
        .select()
        .eq('id', id)
        .single();
    
    return WorkoutTemplate.fromJson(response);
  }

  @override
  Future<List<TemplateExercise>> getTemplateExercises(String templateId) async {
    final response = await SupabaseConfig.client
        .from('template_exercises')
        .select()
        .eq('template_id', templateId)
        .order('order_index');
    
    return response.map((json) => TemplateExercise.fromJson(json)).toList();
  }

  @override
  Future<TemplateExercise> addExerciseToTemplate(TemplateExercise exercise) async {
    final response = await SupabaseConfig.client
        .from('template_exercises')
        .insert(exercise.toJson())
        .select()
        .single();
    
    return TemplateExercise.fromJson(response);
  }

  @override
  Future<void> removeExerciseFromTemplate(String exerciseId) async {
    await SupabaseConfig.client
        .from('template_exercises')
        .delete()
        .eq('id', exerciseId);
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    final response = await SupabaseConfig.client
        .from('workouts')
        .select()
        .eq('user_id', _defaultUserId)
        .order('started_at', ascending: false);
    
    return response.map((json) => Workout.fromJson(json)).toList();
  }

  @override
  Future<Workout> endWorkout(String workoutId) async {
    final response = await SupabaseConfig.client
        .from('workouts')
        .update({'completed_at': DateTime.now().toIso8601String()})
        .eq('id', workoutId)
        .select()
        .single();
    
    return Workout.fromJson(response);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await SupabaseConfig.client
        .from('workouts')
        .delete()
        .eq('id', id);
  }

  @override
  Future<Workout> startWorkout(String? templateId) async {
    final now = DateTime.now();
    final workoutData = {
      'user_id': _defaultUserId,
      'started_at': now.toIso8601String(),
      'template_id': templateId,
      'name': templateId != null 
          ? (await getWorkoutTemplateById(templateId)).name 
          : 'Quick Workout',
    };

    final response = await SupabaseConfig.client
        .from('workouts')
        .insert(workoutData)
        .select()
        .single();
    
    return Workout.fromJson(response);
  }
} 