import 'package:hackbyte2/feautures/resources/domain/entities/exercise_entity.dart';

abstract class ExerciseRepository {
  Future<List<String>> fetchUniqueExerciseCategories();
  Future<List<ExerciseEntity>> getExercisesByCategory(String categoryName);
}