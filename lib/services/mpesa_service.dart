import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MpesaService {
  // Dynamic base URL configuration
  String get baseUrl {
    // For web platform
    if (kIsWeb) {
      return "http://localhost:5000";
    }

    // For Android emulator
    if (Platform.isAndroid) {
      return "http://10.0.2.2:5000";
    }

    // For iOS simulator
    if (Platform.isIOS) {
      return "http://localhost:5000";
    }

    // For physical devices - use ngrok URL when available
    // Replace with your ngrok URL when using ngrok
    return "https://7a217d05a943.ngrok-free.app";
  }

  Future<Map<String, dynamic>> initiateStkPush(String phoneNumber, double amount) async {
    try {
      print('🔄 Initiating STK Push...');
      print('📱 Phone: $phoneNumber');
      print('💰 Amount: $amount');
      print('🌐 Backend URL: $baseUrl');
      print('🔗 Full STK Push URL: $baseUrl/stkpush');

      final response = await http.post(
        Uri.parse("$baseUrl/stkpush"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "amount": amount.round().toString(), // Safaricom requires int
        }),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        print('✅ STK Push initiated successfully');
        return responseData;
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ STK Push failed: $errorData');
        throw Exception("Failed: ${response.statusCode} - ${errorData['error'] ?? response.body}");
      }
    } catch (e) {
      print('💥 Error initiating STK Push: $e');
      if (e.toString().contains('Connection refused')) {
        throw Exception("Cannot connect to backend server. Please ensure the M-Pesa backend is running on $baseUrl");
      }
      throw Exception("Error initiating STK Push: $e");
    }
  }

  // Check payment status using checkout request ID
  Future<Map<String, dynamic>> checkPaymentStatus(String checkoutRequestId) async {
    try {
      print('🔍 Checking payment status for: $checkoutRequestId');

      final response = await http.get(
        Uri.parse("$baseUrl/api/payment/status/$checkoutRequestId"),
      );

      print('📡 Status Check Response: ${response.statusCode}');
      print('📄 Status Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        throw Exception("Failed to check payment status: ${response.statusCode}");
      }
    } catch (e) {
      print('💥 Error checking payment status: $e');
      throw Exception("Error checking payment status: $e");
    }
  }

  // Get order details
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      print('📦 Getting order details for: $orderId');

      final response = await http.get(
        Uri.parse("$baseUrl/api/order/$orderId"),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        throw Exception("Failed to get order details: ${response.statusCode}");
      }
    } catch (e) {
      print('💥 Error getting order details: $e');
      throw Exception("Error getting order details: $e");
    }
  }
}
