import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/screens/onboarding/completed_onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roam_mate/screens/onboarding/onboarding_page.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool completedOnboarding;
  bool loadingOnboardingStatusData = true;

  void toggleCompletedOnboarding() {
    setState(() {
      completedOnboarding = !completedOnboarding;
    });
  }

  @override
  void initState() {
    super.initState();

    final userData =
        db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    userData.get().then(
      (DocumentSnapshot doc) {
        var userData = doc.data();

        setState(() {
          if (userData == null) {
            completedOnboarding = false;
          } else {
            completedOnboarding = true;
          }

          loadingOnboardingStatusData = false;
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadingOnboardingStatusData == true) {
      return const CircularProgressIndicator();
    }

    if (completedOnboarding == true) {
      return const CompletedOnboarding();
    }

    return OnboardingPage(toggleCompletedOnboarding: toggleCompletedOnboarding);
  }
}
