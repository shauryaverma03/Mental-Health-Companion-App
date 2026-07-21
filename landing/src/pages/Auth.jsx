import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { auth, googleProvider } from "../firebase";
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendPasswordResetEmail,
  signInWithPopup,
} from "firebase/auth";

// Google Logo SVG (self-contained, no path issues)
const GoogleIcon = () => (
  <svg className="h-5 w-5" viewBox="0 0 48 48">
    <path
      fill="#4285F4"
      d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l8.06 6.22C12.91 13.56 18.06 9.5 24 9.5z"
    ></path>
    <path
      fill="#34A853"
      d="M46.94 24.5c0-1.56-.14-3.08-.4-4.55H24v8.51h12.8c-.57 2.74-2.34 5.09-4.82 6.62l7.2 5.56C43.5 37.1 46.94 31.3 46.94 24.5z"
    ></path>
    <path
      fill="#FBBC05"
      d="M10.62 28.5c-.29-.87-.45-1.8-.45-2.78s.16-1.91.45-2.78l-8.06-6.22C.96 18.46 0 21.13 0 24c0 2.87.96 5.54 2.56 7.72l8.06-6.22z"
    ></path>
    <path
      fill="#EA4335"
      d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.2-5.56c-2.11 1.41-4.8 2.26-7.69 2.26-5.14 0-9.6-3.4-11.17-8.03l-8.06 6.22C6.51 42.62 14.62 48 24 48z"
    ></path>
    <path fill="none" d="M0 0h48v48H0z"></path>
  </svg>
);

export default function AuthPage() {
  const [mode, setMode] = useState("login"); // 'login' | 'signup' | 'forgot'
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [status, setStatus] = useState("");
  const [loading, setLoading] = useState(false);

  const navigate = useNavigate();

  const handleGoogle = async () => {
    setLoading(true);
    setStatus("");
    try {
      await signInWithPopup(auth, googleProvider);
      navigate("/chat");
    } catch (err) {
      setStatus(err.message || "Google sign-in failed.");
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus("");
    setLoading(true);
    try {
      if (mode === "login") {
        await signInWithEmailAndPassword(auth, email, password);
        navigate("/chat");
      } else if (mode === "signup") {
        await createUserWithEmailAndPassword(auth, email, password);
        navigate("/chat");
      } else if (mode === "forgot") {
        await sendPasswordResetEmail(auth, email);
        setStatus("Password reset email sent. Check your inbox.");
        setMode("login");
      }
    } catch (err) {
      setStatus(err.message || "An error occurred.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 p-4">
      <div className="w-full max-w-md bg-white rounded-xl shadow-lg p-8">
        {/* Logo Header */}
        <div className="flex justify-center mb-6">
          <Link to="/" className="flex items-center gap-2">
            <img src="/otter.gif" className="h-10" alt="Saathi Logo" />
            <span className="text-2xl font-bold">Saathi</span>
          </Link>
        </div>

        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-semibold text-gray-800">
            {mode === "login"
              ? "Welcome back"
              : mode === "signup"
              ? "Create your account"
              : "Reset Password"}
          </h2>
          <button
            type="button"
            onClick={() => setMode(mode === "login" ? "signup" : "login")}
            className="text-sm text-[#0CADB5] hover:underline font-medium"
          >
            {mode === "login" ? "Sign up" : "Log in"}
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 block w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-[#0CADB5] focus:ring focus:ring-[#0CADB5] focus:ring-opacity-50"
            />
          </div>

          {mode !== "forgot" && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Password
              </label>
              <input
                type="password"
                required={mode !== "forgot"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="mt-1 block w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-[#0CADB5] focus:ring focus:ring-[#0CADB5] focus:ring-opacity-50"
              />
            </div>
          )}

          <div className="flex items-center justify-between pt-2">
            <button
              type="submit"
              disabled={loading}
              className="px-5 py-2.5 bg-[#0CADB5] text-white rounded-full font-medium hover:bg-[#089399] disabled:opacity-50 transition duration-200"
            >
              {mode === "login"
                ? "Login"
                : mode === "signup"
                ? "Sign Up"
                : "Send Reset Email"}
            </button>

            {mode === "login" && (
              <button
                type="button"
                onClick={() => setMode("forgot")}
                className="text-sm text-gray-600 hover:underline"
              >
                Forgot password?
              </button>
            )}
          </div>

          <div className="relative flex items-center justify-center py-2">
            <div className="flex-grow border-t border-gray-200"></div>
            <span className="flex-shrink mx-4 text-sm text-gray-500">
              or
            </span>
            <div className="flex-grow border-t border-gray-200"></div>
          </div>

          <button
            type="button"
            onClick={handleGoogle}
            disabled={loading}
            className="w-full inline-flex items-center justify-center gap-3 border border-gray-300 p-2.5 rounded-full hover:bg-gray-50 transition duration-200 shadow-sm"
          >
            <GoogleIcon />
            <span className="text-sm font-medium text-gray-700">
              Continue with Google
            </span>
          </button>

          {status && (
            <p className="text-sm text-red-500 text-center pt-2">{status}</p>
          )}

          <p className="text-xs text-gray-500 text-center pt-4">
            By continuing, you agree to Saathi's{" "}
            <Link to="/terms" className="underline hover:text-gray-700">
              Terms of Service
            </Link>
            .
          </p>
        </form>
      </div>
    </div>
  );
}