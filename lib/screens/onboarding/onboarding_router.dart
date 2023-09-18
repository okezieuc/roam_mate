import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/screens/onboarding/completed_onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roam_mate/screens/onboarding/onboarding_page.dart';
import 'package:roam_mate/screens/pages/app.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class OnboardingController extends StatefulWidget {
  const OnboardingController({super.key});

  @override
  State<OnboardingController> createState() => _OnboardingControllerState();
}

class _OnboardingControllerState extends State<OnboardingController> {
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
      return wrapInScaffold(const CircularProgressIndicator());
    }

    if (completedOnboarding == true) {
      return const App();
    }

    return wrapInScaffold(
        OnboardingPage(toggleCompletedOnboarding: toggleCompletedOnboarding));
  }
}

Widget wrapInScaffold(Widget innerWidget) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          innerWidget,
        ],
      ),
    ),
  );
}
