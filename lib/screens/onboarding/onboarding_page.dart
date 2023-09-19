import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roam_mate/utils/controllers/friendships_controller.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/controllers/user_locations_controller.dart';

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

      // create a friendships entry for a user on sign up
      friendshipsController
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(Friendships(friends: []))
          .onError(
              (error, stackTrace) => print("Error writing document: $error"));

      // create a user_locations entry for a user on sign up
      userLocationsController
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(UserLocation(longitude: -1, latitude: -1))
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
