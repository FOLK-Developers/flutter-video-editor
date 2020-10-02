const functions = require('firebase-functions');
const admin=require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;
 
exports.myTrigger = functions.firestore.document('Messages/{messageId}').onCreate(async (snapshot, context) => {
    //
 
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }
 
    newData = snapshot.data();
    var tokens = [];
 
    const deviceIdTokens = await admin
        .firestore()
        .collection('DeviceTokens')
        .get();
 
    
 
    for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().device_token);
    }
    var payload = {
        notification: {
            title: 'Push Title',
            body: 'Push Body',
            sound: 'default',
            image:newData.image,
            // url:newData.url,
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            message:newData.message,
            // image:'https://firebasestorage.googleapis.com/v0/b/chat-139a3.appspot.com/o/user_image%2FvYoiHv6qPUNlasZoI5n4BpWaVso1.jpg?alt=media&token=3cfd4f23-e9f6-474c-a771-6d77bf2d4a9f',
            image:newData.image,
            url:"https://www.aikyayouth.org/",
            // push_key: 'Push Key Value',
            // key1: newData.data,
        },
    };
 
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (err) {
        console.log(err);
    }
});