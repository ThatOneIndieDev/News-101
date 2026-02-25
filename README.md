# News-101

A clean SwiftUI remake of the Al Jazeera experience with a custom tab bar, live news feed, analytics summaries, topic personalization, and Firebase authentication.

## Demo

<p align="center">
  <img src="AlJazeeraRemake/Demo%20Images/MainScreen.png" width="220">
  <img src="AlJazeeraRemake/Demo%20Images/Analytics%20Tab.png" width="220">
  <img src="AlJazeeraRemake/Demo%20Images/TopicsTab.png" width="220">
  <img src="AlJazeeraRemake/Demo%20Images/SignUp%20Screen.png" width="220">
  <img src="AlJazeeraRemake/Demo%20Images/SignedInProfile.jpeg" width="220">
</p>

## Tabs Overview

<h3 align=center>News</h3>
<p align=center>The default feed with live updates, full article cards, and a Follow system to track stories you care about.</p>

<h3 align=center>Analytics</h3>
<p align=center>A concise summary view of the current articles with prediction-style trend visuals for stories that look forecast-heavy.</p>

<h3 align=center>Topics</h3>
<p align=center>Pick and persist topics to personalize your feed. Selected topics show relevant articles below.</p>

<h3 align=center>Profile</h3>
<p align=center>Sign up or log in using email/password, Google, or Apple. After first login, complete your profile and avatar.</p>

## Setup

1. Clone the repo.
2. Add your `GoogleService-Info.plist` file to:
   `AlJazeeraRemake/Secrets/`
3. Run `pod install` (if using CocoaPods) or resolve Swift Packages.
4. Open in Xcode.
5. Build and run on simulator.

## Notes

- Add Firebase `GoogleService-Info.plist` to `AlJazeeraRemake/Secrets/` and ensure it is included in the app target.
- The `Secrets/` folder is gitignored for safety.
