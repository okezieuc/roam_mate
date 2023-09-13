import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/screens/pages/add_friend.dart';

class App extends StatelessWidget {
  const App({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddFriend(),
        TextButton(
            onPressed: () {
              signOut();
            },
            child: const Text("Sign out")),
      ],
    );
  }
}
