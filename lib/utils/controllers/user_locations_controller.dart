import 'package:cloud_firestore/cloud_firestore.dart';

final userLocationsController = FirebaseFirestore.instance
    .collection("user_locations")
    .withConverter<UserLocation>(
      fromFirestore: (snapshot, _) => UserLocation.fromJson(snapshot.data()!),
      toFirestore: (userLocation, _) => userLocation.toJson(),
    );

class UserLocation {
  UserLocation({required this.longitude, required this.latitude});

  UserLocation.fromJson(Map<String, Object?> json)
      : this(
          longitude: json['longitude']! as double,
          latitude: json['latitude']! as double,
        );

  final double longitude;
  final double latitude;

  Map<String, Object?> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
