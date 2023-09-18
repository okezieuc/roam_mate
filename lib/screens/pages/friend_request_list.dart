import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:roam_mate/utils/controllers/friend_request_controller.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/widgets/friend_request_list/request_list_user_profile.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({super.key});

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  LoadingFriendRequestDataStatus loadingFriendRequestDataStatus =
      LoadingFriendRequestDataStatus.loading;

  List<Profile> friendRequestList = [];

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
    return Column(
      children: [
        const Text('Friend request list'),
        for (var userProfile in friendRequestList)
          RequestListUserProfile(user: userProfile)
      ],
    );
  }
}

// enum state for tracking loading states
enum LoadingFriendRequestDataStatus {
  loading,
  loaded,
  noData,
}
