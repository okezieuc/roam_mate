const { onCall, } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions/v1");

const admin = require("firebase-admin");
admin.initializeApp();

exports.createFriendshipsRecord = functions.auth.user().onCreate((user) => {
    logger.log("Creating friendships record for ", user.uid);
    return admin.firestore().collection("friendships").doc(user.uid).create({ friends: [] });
})

exports.createNearbyFriendsRecord = functions.auth.user().onCreate((user) => {
    logger.log("Creating nearby_friends recrod for ", user.uid);
    return admin.firestore().collection("nearby_friends").doc(user.uid).create({
        user_ids: [],
    });
})

exports.createUserLocationsRecord = functions.auth.user().onCreate((user) => {
    logger.log("Creating a user_locations record for ", user.uid);
    return admin.firestore().collection("user_locations").doc(user.uid).create({
        longitude: 179,
        latitude: 179,
        userId: user.uid,
    })
})

exports.addFriend = onCall((request) => {
    const requesterUserId = request.data.requesterUserId;
    const accepterUserId = request.auth.uid;
    const friendRequestId = request.data.friendRequestId;

    const batch = admin.firestore().batch();

    // add the requester as a friend of the accepter
    const requesterFriendships = admin.firestore().collection("friendships").doc(accepterUserId);
    batch.update(requesterFriendships, {
        "friends": admin.firestore.FieldValue.arrayUnion(requesterUserId)
    });

    // add the accepter as a friend of the requester
    const accepterFriendships = admin.firestore().collection("friendships").doc(requesterUserId);
    batch.update(accepterFriendships, {
        "friends": admin.firestore.FieldValue.arrayUnion(accepterUserId)
    });

    // set responded to true in the friend_request
    const friendRequest = admin.firestore().collection("friend_requests").doc(friendRequestId);
    batch.update(friendRequest, { "responded": true, "isRequestApproved": true });

    return batch.commit().then((_) => {
        logger.log("a new friend pair created");
        return { "result": "friendship accepted", "successful": true };
    })
})

exports.updateLocation = onCall((request) => {
    logger.log("starting to update location");
    const { longitude, latitude } = request.data;


    const batch = admin.firestore().batch();

    // update the current user's userLocation

    // the problem with this code is that update fails when the thing that you are trying to udpate
    // does not already exist. and it appears that we do not create a user_lications entry automatically
    // for a user when they sign up.
    const currentUsersLocation = admin.firestore().collection("user_locations").doc(request.auth.uid);
    batch.update(currentUsersLocation, {
        longitude, latitude
    });

    logger.log("will update user_location record");

    // load the friend list of the current user
    admin.firestore().collection("friendships").doc(request.auth.uid).get().then((doc) => {
        currentUsersFriends = doc.data().friends;

        logger.log("got friend list");

        // get the location data for each of their friends
        admin.firestore().collection("user_locations").where("userId", "in", currentUsersFriends).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
                userLocation = doc.data();

                // check if this friend is within 200 miles of the user
                pairDistance = distance(latitude, userLocation.latitude, longitude, userLocation.longitude);

                // switch back to <= 200
                if (pairDistance >= 200) {
                    // if this friend is within 200 miles, add the friend to the current user's
                    // nearby_friends list

                    logger.log("creating a log record for a friend")

                    const currentUserNearbyFriends = admin.firestore().collection("nearby_friends").doc(request.auth.uid);
                    batch.update(currentUserNearbyFriends, {
                        "user_ids": admin.firestore.FieldValue.arrayUnion(userLocation.userId),
                        // also, add create a field in nearby_friends to store the distance between the two 
                        [userLocation.userId]: {
                            "distance": pairDistance,
                        },
                    });

                    // also add the current user to the other user's nearby_friends list
                    const otherUserNearbyFriends = admin.firestore().collection("nearby_friends").doc(userLocation.userId);
                    batch.update(otherUserNearbyFriends, {
                        "user_ids": admin.firestore.FieldValue.arrayUnion(request.auth.uid),
                        // and add the distance between the two
                        [request.auth.uid]: {
                            "distance": pairDistance,
                        },
                    });

                } else {
                    logger.log("deleting a log record for a friend")

                    // if this friend is not within 200 miles, remove the friend from the user's
                    // nearby friends list if they used to be in the list.
                    const currentUserNearbyFriends = admin.firestore().collection("nearby_friends").doc(request.auth.uid);
                    batch.update(currentUserNearbyFriends, {
                        "user_ids": admin.firestore.FieldValue.arrayRemove(userLocation.userId),
                        // also remove the field that stores the distance between the two
                        [userLocation.userId]: admin.firestore.FieldValue.delete(),
                    });

                    // and remove from the other user's nearby friends list
                    const otherUserNearbyFriends = admin.firestore().collection("nearby_friends").doc(userLocation.userId);
                    batch.update(otherUserNearbyFriends, {
                        "user_ids": admin.firestore.FieldValue.arrayRemove(request.auth.uid),
                        // and remove the distance between the two
                        [request.auth.uid]: admin.firestore.FieldValue.delete(),
                    });
                }
            });
        }).then((_) => {
            return batch.commit().then((_) => {
                logger.log("added a new user's location and made accompanying updates");
                return { "result": "location updated", "successful": true };
            });
        });
    })



})

// distance function adapted from https://www.geeksforgeeks.org/program-distance-two-points-earth/
function distance(lat1,
    lat2, lon1, lon2) {

    // The math module contains a function
    // named toRadians which converts from
    // degrees to radians.
    lon1 = lon1 * Math.PI / 180;
    lon2 = lon2 * Math.PI / 180;
    lat1 = lat1 * Math.PI / 180;
    lat2 = lat2 * Math.PI / 180;

    // Haversine formula
    let dlon = lon2 - lon1;
    let dlat = lat2 - lat1;
    let a = Math.pow(Math.sin(dlat / 2), 2)
        + Math.cos(lat1) * Math.cos(lat2)
        * Math.pow(Math.sin(dlon / 2), 2);

    let c = 2 * Math.asin(Math.sqrt(a));

    // Radius of earth in kilometers. Use 3956
    // for miles and 6371 for kilometers
    let r = 3956;

    // calculate the result
    return (c * r);
}  
