require("dotenv").config();
const express = require("express");
const fetch = require("node-fetch");
const base64 = require("base-64");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// Import webhook routes
const webhookRoutes = require("./webhook");
app.use("/api", webhookRoutes);

// Environment variable validation
const requiredEnvVars = [
  'MPESA_CONSUMER_KEY',
  'MPESA_CONSUMER_SECRET',
  'MPESA_PASSKEY'
];

const missingEnvVars = requiredEnvVars.filter(envVar => !process.env[envVar]);
if (missingEnvVars.length > 0) {
  console.error('❌ Missing required environment variables:', missingEnvVars.join(', '));
  console.error('Please check your .env file and ensure all required variables are set.');
  process.exit(1);
}

console.log('✅ Environment variables loaded successfully');

// ✅ M-Pesa credentials from environment variables
const consumerKey = process.env.MPESA_CONSUMER_KEY;
const consumerSecret = process.env.MPESA_CONSUMER_SECRET;
const businessShortCode = process.env.MPESA_BUSINESS_SHORT_CODE || "174379";
const passkey = process.env.MPESA_PASSKEY;
const callbackUrl = process.env.MPESA_CALLBACK_URL || "http://localhost:5000/api/mpesa/callback";

// TODO: For production, update callbackUrl to your public backend endpoint to receive payment confirmation callbacks
// e.g., const callbackUrl = "https://yourdomain.com/api/mpesa/callback";
// For testing, use a service like webhook.site or ngrok to expose local server

// 🔑 Get OAuth access token
async function getAccessToken() {
  const url =
    "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
  const credentials = base64.encode(`${consumerKey}:${consumerSecret}`);

  const response = await fetch(url, {
    method: "GET",
    headers: { Authorization: `Basic ${credentials}` },
  });

  if (!response.ok) {
    throw new Error(`Failed to get access token: ${response.statusText}`);
  }

  const data = await response.json();
  return data.access_token;
}

// 📲 STK Push endpoint
app.post("/stkpush", async (req, res) => {
  try {
    const { phoneNumber, amount } = req.body;

    if (!phoneNumber || !amount) {
      return res.status(400).json({ error: "Missing phoneNumber or amount" });
    }

    // Validate phone number format (e.g., must start with 254 and be 12 digits)
    if (!/^254\d{9}$/.test(phoneNumber)) {
      return res.status(400).json({ error: "Invalid phone number format. Use 254XXXXXXXXX." });
    }

    const accessToken = await getAccessToken();
    const timestamp = new Date()
      .toISOString()
      .replace(/[^0-9]/g, "")
      .slice(0, 14);
    const password = base64.encode(businessShortCode + passkey + timestamp);

    const body = {
      BusinessShortCode: businessShortCode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: parseInt(amount, 10),
      PartyA: phoneNumber,
      PartyB: businessShortCode,
      PhoneNumber: phoneNumber,
      CallBackURL: callbackUrl,
      AccountReference: "SmartShop",
      TransactionDesc: "Payment for order",
    };

    const stkResponse = await fetch(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
      }
    );

    const responseData = await stkResponse.json();

    if (!stkResponse.ok) {
      console.error("M-Pesa STK Push failed:", responseData);
      return res.status(stkResponse.status).json({
        error: "STK Push request failed",
        details: responseData
      });
    }

    return res.json(responseData);
  } catch (error) {
    console.error("STK Push error:", error);
    return res.status(500).json({ error: error.message });
  }
});

// 🚀 Start local server
const PORT = 5000;
app.listen(PORT, () =>
  console.log(`M-Pesa backend running locally on port ${PORT}`)
);
