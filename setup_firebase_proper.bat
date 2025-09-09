@echo off
echo === Firebase Setup Script ===
echo This script will guide you through Firebase setup
echo.

echo Step 1: Create Firebase Project
echo Go to: https://console.firebase.google.com/
echo Create a project with name: smartshop-app
echo.

echo Step 2: Add Android App
echo Package name: com.example.smartshop
echo Download google-services.json
echo.

echo Step 3: Run these commands:
echo dart pub global activate flutterfire_cli
echo flutterfire configure --project=your-project-id
echo.

echo Step 4: Clean and rebuild
echo flutter clean
echo flutter pub get
echo flutter run

pause
