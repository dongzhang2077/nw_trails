# NW Trails — Project Proposal (Draft)

> **CSIS 4280 Special Topics in Emerging Technology — Winter 2026**
> **Phase 1 & 2: Project Proposal + Prototype**
> **Due: March 02, 2026, 17:00**

> **Note**: This is a communication draft for team coordination. The final submission must be in `.docx` format named `group06-proposal.docx`.

---

## i. Cover Page

|                  |                                                 |
| ---------------- | ----------------------------------------------- |
| **App Name**     | NW Trails                                       |
| **Group Number** | Group 06                                        |
| **Course**       | CSIS 4280 Special Topics in Emerging Technology |
| **Term**         | Winter 2026                                     |

| Name                         | Student ID | Role      |
| ---------------------------- | ---------- | --------- |
| Dong Zhang                   | 300403848  | Team Lead |
| Diego Romero-Lovo De la Flor | 300398786  | Member    |
| Zhi Kang                     | 300403869  | Member    |
| Menghua Wang                 | 300397100  | Member    |

> **TODO**: Each member fill in your Student ID before final submission.

---

## ii. Description

NW Trails is a gamified city exploration app designed for Douglas College students to discover New Westminster through location-based check-ins and achievement collection.

The app features an interactive map displaying 15 curated landmarks across New Westminster, spanning historic sites, nature spots, food destinations, and cultural attractions. Users explore the city by physically visiting these landmarks and checking in via GPS verification. Each check-in contributes to a personal achievement system where users earn badges — Bronze, Silver, and Gold — based on the number of landmarks visited, as well as themed badges for completing category-specific collections such as "History Buff" or "Foodie Explorer."

To provide a structured exploration experience, NW Trails offers pre-set walking routes such as "Historic Downtown Walk" and "Waterfront Trail," each with distance, duration, and difficulty information. Users can follow these guided routes to efficiently discover landmarks while enjoying a curated walking tour of the city.

The app encourages community engagement through a leaderboard that ranks users by exploration progress and displays trending landmarks. Users can also share their achievements and check-in highlights on social media.

NW Trails addresses a common challenge faced by new students: unfamiliarity with the surrounding city. Rather than relying on generic tourism apps, NW Trails offers a fun, social, and gamified way for students to build a connection with New Westminster while staying physically active.

The project follows a client-server architecture. The Flutter-based client communicates with a SpringBoot REST API backend, with MongoDB serving as the centralized database. In Phase 1, the client operates with locally stored mock data, with full backend integration planned for subsequent phases.

---

## iii. Market Analysis

### Reference Application: Pokemon GO

Pokemon GO, developed by Niantic and launched in 2016, is the most widely recognized location-based mobile game in the world. With over 600 million downloads, it pioneered the concept of gamified real-world exploration by encouraging users to physically visit locations to interact with virtual content. We selected Pokemon GO as our reference application because it shares the same foundational concept as NW Trails — motivating users to explore real-world locations through game mechanics.

We have identified three core features from Pokemon GO that we aim to replicate and improve upon in the context of a campus-oriented city exploration app.

### Feature 1: Location-Based Discovery & Check-in

**How Pokemon GO does it:**
Pokemon GO uses "PokeStops" and "Gyms" tied to real-world landmarks. Users must physically travel to these locations to interact with them, spinning a PokeStop disc to collect items. The system uses GPS to verify the user's proximity.

**How NW Trails replicates and improves it:**

| Aspect       | Pokemon GO                             | NW Trails                                                |
| ------------ | -------------------------------------- | -------------------------------------------------------- |
| Content      | Virtual creatures at generic locations | Curated real landmarks with educational descriptions     |
| Check-in     | Spin a disc (game mechanic)            | One-tap check-in with optional photo upload              |
| Verification | GPS proximity                          | GPS proximity (within 50m)                               |
| Value        | Collect game items                     | Learn about New Westminster's history, food, and culture |

**Our improvement:** While Pokemon GO's PokeStops are often placed at arbitrary locations with little context, NW Trails curates each landmark with meaningful descriptions, practical information (opening hours, tips from students), and category tags. The goal shifts from collecting virtual items to gaining genuine knowledge about the city.

### Feature 2: Achievement & Progression System

**How Pokemon GO does it:**
Pokemon GO features an extensive medal system. Players earn medals for catching certain types of Pokemon, walking specific distances, or completing raids. Medals progress through Bronze, Silver, and Gold tiers, each requiring increasing thresholds.

**How NW Trails replicates and improves it:**

| Aspect     | Pokemon GO                        | NW Trails                                         |
| ---------- | --------------------------------- | ------------------------------------------------- |
| Tiers      | Bronze, Silver, Gold              | Bronze (5), Silver (10), Gold (15)                |
| Categories | Pokemon types (Fire, Water, etc.) | Landmark themes (Historic, Nature, Food, Culture) |
| Scope      | 100+ medals, overwhelming         | Focused set of achievable badges                  |
| Motivation | Completionist grind               | Realistic weekend goals                           |

**Our improvement:** Pokemon GO's medal system is vast and can feel unattainable for casual players. NW Trails intentionally limits the scope to 15 landmarks and a focused set of badges, making 100% completion a realistic and rewarding goal achievable within a semester. The themed badges (e.g., "History Buff" for visiting all historic sites) provide clear, short-term objectives that maintain motivation.

### Feature 3: Guided Exploration Routes

**How Pokemon GO does it:**
Pokemon GO introduced "Routes" in 2023, allowing players to follow community-created paths. Routes show a trail on the map and reward players with special Pokemon encounters along the way. However, routes are user-generated with minimal curation, and the focus remains on game rewards rather than exploration value.

**How NW Trails replicates and improves it:**

| Aspect         | Pokemon GO                           | NW Trails                                             |
| -------------- | ------------------------------------ | ----------------------------------------------------- |
| Route creation | User-generated, inconsistent quality | Professionally curated by the development team        |
| Information    | Minimal (just a path line)           | Distance, duration, difficulty, landmark descriptions |
| Purpose        | Catch special Pokemon                | Discover the city with structured walking tours       |
| Navigation     | Follow a line on map                 | Step-by-step directions between landmarks             |

**Our improvement:** NW Trails routes are thoughtfully designed walking tours with practical metadata (distance, time, difficulty). Each route tells a story — the "Historic Downtown Walk" guides users through New Westminster's heritage sites in chronological order, while the "Waterfront Trail" follows the scenic Fraser River path. This transforms a game mechanic into a genuinely useful city guide.

### Summary

| Core Feature       | Pokemon GO                   | NW Trails Improvement                      |
| ------------------ | ---------------------------- | ------------------------------------------ |
| Location check-in  | Generic PokeStops            | Curated landmarks with educational content |
| Achievement system | Overwhelming 100+ medals     | Focused, achievable badge collection       |
| Guided routes      | User-generated, game-focused | Curated walking tours with practical info  |

NW Trails takes proven engagement mechanics from the world's most successful location-based game and reimagines them for a focused, practical purpose: helping Douglas College students discover and connect with New Westminster.

---

## iv. Target Audience

### Primary Audience: Douglas College Students New to New Westminster

The primary target users of NW Trails are Douglas College students, particularly those who are new to the New Westminster area. This includes:

- **International students** who have recently arrived in Canada and are unfamiliar with the local area. These students often spend their first semester confined to campus and their residence, missing out on the vibrant community surrounding Douglas College.

- **Domestic students from other cities** who have moved to New Westminster for their studies and want to explore their new neighborhood but do not know where to start.

- **First-year students** looking for social activities beyond the classroom. NW Trails provides a low-pressure, self-paced way to explore the city — alone or with friends.

### Secondary Audience: Current Students Seeking Weekend Activities

Even students who have lived in New Westminster for a while may not have explored many of its landmarks. NW Trails serves as a weekend activity planner by offering:

- **Structured walking routes** that turn a casual walk into a guided exploration.
- **Gamification elements** (badges, leaderboard) that create motivation to visit places they have walked past but never entered.
- **Social competition** through the leaderboard, encouraging friend groups to compete on who can explore the most landmarks.

### User Needs

| User Need                                | How NW Trails Addresses It                                                           |
| ---------------------------------------- | ------------------------------------------------------------------------------------ |
| "I don't know what's around campus"      | Interactive map with 15 curated landmarks, each with descriptions and categories     |
| "I want something fun to do on weekends" | Guided walking routes with varying difficulty, gamified with badge rewards           |
| "I want to feel connected to this city"  | Educational landmark content about New Westminster's history, food, and culture      |
| "I want to do this with friends"         | Leaderboard, social sharing, community stats that encourage group exploration        |
| "I don't have a lot of time"             | Short routes (30-70 min), one-tap check-in (3 seconds), progress saves automatically |

### Why They Would Use NW Trails

Unlike generic tourism apps (Google Maps, TripAdvisor) that serve all travelers, NW Trails is specifically designed for Douglas College students exploring New Westminster. The curated landmarks are chosen for relevance to student life — affordable food spots, free parks, cultural venues with student discounts, and transit-accessible locations. The gamification layer transforms routine exploration into an engaging challenge, and the community leaderboard adds a social dimension that generic apps lack.

---

## v. Features

### Must-Have Features

#### Must-Have 1: Landmark Discovery & Map

> As a Douglas student new to New Westminster, I want to view a map showing curated landmarks around the city so that I can discover interesting places to visit nearby.

> As a user, I want to tap on a landmark pin on the map to see its details (name, description, photo, distance from me) so that I can decide whether to visit it.

> As a user, I want to filter landmarks by category (Historic, Nature, Food, Culture) so that I can find places that match my interests.

#### Must-Have 2: Location-Based Check-in

> As a user visiting a landmark, I want to check in when I am within 50 meters of the location so that my visit is verified and recorded.

> As a user, I want to optionally upload a photo when checking in so that I can keep a visual memory of my visit.

> As a user, I want to see my check-in history with dates and photos so that I can review all the places I have explored.

#### Must-Have 3: Achievement & Badge System

> As a user, I want to earn achievement badges (Bronze for 5 landmarks, Silver for 10, Gold for all 15) so that I feel motivated to explore more of New Westminster.

> As a user, I want to earn special themed badges (e.g., "History Buff" for visiting all historic sites, "Foodie Explorer" for visiting all food spots) so that I have additional goals to pursue.

> As a user, I want to view my achievement progress on a personal profile page so that I can track how close I am to earning the next badge.

#### Must-Have 4: Guided Walking Routes

> As a user who wants a structured exploration experience, I want to browse pre-set walking routes (e.g., "Historic Downtown Walk", "Waterfront Trail") so that I can follow a curated path through the city.

> As a user, I want to see each route's distance, estimated duration, and difficulty level so that I can choose a route that fits my schedule and fitness level.

> As a user on an active route, I want to see the next landmark in the route with navigation directions so that I can easily find my way.

### Nice-to-Have Features

#### Nice-to-Have 1: Social Sharing & Achievement Wall

> As a user, I want to view a personal "achievement wall" displaying all my badges and check-in highlights so that I can showcase my exploration journey.

> As a user, I want to share my achievements or check-ins to social media (Instagram, Twitter) so that I can let friends know about my New Westminster experiences.

#### Nice-to-Have 2: Community Leaderboard

> As a user, I want to see a leaderboard ranking all users by the number of landmarks visited so that I can compete with fellow students.

> As a user, I want to see a community exploration heatmap showing which landmarks are most popular so that I can discover trending spots.

#### Nice-to-Have 3: Landmark Reviews & Tips

> As a user who has checked in at a landmark, I want to leave a short review or tip (e.g., "Best visited at sunset", "Free parking nearby") so that other users benefit from my experience.

> As a user, I want to read reviews from other students before visiting a landmark so that I can plan my visit better.

---

## vi. Wireframes (5 Pages)

> Wireframes will be created in Figma by assigned members. Below is the detailed layout specification for each page.

### Page 1: Home / Map Screen

**Purpose**: Main screen showing the interactive map with all landmark pins.

**Layout (top to bottom):**

1. **AppBar**
   - Left: App name "NW Trails"
   - Right: User avatar icon (tap to go to Profile)

2. **Category Filter Bar** (horizontal scroll)
   - Chips: Historic (brown), Nature (green), Food (orange), Culture (purple)
   - Supports multi-select, selected chips are filled color, unselected are outlined

3. **Map Area** (~60% of screen)
   - Google Map centered on New Westminster
   - 15 landmark pins, color-coded by category
   - User's current location shown as blue dot
   - Tapping a pin highlights it and opens the bottom preview card

4. **Bottom Preview Card** (appears when a pin is tapped)
   - Landmark icon + name
   - Category tag + distance from user
   - Star rating + total check-in count
   - Tap card to navigate to Landmark Detail (Page 2)

5. **Bottom Navigation Bar** (4 tabs)
   - Map (active) | Check-in | Awards | Routes
   - Check-in tab is used for history/status review; new check-in actions are initiated from Landmark Detail

---

### Page 2: Landmark Detail + Check-in

**Purpose**: Show full landmark info and enable check-in.

**Layout (top to bottom):**

1. **AppBar**: Back button + Bookmark/favorite icon

2. **Image Carousel** (~200px height)
   - Landmark photos, swipeable
   - Dot indicator at bottom

3. **Info Section**
   - Landmark name (large, bold)
   - Category tag (colored chip)
   - Address with map pin icon
   - Distance from user
   - Total check-in count

4. **Description Section**
   - "About" header
   - 2-3 sentences about the landmark
   - Practical info: hours, tips

5. **Student Tips Section** (Nice-to-Have)
   - Header: "Tips from students"
   - Cards with tip text and username

6. **Action Buttons** (bottom, sticky)
   - Primary: "CHECK IN" — green if within 50m, gray if too far (shows distance)
   - Secondary: "GET DIRECTIONS" — opens native maps app
   - New check-in records are created only from this page's `CHECK IN` action

7. **Check-in Success Dialog** (popup after check-in)
   - Celebration animation/icon
   - Landmark name + date
   - Optional photo upload button + note button
   - Progress bar: "X/15 landmarks"
   - Next badge hint: "Next badge: Silver (10)"
   - "Done" button to dismiss

---

### Page 3: Achievements & Profile

**Purpose**: Personal profile showing badges, progress, and check-in history.

**Layout (top to bottom):**

1. **AppBar**: "My Explorer Profile"

2. **Profile Header**
   - User avatar (center)
   - Username
   - Progress text: "6/15 landmarks explored"
   - Progress bar (filled proportionally)

3. **Badges Section** — "Badges" header
   - **Row 1**: Tier badges in 3 cards
     - Bronze (5) — checkmark if earned, lock + progress if not
     - Silver (10) — same
     - Gold (15) — same
   - **Row 2**: Theme badges in 3 cards
     - History Buff (all historic sites)
     - Nature Lover (all nature spots)
     - Foodie Explorer (all food spots)
   - Earned badges: full color with checkmark
   - Locked badges: grayed out with "X/Y" progress

4. **Check-in History** — "Check-in History" header
   - Scrollable list, each item shows:
     - Category icon + landmark name
     - Date
     - Photo indicator icon if photo was uploaded
   - Sorted by most recent first

---

### Page 4: Routes Browser + Route Detail

**Purpose**: Browse and select walking routes; view route details.

**Page 4A — Routes List:**

1. **AppBar**: "Walking Routes"

2. **Difficulty Filter Tabs**: All | Easy | Medium | Hard

3. **Route Cards** (scrollable list), each card contains:
   - Route cover image/thumbnail
   - Route name (e.g., "Historic Downtown Walk")
   - Metadata: distance (km), duration (min), difficulty
   - Number of landmarks on this route
   - Personal completion progress bar for this route

4. **Bottom Navigation Bar**: Map | Check-in | Awards | Routes (active)

**Page 4B — Route Detail** (tap a route card):

1. **AppBar**: Route name + back button

2. **Mini Map** (~150px height)
   - Shows the route path as a line connecting landmarks
   - All landmark pins on the route visible

3. **Route Metadata Bar**
   - Distance | Duration | Difficulty (horizontal row with icons)

4. **Route Stops** (Timeline/Stepper layout)
   - Start point (filled circle)
   - Each landmark as a step:
     - Filled circle + checkmark if visited
     - Empty circle if not visited
     - Landmark name
     - Distance + walk time to next stop
   - End point (square icon)

5. **Action Button** (bottom, sticky)
   - "START THIS ROUTE" — primary color, full width

---

### Page 5: Community Leaderboard

**Purpose**: Show rankings, personal stats, and trending landmarks.

**Layout (top to bottom):**

1. **AppBar**: "Community Explorer"

2. **Tab Bar**: Leaderboard | Heatmap

3. **Leaderboard Tab:**
   - Header: "This Week's Top Explorers"
   - Top 3 with medal icons (gold/silver/bronze) and landmark count
   - Remaining users in plain list
   - Current user's row highlighted with arrow marker
   - Each row: rank + avatar + username + "X/15"

4. **Personal Stats Bar** (3 stat cards in a row)
   - Visited (number) | Badges (number) | Routes (number)

5. **Trending Landmarks Section**
   - Header: "Trending Landmarks"
   - List of top 3 most checked-in landmarks
   - Each item: rank + name + check-in count with people icon

---

### Wireframe Design Guidelines

| Element         | Specification                                                                                         |
| --------------- | ----------------------------------------------------------------------------------------------------- |
| Primary Color   | Deep Teal `#0D7377`                                                                                   |
| Accent Color    | Warm Orange `#FF6B35` (CTA buttons, check-in highlights)                                              |
| Background      | Light Gray `#F5F5F5`                                                                                  |
| Cards           | White `#FFFFFF` with subtle shadow, 12px border radius                                                |
| Category Colors | Historic: Brown `#8B6914`, Nature: Green `#2E7D32`, Food: Orange `#E65100`, Culture: Purple `#6A1B9A` |
| Typography      | Titles: Bold 18-20sp, Body: Regular 14-16sp, Caption: 12sp                                            |
| Icons           | Material Icons, rounded style                                                                         |
| Spacing         | 16px standard padding, 8px between cards                                                              |

---

### Wireframe Assignment

| Page                               | Assigned To            | Description                                      |
| ---------------------------------- | ---------------------- | ------------------------------------------------ |
| Page 1: Home / Map Screen          | Dong Zhang (Team Lead) | Main map with landmark pins and category filters |
| Page 2: Landmark Detail + Check-in | Dong Zhang (Team Lead) | Landmark info, photos, check-in flow             |
| Page 3: Achievements & Profile     | Dong Zhang (Team Lead) | Badges, progress, check-in history               |
| Page 4: Routes Browser + Detail    | Dong Zhang             | Route list, route detail with timeline           |
| Page 5: Community Leaderboard      | Dong Zhang (Team Lead) | Rankings, stats, trending landmarks              |

#### Interaction Prototyping Assignment

| Task                                | Assigned To | Description                                                                                                                               |
| ----------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Figma Prototype Interaction Linking | Zhi Kang    | Configure page-to-page click-through flow and validate the main sequence (Map -> Detail -> Check-in Success -> Profile, plus Routes flow) |

> Wireframes are created in **Figma** with a low-to-mid fidelity focus on UX flow clarity, navigation logic, and component consistency (visual polish is secondary in this phase).

---

## vii. Peer Evaluation Table

> **TODO**: Each member completes this table before final submission.

**Rubric:**

- **1 Point**: No or very little contribution; cannot deliver artifacts or largely miss deadlines; no passion.
- **2 Points**: Little contribution with no negative effect; sometimes misses deadlines; mainly follows others.
- **3 Points**: Fairly large and positive contribution; handles most tasks and delivers on time.
- **4 Points**: Large and positive contribution; helps others tackle problems; proactive and passionate.

| Evaluator \ Evaluatee | Diego Romero-Lovo De la Flor | Dong Zhang | Zhi Kang | Menghua Wang |
| --------------------- | ---------------------------- | ---------- | -------- | ------------ |
| **Diego**             | —                            | [ ]        | [ ]      | [ ]          |
| **Dong**              | [ ]                          | —          | [ ]      | [ ]          |
| **Zhi**               | [ ]                          | [ ]        | —        | [ ]          |
| **Menghua**           | [ ]                          | [ ]        | [ ]      | —            |

---

## Appendix A: Prototype Task Assignment

### Architecture Overview (Phase 1)

```
Phase 1: Client only (Flutter)
- All data hardcoded or stored locally
- No REST API calls yet
- Focus on UI, navigation, and core feature logic

Phase 2+ (Future):
Client (Flutter) --REST API--> Server (SpringBoot) ---> Database (MongoDB)
```

### Prototype Requirements Checklist

- [ ] Minimum Viable UI: Basic screens with navigation
- [ ] At least 3 core features (3 completed user stories)
- [ ] Use local data storage or hardcoded data

### Confirmed Task Assignment (Execution Plan)

| Member                           | Module                             | Must-Have Feature                      | Key Screens                                                       | Deliverables                                                                                                          |
| -------------------------------- | ---------------------------------- | -------------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Dong Zhang (Team Lead)**       | App Shell, Routes, Integration     | Must-Have 4 + cross-module integration | App shell, Routes list/detail, shared navigation                  | Bottom navigation architecture, routes workflow, module integration, final merge and release packaging                |
| **Diego Romero-Lovo De la Flor** | Map & Landmark Discovery           | Must-Have 1                            | Home/Map Screen, Landmark Detail                                  | Landmark data model, category filter chips, pin/preview interaction, detail page layout                               |
| **Zhi Kang**                     | Check-in + Figma Prototype Linking | Must-Have 2                            | Landmark Detail Check-in, Check-in History, Figma prototype links | Distance verification stub (within 50m simulation), check-in action and history list, Figma click-through flow wiring |
| **Menghua Wang**                 | Achievement & Profile              | Must-Have 3                            | Profile page, Badge display                                       | Bronze/Silver/Gold progress logic, themed badge states, profile progress bar and history section                      |

### Milestone and Handoff Schedule

| Timebox            | Owner(s)            | Target Output                                                                           |
| ------------------ | ------------------- | --------------------------------------------------------------------------------------- |
| Mar 1 night        | Dong + Zhi          | Complete wireframe frames and configure Figma interaction linking for primary user flow |
| Mar 2 morning      | Diego, Zhi, Menghua | Module code handoff to team lead and basic self-test completed                          |
| Mar 2 noon         | Dong + all          | Integration test pass: navigation + 3 core features demo flow                           |
| Mar 2 before 17:00 | Dong (submitter)    | Final package: `group06-proposal.docx` + `group06-app.zip` -> `group06-project01.zip`   |

### Shared Components (to be built collaboratively)

- Bottom Navigation Bar (4 tabs)
- Common AppBar style
- Landmark data model (hardcoded list of 15 landmarks)
- Color theme and constants file
- Category enum and color mapping

### 15 Curated Landmarks (Reference Data)

| #   | Name                       | Category | Coordinates (approx.) |
| --- | -------------------------- | -------- | --------------------- |
| 1   | Irving House               | Historic | 49.2077, -122.9128    |
| 2   | New Westminster Museum     | Historic | 49.2043, -122.9108    |
| 3   | City Hall                  | Historic | 49.2044, -122.9070    |
| 4   | Westminster Pier Park      | Historic | 49.2002, -122.9088    |
| 5   | Queens Park                | Nature   | 49.2134, -122.9026    |
| 6   | Fraser River Trail         | Nature   | 49.1980, -122.9150    |
| 7   | Hume Park                  | Nature   | 49.2170, -122.8920    |
| 8   | Tipperary Park             | Nature   | 49.2060, -122.9070    |
| 9   | River Market               | Food     | 49.2005, -122.9095    |
| 10  | Columbia Street Cafes      | Food     | 49.2045, -122.9100    |
| 11  | Steel & Oak Brewing        | Food     | 49.2010, -122.9055    |
| 12  | Anvil Centre               | Culture  | 49.2015, -122.9105    |
| 13  | Massey Theatre             | Culture  | 49.2132, -122.9030    |
| 14  | Douglas College (New West) | Culture  | 49.2048, -122.9120    |
| 15  | Samson V Maritime Museum   | Culture  | 49.2000, -122.9090    |

> **Note**: Coordinates are approximate. Verify with Google Maps before implementation.

### Pre-Set Walking Routes (Reference Data)

| Route Name             | Difficulty | Distance | Duration | Landmarks                 |
| ---------------------- | ---------- | -------- | -------- | ------------------------- |
| Historic Downtown Walk | Easy       | 2.5 km   | 45 min   | #1, #2, #3, #4, #12       |
| Waterfront Trail       | Medium     | 3.8 km   | 70 min   | #4, #6, #9, #11, #15, #12 |
| Food & Market Tour     | Easy       | 1.8 km   | 30 min   | #9, #10, #11, #14         |
| Queens Park & Beyond   | Medium     | 3.2 km   | 55 min   | #5, #7, #8, #13           |
| Complete New West      | Hard       | 6.5 km   | 120 min  | All 15 landmarks          |

---

## Appendix B: Submission Checklist

- [ ] Proposal document: `group06-proposal.docx`
- [ ] Flutter project zip: `group06-app.zip`
- [ ] Final package: `group06-project01.zip`
- [ ] All Student IDs filled in on Cover Page
- [ ] Peer Evaluation table completed by all members
- [ ] Wireframes (5 pages) included in proposal
- [ ] Only ONE member (team lead) submits to Blackboard

---

_Document prepared for Group 06 internal coordination. Convert to `.docx` for final submission._
