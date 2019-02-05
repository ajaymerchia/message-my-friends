const functions = require('firebase-functions');
const admin = require('firebase-admin');



// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp(functions.config().firebase);
exports.friendStatusChange = functions.database.ref('/users/{person}/statuses/{friend}').onWrite((snapshot, context) => {
    var personID = context.params.person
    var friendID = context.params.friend
    var newStatus = snapshot.after.val()

    console.log("Friend status change detected")


    return loadUser(personID).then(target => {
        console.log("loaded " + target["first"] + "'s profile for fcmToken'")
        return loadUser(friendID).then(src => {
            const registrationToken = target["fcmToken"]
            const fullname = src["first"] + " " + src["last"]
            console.log("loaded " + fullname + "'s profile for the body.'")

            var alertJSON = "friend status changed"
            if (newStatus === "pending") {
                alertJSON = fullname + " has sent you a friend request."
            } else if (newStatus === "friends") {
                alertJSON = fullname + " has accepted your friend request."
            } else {
                alertJSON = fullname + " has changed location sharing status with you."
            }


            var message = {
                  apns: {
                      headers: {
                        'apns-priority': '10'
                      },
                      payload: {
                        aps: {
                          alert: alertJSON,
                          sound: "default",
                        }
                      }

                    },
                  token: registrationToken,
                }

            console.log("sending message")
            console.log(message)

            return admin.messaging().send(message)
        })
    })
})

exports.notifyNewMessage = functions.database.ref('/chats/{chatID}/messages/{msgID}').onWrite((snapshot, context) => {
  const messageContents = snapshot.after.val()

  const senderID = messageContents["sender"]
  const chatID = context.params.chatID
  const textSent = messageContents["msg"]
  var recipID = ""

  if (chatID.endsWith(senderID)) {
      recipID = chatID.substring(0, chatID.indexOf(senderID))
  } else {
      recipID = chatID.substring(senderID.length)
  }

  console.log(senderID + " sent " + recipID + " a message that says: " + textSent)

  return loadUser(recipID).then(recipient => {
      console.log("got recipient")
      return loadUser(senderID).then(sender => {
          console.log("got sender")

          const senderName = sender["first"] + " " + sender["last"]
          const registrationToken = recipient["fcmToken"]
          var message = {
            apns: {
                headers: {
                  'apns-priority': '10'
                },
                payload: {
                  aps: {
                    alert: {title: senderName, body: textSent},
                    badge: 0,
                    sound: "default",
                  },
                }
            },
            token: registrationToken,
          }

          console.log("sending message")
          console.log(message)
          console.log(message.apns.payload.aps)


          return admin.messaging().send(message)


      })
  })

})


function loadUser(uid) {
  let dbRef = admin.database().ref('/users/' + uid);
    let defer = new Promise((resolve, reject) => {
        dbRef.once('value', (snap) => {
            let data = snap.val();
            resolve(data);
        }, (err) => {
            reject(err);
        });
    });
    return defer;
}

function loadChat(uid) {
  let dbRef = admin.database().ref('/chats/' + uid);
    let defer = new Promise((resolve, reject) => {
        dbRef.once('value', (snap) => {
            let data = snap.val();
            resolve(data);
        }, (err) => {
            reject(err);
        });
    });
    return defer;
}
