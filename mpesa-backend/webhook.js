const express = require("express");
const app = express();
app.use(express.json());

// Webhook endpoint to receive payment confirmation callbacks from M-Pesa
app.post("/mpesa/callback", (req, res) => {
  console.log("Received M-Pesa callback:", req.body);

  // TODO: Process the callback data, update order/payment status in your database

  // Respond with 200 OK to acknowledge receipt
  res.status(200).send("Callback received");
});

module.exports = app;
