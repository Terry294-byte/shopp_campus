@echo off
echo ========================================
echo QUICK CORS FIX - Manual Configuration
echo ========================================
echo.
echo This batch file provides step-by-step instructions to manually
echo configure CORS for Firebase Storage through web interfaces.
echo.
echo NO ADDITIONAL TOOLS NEEDED!
echo.
echo ========== STEP 1: FIREBASE STORAGE RULES ==========
echo.
echo 1. Open Firefox or Chrome browser
echo 2. Go to: https://console.firebase.google.com/
echo 3. Select your project: shopp-5ee57
echo 4. Click "Storage" in the left sidebar
echo 5. Click the "Rules" tab
echo 6. REPLACE the existing rules with:
echo.
echo service firebase.storage {
echo   match /b/{bucket}/o {
echo     match /{allPaths=**} {
echo       allow read, write: if true;
echo     }
echo   }
echo }
echo.
echo 7. Click "PUBLISH"
echo.
echo ========== STEP 2: GOOGLE CLOUD CORS CONFIG ==========
echo.
echo 1. Open a NEW TAB in your browser
echo 2. Go to: https://console.cloud.google.com/
echo 3. Select the SAME project: shopp-5ee57
echo 4. Click "Cloud Storage" in the left sidebar
echo 5. Click on your bucket: shopp-5ee57.appspot.com
echo 6. Click "CONFIGURATION" tab
echo 7. Scroll down to "CORS" section
echo 8. Click "ADD" or "EDIT" CORS configuration
echo 9. Use this JSON configuration:
echo.
echo [
echo   {
echo     "origin": ["http://localhost:51293", "http://localhost:8080", "http://127.0.0.1:51293"],
echo     "method": ["GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS"],
echo     "responseHeader": ["Content-Type", "Authorization", "Content-Length", "User-Agent", "x-goog-resumable"],
echo     "maxAgeSeconds": 3600
echo   }
echo ]
echo.
echo 10. Click "SAVE"
echo.
echo ========== STEP 3: TEST THE FIX ==========
echo.
echo 1. Restart your Flutter web server
echo 2. Try uploading an image again
echo 3. The CORS error should be resolved!
echo.
echo ========== TROUBLESHOOTING ==========
echo.
echo - Make sure you're logged into the correct Google account
echo - Verify the project ID is "shopp-5ee57"
echo - Check browser console for any other errors
echo - Allow a few minutes for changes to propagate
echo.
pause
