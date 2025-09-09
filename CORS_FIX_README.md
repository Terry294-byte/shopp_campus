# Fixing Firebase Storage CORS Error

## Problem
When running the Flutter web app on `http://localhost:51293`, you encounter CORS errors when trying to upload images to Firebase Storage:

```
Access to XMLHttpRequest at 'https://firebasestorage.googleapis.com/...' from origin 'http://localhost:51293' has been blocked by CORS policy
```

## Root Cause
Firebase Storage requires proper CORS (Cross-Origin Resource Sharing) configuration to allow requests from web applications running on different domains (like localhost).

## Solution

### 1. Configure Firebase Storage CORS
Run these commands to configure CORS for your Firebase Storage:

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase (if not already logged in)
firebase login

# Run the CORS configuration script
node configure_cors.js

# Apply the CORS configuration to Firebase Storage
firebase storage:update --project shopp-5ee57 cors.json
```

### 2. Alternative: Manual CORS Configuration
If the above doesn't work, you can manually configure CORS:

1. Go to Google Cloud Console: https://console.cloud.google.com/
2. Select your project (shopp-5ee57)
3. Go to Cloud Storage → Browser
4. Click on your bucket (shopp-5ee57.appspot.com)
5. Go to Configuration → CORS
6. Add the following CORS configuration:

```json
[
  {
    "origin": ["http://localhost:51293", "http://localhost:8080", "http://127.0.0.1:51293"],
    "method": ["GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS"],
    "responseHeader": ["Content-Type", "Authorization", "Content-Length", "User-Agent", "x-goog-resumable"],
    "maxAgeSeconds": 3600
  }
]
```

### 3. Verify Firebase Configuration
Make sure your `lib/firebase_options.dart` has the correct web configuration. The web configuration should use web app credentials, not Android credentials.

### 4. Test the Fix
After applying the CORS configuration:
1. Restart your Flutter web server
2. Try uploading an image again
3. The CORS error should be resolved

## Additional Notes
- The CORS configuration allows requests from localhost development servers
- For production, you should update the CORS configuration to include your production domain
- Firebase Storage rules should also be configured to allow read/write operations

## Files Created
- `configure_cors.js` - Script to generate CORS configuration
- `setup_cors.bat` - Batch file with instructions
- Updated `web/index.html` - Added Firebase SDK for web compatibility

## Troubleshooting
If you still encounter issues:
1. Check Firebase project permissions
2. Verify Firebase Storage rules allow the operations
3. Ensure you're using the correct Firebase project ID
4. Check browser console for any additional error messages
