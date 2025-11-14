// Firebase initialization for the landing (web) app
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore } from "firebase/firestore";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDyJsigLG8S3tyeqzw51IIf0aQ7X4UyxAg",
  authDomain: "mental-health-48a45.firebaseapp.com",
  projectId: "mental-health-48a45",
  storageBucket: "mental-health-48a45.firebasestorage.app",
  messagingSenderId: "898369877318",
  appId: "1:898369877318:web:9024dcccdacd889fc46147",
  measurementId: "G-W2TXB2YVSB",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
let analytics;
try {
  analytics = getAnalytics(app);
} catch (err) {
  // Analytics may fail to initialize in non-browser environments (e.g. SSR, tests)
  // or if the measurementId is not configured for this environment.
  // Fail gracefully and continue without analytics.
  // console.warn('Firebase analytics not initialized:', err.message || err);
}

const db = getFirestore(app);

export { app, analytics, db };
