import React, { Suspense, lazy } from 'react';
import { Routes, Route, Navigate } from "react-router-dom";

// Import pages
import Home from "../pages/Home";
import AuthPage from "../pages/Auth";

// Lazy-load Chat just like in App.jsx
const Chatbot = lazy(() => import('../pages/Chat').then(mod => ({ default: mod.default })));

const Router = () => {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center">Loading...</div>}>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/auth" element={<AuthPage />} />
        <Route path="/chat" element={<Chatbot />} />
        {/* Adds the fallback route back in */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Suspense>
  );
};

export default Router;