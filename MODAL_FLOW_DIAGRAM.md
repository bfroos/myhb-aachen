# Modal Trigger Flow Diagram

## User Journey & Modal Logic

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER VISITS PAGE                             │
│                                                                      │
│  sessionStorage.modalShown = not set (null)                         │
│  Modal is hidden                                                     │
└──────────────────────────┬──────────────────────────────────────────┘
                           │
                ┌──────────┴──────────┐
                │                     │
        ┌───────▼────────┐    ┌──────▼──────────┐
        │ User Scrolls   │    │ User Moves      │
        │   Down Page    │    │ Mouse to Top    │
        └───────┬────────┘    └──────┬──────────┘
                │                    │
        ┌───────▼────────────────────▼───────┐
        │                                    │
        │  Event Listener Checks:            │
        │  scrollPercent >= 95%?             │
        │  OR clientY <= 0?                  │
        │                                    │
        │  AND                               │
        │                                    │
        │  sessionStorage.modalShown?        │
        └─────────┬──────────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
    ┌────▼─────┐      ┌────▼──────────┐
    │   YES    │      │     NO        │
    │ (Already │      │  (Not shown)   │
    │  shown)  │      │               │
    └────┬─────┘      └────┬──────────┘
         │                 │
    ┌────▼──────┐      ┌────▼─────────────┐
    │ Do Nothing │      │ OPEN MODAL       │
    │            │      │                  │
    │ Log: Modal │      │ 1. Add .active   │
    │ already    │      │    class         │
    │ shown this │      │                  │
    │ session    │      │ 2. Set           │
    └────────────┘      │    sessionStorage│
                        │    .modalShown   │
                        │    = 'true'      │
                        │                  │
                        │ 3. Show form     │
                        │    state         │
                        │                  │
                        │ 4. Focus email   │
                        │    input         │
                        └────┬─────────────┘
                             │
                        ┌────▼──────────┐
                        │ USER SEES     │
                        │ DISCOUNT      │
                        │ MODAL         │
                        │                │
                        │ 🎁 20% OFF!    │
                        │ Enter email →  │
                        │ Get code → ✅  │
                        └────────────────┘
```

---

## Session Storage State Machine

```
┌─────────────────────────────────────────────────────────┐
│  TAB OPENED / PAGE LOADED                               │
│  sessionStorage.modalShown = undefined                  │
└─────────┬───────────────────────────────────────────────┘
          │
          │
          ├─────────────────────────────────┐
          │                                 │
          │     USER ACTION DETECTED        │
          │     (scroll to 95% OR exit      │
          │      intent)                    │
          │                                 │
    ┌─────▼──────────┐                      │
    │ Check Storage: │                      │
    │ modalShown?    │                      │
    └─────┬──────────┘                      │
          │                                 │
    ┌─────┴────────┐                        │
    │              │                        │
    │ NOT SET      │  SET TO 'true'        │
    │              │                        │
┌───▼────────┐    │                    ┌───▼────────┐
│ ALLOW      │    │                    │ BLOCK      │
│ MODAL      │    │                    │ MODAL      │
│ OPEN       │    │                    │ (already   │
│            │    │                    │  shown)    │
│ Set to:    │    │                    │            │
│ 'true'     │    │                    │ Log:       │
└────┬───────┘    │                    │ "Modal     │
     │            │                    │ suppressed"│
     │            │                    └────────────┘
     │            │
     │     ┌──────▼─────┐
     │     │ IGNORE ALL │
     │     │ SUBSEQUENT │
     │     │ TRIGGERS   │
     │     │ IN SESSION │
     │     └─────┬──────┘
     │           │
     └───────┬───┘
             │
             │
   ┌─────────▼──────────┐
   │ USER CLOSES TAB    │
   │                    │
   │ sessionStorage     │
   │ cleared            │
   │ (session ends)     │
   └─────────┬──────────┘
             │
   ┌─────────▼──────────────────┐
   │ USER OPENS SAME PAGE       │
   │ IN NEW TAB / FRESH SESSION │
   │                            │
   │ sessionStorage.modalShown  │
   │ = undefined (reset)        │
   │                            │
   │ → Modal can trigger again  │
   └────────────────────────────┘
```

---

## Event Listener Timeline

```
TIME →
│
├─ 0:00  Page loads
│        • EXIT INTENT listener activated
│        • SCROLL listener activated
│        • sessionStorage check: false (no flag)
│
├─ 0:05  User scrolls down
│        • SCROLL listener fires every frame
│        • Calculates scrollPercent
│        • Progress: 20%... 40%... 65%...
│
├─ 0:15  User reaches 95% scroll
│        ✓ SCROLL TRIGGER CONDITION MET
│        • Check: sessionStorage.modalShown → null
│        • ACTION: openDiscountModal()
│        • ACTION: sessionStorage.setItem('true')
│        • RESULT: Modal appears 🎉
│
├─ 0:20  User scrolls to 100%
│        • SCROLL listener fires again
│        • scrollPercent = 100%
│        • Check: sessionStorage.modalShown → 'true'
│        • ACTION: Do nothing
│        • Log: "Modal already shown this session"
│
├─ 0:30  User tries EXIT INTENT (moves mouse to top)
│        • MOUSELEAVE listener fires
│        • clientY = -5 (above viewport)
│        • Check: sessionStorage.modalShown → 'true'
│        • ACTION: Do nothing
│        • Log: "Modal already shown this session"
│
└─ ∞     User closes tab
         • sessionStorage cleared
         • Session ends
```

---

## Desktop Flow Diagram

```
   DESKTOP BROWSER (1920x1080)
   ┌────────────────────────────────────────────┐
   │  File  Edit  View  Tools  ▢  ≡             │ ← TOP EDGE (Y = 0)
   ├────────────────────────────────────────────┤
   │ https://aachen.myhealthandbeauty.com       │
   ├────────────────────────────────────────────┤
   │                                            │
   │  Hero Section                              │
   │  "Lippen sanft aufspritzen"                │
   │  [20% RABATT SICHERN]                      │
   │                                            │
   │ ┌──────────────────────────────────────┐  │
   │ │  👁️ EXIT INTENT TRIGGER              │  │
   │ │  User mouse leaves from here ↑ ↑ ↑  │  │
   │ │  When clientY ≤ 0 ✓                │  │
   │ └──────────────────────────────────────┘  │
   │                                            │
   │  Video Section                             │
   │  [Image] [Text]                            │
   │                                            │
   │  Testimonials                              │
   │  ⭐⭐⭐⭐⭐  (Scrolling here...)          │
   │                                            │
   │  Treatment Details                         │
   │  [Grid of 8 items]                         │
   │                                            │
   │  Carousel                                  │
   │  [Cards] [Cards]                           │
   │                                            │
   │  Process                                   │
   │  [Step 1] [Step 2] [Step 3]               │
   │                                            │
   │  Benefits                                  │
   │  ✓ Natural Results                        │
   │  ✓ Fast Results                           │
   │                                            │
   │  Doctor Section                            │
   │  [Profile] [Bio]                          │
   │                                            │
   │  FAQ                                       │
   │  [Accordion Items...]                      │
   │                                            │
   │  Location Map                              │
   │  [Google Map Embed]                        │
   │                                            │
   │  Location Benefits                         │
   │  [3 Benefits Cards]                        │
   │                                            │
   │  CTA Gold Section                          │
   │  "Jetzt Deine Lippen-Aufspritzung buchen!"│
   │                                            │
   │  Footer                                    │
   │ ┌──────────────────────────────────────┐  │
   │ │  👁️ SCROLL TO BOTTOM TRIGGER         │  │
   │ │  95% of page scrolled ✓              │  │
   │ │                                      │  │
   │ │  © 2026 MY HEALTH & BEAUTY          │  │ ← BOTTOM EDGE
   │ └──────────────────────────────────────┘  │
   │                                            │
   └────────────────────────────────────────────┘
```

---

## Mobile Flow Diagram

```
   MOBILE (375px width)
   ┌────────────────────┐
   │ ← | 📍 aachen.m... │ ← TOP EDGE (Y = 0)
   ├────────────────────┤
   │   Hero            │
   │ "Lippen sanft"    │
   │ [RABATT BUTTON]   │
   │                    │
   │ 👁️ EXIT INTENT    │
   │ Can trigger when  │
   │ swiping top/out   │
   ├────────────────────┤
   │   Video Section   │
   │                    │
   │   [Scrolling...]   │
   │   Testimonials    │
   │                    │
   │   Details Grid    │
   │   (2 columns)     │
   │                    │
   │   Carousel        │
   │   (single scroll) │
   │                    │
   │   Process        │
   │   (stacked)       │
   │                    │
   │   Benefits        │
   │   (image on top)   │
   │                    │
   │   Doctor          │
   │                    │
   │   FAQ Accordion   │
   │                    │
   │   Location Map    │
   │   [Google Map]    │
   │                    │
   │   Benefits Cards  │
   │   (stacked)       │
   │                    │
   │   CTA Gold        │
   │                    │
   │   Footer          │
   │ ┌────────────────┐ │
   │ │ Footer Links  │ │
   │ │ Copyright     │ │
   │ │               │ │ ← BOTTOM EDGE
   │ └────────────────┘ │
   │                    │
   │ ┌────────────────┐ │
   │ │📞│📅│💬       │ ← Sticky bottom bar
   │ └────────────────┘ │    (only mobile)
   └────────────────────┘
   
   👁️ SCROLL TO BOTTOM TRIGGER
   Fires when user scrolls to 95% of page
   (very natural on mobile)
```

---

## Code Flow

```javascript
PAGE LOAD
│
├─ DOMContentLoaded fires
│  ├─ initializeLocation() ✓
│  ├─ Set up exit intent listener
│  │  └─ document.addEventListener('mouseleave', function(e) {...})
│  │
│  └─ Set up scroll listener
│     └─ window.addEventListener('scroll', function() {...})
│
│
USER ACTION 1: SCROLLS DOWN
│
├─ scroll event fires repeatedly
│  └─ Calculate scrollPercent = (viewportHeight + scrollY) / pageHeight * 100
│     ├─ scrollPercent = 45% → No trigger
│     ├─ scrollPercent = 75% → No trigger
│     ├─ scrollPercent = 95% → TRIGGER!
│     │  ├─ Check: !sessionStorage.getItem('modalShown')
│     │  │  ├─ TRUE (first time)
│     │  │  │  ├─ openDiscountModal()
│     │  │  │  ├─ sessionStorage.setItem('modalShown', 'true')
│     │  │  │  └─ MODAL OPENS ✓
│     │  │  └─ FALSE (already shown)
│     │  │     └─ Log: "Modal already shown"
│     │  └─ Exit function
│     │
│     └─ scrollPercent = 100% → No action (already shown)
│
│
USER ACTION 2: CLOSES MODAL & TRIES EXIT INTENT
│
├─ mouseleave event fires
│  ├─ Check: e.clientY <= 0
│  │  ├─ TRUE (at top edge)
│  │  │  ├─ Check: !sessionStorage.getItem('modalShown')
│  │  │  │  ├─ FALSE (set to 'true' earlier)
│  │  │  │  └─ Do nothing
│  │  │  └─ Exit function
│  │  │
│  │  └─ FALSE (not at top)
│  │     └─ Exit function
│
│
USER CLOSES TAB
│
└─ sessionStorage cleared
   (session ended)
```

---

## Summary

**Two Independent Triggers:**
1. ✅ **Exit Intent** - `mouseleave` at `clientY <= 0`
2. ✅ **Scroll to Bottom** - scroll >= 95% of page height

**Session Control:**
- `sessionStorage.modalShown` prevents duplicate shows
- Cleared when tab closes (true session-based)
- No persistent storage (respects user privacy)

**Result:**
- Higher engagement (only shows on genuine intent)
- Better UX (not forced in face)
- Better conversion rates (right message at right time)
