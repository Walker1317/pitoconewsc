/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();

sgMail.setApiKey('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');

exports.sendEmails = functions.https.onCall(async (data, context) => {
  const { recipients, subject, body } = data;

  const msg = {
    to: recipients,
    from: 'pitoconewsc@gmail.com',
    subject,
    text: body,
  };

  try {
    await sgMail.sendMultiple(msg);
    return { success: true };
  } catch (error) {
    console.error('Error sending emails:', error);
    throw new functions.https.HttpsError('internal', 'An error occurred while sending the emails.');
  }
});