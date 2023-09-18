import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/widgets/user_search/user_profile.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  LoadingFriendsDataStatus loadingFriendsDataStatus =
      LoadingFriendsDataStatus.noData;

  late Profile returnedUserProfile;

  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void searchUserByUsername() {
    setState(() {
      loadingFriendsDataStatus = LoadingFriendsDataStatus.loading;
    });

    // load the data for the selected user
    profileController
        .where("username", isEqualTo: _usernameController.text)
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  filled: true,
                  labelText: 'Search',
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton.filled(
                onPressed: () {
                  searchUserByUsername();
                },
                icon: const Icon(Icons.search)),
          ],
        ),
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
