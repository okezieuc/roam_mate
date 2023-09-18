import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/friendships_controller.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/show_snackbar.dart';

class RequestListUserProfile extends StatefulWidget {
  const RequestListUserProfile({super.key, required this.user});

  final Profile user;

  @override
  State<RequestListUserProfile> createState() => _RequestListUserProfileState();
}

class _RequestListUserProfileState extends State<RequestListUserProfile> {
  void addFriend() {
    final batch = FirebaseFirestore.instance.batch();

    // add the current user's ID to the current user's friendship list
    var currentUserFriendships =
        friendshipsController.doc(FirebaseAuth.instance.currentUser!.uid);
    batch.update(currentUserFriendships, {
      "friends": FieldValue.arrayUnion([widget.user.userId])
    });

    // add the current user's ID to the friend request sender's friendship list
    var friendRequestSenderFriendships =
        friendshipsController.doc(widget.user.userId);
    batch.update(friendRequestSenderFriendships, {
      "friends": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });

    batch.commit().then((res) {
      showSnackBar(context, 'Friend Request Accepted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.user.displayName}'),
        Text('Username: ${widget.user.username}'),
        TextButton.icon(
            onPressed: () {
              addFriend();
            },
            icon: const Icon(Icons.add),
            label: const Text("Accept Request"))
      ],
    );
  }
}
