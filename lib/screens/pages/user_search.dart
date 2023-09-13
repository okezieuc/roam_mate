import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  late Map<String, dynamic> friend;

  @override
  void initState() {
    super.initState();

    // load the data for the selected user
    db
        .collection("users")
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
          friend = querySnapshot.docs[0].data();
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
                ? UserProfile(user: friend)
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
