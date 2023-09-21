import 'package:flutter/material.dart';
import 'package:roam_mate/utils/controllers/profile_controller.dart';

class FriendLocationListItem extends StatelessWidget {
  const FriendLocationListItem(
      {super.key, required this.profile, required this.userId});

  final String userId;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(profile.displayName),
        Text("@${profile.username}"),
      ],
    );
  }
}
