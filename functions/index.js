const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

exports.sendPushNotification = onDocumentCreated("calls/{callId}", async (event) => {
  const data = event.data?.data();

  if (!data) {
    console.log("No data found in document.");
    return;
  }

  const { name, number, fcmToken } = data;

  const message = {
    notification: {
      title: `Incoming Call from ${name}`,
      body: `Phone: ${number}`,
    },
    token: fcmToken,
  };

  try {
    const response = await getMessaging().send(message);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.error("Error sending message:", error);
  }
});

