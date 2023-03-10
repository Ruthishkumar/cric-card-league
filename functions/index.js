const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

 // Create and deploy your first functions
 // https://firebase.google.com/docs/functions/get-started

 exports.helloWorld = functions.https.onRequest((request, response) => {
   functions.logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
 });

 exports.addNumbers = functions.https.onCall((data) => {
 // [ending addFunctionTrigger]
   // [starting readAddData]
   // Numbers are passed from the client.
   const firstNumber = data.firstNumber;
   const secondNumber = data.secondNumber;
   // [ending readAddData]

   // [starting addHttpsError]
   // check that attributes are present and are numbers.
   if (!Number.isFinite(firstNumber) || !Number.isFinite(secondNumber)) {
     // Throw an HttpsError. So that the client gets the error details.
     throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
         'two arguments "firstNumber" and "secondNumber" which must both be numbers.');
   }
   // [ending addHttpsError]

   // [starting returnAddData]
   // returning result.
   return {
     firstNumber: firstNumber,
     secondNumber: secondNumber,
     operator: '+',
     operationResult: firstNumber + secondNumber,
   };
   // [ending returnAddData]
 });

 exports.register = functions.https.onRequest((request , response) => {
  if (request.method !== "POST") {
      response.status(400).send("what are you trying baby?");
      return 0;
  }
   const email = request.body.email;
   const pass = request.body.pass;
   admin.auth().createUser({
       email: email,
       emailVerified: true,
       password: pass,
   })
       .then(function(userRecord) {
           console.log("Conductor " + email + "Creado" );
           response.send({"uid":userRecord.uid});
           return 1;
       })
       .catch(function(error) {
           response.send("Error: "+error);
           console.log("Error creating new user:", error);
           return 1;
       });
    return 1;
});
