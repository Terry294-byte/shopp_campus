const express = require("express");
const app = express();
app.use(express.json());

// Webhook endpoint to receive payment confirmation callbacks from M-Pesa
app.post("/mpesa/callback", (req, res) => {
  try {
    console.log("🔔 Received M-Pesa callback:", JSON.stringify(req.body, null, 2));

    // Extract callback data
    const { MerchantRequestID, CheckoutRequestID, ResultCode, ResultDesc, CallbackMetadata } = req.body.Body?.stkCallback || {};

    console.log("📊 Callback Details:");
    console.log("- MerchantRequestID:", MerchantRequestID);
    console.log("- CheckoutRequestID:", CheckoutRequestID);
    console.log("- ResultCode:", ResultCode);
    console.log("- ResultDesc:", ResultDesc);

    if (CallbackMetadata && CallbackMetadata.Item) {
      console.log("💰 Payment Details:");
      CallbackMetadata.Item.forEach(item => {
        console.log(`- ${item.Name}: ${item.Value}`);
      });
    }

    // TODO: Process the callback data, update order/payment status in your database
    // Example: Update payment status based on ResultCode
    // - ResultCode 0 = Success
    // - ResultCode non-zero = Failed

    if (ResultCode === 0) {
      console.log("✅ Payment successful!");
      // Update your database here
    } else {
      console.log("❌ Payment failed:", ResultDesc);
      // Handle failed payment here
    }

    // Always respond with 200 OK to acknowledge receipt (M-Pesa requirement)
    res.status(200).json({
      success: true,
      message: "Callback received successfully",
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error("💥 Error processing M-Pesa callback:", error);
    // Still respond with 200 OK to prevent M-Pesa from retrying
    res.status(200).json({
      success: false,
      message: "Error processing callback",
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Health check endpoint
app.get("/mpesa/callback", (req, res) => {
  res.status(200).json({
    status: "OK",
    message: "M-Pesa callback endpoint is working",
    timestamp: new Date().toISOString()
  });
});

module.exports = app;
