import 'package:cloud_firestore/cloud_firestore.dart';

final friendshipsController = FirebaseFirestore.instance
    .collection("friendships")
    .withConverter<Friendships>(
        fromFirestore: (snapshot, _) => Friendships.fromJson(snapshot.data()!),
        toFirestore: (friendships, _) => friendships.toJson());

class Friendships {
  Friendships({required this.friends});

  final List<dynamic> friends;

  Friendships.fromJson(Map<String, Object?> json)
      : this(friends: json['friends']! as List<dynamic>);

  Map<String, Object?> toJson() {
    return {
      'friends': friends,
    };
  }
}
