import 'package:hackbyte2/core/models/assessment_model.dart';
import 'package:hackbyte2/feautures/assessment/data/data_source/assessment_data_source.dart';
import 'package:hackbyte2/feautures/assessment/domain/repository/assessment_repository.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentDataSource userDataSource;

  AssessmentRepositoryImpl(this.userDataSource);

  @override
  Future<bool> saveAssessmentResponses(List<int> responses) async {
    try {
      await userDataSource.saveAssessmentResponses(responses);
      return true; // Return true if the operation succeeds
    } catch (e) {
      // Handle errors here if necessary
      return false; // Return false if the operation fails
    }
  }

  @override
  Future<List<int>?> getAssessmentResponses() async {
    return await userDataSource.getAssessmentResponses();
  }
}
