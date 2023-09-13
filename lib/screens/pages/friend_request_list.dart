import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:roam_mate/utils/friend_request_controller.dart';
import 'package:roam_mate/utils/profile_controller.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({super.key});

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  LoadingFriendRequestDataStatus loadingFriendRequestDataStatus =
      LoadingFriendRequestDataStatus.loading;

  late List<Profile> friendRequestList;

  @override
  void initState() {
    super.initState();

    List<Profile> friendRequestSenders = [];

    // load the list of all non-responded friend requests sent to this user
    friendRequestController
        .where("isFor", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("responded", isEqualTo: false)
        .get()
        .then((friendRequestsQuerySnapshot) {
      List<String> usernamesOfFriendRequestSenders = [];

      for (var friendRequest in friendRequestsQuerySnapshot.docs) {
        usernamesOfFriendRequestSenders.add(friendRequest.data().requestedBy);
      }

      // fetch the profile information of every user that sent a friend request
      profileController
          .where("userId", whereIn: usernamesOfFriendRequestSenders)
          .get()
          .then((profilesQuerySnapshot) {
        for (var profile in profilesQuerySnapshot.docs) {
          friendRequestSenders.add(profile.data());
        }

        setState(() {
          friendRequestList = friendRequestSenders;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Friend request list');
  }
}

// enum state for tracking loading states
enum LoadingFriendRequestDataStatus {
  loading,
  loaded,
  noData,
}
