import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roam_mate/utils/profile_controller.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.toggleCompletedOnboarding});

  final void Function() toggleCompletedOnboarding;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _onboardingFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool completedOnboarding = false;

  void setUserData() {
    User? currentAuthUser = FirebaseAuth.instance.currentUser;

    if (currentAuthUser != null) {
      profileController
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(Profile(
            userId: FirebaseAuth.instance.currentUser!.uid,
            username: _usernameController.text,
            displayName: _displayNameController.text,
          ))
          .onError(
              (error, stackTrace) => print("Error writing document: $error"));

      widget.toggleCompletedOnboarding();
    } else {
      print("No logged in user.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _onboardingFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(labelText: "Display name"),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(
                        'Onboarding form info submitted with ${_usernameController.text} ${_displayNameController.text}');
                    setUserData();
                  },
                  child: const Text("Let's Go."))
            ],
          )),
    );
  }
}
