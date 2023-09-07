import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompletedOnboarding extends StatelessWidget {
  const CompletedOnboarding({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Onboarding Completed"),
          TextButton(
              onPressed: () {
                signOut();
              },
              child: const Text("Sign out"))
        ],
      ),
    );
  }
}
