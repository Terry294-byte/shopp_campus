@echo off
echo === Firebase API Key Error Fix ===
echo.

echo Step 1: Checking current Firebase configuration...
echo.

echo Checking for google-services.json...
if exist "android\app\google-services.json" (
    echo ✅ google-services.json found
) else (
    echo ❌ google-services.json NOT FOUND - This is the main issue!
    echo.
    echo === IMMEDIATE ACTION REQUIRED ===
    echo 1. Go to https://console.firebase.google.com/
    echo 2. Create project "smartshop-app"
    echo 3. Add Android app with package: com.example.smartshop
    echo 4. Download google-services.json
    echo 5. Copy to android\app\google-services.json
    echo.
    pause
    exit /b 1
)

echo.
echo Step 2: Checking FlutterFire CLI...
flutterfire --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing FlutterFire CLI...
    dart pub global activate flutterfire_cli
)

echo.
echo Step 3: Configuring Firebase...
echo Please enter your Firebase project ID:
set /p project_id="Firebase Project ID: "
flutterfire configure --project=%project_id%

echo.
echo Step 4: Cleaning and rebuilding...
flutter clean
flutter pub get
flutter build apk

echo.
echo ✅ Firebase configuration complete!
echo Try running your app again - the API key error should be resolved.
pause
