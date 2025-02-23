import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import 'package:sentry/sentry.dart';
import 'package:dio/dio.dart';

class WgerExerciseRepository implements ExerciseRepository {
  final baseUrl = 'https://wger.de/api/v2';
  final _dio = Dio();
  
  @override
  Future<List<Exercise>> getExercises({int page = 1}) async {
    final response = await _dio.get(
      '/exercise',
      queryParameters: {
        'language': '1',  // English only
        'limit': '20',    // Page size
        'offset': ((page - 1) * 20).toString(), // Pagination offset
      },
    );
    
    return (response.data['results'] as List)
        .map((json) => Exercise.fromJson(json))
        .toList();
  }

  String? _mapCategory(dynamic category) {
    final categoryMap = {
      10: 'Strength',
      11: 'Cardio',
      12: 'Flexibility',
    };
    return categoryMap[category];
  }

  List<String>? _mapEquipment(List<dynamic>? equipment) {
    if (equipment == null || equipment.isEmpty) return null;
    
    final equipmentMap = {
      1: 'Barbell',
      2: 'Dumbbells',
      3: 'Kettlebell',
      4: 'Body Weight',
      5: 'Machine',
      6: 'Cable',
      7: 'Medicine Ball',
      8: 'Resistance Bands',
    };
    
    return equipment
        .map((e) => equipmentMap[e])
        .where((e) => e != null)
        .cast<String>()
        .toList();
  }

  // Other required methods with minimal implementation for MVP
  @override
  Future<Exercise> getExerciseById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercise/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Exercise(
        id: json['id'].toString(),
        name: json['name'],
        description: json['description'],
        category: _mapCategory(json['category']),
        equipment: _mapEquipment(json['equipment']),
      );
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  // These methods can be implemented later if needed
  @override
  Future<Exercise> createExercise(Exercise exercise) async {
    throw UnimplementedError('Creating exercises not supported with wger API');
  }

  @override
  Future<Exercise> updateExercise(Exercise exercise) async {
    throw UnimplementedError('Updating exercises not supported with wger API');
  }

  @override
  Future<void> deleteExercise(String id) async {
    throw UnimplementedError('Deleting exercises not supported with wger API');
  }

  @override
  Future<List<Exercise>> getExercisesByIds(List<String> ids) async {
    final exercises = await Future.wait(
      ids.map((id) => getExerciseById(id)),
    );
    return exercises;
  }

  Future<List<Exercise>> searchExercises(String query) async {
    final response = await _dio.get(
      '/exercise',
      queryParameters: {
        'name': query,  // Filter by name field
        'language': '1', // English only
      },
    );
    
    return (response.data['results'] as List)
        .map((json) => Exercise.fromJson(json))
        .toList();
  }
} 