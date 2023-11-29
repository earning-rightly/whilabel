const functions = require("firebase-functions");
const admin = require("firebase-admin");
// const auth = require("firebase-auth");

var serviceAccount = require("./whilabel-firebase-adminsdk-wpf10-2601dd9c96.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.createCustomTokenWithCreatAt = functions.https.onRequest(async (request, response) => {
  const user = request.body;

  const uid = `${user.snsType}:${user.uid}`;
  const updateParams = {
    email: user.email,
    photoURL: user.photoURL,
    displayName: user.displayName,
  };

  try {
    await admin.auth().updateUser(uid, updateParams);
  } catch (e) {
    updateParams["uid"] = uid;
    await admin.auth().createUser(updateParams);
  }

  const token = await admin.auth().createCustomToken(uid);

  response.send(token);
});