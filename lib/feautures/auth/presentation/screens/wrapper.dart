import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackbyte2/core/bottom_bar.dart';
import 'package:hackbyte2/feautures/assessment/presentation/providers/assessment_providers.dart';
import 'package:hackbyte2/feautures/assessment/presentation/screens/question1.dart';
import 'package:hackbyte2/feautures/auth/auth/presentation/providers/auth_provider.dart';
import 'package:hackbyte2/feautures/auth/auth/presentation/screens/myhomepage.dart';
import 'package:hackbyte2/feautures/chat/presentation/screens/chat_screen.dart';
import 'package:hackbyte2/feautures/chat/presentation/screens/my_chats.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateNotifierProvider.notifier).init();
    final isAuthenticated = ref.watch(authStateNotifierProvider);
    final hasCompletedAssessment = ref.watch(hasCompletedAssessmentProvider);

    return hasCompletedAssessment.when(
      data: (hasCompleted) => isAuthenticated
          ? hasCompleted ? BottomBar() : Question1()
          : MyHomePage(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}