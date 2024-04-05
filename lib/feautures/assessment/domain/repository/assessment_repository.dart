import 'package:hackbyte2/core/models/assessment_model.dart';

abstract class AssessmentRepository {

  Future<bool> saveAssessmentResponses(List<int> responses);

  Future<List<int>?> getAssessmentResponses();

}
