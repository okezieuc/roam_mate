import 'package:cloud_firestore/cloud_firestore.dart';

final profileController =
    FirebaseFirestore.instance.collection('users').withConverter<Profile>(
          fromFirestore: (snapshot, _) => Profile.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );

class Profile {
  Profile(
      {required this.userId,
      required this.username,
      required this.displayName});

  Profile.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId']! as String,
          username: json['username']! as String,
          displayName: json['displayName']! as String,
        );

  final String userId;
  final String username;
  final String displayName;

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
    };
  }
}
