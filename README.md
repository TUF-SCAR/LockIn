# LockIn

Routine engine for skin, gym, food, and meds.

## What it does (MVP)
- Day reset: 03:00 AM
- Morning routine: triggered on first phone unlock after reset
- Lunch tracking: Start Lunch / End Lunch
- Tue/Wed/Thu: Azifast 500mg reminder after End Lunch (Taken/Snooze/Skip)
- Gym tracking: Start Gym / End Gym (Mon–Sat)
- Night routine chain after End Gym:
    - Cleanser → BPO 2.5% (2h) → wash with water → Azibrite overnight
- Monthly derm sessions:
    - Manual date entry
    - Blackout D−5..D+5 blocks BPO/Azibrite (hard block)
- “Show Today’s Summary” button
- Food targets + water tracking (daily totals)
- Offline-first
- Monthly export: JSON to Drive, PDF for dermatologist & gym

## Dev notes
See:
- `LOCKIN_SPEC.md` (rules)
- `CURRENT_STEP.md` (current progress)
