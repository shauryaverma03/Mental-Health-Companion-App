import React, { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import { GoogleGenerativeAI } from "@google/generative-ai";
import './Chat.css';
// fallback SVG kept in the repo; primary logo should be served from public/otterChat.png
import fallbackLogo from '../assets/images/logo.svg';

// NEW: Import Link and useNavigate for routing
import { Link, useNavigate } from 'react-router-dom';

// NEW: Import firebase auth and firestore
import { auth, db } from '../firebase'; //
import { onAuthStateChanged, signOut } from 'firebase/auth'; //
import { doc, setDoc, getDoc, collection, getDocs, query, where, addDoc, deleteDoc, updateDoc, serverTimestamp } from 'firebase/firestore'; //

const PUBLIC_LOGO = '/otterChat.png';

// --- Configuration ---
const GEMINI_API_KEY = "AIzaSyBTQu6Q7Pt3GZFnH3xUGFCvmKALYde6HZI";
const PLACEHOLDER_KEY = "YOUR_GEMINI_API_KEY_HERE";

// --- ChatBubble Component (no changes) ---
const ChatBubble = ({ message, sender }) => {
  const isUser = sender === 'user';
  const isTyping = message === 'Typing...';
  const entranceClass = isUser ? 'slide-in-right' : 'slide-in-left';

  return (
    <div className={`flex ${isUser ? 'justify-end' : 'justify-start'} mb-4 chat-row items-end`}>
      {!isUser && (
        <img
          src={PUBLIC_LOGO}
          alt="otterChat"
          className="chat-avatar mr-3"
          onError={(e) => {
            // If public image missing, fall back to the bundled svg
            e.currentTarget.onerror = null;
            e.currentTarget.src = fallbackLogo;
          }}
        />
      )}
      <div
        className={`max-w-xs md:max-w-md px-4 py-3 rounded-lg shadow-md chat-bubble ${isUser ? 'user' : 'bot'} ${entranceClass} ${isTyping ? 'typing' : ''}`}
        aria-live={isTyping ? 'polite' : 'off'}
      >
        {isTyping ? (
          <span className="typing-dots" aria-hidden="true">
            <span></span><span></span><span></span>
          </span>
        ) : (
          <p className="text-sm">{message}</p>
        )}
      </div>
    </div>
  );
};

export const CHAT_ROUTE = '/chat';

// --- Helper utilities (no changes) ---
const MENTAL_KEYWORDS = [
  'feel','feelings','depress','depressed','anxiety','anxious','stress','stressed',
  'therapy','therapist','panic','suicide','lonely','mood','sad','happy','overwhelmed',
  'mental','mental health','emotion','emotionally','hurt','help'
];
const SOCIAL_KEYWORDS = [
  'hi','hlo','hllo','hello','hey','thanks','thank','thank you','appreciate','appreciation',
  'good morning','good afternoon','good evening','goodnight','bye','goodbye',
  'welcome','how are you','howdy','congrats','congratulations'
];
const COMMON_REASONS = [
  'stressful life events',
  'relationship problems',
  'work or academic pressure',
  'financial difficulties',
  'social isolation',
  'loss or bereavement'
];
const SCENARIO_GUIDANCE = [
  { keys: ['family','parents','forced','pressure','pressure from family'], guidance: 'If family pressures feel overwhelming, try setting a small boundary, talk with a trusted friend, and consider counseling for support.' },
  { keys: ['breakup','ex','divorce','relationship ended','left me'], guidance: 'After a breakup, allow yourself to grieve, maintain simple routines, reach out to friends, and avoid big decisions while emotional.' },
  { keys: ['job','fired','unemployed','laid off','career'], guidance: 'Job loss impacts self-worth; focus on small practical steps (resume, network), seek support, and explore local employment resources.' },
  { keys: ['bereav','grief','loss of','died','passed away'], guidance: 'Grief is normal; allow feelings, seek support from others, and consider bereavement counseling if needed.' },
  { keys: ['bully','bullying','abuse','harass','harassed'], guidance: 'If you face bullying or abuse, prioritize safety, document incidents, seek trusted support, and contact authorities or helplines if at risk.' },
  { keys: ['exam','study','grades','school','college','pressure','academic'], guidance: 'Academic stress: break tasks into small steps, use a study plan, ask for help, and speak with school counselors.' },
  { keys: ['money','debt','finance','financial','bills'], guidance: 'Financial stress: make a simple budget, look for financial advice or assistance programs, and share concerns with someone you trust.' },
  { keys: ['lonely','isolate','isolated','alone'], guidance: 'Loneliness: try small steps to connect (a call, group, or volunteer), and schedule regular social check-ins.' }
];

function detectScenarioAndGuidance(text) {
  if (!text) return null;
  const t = text.toLowerCase();
  for (const s of SCENARIO_GUIDANCE) {
    if (s.keys.some(k => t.includes(k))) {
      const reasons = COMMON_REASONS.slice(0, 4).join(', ');
      const line1 = `Common reasons: ${reasons}.`;
      const line2 = s.guidance;
      return `${line1}\n${line2}`;
    }
  }
  return null;
}
function isMentalHealthQuery(text) {
  if (!text) return false;
  const t = text.toLowerCase();
  return (
    MENTAL_KEYWORDS.some(k => t.includes(k)) ||
    SOCIAL_KEYWORDS.some(k => t.includes(k))
  );
}
function cleanResponseText(text) {
  if (!text) return '';
  let cleaned = text.replace(/[*#`]/g, '');
  cleaned = cleaned.replace(/\[(.*?)\]\(.*?\)/g, '$1');
  cleaned = cleaned.replace(/\s+/g, ' ').trim();
  cleaned = cleaned.replace(/[-_*]{2,}/g, '');
  return cleaned;
}
function splitIntoLines(text, maxLines = 3) {
  if (!text) return [];
  let parts = text.split(/\r?\n/).map(p => p.trim()).filter(Boolean);
  if (parts.length === 0) {
    parts = text.match(/[^.!?]+[.!?]?/g) || [text];
    parts = parts.map(p => p.trim()).filter(Boolean);
  }
  const lines = [];
  for (let p of parts) {
    if (lines.length < maxLines) {
      lines.push(p);
    } else {
      break;
    }
  }
  return lines.slice(0, maxLines);
}

// --- App Component ---
export default function Chatbot() {
  // NEW: Define the default welcome message
  const defaultWelcome = {
    sender: 'bot',
    message: "Hello! I'm a Saathi chatbot. How can I help today?",
  };

  const [messages, setMessages] = useState([defaultWelcome]);
  const [input, setInput] = useState('');
  // --- Speech to text states ---
  const [transcript, setTranscript] = useState(''); // live transcript
  const [isRecording, setIsRecording] = useState(false);
  const [recognitionSupported, setRecognitionSupported] = useState(false);
  const recognitionRef = useRef(null);
  // --- Text-to-Speech states (NEW) ---
  const [speakEnabled, setSpeakEnabled] = useState(true);
  const [voices, setVoices] = useState([]);
  const [selectedVoice, setSelectedVoice] = useState('');
  const [speechRate, setSpeechRate] = useState(1); // 0.8 - 1.4
  const [speechPitch, setSpeechPitch] = useState(1); // 0.8 - 1.4
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const chatEndRef = useRef(null);

  // NEW: Add state for the current user and history loading
  const [user, setUser] = useState(null);
  const [isHistoryLoaded, setIsHistoryLoaded] = useState(false);

  // NEW: list of chat docs for the user
  const [chats, setChats] = useState([]); // each: { id, owner, title, messages, createdAt }
  const [currentChatId, setCurrentChatId] = useState(null);

  // NEW: Add navigate for logout
  const navigate = useNavigate();

  // Initialize the Gemini Model (no change)
  const genModel = useMemo(() => {
    if (GEMINI_API_KEY && GEMINI_API_KEY !== PLACEHOLDER_KEY) {
      const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
      return genAI.getGenerativeModel({ model: "gemini-2.5-flash" });
    }
    return null;
  }, []);

  // Check if the client is initialized (no change)
  useEffect(() => {
    if (!genModel) {
      setError("Please add your Google AI Studio API key to the code.");
    } else {
      setError(null);
    }
  }, [genModel]);

  // Automatically scroll to the bottom (no change)
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // NEW: Effect to listen for auth changes and load history
  useEffect(() => {
    // Function to load all chat documents for the current user
    const loadUserChats = async (uid) => {
      if (!uid) return;
      try {
        const q = query(collection(db, 'chatHistory'), where('owner', '==', uid));
        const snaps = await getDocs(q);
        const list = snaps.docs.map(d => ({ id: d.id, ...d.data() }));
        setChats(list);

        if (list.length > 0) {
          // If currentChatId is already provided (e.g. from URL) try to use it; else use the first chat
          // If you want to prefer a specific chat id stored elsewhere, add logic here to pick it.
          const pick = currentChatId ? list.find(c => c.id === currentChatId) : list[0];
          if (pick) {
            setCurrentChatId(pick.id);
            setMessages(pick.messages && pick.messages.length ? pick.messages : [defaultWelcome]);
          } else {
            // no pick -> new chat
            setMessages([defaultWelcome]);
            setCurrentChatId(null);
          }
        } else {
          // no chats exist -> create a new chat doc
          const newDoc = await addDoc(collection(db, 'chatHistory'), {
            owner: uid,
            title: 'New Chat',
            messages: [defaultWelcome],
            createdAt: serverTimestamp()
          });
          setChats([{ id: newDoc.id, owner: uid, title: 'New Chat', messages: [defaultWelcome] }]);
          setCurrentChatId(newDoc.id);
          setMessages([defaultWelcome]);
        }
      } catch (err) {
        console.error('Failed to load user chats:', err);
        setChats([]);
        setMessages([defaultWelcome]);
      } finally {
        setIsHistoryLoaded(true);
      }
    };

    // Listen for changes in authentication state
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      if (currentUser) {
        // User is logged in
        setUser(currentUser);
        // load chats for this user
        loadUserChats(currentUser.uid);
      } else {
        // User is logged out
        setUser(null);
        setChats([]);
        setCurrentChatId(null);
        setMessages([defaultWelcome]);
        setIsHistoryLoaded(true);
      }
    });

    // Cleanup subscription on component unmount
    return () => unsubscribe();
  }, []); // note: currentChatId will be updated within loadUserChats when needed

  // NEW: Save to per-chat doc; if no currentChatId create a new chat doc
  useEffect(() => {
    if (!isHistoryLoaded) return;
    if (!user) return;

    // avoid saving the typing placeholder
    const lastMessage = messages[messages.length - 1];
    if (lastMessage && lastMessage.message === 'Typing...') return;

    const saveHistory = async () => {
      try {
        if (currentChatId) {
          const ref = doc(db, 'chatHistory', currentChatId);
          await updateDoc(ref, { messages });
          // update local chats list copy
          setChats(prev => prev.map(c => c.id === currentChatId ? { ...c, messages } : c));
        } else {
          // create a new chat doc
          const newDocRef = await addDoc(collection(db, 'chatHistory'), {
            owner: user.uid,
            title: 'Chat',
            messages,
            createdAt: serverTimestamp()
          });
          setCurrentChatId(newDocRef.id);
          setChats(prev => [...prev, { id: newDocRef.id, owner: user.uid, title: 'Chat', messages }]);
        }
      } catch (err) {
        console.error('Failed to save chat history:', err);
      }
    };

    if (messages.length > 0) saveHistory();
  }, [messages, user, isHistoryLoaded, currentChatId]);

  // NEW: helper to load a specific chat by id (when user selects from sidebar)
  const loadChatById = async (chatId) => {
    try {
      const snap = await getDoc(doc(db, 'chatHistory', chatId));
      if (snap.exists()) {
        const data = snap.data();
        setMessages(data.messages && data.messages.length ? data.messages : [defaultWelcome]);
        setCurrentChatId(chatId);
        // ensure the chats list reflects selection
        setChats(prev => {
          const exists = prev.some(c => c.id === chatId);
          if (!exists) return [...prev, { id: chatId, ...data }];
          return prev.map(c => c.id === chatId ? { id: chatId, ...data } : c);
        });
      } else {
        console.warn('Chat doc not found', chatId);
      }
    } catch (err) {
      console.error('Failed to load chat:', err);
    }
  };

  // NEW: create a new chat and select it
  const createNewChat = async () => {
    if (!user) {
      setError('Please log in to create a new chat.');
      return;
    }
    try {
      const newDocRef = await addDoc(collection(db, 'chatHistory'), {
        owner: user.uid,
        title: 'New Chat',
        messages: [defaultWelcome],
        createdAt: serverTimestamp()
      });
      const newChat = { id: newDocRef.id, owner: user.uid, title: 'New Chat', messages: [defaultWelcome] };
      setChats(prev => [newChat, ...prev]);
      setCurrentChatId(newDocRef.id);
      setMessages([defaultWelcome]);
    } catch (err) {
      console.error('Failed to create chat:', err);
    }
  };

  // NEW: delete chat
  const deleteChatById = async (chatId) => {
    try {
      await deleteDoc(doc(db, 'chatHistory', chatId));
      setChats(prev => prev.filter(c => c.id !== chatId));
      if (chatId === currentChatId) {
        // pick another chat if available
        if (chats.length > 1) {
          const next = chats.find(c => c.id !== chatId);
          if (next) loadChatById(next.id);
        } else {
          // reset to a fresh chat
          setCurrentChatId(null);
          setMessages([defaultWelcome]);
        }
      }
    } catch (err) {
      console.error('Failed to delete chat:', err);
    }
  };

  // --- API Call Function (no changes) ---
  const queryModel = async (prompt, options = {}) => {
    // ... (rest of the queryModel function is unchanged)
    if (!genModel) {
      setError("Gemini client is not initialized. Check your API key.");
      setIsLoading(false);
      return null;
    }
    const scenarioReply = detectScenarioAndGuidance(prompt);
    if (scenarioReply) {
      return scenarioReply;
    }
    if (!isMentalHealthQuery(prompt) && !(prompt.toLowerCase().includes('summar') || prompt.toLowerCase().includes('summary'))) {
      return "I can only provide support for mental health, emotions, and coping strategies. Please ask about how you're feeling or related topics.";
    }
    setError(null);
    let instruction = `You are a compassionate, supportive mental health chatbot. Only respond about mental health, emotional support, coping strategies, and resources. Do NOT provide medical diagnoses. If user appears to be in immediate danger or at risk of harming themselves or others, briefly urge them to seek immediate professional or emergency help (don't provide instructions beyond that).`;
    instruction += ` Important: Output plain text only, no markdown, no asterisks, no headings, no lists with bullets, and keep the response very concise — at most 2 to 3 short lines. Use simple sentences.`;
    let modelPrompt = '';
    if (options.recentConversation && options.recentConversation.length > 0) {
      modelPrompt = `${instruction}\n\nHere is the recent conversation (most recent last). Summarize the user's main emotional state and suggested next step in 2-3 short lines:\n\n${options.recentConversation.join('\n')}\n\nSummary:`;
    } else {
      modelPrompt = `${instruction}\n\nUser: ${prompt}\n\nReply:`;
    }
    try {
      const result = await genModel.generateContent(modelPrompt);
      const response = await result.response;
      const text = response.text();
      if (text) {
        return text;
      } else {
        throw new Error('Unexpected response format from API.');
      }
    } catch (err) {
      console.error(err);
      if (err.message && err.message.toLowerCase().includes('api key')) {
        setError("Your Gemini API Key is invalid. Please check it in Google AI Studio.");
      } else {
        setError(err.message || "An unknown error occurred.");
      }
      return null;
    }
  };

  // --- Form Submission Handler (no changes) ---
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!input.trim() || isLoading) return;

    const userMessage = input;
    setInput('');

    setMessages((prev) => [...prev, { sender: 'user', message: userMessage }]);
    setIsLoading(true);

    const isSummary = /summar|summary|daily summary|summarize/i.test(userMessage);
    let botRaw = null;
    if (isSummary) {
      const recent = [...messages, { sender: 'user', message: userMessage }]
        .slice(-8)
        .map(m => `${m.sender === 'user' ? 'User' : 'Bot'}: ${m.message.replace(/\n/g, ' ')}`);
      botRaw = await queryModel(userMessage, { recentConversation: recent });
    } else {
      botRaw = await queryModel(userMessage);
    }

    if (!botRaw) {
      setIsLoading(false);
      setMessages((prev) => [
        ...prev,
        {
          sender: 'bot',
          message: error
            ? `Sorry, I encountered an error: ${error}`
            : 'Sorry, I had trouble getting a response. Please try again.',
        },
      ]);
      return;
    }

    const cleaned = cleanResponseText(botRaw);
    const lines = splitIntoLines(cleaned, 3);
    const finalLines = lines.length ? lines : [cleaned];
    const delayMs = 600;
    
    for (let i = 0; i < finalLines.length; i++) {
      if (i === 0) {
        setMessages((prev) => [...prev, { sender: 'bot', message: 'Typing...' }]);
      }
      // eslint-disable-next-line no-await-in-loop
      await new Promise((res) => setTimeout(res, delayMs));
      setMessages((prev) => {
        const copy = [...prev];
        const lastIdx = copy.length - 1;
        if (copy[lastIdx] && copy[lastIdx].sender === 'bot' && copy[lastIdx].message === 'Typing...') {
          copy.splice(lastIdx, 1);
        }
        copy.push({ sender: 'bot', message: finalLines[i] });
        return copy;
      });
    }

    setIsLoading(false);
  };

  // NEW: Effect to detect SpeechRecognition support
  useEffect(() => {
    const hasSupport = !!(window.SpeechRecognition || window.webkitSpeechRecognition);
    setRecognitionSupported(hasSupport);
  }, []);

  // NEW: Create recognition instance lazily and set handlers
  const createRecognition = useCallback(() => {
    if (!recognitionSupported) return null;
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) return null;
    try {
      const r = new SpeechRecognition();
      r.continuous = true;
      r.interimResults = true;
      r.lang = 'en-US';

      r.onresult = (event) => {
        // assemble a transcript from all results (interim included)
        const currentTranscript = Array.from(event.results)
          .map((result) => result[0].transcript)
          .join(' ');
        setTranscript(currentTranscript);
        // show live text in the input so user can edit before sending
        setInput(currentTranscript);
      };

      r.onerror = (ev) => {
        console.error('Speech recognition error', ev);
        setError(ev.error || 'Speech recognition error');
        setIsRecording(false);
      };

      r.onend = () => {
        // stop recording flag; keep transcript in input for user to send/edit
        setIsRecording(false);
      };

      return r;
    } catch (err) {
      console.error('Failed to create SpeechRecognition', err);
      setError('Speech recognition not available');
      return null;
    }
  }, [recognitionSupported]);

  const startRecognition = useCallback(() => {
    if (!recognitionSupported) {
      setError('Speech recognition not supported in this browser.');
      return;
    }
    if (!recognitionRef.current) recognitionRef.current = createRecognition();
    try {
      recognitionRef.current && recognitionRef.current.start();
      setIsRecording(true);
      setError(null);
    } catch (err) {
      // start can throw if already running
      console.warn('Recognition start error', err);
    }
  }, [recognitionSupported, createRecognition]);

  const stopRecognition = useCallback(() => {
    try {
      if (recognitionRef.current) recognitionRef.current.stop();
    } catch (err) {
      console.warn('Recognition stop error', err);
    } finally {
      setIsRecording(false);
    }
  }, []);

  const toggleRecording = useCallback(() => {
    if (isRecording) {
      stopRecognition();
    } else {
      startRecognition();
    }
  }, [isRecording, startRecognition, stopRecognition]);

  // cleanup recognition on unmount
  useEffect(() => {
    return () => {
      try {
        if (recognitionRef.current) {
          recognitionRef.current.onresult = null;
          recognitionRef.current.onend = null;
          recognitionRef.current.onerror = null;
          recognitionRef.current.stop && recognitionRef.current.stop();
        }
      } catch (err) {
        // ignore
      }
    };
  }, []);

  // Load available voices (browser may fire onvoiceschanged)
	useEffect(() => {
		if (typeof window === 'undefined' || !window.speechSynthesis) return;
		const load = () => {
			const list = window.speechSynthesis.getVoices() || [];
			setVoices(list);
			if (list.length && !selectedVoice) setSelectedVoice(list[0].name);
		};
		load();
		window.speechSynthesis.onvoiceschanged = load;
		return () => {
			try { window.speechSynthesis.onvoiceschanged = null; } catch (e) {}
		};
	}, [selectedVoice]);

  // Helper to speak text and return a Promise that resolves on end/error
	const speakText = useCallback((text) => {
		return new Promise((resolve) => {
			if (!speakEnabled || typeof window === 'undefined' || !window.speechSynthesis) {
				resolve();
				return;
			}
			// Cancel any ongoing speech for clarity
			window.speechSynthesis.cancel();

			const utter = new SpeechSynthesisUtterance(text);
			utter.rate = speechRate;
			utter.pitch = speechPitch;
			// Attach selected voice by name if available
			if (selectedVoice) {
				const v = voices.find(x => x.name === selectedVoice);
				if (v) utter.voice = v;
			}
			utter.onend = () => resolve();
			utter.onerror = () => resolve();
			// Small safety timeout in case events don't fire
			const timeout = setTimeout(() => resolve(), 8000);
			utter.onend = () => { clearTimeout(timeout); resolve(); };
			utter.onerror = () => { clearTimeout(timeout); resolve(); };
			window.speechSynthesis.speak(utter);
		});
	}, [speakEnabled, voices, selectedVoice, speechRate, speechPitch]);

  // Stop speech when recording begins (avoid overlap)
	useEffect(() => {
		if (isRecording && window.speechSynthesis) {
			window.speechSynthesis.cancel();
		}
	}, [isRecording]);

  // Speak new bot messages sequentially for precise output
	useEffect(() => {
		if (!speakEnabled) return;
		if (!messages || messages.length === 0) return;

		const last = messages[messages.length - 1];
		// Ignore typing placeholders and non-bot messages
		if (!last || last.sender !== 'bot' || last.message === 'Typing...') return;

		// Split into up to 3 lines (reuse existing helper)
		const lines = splitIntoLines(last.message, 3);
		(async () => {
			for (const ln of lines) {
				// Up-to-date check: if speak disabled or recording started, bail out
				if (!speakEnabled || isRecording) break;
				// Speak each short line sequentially
				await speakText(ln);
				// slight pause between lines for clarity
				await new Promise(r => setTimeout(r, 220));
			}
		})();
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [messages, speakEnabled, isRecording, selectedVoice, speechRate, speechPitch]);

  // Stop speech on logout
  const handleLogout = async () => {
    try {
      if (window.speechSynthesis) window.speechSynthesis.cancel();
      await signOut(auth);
      // The onAuthStateChanged listener will clear the user state
      // and reset messages. We just need to navigate away.
      navigate('/auth'); //
    } catch (err) {
      setError("Failed to log out. " + err.message);
    }
  };

  // --- JSX Return (add controls in header) ---
  return (
    <div className="flex flex-col h-screen bg-gray-50 font-sans chat-container">
      <header className="bg-white shadow-md w-full p-4 border-b border-gray-200 chat-header">
        <div className="flex items-center justify-between">
          <Link to="/" className="flex items-center gap-3">
            <img src="/otterChat.png" alt="otterChat" className="h-10" />
            <span className="text-xl font-bold text-blue-700 hidden md:inline">Saathi</span>
          </Link>

          <div className="flex items-center gap-4">
            <p className="text-center text-sm text-gray-500 mt-1 md:mt-0 chat-subtext hidden sm:block">
              This is an AI model, not a medical professional.
            </p>

            {/* TTS Controls: toggle + voice + rate */}
            <div className="flex items-center gap-3">
              <button
                onClick={() => {
                  const next = !speakEnabled;
                  // cancel ongoing speech when disabling
                  if (!next && window.speechSynthesis) window.speechSynthesis.cancel();
                  setSpeakEnabled(next);
                }}
                className={`px-3 py-1 rounded-full text-sm font-medium ${speakEnabled ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'}`}
                title={speakEnabled ? 'Disable speech' : 'Enable speech'}
              >
                { speakEnabled ? 'Voice: On' : 'Voice: Off' }
              </button>

              {voices.length > 0 && (
                <select
                  value={selectedVoice}
                  onChange={(e) => setSelectedVoice(e.target.value)}
                  className="text-sm rounded-md border-gray-200 p-1 hidden md:inline-block"
                  title="Select voice"
                >
                  {voices.map(v => <option key={v.name} value={v.name}>{v.name} ({v.lang})</option>)}
                </select>
              )}

              {/* Rate & Pitch small controls */}
              <div className="flex items-center gap-2">
                <label className="text-xs text-gray-500 hidden sm:inline">Rate</label>
                <input
                  type="range"
                  min="0.7"
                  max="1.4"
                  step="0.05"
                  value={speechRate}
                  onChange={(e) => setSpeechRate(Number(e.target.value))}
                  className="w-24 hidden sm:inline"
                  title="Speech rate"
                />
                <label className="text-xs text-gray-500 hidden sm:inline">Pitch</label>
                <input
                  type="range"
                  min="0.7"
                  max="1.4"
                  step="0.05"
                  value={speechPitch}
                  onChange={(e) => setSpeechPitch(Number(e.target.value))}
                  className="w-24 hidden sm:inline"
                  title="Speech pitch"
                />
              </div>

            </div>

            {/* Logout button */}
            {user && (
              <button
                onClick={handleLogout}
                className="px-4 py-2 text-sm text-white bg-red-500 rounded-full hover:bg-red-600 transition"
              >
                Logout
              </button>
            )}
          </div>
        </div>
      </header>

      {/* MAIN AREA: sidebar + chat */}
      <div className="flex flex-1 overflow-hidden">
        {/* LEFT: history sidebar */}
        <aside className="w-72 bg-white border-r border-gray-200 p-4 overflow-y-auto hidden sm:block">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-semibold">Your Chats</h3>
            <button
              onClick={createNewChat}
              aria-label="Create new chat"
              className="new-chat-btn inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-sm font-medium shadow-md focus:outline-none"
            >
              {/* plus icon */}
              <svg className="h-4 w-4 transform" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path d="M10 4v12M4 10h12" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"></path>
              </svg>
              <span>New Chat</span>
            </button>
          </div>

          {/* loading state */}
          {!isHistoryLoaded ? (
            <p className="text-sm text-gray-500">Loading...</p>
          ) : (
            <>
              {chats.length === 0 ? (
                <p className="text-sm text-gray-500">No chats yet.</p>
              ) : (
                <ul className="space-y-2">
                  {chats.map((c) => (
                    <li key={c.id}>
                      <div
                        className={`flex items-center justify-between p-2 rounded-md cursor-pointer hover:bg-gray-50 ${c.id === currentChatId ? 'bg-blue-50' : ''}`}
                        onClick={() => loadChatById(c.id)}
                      >
                        <div>
                          <div className="text-sm font-medium text-gray-800">
                            {c.title || `Chat ${c.id.slice(0,6)}`}
                          </div>
                          <div className="text-xs text-gray-500 mt-1">
                            {c.messages && c.messages.length ? c.messages[c.messages.length - 1].message.slice(0,60) : 'No messages'}
                          </div>
                        </div>
                        <div className="ml-2 flex-shrink-0">
                          <button
                            onClick={(e) => { e.stopPropagation(); deleteChatById(c.id); }}
                            className="text-xs text-red-500 hover:underline"
                          >
                            Delete
                          </button>
                        </div>
                      </div>
                    </li>
                  ))}
                </ul>
              )}
            </>
          )}
        </aside>

        {/* RIGHT: chat area */}
        <main className="flex-1 flex flex-col overflow-hidden">
          <div className="flex-1 overflow-y-auto p-4 md:p-6 space-y-4 chat-messages">
            {messages.map((msg, index) => (
              <ChatBubble key={index} sender={msg.sender} message={msg.message} />
            ))}
            <div ref={chatEndRef} />
          </div>

          <footer className="bg-white shadow-inner p-4 border-t border-gray-200 chat-footer">
            {/* NEW: Disable form if user is not logged in or history is still loading */}
            {!user ? (
              <p className="text-center text-gray-500">
                Please <Link to="/auth" className="text-blue-600 underline">log in</Link> to start chatting.
              </p>
            ) : (
              <form onSubmit={handleSubmit} className="flex items-center space-x-3">
                <input
                  type="text"
                  value={input}
                  onChange={(e) => { setInput(e.target.value); setTranscript(''); }}
                  placeholder={isRecording ? "Listening... speak now" : "Type your message..."}
                  className="flex-1 p-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500 transition chat-input"
                  disabled={isLoading || !isHistoryLoaded}
                />

                {/* Mic button: shows animation when recording */}
                {recognitionSupported && (
                  <button
                    type="button"
                    onClick={toggleRecording}
                    aria-pressed={isRecording}
                    title={isRecording ? "Stop recording" : "Start voice input"}
                    className={`mic-btn ${isRecording ? 'active' : ''}`}
                  >
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                      <path d="M12 1v11"></path>
                      <path d="M19 11a7 7 0 0 1-14 0"></path>
                      <path d="M12 21v-4"></path>
                    </svg>
                  </button>
                )}

                <button
                  type="submit"
                  className="px-6 py-3 bg-blue-600 text-white rounded-full font-semibold shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 transition chat-send-btn"
                  disabled={isLoading || !isHistoryLoaded}
                >
                  Send
                </button>
              </form>
            )}
            {error && (
              <p className="text-red-500 text-sm text-center mt-2">{error}</p>
            )}
          </footer>
        </main>
      </div>
    </div>
  );
}
