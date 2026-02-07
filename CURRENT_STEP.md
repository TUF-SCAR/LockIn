# LockIn – Current Development State

## Current Phase
**Phase 1 – App Skeleton**

---

## Goal of This Phase
Replace demo Flutter app with:
- LockIn base structure
- Today screen
- Core action buttons

---

## What Is Already Done
- Flutter SDK installed and working
- Android toolchain fixed
- Project created via CLI
- App runs on physical phone
- App name locked: **LockIn**
- Package: **com.scar.app.lockin**

---

## Current UI (Today Screen)
Buttons present:
- Start Lunch
- End Lunch
- Start Gym
- End Gym
- Show Today’s Summary

(No logic yet, UI only)

---

## Next Steps (IN ORDER)
1. Wire **Day Reset = 03:00 AM**
2. Implement Day Events:
    - Start Lunch / End Lunch
    - Start Gym / End Gym
3. After End Lunch (Tue/Wed/Thu):
    - Trigger Azifast reminder
    - Actions: Taken / Snooze / Skip
4. After End Gym:
    - Trigger night routine chain
    - Schedule 2-hour BPO wash-off reminder
5. Implement blackout rule engine:
    - Disable BPO & Azibrite during D−5..D+5
6. Add “Show Today’s Summary” logic
7. Commit Phase 1 completion

---

## Last Commit Message
- Phase 1: LockIn skeleton + Today screen buttons

---