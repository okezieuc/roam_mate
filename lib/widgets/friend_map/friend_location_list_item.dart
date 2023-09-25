import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';

class FriendLocationListItem extends StatelessWidget {
  const FriendLocationListItem(
      {super.key,
      required this.profile,
      required this.userId,
      required this.locationInfo});

  final String userId;
  final Profile profile;
  final dynamic locationInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Text(
                    profile.displayName,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "@${profile.username}",
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("${locationInfo['distance'].round()} miles away"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
