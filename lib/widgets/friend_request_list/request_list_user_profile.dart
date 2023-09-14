import 'package:flutter/material.dart';
import 'package:roam_mate/utils/profile_controller.dart';

class RequestListUserProfile extends StatefulWidget {
  const RequestListUserProfile({super.key, required this.user});

  final Profile user;

  @override
  State<RequestListUserProfile> createState() => _RequestListUserProfileState();
}

class _RequestListUserProfileState extends State<RequestListUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.user.displayName}'),
        Text('Username: ${widget.user.username}'),
      ],
    );
  }
}
