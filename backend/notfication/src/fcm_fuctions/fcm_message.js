const {
  initializeApp,
  applicationDefault,
  cert
} = require('firebase-admin/app')
const {
  getFirestore,
  Timestamp,
  FieldValue,
  Filter
} = require('firebase-admin/firestore')
const appUserSchema = '../../schema/app_user_schema.js' // appUserSchema가 정의된 파일 경로

var serviceAccount = require('../../whilabel-firebase-adminsdk-wpf10-1d22ff9fea.json')

initializeApp({
  credential: cert(serviceAccount)
})

const db = getFirestore()
const admin = require('firebase-admin')

async function sendAnnouncement (title, body, whiskyName, userid) {
  var fcmToken = await saveAnnouncement(title, body, whiskyName, userid)

  let message = {
    notification: {
      title: title,
      body: body
    },
    token: fcmToken,
    android: {
      priority: 'high'
    },
    apns: {
      payload: {
        aps: {
          contentAvailable: true
        }
      }
    }
  }

  admin
    .messaging()
    .send(message)
    .then(function (response) {
      console.log('Successfully sent message: : ', response)
    })
    .catch(function (err) {
      console.log('Error Sending message!!! : ', err)
    })
}
async function saveAnnouncement (title, body, whiskyName, userId) {
  var appUser = await db.collection('user').doc(userId).get()
  console.log(appUser.data())
  // const isValid = ajv.validate(appUser, appUserSchema);
  //     // if (appUser.data().announcements === null) {
  //     //     appUser["announcements"] = [];
  //     // }
  //     // else {

  //     // }

  var announcements = appUser.data().announcements ?? []

  var newAnnouncement = {
    title: title,
    body: body,
    whiskyName: whiskyName
  }

  // 새로운 알림 추가
  announcements.push(newAnnouncement)

  var newAnnouncement = {
    title: title,
    body: body,
    whiskyName: whiskyName
  }

  await db
    .collection('user')
    .doc(userId)
    .update({ announcements: announcements })

  return appUser.data().fcmToken
}

module.exports.sendAnnouncement = sendAnnouncement
