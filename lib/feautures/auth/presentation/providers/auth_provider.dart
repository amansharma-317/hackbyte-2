import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackbyte2/feautures/auth/data/data_sources/auth_data_source.dart';
import 'package:hackbyte2/feautures/auth/data/repository/auth_repository_impl.dart';

import '../../domain/repository/auth_repository.dart';
//returning bool (true if authenticated, else false)
class AuthStateNotifier extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  //initialize with initial state false -> meaning 'not authenticated'
  AuthStateNotifier(this._authRepository) : super(false);

  Future<void> init() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        state = true; // User is still authenticated
      } else {
        state = false; // User is no longer authenticated
      }
    } catch (e) {
      print('Error checking Firebase Auth: $e');
      state = false; // Assume not authenticated in case of errors
    }
  }

  void setAuthenticated(bool isAuthenticated) {
    state = isAuthenticated;
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // Access the data source from the repository and trigger phone number verification
     await _authRepository.sendOTP(phoneNumber);
  }

  Future<void> verifyOTP(String phoneNumber, String otp) async {
    // Access the data source from the repository and verify the OTP
    await _authRepository.verifyOTP(otp);

    // Set authenticated state if OTP verification is successful
    setAuthenticated(true);
  }
}

// auth_provider.dart
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, bool>(
      (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthStateNotifier(authRepository);
  },
);

//the function below defines how to create an instance of 'AuthStateNotifier'
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = FirebasePhoneDataSource(); // Instantiate your data source here
  return FirebaseAuthRepository(dataSource);
});
