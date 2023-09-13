import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/utils/profile_controller.dart';
import 'package:roam_mate/widgets/user_search/user_profile.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  LoadingFriendsDataStatus loadingFriendsDataStatus =
      LoadingFriendsDataStatus.loading;

  late Profile returnedUserProfile;

  @override
  void initState() {
    super.initState();

    // load the data for the selected user
    profileController
        .where("username",
            isEqualTo:
                "janedoe") // replace "janedoe" with data from an input source
        .limit(1)
        .get()
        .then((querySnapshot) {
      // update state and loading tracker based on returned data
      setState(() {
        if (querySnapshot.docs.isEmpty) {
          loadingFriendsDataStatus = LoadingFriendsDataStatus.noData;
        } else {
          returnedUserProfile = querySnapshot.docs[0].data();
          loadingFriendsDataStatus = LoadingFriendsDataStatus.loaded;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text("User Data"),
        loadingFriendsDataStatus == LoadingFriendsDataStatus.loading
            ? const Text("Loading")
            : (loadingFriendsDataStatus == LoadingFriendsDataStatus.loaded
                ? UserProfile(user: returnedUserProfile)
                : const Text("No data"))
      ],
    ));
  }
}

// enum state for tracking loading states of add friends page
enum LoadingFriendsDataStatus {
  loading,
  loaded,
  noData,
}
