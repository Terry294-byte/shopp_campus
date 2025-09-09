// Script to configure CORS for Firebase Storage
// Run this using Node.js after installing Firebase CLI: npm install -g firebase-tools
// Then run: node configure_cors.js

const fs = require('fs');

// CORS configuration for Firebase Storage
const corsConfig = {
  "cors": [
    {
      "origin": ["http://localhost:51293", "http://localhost:8080", "http://127.0.0.1:51293", "http://localhost:3000"],
      "method": ["GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS"],
      "responseHeader": ["Content-Type", "Authorization", "Content-Length", "User-Agent", "x-goog-resumable"],
      "maxAgeSeconds": 3600
    }
  ]
};

// Save the CORS configuration to a temporary file
fs.writeFileSync('cors.json', JSON.stringify(corsConfig, null, 2));

console.log('CORS configuration file created: cors.json');
console.log('');
console.log('=== INSTRUCTIONS TO FIX CORS ERROR ===');
console.log('');
console.log('1. Install Firebase CLI (if not already installed):');
console.log('   npm install -g firebase-tools');
console.log('');
console.log('2. Login to Firebase:');
console.log('   firebase login');
console.log('');
console.log('3. Apply CORS configuration to Firebase Storage:');
console.log('   firebase storage:update --project shopp-5ee57 cors.json');
console.log('');
console.log('4. (Optional) Update Firebase Storage rules for development:');
console.log('   firebase deploy --only storage --project shopp-5ee57');
console.log('   This will deploy the storage.rules file with permissive rules');
console.log('');
console.log('5. Restart your Flutter web server and test image uploads');
console.log('');
console.log('=== TROUBLESHOOTING ===');
console.log('- Make sure you have proper permissions on the Firebase project');
console.log('- Verify the Firebase project ID (shopp-5ee57) is correct');
console.log('- Check browser console for any additional error messages');
console.log('- If issues persist, manually configure CORS in Google Cloud Console');
