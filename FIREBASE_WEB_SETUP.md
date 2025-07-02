# Setup Firebase Web untuk Toko Anak Kos

## Langkah-langkah Setup Firebase Web

### 1. Setup Firebase Console
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project yang sudah ada atau buat project baru
3. Tambahkan **Web App** ke project:
   - Klik ikon "⚙️" > Project settings
   - Scroll ke bawah dan klik "Add app" > pilih "</>"
   - Masukkan app nickname: "Toko Anak Kos Web"
   - Centang "Also set up Firebase Hosting" (opsional)
   - Klik "Register app"

### 2. Copy Firebase Config
Setelah register web app, Anda akan mendapat konfigurasi seperti ini:
```javascript
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};
```

### 3. Update lib/firebase_options.dart
Ganti konfigurasi di `lib/firebase_options.dart`:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: '1:123456789:web:abcdef123456',
  messagingSenderId: '123456789',
  projectId: 'your-project-id',
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.appspot.com',
);
```

### 4. Enable Authentication
1. Di Firebase Console, pilih **Authentication**
2. Klik tab **Sign-in method**
3. Enable **Email/Password**
4. Enable **Google** (opsional)

### 5. Setup Firestore Database
1. Di Firebase Console, pilih **Firestore Database**
2. Klik **Create database**
3. Pilih **Start in test mode** (untuk development)
4. Pilih lokasi database (pilih yang terdekat)

### 6. Setup Firebase Rules (Security)
```javascript
// Firestore Rules (dev mode)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

// Auth Rules
rules_version = '2';
service firebase.auth {
  match /{allPaths=**} {
    allow read, write: if request.auth != null;
  }
}
```

## Cara Menjalankan Aplikasi Web

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Enable Web Support (jika belum)
```bash
flutter config --enable-web
```

### 3. Run in Chrome
```bash
flutter run -d chrome
```

### 4. Build untuk Production
```bash
flutter build web
```

### 5. Deploy ke Firebase Hosting (opsional)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Initialize Firebase Hosting
firebase init hosting

# Deploy
firebase deploy
```

## Fitur yang Tersedia dengan Firebase Web

### ✅ Authentication
- ✅ Register dengan email/password
- ✅ Login dengan email/password
- ✅ Reset password
- ✅ Email verification
- ✅ Logout
- ✅ Auto login (persistent session)

### ✅ Database
- ✅ Save user profile to Firestore
- ✅ Update user data
- ✅ Real-time data sync

### ✅ Security
- ✅ Authentication rules
- ✅ Database security rules
- ✅ Input validation

## Keuntungan Firebase Web vs Android

### 🚀 Pengembangan
- **Lebih cepat**: Hot reload web lebih responsif
- **No NDK issues**: Tidak ada masalah versi Android NDK
- **Cross-platform**: Bisa diakses dari browser mana saja
- **Easy debugging**: Chrome DevTools

### 🌐 Deployment
- **Firebase Hosting**: Deploy gratis ke CDN global
- **Custom domain**: Bisa pakai domain sendiri
- **HTTPS**: Otomatis secure
- **PWA**: Bisa jadi Progressive Web App

### 📱 User Experience
- **Responsive**: Otomatis adaptif ke semua ukuran layar
- **Fast loading**: Optimasi web otomatis
- **No installation**: Langsung buka di browser
- **Update otomatis**: Tidak perlu download APK baru

## Testing

### 1. Test di Chrome Desktop
```bash
flutter run -d chrome
```

### 2. Test di Mobile Browser
```bash
flutter run -d web-server --web-port 8080
# Buka http://localhost:8080 di mobile browser
```

### 3. Test Build Production
```bash
flutter build web
# Serve build folder dengan web server
```

## Troubleshooting

### Error: Firebase not initialized
- Pastikan `firebase_options.dart` sudah dikonfigurasi dengan benar
- Cek apakah web app sudah ditambahkan di Firebase Console

### Error: Authentication failed
- Pastikan Authentication sudah di-enable di Firebase Console
- Cek domain di Authentication > Settings > Authorized domains

### Error: CORS issues
- Tambahkan domain ke Firebase Console
- Gunakan `flutter run -d chrome --web-browser-flag="--disable-web-security"`

### Performance Issues
- Build production version: `flutter build web`
- Enable web optimizations di `web/index.html`
