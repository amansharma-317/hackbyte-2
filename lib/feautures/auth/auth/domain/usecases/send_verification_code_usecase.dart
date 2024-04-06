
/*
class SendVerificationCodeUseCase {
  final AuthRepository _repository;

  SendVerificationCodeUseCase(this._repository);

  Future<void> sendVerificationCode(String phoneNumber) async {
    // Validate phone number format
    if (!isValidPhoneNumber(phoneNumber)) {
      throw InvalidPhoneNumberException();
    }

    await _repository.sendVerificationCode(phoneNumber);
  }
}
*/