const appUserSchema = {
    type: "object",
    required: [
        "firebaseUserId",
        "uid",
        "nickName",
        "snsUserInfo",
        "snsType",
        "creatAt",
    ],
    properties: {
        firebaseUserId: { type: "string" },
        uid: { type: "string" },
        nickName: { type: "string" },
        snsUserInfo: { type: "object" }, // snsUserInfo의 세부 스키마는 필요에 따라 정의
        snsType: { type: "string" }, // SnsType의 유효값 정의 필요
        creatAt: { type: "timestamp" },
        announcements: {
            type: "array",
            items: {
                // Announcement 객체의 스키마 정의 필요
            }
        },
        isDeleted: { type: "boolean", default: false },
        isPushNotificationEnabled: { type: "boolean", default: false },
        isMarketingNotificationEnabled: { type: "boolean", default: false },
        fcmToken: { type: "string" },
        birthDay: { type: "string" },
        name: { type: "string" },
        age: { type: "number" },
        gender: { type: "string" }, // Gender의 유효값 정의 필요
        email: { type: "string" },
        imageUrl: { type: "string" },
        sameKindWhiskyId: { type: "string" }
    }
};
