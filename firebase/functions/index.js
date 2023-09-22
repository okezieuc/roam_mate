const logger = require("firebase-functions/logger");
const functions = require("firebase-functions/v1");

const admin = require("firebase-admin");
admin.initializeApp();

exports.createFriendshipsRecord = functions.auth.user().onCreate((user) => {
    logger.log("Creating friendships record for ", user.uid);
    return admin.firestore().collection("friendships").doc(user.uid).create({ friends: [] });
})