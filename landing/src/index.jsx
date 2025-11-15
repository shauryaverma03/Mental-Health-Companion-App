import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import './index.css'; // if you use a global css / tailwind entry - keep or remove as appropriate

// Mount the app
const container = document.getElementById('root');
if (!container) {
  // If your HTML uses a different root id, update it or ensure index.html has <div id="root"></div>
  throw new Error('No root element found. Ensure public/index.html contains <div id="root"></div>');
}
createRoot(container).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
