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
      showSnackBar(context, '${widget.user.displayName} is now a friend.');
      setState(() {
        acceptedFriendRequest = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (acceptedFriendRequest == true) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(widget.user.displayName),
                  subtitle: Text("@${widget.user.username}"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    acceptedFriendRequest
                        ? TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.check_box_outlined),
                            label: const Text("Accepted"))
                        : TextButton.icon(
                            onPressed: () {
                              addFriend();
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text("Accept Request")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
