import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roam_mate/utils/controllers/user_locations_controller.dart';
import 'package:roam_mate/utils/determine_position.dart';
import 'package:roam_mate/utils/show_snackbar.dart';

class FriendMap extends StatefulWidget {
  const FriendMap({super.key});

  @override
  State<FriendMap> createState() => _FriendMapState();
}

class _FriendMapState extends State<FriendMap> {
  void signOut() {
    FirebaseAuth.instance.signOut();
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
                    .set(UserLocation(
                        longitude: location.longitude,
                        latitude: location.latitude));

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
