@echo off
echo ========================================
echo Firebase Storage CORS Configuration Tool
echo ========================================
echo.
echo This script helps you configure CORS for Firebase Storage
echo to allow requests from your local development server.
echo.
echo Prerequisites:
echo 1. Node.js installed
echo 2. Firebase CLI installed (npm install -g firebase-tools)
echo 3. Logged in to Firebase (firebase login)
echo.
echo Steps:
echo 1. Run: node configure_cors.js
echo 2. Run: firebase storage:update --project shopp-5ee57 cors.json
echo.
echo If you encounter issues, check:
echo - Firebase project ID is correct
echo - You have permissions to modify Firebase Storage rules
echo - Firebase CLI is properly installed and authenticated
echo.
pause
