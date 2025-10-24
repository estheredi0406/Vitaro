# Vitaro

# Vitaro Project: Work Distribution Strategy for 5 Team Members

---

## **Team Structure & Role Assignment**

### **Member 1: Authentication & User Management Lead**
**Primary Responsibilities:**
- Implement Firebase Authentication (2 methods: Email/Password + Google Sign-in)
- Create login, registration, and password reset screens
- Implement input validation and error handling
- Set up email verification or OTP
- Manage auth state persistence
- Create user profile management (edit profile, settings)

**Deliverables:**
- `lib/features/auth/` folder with complete authentication flow
- `lib/features/profile/` folder with user profile CRUD
- Security rules for user authentication
- Widget tests for login/signup forms
- Demo: Registration → Logout → Login flow in video

**Git Commits:** ~25-30 commits across 2-3 weeks

---

### **Member 2: Donor Features & Dashboard Lead**
**Primary Responsibilities:**
- Implement Dashboard (home screen with blood type, recent donations, quick actions)
- Create "Find Centers" feature with list and map view
- Build eligibility check flow
- Implement donation booking system
- Create donation confirmation and success screens

**Deliverables:**
- `lib/features/dashboard/` folder
- `lib/features/centers/` folder (Find Centers, Select Center)
- `lib/features/donation/` folder (Eligibility, Booking, Confirmation)
- CRUD operations for donor records and donation requests
- Unit tests for donation eligibility logic
- Demo: Dashboard → Find Centers → Book Donation flow in video

**Git Commits:** ~25-30 commits

---

### **Member 3: Donation History & Tracking Lead**
**Primary Responsibilities:**
- Implement "Past Donations" screen with filtering/sorting
- Create "Track Donation Status" feature with real-time updates
- Build donation details view
- Implement donation impact visualization (charts/stats using recharts equivalent)
- Create donation reminders system

**Deliverables:**
- `lib/features/donation_history/` folder
- `lib/features/tracking/` folder
- CRUD operations for reading and updating donation records
- SharedPreferences for user preferences (notification settings, filters)
- Widget tests for donation history list
- Demo: View history → Track status → Update donation in video

**Git Commits:** ~20-25 commits

---

### **Member 4: Emergency Alerts & Hospital Features Lead**
**Primary Responsibilities:**
- Implement Emergency Alert system (create and submit alerts)
- Build hospital/blood bank dashboard (if applicable)
- Create notification system (FCM push notifications)
- Implement alert response tracking
- Build contact support and FAQ screens

**Deliverables:**
- `lib/features/emergency/` folder
- `lib/features/notifications/` folder
- `lib/features/support/` folder (Contact, FAQ)
- CRUD operations for emergency alerts
- Firebase Cloud Messaging integration
- Security rules for alert access control
- Demo: Submit emergency alert → Show Firebase update in video

**Git Commits:** ~20-25 commits

---

### **Member 5: State Management, Architecture & DevOps Lead**
**Primary Responsibilities:**
- Set up BLoC/Cubit state management architecture
- Establish clean architecture folder structure (presentation/domain/data)
- Create shared widgets library (custom buttons, cards, forms)
- Implement SharedPreferences for app settings (theme, language preferences)
- Set up Firebase ERD and security rules
- Configure Git workflow (branching strategy, PR templates)
- Run `flutter analyze` and `dart format` quality checks
- Coordinate testing strategy

**Deliverables:**
- `lib/core/` folder (constants, themes, utils, shared widgets)
- `lib/shared/` folder (common BLoCs, models, repositories)
- Complete ERD diagram matching Firestore structure
- Firebase security rules documentation
- README with setup instructions
- GitHub Actions/workflow setup (optional but recommended)
- Overall code quality assurance
- Demo: State management in action + SharedPreferences persistence in video

**Git Commits:** ~25-30 commits (including reviews and refactoring)

---

## **Shared Responsibilities (All Members)**

1. **Weekly standup meetings** - Each member reports progress, blockers, and next steps
2. **Code reviews** - Each member reviews at least 2 PRs from other members
3. **Documentation** - Each member documents their section in the final PDF report
4. **Video demo** - Each member presents their feature (2-3 minutes each)

---

## **Git Workflow Strategy**

### **Branch Naming Convention:**
```
feature/auth-login          (Member 1)
feature/dashboard-ui        (Member 2)
feature/donation-history    (Member 3)
feature/emergency-alerts    (Member 4)
feature/state-management    (Member 5)
```

### **Commit Message Format:**
```
feat(auth): implement email/password login
fix(dashboard): resolve null safety issue in blood type display
refactor(donation): extract eligibility logic to domain layer
test(profile): add widget tests for edit profile form
```

### **Pull Request Process:**
1. Each member works on their feature branch
2. Create PR when feature is testable
3. At least 1 other member reviews before merging
4. Member 5 does final quality check before merging to `main`

---

## **Timeline Recommendation (3-4 Weeks)**

### **Week 1: Setup & Core Features**
- Member 5: Architecture setup, ERD, Firebase configuration
- Members 1-4: Start UI implementation for their screens
- **Milestone:** All screens visible (even if not functional)

### **Week 2: Backend Integration**
- All members: Implement CRUD operations for their features
- Member 1: Complete authentication integration
- **Milestone:** Firebase connected, basic CRUD working

### **Week 3: Advanced Features & Testing**
- All members: Complete remaining features
- Implement SharedPreferences (Members 1, 3, 5)
- Write tests (everyone writes tests for their code)
- **Milestone:** All features functional, tests passing

### **Week 4: Polish & Documentation**
- Code quality checks (`flutter analyze`, `dart format`)
- Bug fixes and refinements
- Record demo video (allocate 3 hours for multiple takes)
- Write final report (divide sections by feature ownership)
- **Milestone:** Submission ready

---

## **Avoiding Overlap & Conflicts**

### **Clear Boundaries:**
- **Member 1** owns all `auth/` and `profile/` code
- **Member 2** owns `dashboard/`, `centers/`, and `donation/` code
- **Member 3** owns `donation_history/` and `tracking/` code
- **Member 4** owns `emergency/`, `notifications/`, and `support/` code
- **Member 5** owns `core/`, `shared/`, and architecture files

### **Shared Code Coordination:**
- Member 5 creates shared widgets first (custom buttons, cards, etc.)
- Other members use these shared components in their features
- Any modifications to shared code require PR review from Member 5

### **Firebase Collections Ownership:**
```
users → Member 1 (auth & profile)
donors → Member 2 (registration & eligibility)
donations → Members 2 & 3 (booking & history)
centers → Member 2 (find centers)
emergency_alerts → Member 4 (alerts)
notifications → Member 4 (push notifications)
```

---

## **Red Flags to Avoid**

❌ **One person doing 70%+ of commits** - Use contribution table to monitor
❌ **Last-minute push on final night** - Enforce weekly PR deadlines
❌ **Commits without tests** - Require tests in PR template
❌ **Merge conflicts** - Communicate before touching shared files
❌ **Missing from video demo** - Schedule recording 2 days before deadline

---

## **Success Metrics**

✅ Each member has 20-30+ meaningful commits
✅ PRs spread across 3-4 weeks (not all in final 3 days)
✅ Each member demonstrates their feature in video
✅ All tests pass (`flutter test`)
✅ Zero warnings from `flutter analyze`
✅ ERD matches Firestore structure exactly
✅ Report includes clear contribution table matching Git stats

---

This distribution ensures everyone writes substantial code, owns clear features, and has evidence of their work in Git history. The architecture lead (Member 5) coordinates but doesn't dominate—they enable others while building the foundation.
