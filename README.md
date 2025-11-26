# Vitaro - Blood Donation Mobile App 🩸

**Connect. Donate. Save Lives.**

Vitaro is a Flutter-based mobile application designed to streamline the blood donation process in Kigali, Rwanda. It connects donors with blood centers, tracks donation history, and facilitates emergency blood requests.

---

## 📱 Features

### 1. Authentication (Fatoumata Ndiaye)
- **Secure Login/Signup:** Email/Password authentication via Firebase Auth.  
- **Social Sign-in:** One-tap login with Google & Facebook.  
- **Persistent Session:** Auto-login for returning users.

### 2. Dashboard & Centers (David)
- **Health Dashboard:** Real-time vitals tracking (Hemoglobin, BP, Pulse) and recent activity feed.  
- **Blood Type Card:** Dynamic display of user's blood type.  
- **Find Centers:** Interactive Google Map showing nearby blood donation centers.  
- **List View:** Searchable list of centers with distance and operating hours.

### 3. Donation History & Tracking (Otani)
- **Donation Log:** Detailed history of past donations with dates and locations.  
- **Impact Tracking:** Visual charts showing lives saved and donation frequency.  
- **Eligibility Check:** Smart questionnaire to determine donor eligibility before booking.  
- **Appointment Booking:** Seamless flow to schedule donations at specific centers.

### 4. Emergency Alerts (Esther)
- **Urgent Requests:** View real-time emergency blood requests from hospitals.  
- **Response System:** “I can donate” quick response button for eligible donors.  
- **Notification Integration:** Push notifications for critical shortages nearby.

### 5. Architecture, DevOps & User Management (Tamunotonye Briggs)
- **Clean Architecture:** Modular codebase separated into Data, Domain, and Presentation layers. Configure Git workflow (branching strategy, PR templates)
- Run `flutter analyze` and `dart format` quality checks
- **Firebase setup:** Set up Firebase ERD.  
- **Shared Widgets:** Create shared widgets library (custom buttons, cards, forms)  
- **CI/CD Ready:** Configured for automated testing and linting.
- **Profile Management:** Edit profile details, upload profile pictures (Cloudinary integration), and manage settings.  

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Dart)  
- **Backend:** Firebase (Auth, Firestore, Cloud Messaging)  
- **State Management:** Flutter BLoC / Cubit  
- **Maps:** Google Maps Flutter  
- **Storage:** Cloudinary (Images), Firestore (Data)  
- **Architecture:** Clean Architecture  

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (3.0.0 or higher)  
- Dart SDK  
- Android Studio / VS Code  
- Firebase Project Credentials  

### **Installation**

#### 1. Clone the Repository:
```bash
git clone https://github.com/estheredi0406/Vitaro.git
cd Vitaro/vitaro
```

## 2. Install Dependencies:
```
flutter pub get
```

## 3. Setup Firebase:

Ensure `firebase_options.dart` is configured for your Firebase project.  
If not, run:
```
flutterfire configure
```

## 4. Run the App:
```
flutter run
```
---

## 🧪 Testing

The project includes both Unit and Widget tests to ensure stability.

### Running Tests
Run all tests:
```
flutter test
```
### Test Coverage

**Widget Tests:**  
Ensures components (`CustomButton`, `CustomTextField`) render properly and respond to interactions.

**Unit Tests:**  
Validates business logic such as `UserModel` parsing differences between Google and Email authentication.

---

## 📂 Project Structure
---
```

lib/
├── config/              # Routes and theme configuration
├── core/                # Shared utilities (Constants, Models, UI Helpers)
├── features/            # Feature-based modules
│   ├── auth/            # Login, Signup, Splash
│   ├── centers/         # Map and List of donation centers
│   ├── dashboard/       # Main user dashboard
│   ├── donation_history/# History list and Impact charts
│   ├── emergency/       # Emergency alerts system
│   └── profile/         # User profile and settings
├── shared_widgets/      # Reusable UI components
└── main.dart            # App entry point and Dependency Injection
```

---

## 👥 Contributors

- **Fatoumata Ndiaye:** Authentication
- **David:** Dashboard & Donation Centers  
- **Otani:** Donation History & Eligibility  
- **Esther:** Emergency Alerts System  
- **Tamunotonye Briggs:** Architecture, User Management & DevOps  

---

**Vitaro © 2025 — Saving lives, one drop at a time.**
