const express = require("express");
const cors = require("cors");
require("dotenv").config();
const route = require("./server/index.route");
const app = express();
const PORT = process.env.PORT || 4000;
const bodyParser = require("body-parser");
// const authRouter=require('./server/routes/auth.route');
// const { connection } = require('./config/db');
const {winstonLogger, errorLogger} = require('./config/winston');
// const { handleError } = require("./server/helpers/errorHandler");
const corsOptions = {
  // allow your production frontend and localhost for dev
  origin: [process.env.FRONTEND_URL || 'https://vayu-one.vercel.app', 'http://localhost:3000'],
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true, // If you're sending cookies or authentication tokens
  allowedHeaders: 'Content-Type,Authorization', // Include any headers you're using
};
app.use(cors(corsOptions));

app.use(express.json());

// Middleware to parse different body formats with a large limit
app.use(bodyParser.json({ limit: "500mb" }));
app.use(bodyParser.urlencoded({ extended: true, limit: "500mb", parameterLimit: 50000 }));
app.use(bodyParser.raw({ limit: "500mb" }));
app.use(bodyParser.text({ limit: "500mb" }));

app.use(winstonLogger); // request logger (keep before routes)

// Quick debug route to verify server is reached by the browser (returns JSON)
app.get('/', (req, res) => {
  res.json({ status: 'backend', env: process.env.NODE_ENV || 'development' });
});

// Log requests for .js module files (helps identify wrong asset host/path)
app.use((req, res, next) => {
  if (req.method === 'GET' && req.path && req.path.endsWith('.js')) {
    console.warn(`JS module request: ${req.method} ${req.originalUrl} (Host: ${req.get('host')})`);
  }
  next();
});

// If browser requests a .js asset by mistake from this server, return a tiny JS instead of HTML
// This prevents "MIME type 'text/html' for module script" from hiding the real issue (missing/incorrect host)
app.get('/*.js', (req, res, next) => {
  // Only respond like this in non-production or when FRONTEND_URL is localhost (safer)
  if ((process.env.NODE_ENV || 'development') !== 'production') {
    res.status(404).type('application/javascript').send('// placeholder - JS not found on backend\n');
  } else {
    next();
  }
});

// these are the routes
app.use("/api/v1", route)
// app.use("/auth/v1", authRouter)

// place error logger after routes so it logs errors
app.use(errorLogger);

// app.use((err, req, res, next) => {
//     handleError(err, res);
// });  

const start = () => {
    try {
        // connection()
        app.listen(PORT, () => {
            console.log(`Server listening on port ${PORT}`);
        });
    } catch (error) {
        console.log(error);
    }
}

start();
