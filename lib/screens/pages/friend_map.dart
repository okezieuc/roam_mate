import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roam_mate/utils/controllers/friendships_controller.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';
import 'package:roam_mate/utils/controllers/user_locations_controller.dart';
import 'package:roam_mate/utils/determine_position.dart';
import 'package:roam_mate/utils/show_snackbar.dart';
import 'package:roam_mate/widgets/user_search/user_profile.dart';

class FriendMap extends StatefulWidget {
  const FriendMap({super.key});

  @override
  State<FriendMap> createState() => _FriendMapState();
}

class _FriendMapState extends State<FriendMap> {
  List<dynamic> currentUsersFriends = [];
  Map<String, Profile> friendsUserProfiles = {};

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();

    // fetch a list of the current user's friends from Firestore
    List<dynamic> currentUsersFriendsData = [];
    Map<String, Profile> friendsUserProfilesData = {};
    Map<String, UserLocation> friendsUserLocationsData = {};

    friendshipsController
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (doc) {
        currentUsersFriendsData = doc.data()!.friends;
        return currentUsersFriendsData;
      },
      onError: (e) => print("Error getting document: $e"),
    ).then((_) {
      // get the profile data for each of the user's friends. store this in a map.
      profileController
          .where("userId", whereIn: currentUsersFriendsData)
          .get()
          .then((querySnapshot) {
        for (var userProfile in querySnapshot.docs) {
          friendsUserProfilesData[userProfile.data().userId] =
              userProfile.data();
        }
      });
    }).then((_) {
      setState(() {
        currentUsersFriends = currentUsersFriendsData;
        friendsUserProfiles = friendsUserProfilesData;
      });
    });

    /*.then((_) {
      print(currentUsersFriends);

      // get the location data for each of the user's friends. store this in a map
      userLocationsController
          .where("userId", whereIn: currentUsersFriends)
          .get()
          .then((querySnapshot) {
        for (var userLocation in querySnapshot.docs) {
          friendsUserLocations[userLocation.data().userId] =
              userLocation.data();
        }

        print(friendsUserLocations.toString());
      });
    });*/

    // update the state
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                Position location = await determinePosition();

                userLocationsController
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  "longitude": location.longitude,
                  "latitude": location.latitude
                });

                if (!context.mounted) return;
                showSnackBar(context, "Updated your location on Firebase");
              },
              child: const Text("Update my location")),
          TextButton(
              onPressed: () {
                signOut();
              },
              child: const Text("Sign out")),
        ],
      ),
    );
  }
}
