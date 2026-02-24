---
phase: 03-rewrite-the-resolution-logic
plan: 01
subsystem: ui
tags: [gameplay, mechanics, win-state]

# Dependency graph
requires:
  - phase: 02-01
    provides: Customer class, real-time mechanics
provides:
  - Tap-to-serve logic
  - CustomersServed/targetCustomers score mechanic
  - UI header showing active customers with patience
affects: [03-02]

# Tech tracking
tech-stack:
  added: []
  patterns: [Order-fulfillment mechanic, Immutable game state]

key-files:
  created: [lib/features/game/widgets/customer_view.dart]
  modified: [lib/core/providers/game_controller.dart, lib/features/game/widgets/game_board.dart]

key-decisions:
  - "Decided to keep checkWin but base it on customersServed instead of trays completion."
  - "Decided to clear history array upon serving a tray to prevent exploit allowing players to undo a successful serve and duplicate score."

patterns-established:
  - "Tap-to-serve: completed trays route to `serveTray` instead of selection."

issues-created: []

# Metrics
duration: 4min
completed: 2026-02-24
---

# Phase 03 Plan 01: Resolution Logic Rewrite Summary

**Game logic shifted from clearing the board to serving completed trays to active customers, driving the win state**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-24T05:44:00Z
- **Completed:** 2026-02-24T05:48:00Z
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments
- Removed "clear all trays" win condition and replaced it with target-based "customersServed".
- Implemented `serveTray` inside GameController to map complete trays to active customers.
- Created `CustomerView` widget with dynamic patience indicator.
- Updated GameBoard UI to feature active customers and HUD to show Served vs Target.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add serve logic to GameController** - `d006024` (feat)
2. **Task 2: Build CustomerView widget** - `0a9093a` (feat)
3. **Task 3: Integrate serving flow into UI** - `74a9bbf` (feat)

## Files Created/Modified
- `lib/core/providers/game_controller.dart` - `serveTray` method and `_checkWin` update.
- `lib/features/game/widgets/customer_view.dart` - Visual representation of `Customer`.
- `lib/features/game/widgets/game_board.dart` - Customer UI row, HUD stat change, tap-to-serve integration.

## Decisions Made
- Reused `_checkWin()` function by replacing its internal validation rule (customersServed vs targetCustomers).
- `history` is purposefully cleared on a `serveTray` action to act as an anti-cheat mechanism (disabling undoing a successful serve to re-serve).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Cleared Undo History on tray serve**
- **Found during:** Task 3 (Integrating serving flow into UI)
- **Issue:** Without clearing history, a player could complete a tray, serve it, then tap 'Undo', getting the tray back but still retaining the score since `customersServed` and `activeCustomers` weren't strictly reversible with time mechanics.
- **Fix:** Cleared the undo `history` array inside `serveTray` to enforce a point-of-no-return when fulfilling an order.
- **Files modified:** `lib/core/providers/game_controller.dart`
- **Verification:** Analyzer passes and logic safely isolates history.
- **Committed in:** `74a9bbf`

---

**Total deviations:** 1 auto-fixed (1 bug), 0 deferred
**Impact on plan:** Bug fix ensures score integrity and respects the new real-time constraints. No scope creep.

## Issues Encountered
None

## Next Phase Readiness
- Core game loop successfully refactored to an order-fulfillment mechanic.
- The game is ready to handle game-over screens based on `isGameOver` conditions (e.g., when a customer's patience reaches 0).

---
*Phase: 03-rewrite-the-resolution-logic*
*Completed: 2026-02-24*
