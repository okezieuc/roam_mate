import 'package:cloud_firestore/cloud_firestore.dart';

final friendRequestController = FirebaseFirestore.instance
    .collection("friend_requests")
    .withConverter<FriendRequest>(
        fromFirestore: (snapshot, _) =>
            FriendRequest.fromJson(snapshot.data()!),
        toFirestore: (friendRequest, _) => friendRequest.toJson());

class FriendRequest {
  FriendRequest(
      {required this.requestedBy,
      required this.isFor,
      required this.isRequestApproved,
      required this.responded});

  FriendRequest.fromJson(Map<String, Object?> json)
      : this(
          requestedBy: json['requestedBy']! as String,
          isFor: json['isFor']! as String,
          isRequestApproved: json['isRequestApproved']! as bool,
          responded: json['responded']! as bool,
        );

  final String requestedBy;
  final String isFor;
  final bool isRequestApproved;
  final bool responded;

  Map<String, Object?> toJson() {
    return {
      'requestedBy': requestedBy,
      'isFor': isFor,
      'isRequestApproved': isRequestApproved,
      'responded': responded,
    };
  }
}
