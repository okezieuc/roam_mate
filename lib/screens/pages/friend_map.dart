import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendMap extends StatelessWidget {
  const FriendMap({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            signOut();
          },
          child: const Text("Sign out")),
    );
  }
}
