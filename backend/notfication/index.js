const fcmMessage = require('./src/fcm_fuctions/fcm_message.js');


userId = "kakao:2964055896+1703139657379752"
title = "위스키 정보가 등록되었습니다"
body = "test 중인 알림입니다,"
whiskyName = "ㄹㅇㅇㄹㅇㄹㅇㄹㅇㄹㄹㅇㅇ"

fcmMessage.sendAnnouncement(title, body, whiskyName, userId);

async function showName() {

    const snapshot = await db.collection('user').orderBy("fcmToken").get();
    snapshot.forEach((doc) => {
        console.log(doc.id, '=>', doc.data().fcmToken);
    });

}

// 메ㅔ에 어드민

