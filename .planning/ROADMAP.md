# Roadmap: Order Panic: Food Frenzy

## Milestones

- ✅ **v2.0 Hyper-Casual Pivot** - Phases 1-4 (complete)

## Phases

### ✅ v2.0 Hyper-Casual Pivot (Complete)

**Milestone Goal:** Abandon the mindful sorting premise and rebuild the game into a chaotic, ad-driven hyper-casual experience.

#### Phase 1: Kill the Thematic Dissonance

**Goal**: Scrap the EmotionBottle UI and rebrand core entities to represent tangible inventory or ingredients that form a final requested product.
**Depends on**: Nothing
**Research**: Unlikely (Internal UI and entity renaming)
**Plans**: 2 plans

Plans:
- [x] 01-01: Domain Rebranding
- [x] 01-02: Thematic UI Overhaul

#### Phase 2: Inject the Chaos Engine (Real-Time State)

**Goal**: Convert sequential Riverpod state to a real-time reactive loop with a Customer model, decay timer, and GameController ticker.
**Depends on**: Phase 1
**Research**: Unlikely (Internal Riverpod timer architecture)
**Plans**: 1 plan

Plans:
- [x] 02-01: Inject the Chaos Engine

#### Phase 3: Rewrite the Resolution Logic

**Goal**: Change win condition to an active order-fulfillment model (drag-to-submit/tap-to-serve) that validates completed bottles against active Customer orders.
**Depends on**: Phase 2
**Research**: Unlikely (Internal game logic)
**Plans**: 1 plan

Plans:
- [x] 03-01: Rewrite Resolution Logic

#### Phase 4: Weaponise the Monetization Strategy

**Goal**: Integrate google_mobile_ads and force interstitial video ads when the player is cornered by the timer.
**Depends on**: Phase 3
**Research**: Likely (Ad integration patterns)
**Research topics**: google_mobile_ads setup for Flutter, handling interstitial ad loading states, complying with App Store ad guidelines for hyper-casual games.
**Plans**: 1 plan

Plans:
- [x] 04-01: AdMob Interstitial Integration

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Kill the Thematic Dissonance | v2.0 | 2/2 | Complete | 2026-02-24 |
| 2. Inject the Chaos Engine | v2.0 | 1/1 | Complete | 2026-02-24 |
| 3. Rewrite the Resolution Logic | v2.0 | 1/1 | Complete | 2026-02-24 |
| 4. Weaponise the Monetization Strategy | v2.0 | 1/1 | Complete | 2026-02-24 |
