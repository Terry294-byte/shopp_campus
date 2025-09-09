@echo off
echo 🔥 Setting up Firebase for SmartShop...

REM Check if google-services.json exists
if not exist "android\app\google-services.json" (
    echo ❌ google-services.json not found!
    echo Please follow these steps:
    echo 1. Go to https://console.firebase.google.com/
    echo 2. Create a project or select existing one
    echo 3. Add Android app with package name: com.smartshop.smartshop
    echo 4. Download google-services.json
    echo 5. Place it in android\app\google-services.json
    pause
    exit /b 1
)

echo ✅ google-services.json found!

REM Install FlutterFire CLI if not installed
where flutterfire >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing FlutterFire CLI...
    dart pub global activate flutterfire_cli
)

REM Configure Firebase
echo Configuring Firebase...
flutterfire configure

echo ✅ Firebase setup complete!
echo Run 'flutter clean && flutter pub get && flutter run' to test
pause
