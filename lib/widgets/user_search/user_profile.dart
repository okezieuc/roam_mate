import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/friend_request_controller.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/show_snackbar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  final Profile user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void followUser() {
    friendRequestController.add(FriendRequest(
        requestedBy: FirebaseAuth.instance.currentUser!.uid,
        isFor: widget.user.userId,
        isRequestApproved: false,
        responded: false));

    showSnackBar(context, "Follow Request Sent");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.displayName,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text('@${widget.user.username}'),
          const SizedBox(height: 36),
          FirebaseAuth.instance.currentUser!.uid != widget.user.userId
              ? FilledButton.icon(
                  onPressed: followUser,
                  icon: const Icon(Icons.person_add),
                  label: const Text("Send Friend Request"))
              : const SizedBox(),
        ],
      ),
    );
  }
}
