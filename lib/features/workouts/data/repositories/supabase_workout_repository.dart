import 'package:workout_tracker/core/config/supabase_config.dart';
import '../../domain/models/workout.dart';
import '../../domain/models/workout_template.dart';
import '../../domain/models/template_exercise.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../core/exceptions/database_exception.dart';
import 'package:postgrest/postgrest.dart';
import '../../core/repositories/base_repository.dart';

class SupabaseWorkoutRepository extends BaseRepository implements WorkoutRepository {
  final String _defaultUserId = '00000000-0000-0000-0000-000000000000';

  @override
  Future<List<WorkoutTemplate>> getWorkoutTemplates() async {
    return executeQuery('fetch workout templates', () async {
      final response = await SupabaseConfig.client
          .from('workout_templates')
          .select('''
            *,
            template_exercises (
              id,
              exercise_id,
              sets,
              reps,
              weight,
              order_index
            )
          ''')
          .eq('user_id', _defaultUserId)
          .order('created_at', ascending: false);
      
      return response.map((json) => WorkoutTemplate.fromJson(json)).toList();
    });
  }

  @override
  Future<WorkoutTemplate> createWorkoutTemplate(WorkoutTemplate template) async {
    try {
      // 1. Create the workout template
      final templateResponse = await SupabaseConfig.client
          .from('workout_templates')
          .insert({
            'name': template.name,
            'description': template.description,
            'user_id': _defaultUserId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final createdTemplate = WorkoutTemplate.fromJson({
        'id': templateResponse['id'],
        'userId': templateResponse['user_id'],
        'name': templateResponse['name'],
        'description': templateResponse['description'],
        'createdAt': templateResponse['created_at'],
        'exercises': [],
      });

      // 2. Create template exercises if any exist
      if (template.exercises.isNotEmpty) {
        final exercisesData = template.exercises.asMap().entries.map((entry) {
          final exercise = entry.value;
          return {
            'template_id': createdTemplate.id,
            'exercise_id': exercise.exerciseId,
            'order_index': entry.key,
            'sets': exercise.sets ?? 3,
            'reps': exercise.reps ?? 10,
            'weight': exercise.weight,
          };
        }).toList();

        await SupabaseConfig.client
            .from('template_exercises')
            .insert(exercisesData);
      }

      // 3. Fetch the complete template
      return await getWorkoutTemplateById(createdTemplate.id);
    } catch (e) {
      if (e is PostgrestException) {
        throw DatabaseException(
          'Failed to create workout template',
          code: e.code,
          details: e.details?.toString(),
          context: {
            'template_name': template.name,
            'exercise_count': template.exercises.length,
            'user_id': _defaultUserId,
          },
        );
      }
      throw DatabaseException(
        'Unexpected error while creating workout template',
        context: {
          'template_name': template.name,
          'exercise_count': template.exercises.length,
        },
      );
    }
  }

  @override
  Future<WorkoutTemplate> updateWorkoutTemplate(WorkoutTemplate template) async {
    try {
      // 1. Update template
      final templateResponse = await SupabaseConfig.client
          .from('workout_templates')
          .update({
            'name': template.name,
            'description': template.description,
            'user_id': template.userId,
          })
          .eq('id', template.id)
          .select()
          .single();

      // 2. Delete existing exercises
      await SupabaseConfig.client
          .from('template_exercises')
          .delete()
          .eq('template_id', template.id);

      // 3. Insert new exercises
      if (template.exercises.isNotEmpty) {
        final exercisesData = template.exercises.asMap().entries.map((entry) {
          final exercise = entry.value;
          return {
            'template_id': template.id,
            'exercise_id': exercise.exerciseId,
            'order_index': entry.key,
            'sets': exercise.sets ?? 3,
            'reps': exercise.reps ?? 10,
            'weight': exercise.weight,
          };
        }).toList();

        await SupabaseConfig.client
            .from('template_exercises')
            .insert(exercisesData);
      }

      // 4. Fetch updated template
      return await getWorkoutTemplateById(template.id);
    } catch (e) {
      if (e is PostgrestException) {
        throw DatabaseException(
          'Failed to update workout template',
          code: e.code,
          details: e.details?.toString(),
          context: {
            'template_id': template.id,
            'template_name': template.name,
            'exercise_count': template.exercises.length,
          },
        );
      }
      throw DatabaseException(
        'Unexpected error while updating workout template',
        context: {
          'template_id': template.id,
          'template_name': template.name,
        },
      );
    }
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
    try {
      final response = await SupabaseConfig.client
          .from('workout_templates')
          .select('''
            *,
            template_exercises (
              id,
              exercise_id,
              sets,
              reps,
              weight,
              order_index
            )
          ''')
          .eq('id', id)
          .single();
      
      return WorkoutTemplate.fromJson(response);
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        throw DatabaseException(
          'Workout template not found',
          code: 'NOT_FOUND',
        );
      }
      throw DatabaseException('Failed to fetch workout template: $e');
    }
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