@echo off
REM Flutter Runner - SmartShop App
REM Use this file to run Flutter commands without PATH issues

set FLUTTER_PATH=C:\Users\Admin\flutter\bin
set PATH=%PATH%;%FLUTTER_PATH%

echo === SmartShop Flutter Setup ===
echo.
echo Available devices:
"%FLUTTER_PATH%\flutter.bat" devices
echo.
echo Ready to run your app!
echo.
echo Usage:
echo   run_flutter.bat devices    - List connected devices
echo   run_flutter.bat run        - Run on connected device
echo   run_flutter.bat build      - Build APK
echo.

if "%1"=="" goto :eof
if "%1"=="devices" "%FLUTTER_PATH%\flutter.bat" devices
if "%1"=="run" "%FLUTTER_PATH%\flutter.bat" run
if "%1"=="build" "%FLUTTER_PATH%\flutter.bat" build apk
if "%1"=="pub" "%FLUTTER_PATH%\flutter.bat" pub get
