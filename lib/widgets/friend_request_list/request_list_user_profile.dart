import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/show_snackbar.dart';

class RequestListUserProfile extends StatefulWidget {
  const RequestListUserProfile(
      {super.key, required this.user, required this.friendRequestId});

  final Profile user;
  final String friendRequestId;

  @override
  State<RequestListUserProfile> createState() => _RequestListUserProfileState();
}

class _RequestListUserProfileState extends State<RequestListUserProfile> {
  bool acceptedFriendRequest = false;

  void addFriend() {
    FirebaseFunctions.instance.httpsCallable('addFriend').call({
      "requesterUserId": widget.user.userId,
      "friendRequestId": widget.friendRequestId,
    }).then((res) {
      showSnackBar(context, 'Friend Request Accepted');
      setState(() {
        acceptedFriendRequest = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.user.displayName}'),
        Text('Username: ${widget.user.username}'),
        acceptedFriendRequest
            ? TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_box_outlined),
                label: const Text("Accepted"))
            : TextButton.icon(
                onPressed: () {
                  addFriend();
                },
                icon: const Icon(Icons.add),
                label: const Text("Accept Request"))
      ],
    );
  }
}
