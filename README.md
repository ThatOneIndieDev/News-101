# News-101

A clean SwiftUI remake of the Al Jazeera experience with a custom tab bar, live news feed, analytics summaries, topic personalization, and Firebase authentication.

## Demo

### Main
![Main Screen](AlJazeeraRemake/Demo%20Images/MainScreen.png)

### Analytics Tab
![Analytics Tab](AlJazeeraRemake/Demo%20Images/Analytics%20Tab.png)

### Topics Tab
![Topics Tab](AlJazeeraRemake/Demo%20Images/TopicsTab.png)

### Sign Up
![Sign Up](AlJazeeraRemake/Demo%20Images/SignUp%20Screen.png)

### Signed-In Profile
![Signed-In Profile](AlJazeeraRemake/Demo%20Images/SignedInProfile.jpeg)

## Tabs Overview

### News
The default feed with live updates, full article cards, and a Follow system to track stories you care about.

### Analytics
A concise summary view of the current articles with prediction-style trend visuals for stories that look forecast-heavy.

### Topics
Pick and persist topics to personalize your feed. Selected topics show relevant articles below.

### Profile
Sign up or log in using email/password, Google, or Apple. After first login, complete your profile and avatar.

## How To Fork

1. Open this repo on GitHub.
2. Click **Fork** in the top-right.
3. Clone your fork locally:

```bash
git clone https://github.com/<your-username>/AlJazeeraRemake.git
```

4. Open the project in Xcode:

```bash
open AlJazeeraRemake.xcodeproj
```

## Notes

- Add Firebase `GoogleService-Info.plist` to `AlJazeeraRemake/Secrets/` and ensure it is included in the app target.
- The `Secrets/` folder is gitignored for safety.
