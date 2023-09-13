import 'package:flutter/material.dart';
import 'package:roam_mate/utils/profile_controller.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  final Profile user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.user.displayName}'),
        Text('Username: ${widget.user.username}')
      ],
    );
  }
}
