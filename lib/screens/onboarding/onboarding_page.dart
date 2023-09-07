import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final _onboardingFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();

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
                        'Onboaring form info submitted with ${_usernameController.text} ${_displayNameController.text}');
                  },
                  child: const Text("Let's Go."))
            ],
          )),
    );
  }
}
