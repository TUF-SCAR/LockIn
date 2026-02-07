# LockIn – Core Specification

## Global Rules
- Day reset time: **03:00 AM**
- App is **offline-first**
- Tone can be **Demon mode** 😈 (per routine)
- Summary is shown **only when user presses “Show Today’s Summary”**

---

## Morning Routine
- Trigger: **First phone unlock after 03:00 AM**
- Steps:
    1. Cleanser
    2. Moisturiser
- Sunscreen:
    - SPF 50
    - Low-priority “human nudge” notifications
    - Ignorable
    - Example style: “If you’re going out, don’t forget sunscreen”

---

## Lunch + Medication
- Lunch is tracked manually:
    - **Start Lunch**
    - **End Lunch**
- Tablet:
    - **Azifast 500mg**
    - Days: **Tuesday / Wednesday / Thursday**
    - Trigger: **After End Lunch**
    - Actions:
        - Taken
        - Snooze
        - Skip

---

## Gym Routine
- Days: **Monday – Saturday**
- Tracking via:
    - **Start Gym**
    - **End Gym**
- Workout split:
    - **Push / Pull / Legs**
    - User-editable
- Reminders:
    - Before gym (prep)
    - Demon-mode allowed

---

## Night Routine (Triggered after End Gym)
Normal days:
1. Cleanser
2. Apply **BPO 2.5%** (whole face)
3. After **2 hours** → reminder to wash off (water only)
4. Towel dry
5. Apply **Azibrite** (overnight)

---

## Monthly Dermatologist Sessions
- User enters session date **manually each month**
- Blackout window:
    - **D − 5 days to D + 5 days (inclusive)**
    - Full-day based
- During blackout:
    - ❌ BPO blocked
    - ❌ Azibrite blocked
    - **Hard block** (cannot mark as done)
- Warnings:
    - “Pause starts in 2 days”
    - “Pause starts tomorrow”
- Session-day reminder time:
    - **09:00 AM**

---

## Food Tracking (Daily)
Targets (cooked weight):
- Rice: **1500 g**
- Chicken: **500 g**
- Eggs: **3**
- Bananas: **4**
- Water: tracked

Rules:
- No oil
- No dairy
- Track **total per day**, not per meal

---

## Data & Exports
- Logs stored locally
- Monthly automatic upload to **Google Drive**:
    - **JSON** (for future progress app)
- Exportable **PDF**:
    - For dermatologist
    - For gym progress

---