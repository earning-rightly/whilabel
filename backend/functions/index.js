const functions = require('firebase-functions')
const admin = require('firebase-admin')
const { getAuth } = require('firebase-admin/auth')
const { getFirestore, Timestamp } = require('firebase-admin/firestore')

var serviceAccount = require('../whilabel-firebase-adminsdk-wpf10-b9b02a24a7.json')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://whilabel-default-rtdb.firebaseio.com'
})
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.createCustomTokenWithCreatAt = functions.https.onRequest(
  async (request, response) => {
    const user = request.body

    const uid = `${user.snsType}:${user.uid}`
    const updateParams = {
      email: user.email,
      photoURL: user.photoURL,
      displayName: user.displayName
    }

    try {
      await admin.auth().updateUser(uid, updateParams)
    } catch (e) {
      updateParams['uid'] = uid
      await admin.auth().createUser(updateParams)
    }

    const token = await admin.auth().createCustomToken(uid)

    response.send(token)
  }
)

exports.withdrawUser = functions.https.onRequest(async (request, response) => {
  const firestoreDB = getFirestore()
  const authorization = request.header('authorization')
  const _body = request.body

  // Bearer token 여부 확인
  if (authorization) {
    const idToken = authorization.split('Bearer ')[1]
    if (!idToken) {
      response.status(400).send({ response: 'Unauthenticated request!' })
      return
    }

    return admin
      .auth()
      .verifyIdToken(idToken)
      .then(async decodedToken => {
        const firbaseUid = decodedToken.uid
        await firestoreDB
          .collection('user')
          .doc(`${_body.uid}`)
          .update({
            isDeleted: true,
            nickName: `${_body.nickName}+deletd`
          })

        await admin.auth().deleteUser(`${firbaseUid}`)

        response.status(200).send({ response: 'Authenticated request!' })
      })
      .catch(err => {
        response.status(400).send({ response: 'Unauthenticated request!' })
      })
  }
})
