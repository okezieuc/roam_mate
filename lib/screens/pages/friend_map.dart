import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/determine_position.dart';
import 'package:roam_mate/utils/show_snackbar.dart';
import 'package:roam_mate/widgets/friend_map/friend_location_list_item.dart';

class FriendMap extends StatefulWidget {
  const FriendMap({super.key});

  @override
  State<FriendMap> createState() => _FriendMapState();
}

class _FriendMapState extends State<FriendMap> {
  List<dynamic> nearbyFriends = [];
  Map<String, Profile> friendsUserProfiles = {};
  Map<String, dynamic> nearbyFriendsLocationData = {};

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();

    Map<String, Profile> friendsUserProfilesData = {};

    // get data for all friends that are near the current user

    FirebaseFirestore.instance
        .collection("nearby_friends")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      final nearbyFriendsData = doc.data();

      // loop over the friends and get the profile data for each user
      profileController
          .where("userId", whereIn: nearbyFriendsData!['user_ids'])
          .get()
          .then((querySnapshot) {
        for (var userProfile in querySnapshot.docs) {
          friendsUserProfilesData[userProfile.data().userId] =
              userProfile.data();
        }
      }).then(
        (value) {
          if (!mounted) return;
          setState(() {
            // update our state afterward
            nearbyFriends = nearbyFriendsData['user_ids'];
            friendsUserProfiles = friendsUserProfilesData;
            nearbyFriendsLocationData = nearbyFriendsData;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                Position location = await determinePosition();
                FirebaseFunctions.instance
                    .httpsCallable('updateLocation')
                    .call({
                  "longitude": location.longitude,
                  "latitude": location.latitude,
                });

                if (!context.mounted) return;
                showSnackBar(context, "Updated your location on Firebase");
              },
              child: const Text("Update my location")),
          for (var friend in nearbyFriends)
            FriendLocationListItem(
              profile: friendsUserProfiles[friend]!,
              userId: friend,
              locationInfo: nearbyFriendsLocationData[friend],
            ),
        ],
      ),
    );
  }
}
