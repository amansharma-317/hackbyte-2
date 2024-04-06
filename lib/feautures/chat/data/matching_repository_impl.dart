import 'package:hackbyte2/core/models/assessment_model.dart';
import 'package:hackbyte2/feautures/chat/data/matching_data_source.dart';
import 'package:hackbyte2/feautures/chat/domain/entities/match_user_result.dart';
import 'package:hackbyte2/feautures/chat/domain/matching_repository.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final MatchingDataSource _dataSource;

  MatchingRepositoryImpl(this._dataSource);

  @override
  Future<MatchUserResult> matchUser(MentalHealthAssessment user) async {
    try {
      return await _dataSource.matchUser(user);
    } catch (e) {
      print('Error: $e');
      return MatchUserResult(success: false, errorMessage: e.toString());
    }
  }


  @override
  Future<void> addUserToChatQueue() async {
    await _dataSource.addUserToChatQueue();
  }
}
