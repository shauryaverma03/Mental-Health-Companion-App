
// New App.jsx
import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import Router from './components/Router'; // <-- Assuming you saved it in /components

export default function App() {
  return (
    <BrowserRouter basename="/Saathi">
      <Router />
    </BrowserRouter>
  );
}