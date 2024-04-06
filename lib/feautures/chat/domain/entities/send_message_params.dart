import 'package:hackbyte2/feautures/chat/domain/entities/message_entity.dart';

class SendMessageParams {
  final Message message;
  final String chatId;

  SendMessageParams(this.message, this.chatId);
}