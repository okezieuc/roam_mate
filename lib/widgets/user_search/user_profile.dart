import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.user["display_name"]}'),
        Text('Username: ${widget.user["username"]}')
      ],
    );
  }
}
