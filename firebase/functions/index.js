const { onCall, HttpsError } = require("firebase-functions/v2/https");
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
        friendLocations: {},
    });
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
    const { longitude, latitude } = request.data;

    const batch = admin.firestore().batch();

    // update the current user's userLocation
    const currentUsersLocation = admin.firestore().collection("user_locations").doc(request.auth.uid);
    batch.update(currentUsersLocation, {
        longitude, latitude
    });

    // load the friend list of the current user
    return admin.firestore().collection("friend_requests").doc(request.auth.uid).get().then((doc) => {

        currentUsersFriends = doc.data().friends;

        // get the location data for each of their friends
        admin.firestore().collection("user_locations").where("userId", "in", currentUsersFriends).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
                userLocation = doc.data();

                // check if this friend is within 200 miles of the user


                // if this friend is within 200 miles, add the friend to the current user's
                // nearby_friends list


                // also add the current user to the other user's nearby_friends list


                // if this friend is not within 200 miles, remove the friend from the user user's
                // nearby friends list if they used to be in the list.


            });
        })
            .catch((error) => {
                console.log("Error getting documents: ", error);
            });
    });

})

