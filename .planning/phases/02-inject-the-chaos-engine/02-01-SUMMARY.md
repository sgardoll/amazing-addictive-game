---
phase: 02-inject-the-chaos-engine
plan: 01
subsystem: game-logic
tags: [timer, reactive, state-management]

# Dependency graph
requires:
  - phase: 01-kill-the-thematic-dissonance
    provides: [Ingredient enum]
provides:
  - Customer domain model with patience tracking
  - Real-time game loop via periodic Timer in GameController
  - Game over logic triggered by zero patience
affects: [ui, features/game/widgets, progression]

# Tech tracking
tech-stack:
  added: [dart:async]
  patterns: [Timer-based state mutations in StateNotifier]

key-files:
  created: [lib/core/models/customer.dart]
  modified: [lib/core/providers/game_controller.dart]

key-decisions:
  - "Implemented Customer as an immutable class with copyWith method."
  - "Integrated a periodic Timer in GameController to implement real-time decay mechanics instead of sequential turn mechanics."

patterns-established:
  - "Real-time state mutations: State mutations happen asynchronously via a Timer rather than strictly in response to user input."

issues-created: []

# Metrics
duration: 5min
completed: 2026-02-24
---

# Phase 02 Plan 01: Inject Chaos Engine Summary

**Real-time reactive game loop with Customer patience decay and randomized spawning**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-24T05:39:00Z
- **Completed:** 2026-02-24T05:44:00Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Implemented `Customer` model to represent dynamic, time-sensitive goals.
- Converted game state to track active customers and game over conditions.
- Implemented `GameController` ticker to decay patience and spawn new customers randomly.
- Shifted game paradigm from pure turn-based puzzle to real-time action puzzle.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create Customer model** - `a7cacbc` (feat)
2. **Task 2: Inject Timer and State into GameController** - `18f0c7d` (feat)

**Plan metadata:** `pending` (docs: complete plan)

## Files Created/Modified
- `lib/core/models/customer.dart` - Customer model representing orders and patience constraints.
- `lib/core/providers/game_controller.dart` - Modified to include activeCustomers, isGameOver, and manage a real-time periodic Timer.

## Decisions Made
- Used simple Dart class with copyWith for `Customer` model to integrate simply without needing to run build_runner, consistent with `GameStateData` implementation.
- Game loop spawns new customers randomly (max 3) and decreases their patience by 1 every second.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Game logic is now real-time, but UI does not yet render active customers or their ticking patience. Ready to hook up UI widgets to the new `activeCustomers` state.

---
*Phase: 02-inject-the-chaos-engine*
*Completed: 2026-02-24*
