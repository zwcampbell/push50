# Push 50 — App Store Status

## Build
- [x] Xcode project generated (xcodegen), iOS 18 minimum, Swift 6
- [x] SwiftData models — AppState, WorkoutSession
- [x] 6-week program schedule (18 workouts, hardcoded)
- [x] Placement test → starting week algorithm
- [x] All 6 screens built and simulator-tested
- [x] Active workout — set states, rest timer, max set input, completion
- [x] Streak tracking and program advancement
- [x] Progress chart (Swift Charts), stats row, timeline bar
- [x] Settings — notifications toggle + time picker, reset confirmation, About
- [x] Daily reminder notifications (UNUserNotificationCenter)
- [x] App icon (1024×1024, AppIcon.appiconset + onboarding)

## Pre-submission (code)
- [x] Set `DEVELOPMENT_TEAM` in `project.yml` — LP5448PXCB
- [x] Add `PrivacyInfo.xcprivacy` manifest — UserDefaults CA92.1

## Pre-submission (App Store Connect)
- [x] Register bundle ID `com.push50.app` — already registered under your account
- [ ] Create app record in App Store Connect — name, bundle ID, primary language, SKU
- [ ] Privacy questionnaire — no data collected, all "No"
- [ ] Age rating — 4+
- [ ] Category — Health & Fitness
- [ ] App description and keywords (draft below)
- [x] Screenshots — 6 screens captured from iPhone 17 Pro Max (6.7") → Screenshots/

## Archiving
- [ ] Archive: Xcode → Product → Archive → Distribute App → App Store Connect
- [ ] Verify no warnings or missing entitlements in the Organizer upload report

## App Store Connect field drafts
**Name:** Push 50
**Subtitle:** 50 Push-Ups in 6 Weeks
**SKU:** push50-001
**Description:**
Push 50 is a structured 6-week program designed to take you from wherever you are today to 50 consecutive push-ups.

The program is built around a proven progressive overload system — three workouts per week, each with 5 sets at a prescribed rep count. A placement test at the start puts you in the right week, so you're never starting too easy or too hard.

**Keywords:** push-ups, fitness, workout, pushups, strength, exercise, training, calisthenics

## Nice to have (post-launch)
- [ ] TestFlight beta before public release
- [ ] App Store preview video (optional but boosts conversion)
- [ ] Localization (EN only for now)
