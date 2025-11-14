// Use only Firebase Admin SDK on the server
const admin = require('firebase-admin');
const env = process.env;

// Initialize Firebase Admin
let adminInitialized = false;
try {
  // Handle a PRIVATE_KEY that may have escaped newline characters (e.g. from .env)
  const privateKey = env.PRIVATE_KEY ? env.PRIVATE_KEY.replace(/\\n/g, "\n") : undefined;

  if (!privateKey || !env.CLIENT_EMAIL) {
    console.error(
      'Firebase Admin credentials are missing or incomplete.\n' +
        'Set `PRIVATE_KEY` and `CLIENT_EMAIL` in your environment, or provide a service account JSON and set `GOOGLE_APPLICATION_CREDENTIALS`.'
    );
  } else if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert({
        type: 'service_account',
        project_id: 'genai-beab8',
        private_key_id: env.PRIVATE_KEY_ID,
        private_key: privateKey,
        client_email: env.CLIENT_EMAIL,
        client_id: env.CLIENT_ID,
        auth_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_uri: 'https://oauth2.googleapis.com/token',
        auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
        client_x509_cert_url:
          'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-okdkq%40genai-beab8.iam.gserviceaccount.com',
        universe_domain: 'googleapis.com',
      }),
      databaseURL: 'https://genai-beab8.firebaseio.com',
    });

    adminInitialized = true;
  }
} catch (err) {
  console.error('Failed to initialize Firebase Admin:', err && err.message ? err.message : err);
}

// Server-side Firestore (admin)
let db = null;
if (adminInitialized) {
  db = admin.firestore();
} else {
  console.warn('Firebase Admin not initialized; `db` is null. Ensure PRIVATE_KEY and CLIENT_EMAIL are set.');
}

// Web (frontend) Firebase config — exported so frontend can initialize client SDK
const webFirebaseConfig = {
  apiKey: "AIzaSyDyJsigLG8S3tyeqzw51IIf0aQ7X4UyxAg",
  authDomain: "mental-health-48a45.firebaseapp.com",
  projectId: "mental-health-48a45",
  storageBucket: "mental-health-48a45.firebasestorage.app",
  messagingSenderId: "898369877318",
  appId: "1:898369877318:web:9024dcccdacd889fc46147",
  measurementId: "G-W2TXB2YVSB"
};

module.exports = { db, admin, adminInitialized, webFirebaseConfig };