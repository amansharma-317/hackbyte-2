import 'package:hackbyte2/core/models/assessment_model.dart';
import 'package:hackbyte2/feautures/chat/domain/entities/match_user_result.dart';

abstract class MatchingRepository {

  Future<MatchUserResult> matchUser(MentalHealthAssessment user);

  Future<void> addUserToChatQueue();
}
