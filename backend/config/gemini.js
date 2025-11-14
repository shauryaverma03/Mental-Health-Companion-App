const axios = require('axios');
const { GoogleAuth } = require('google-auth-library');

const env = process.env;

// You can set these in your environment or hardcode the TUNED_MODEL_ID here (not recommended for secrets).
// Example TUNED_MODEL_ID from your prompt:
// "projects/620832207017/locations/us-central1/models/671346736107250688@1"
const TUNED_MODEL_ID = env.TUNED_MODEL_ID || "projects/620832207017/locations/us-central1/models/671346736107250688@1";
const LOCATION = env.LOCATION || "us-central1";

// Build the predict URL for the Vertex AI endpoint
const BASE_HOST = `${LOCATION}-aiplatform.googleapis.com`;
const PREDICT_URL = `https://${BASE_HOST}/v1/${TUNED_MODEL_ID}:predict`;

// Default generation parameters (adjust as needed)
const DEFAULT_PARAMETERS = {
  temperature: 0.8,
  topK: 64,
  topP: 0.95,
  maxOutputTokens: 1024
};

async function geminiResponse(promptOrBody) {
  // Accept either a string prompt or a prepared body object
  let requestBody;
  if (typeof promptOrBody === 'string') {
    const prompt = promptOrBody + (env.GEMINI_PROMPT || '');
    requestBody = {
      instances: [{ content: prompt }],
      parameters: DEFAULT_PARAMETERS
    };
  } else if (typeof promptOrBody === 'object' && promptOrBody !== null) {
    // allow callers to pass a custom request shape
    requestBody = promptOrBody;
  } else {
    throw new Error('Invalid input to geminiResponse');
  }

  try {
    // Use GoogleAuth to obtain a bearer token for cloud-platform scope
    const auth = new GoogleAuth({ scopes: ['https://www.googleapis.com/auth/cloud-platform'] });
    const client = await auth.getClient();
    const tokenResponse = await client.getAccessToken();
    const accessToken = tokenResponse && tokenResponse.token ? tokenResponse.token : tokenResponse;

    const res = await axios.post(PREDICT_URL, requestBody, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`
      },
      maxBodyLength: Infinity
    });

    const data = res.data || {};

    // Try a few possible response shapes and return the first textual content found
    // 1) predictions[].content (common)
    if (Array.isArray(data.predictions) && data.predictions.length > 0) {
      const p = data.predictions[0];
      if (typeof p === 'string') return p;
      if (p.content && typeof p.content === 'string') return p.content;
      if (p.output && typeof p.output === 'string') return p.output;
    }

    // 2) candidates -> content -> parts -> text (older formats)
    const candidates = data.candidates || [];
    if (Array.isArray(candidates) && candidates.length > 0) {
      const content = candidates[0]?.content;
      const parts = content?.parts;
      if (parts && parts.length > 0 && parts[0]?.text) return parts[0].text;
      if (typeof content === 'string') return content;
    }

    // 3) fallback to raw JSON string
    return JSON.stringify(data);
  } catch (error) {
    // Log minimal error server-side and rethrow for upstream handlers to handle
    console.error('Vertex AI call failed:', error.message || error);
    throw error;
  }
}

module.exports = {
  geminiResponse
};


