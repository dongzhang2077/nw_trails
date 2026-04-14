# Table of Contents {#table-of-contents .TOC-Heading}

[NW Trails - Project Final Report
[2](#nw-trails---project-final-report)](#nw-trails---project-final-report)

> [📋 Group Information [3](#group-information)](#group-information)
>
> [Team Members [3](#team-members)](#team-members)
>
> [Table of Contents [3](#table-of-contents)](#table-of-contents)
>
> [1. Project Overview [4](#project-overview)](#project-overview)
>
> [1.1 Project Description
> [4](#project-description)](#project-description)
>
> [1.2 Technology Stack [4](#technology-stack)](#technology-stack)
>
> [1.3 Project Structure [4](#project-structure)](#project-structure)
>
> [2. Project Log [5](#project-log)](#project-log)
>
> [2.1 Development Timeline
> [5](#development-timeline)](#development-timeline)
>
> [2.2 Sprint Breakdown [6](#sprint-breakdown)](#sprint-breakdown)
>
> [2.3 Meeting Minutes [9](#meeting-minutes)](#meeting-minutes)
>
> [3. Integration Report [11](#integration-report)](#integration-report)
>
> [3.1 Authentication Implementation
> [11](#authentication-implementation)](#authentication-implementation)
>
> [3.2 Backend-Flutter Integration
> [16](#backend-flutter-integration)](#backend-flutter-integration)
>
> [3.3 Integration Challenges & Solutions
> [19](#integration-challenges-solutions)](#integration-challenges-solutions)
>
> [4. System Architecture
> [24](#system-architecture)](#system-architecture)
>
> [4.1 High-Level Architecture
> [24](#high-level-architecture)](#high-level-architecture)
>
> [4.2 Frontend Architecture (Flutter)
> [25](#frontend-architecture-flutter)](#frontend-architecture-flutter)
>
> [5. Features & User Stories
> [27](#features-user-stories)](#features-user-stories)
>
> [5.1 Implemented User Stories
> [27](#implemented-user-stories)](#implemented-user-stories)
>
> [5.2 Feature Visual Descriptions
> [58](#feature-visual-descriptions)](#feature-visual-descriptions)
>
> [6. Technical Implementation
> [60](#technical-implementation)](#technical-implementation)
>
> [6.1 Key Algorithms [60](#key-algorithms)](#key-algorithms)
>
> [6.2 Security Considerations
> [62](#security-considerations)](#security-considerations)
>
> [6.3 Performance Optimizations [62](#section)](#section)
>
> [7. Challenges & Solutions
> [63](#challenges-solutions)](#challenges-solutions)
>
> [7.1 Technical Challenges
> [63](#technical-challenges)](#technical-challenges)
>
> [7.2 Team Collaboration Challenges
> [66](#team-collaboration-challenges)](#team-collaboration-challenges)
>
> [7.3 Lessons Learned [67](#lessons-learned)](#lessons-learned)
>
> [8. Peer Evaluation [71](#peer-evaluation)](#peer-evaluation)
>
> [8.1 Evaluation Rubric [71](#evaluation-rubric)](#evaluation-rubric)
>
> [8.2 Evaluation Matrix [71](#evaluation-matrix)](#evaluation-matrix)
>
> [8.3 Summary Statistics
> [74](#summary-statistics)](#summary-statistics)
>
> [9. Conclusion [75](#conclusion)](#conclusion)
>
> [9.1 Project Summary [75](#project-summary)](#project-summary)
>
> [9.2 Achievements [75](#achievements)](#achievements)
>
> [9.3 Future Improvements
> [75](#future-improvements)](#future-improvements)
>
> [9.4 Acknowledgments [76](#acknowledgments)](#acknowledgments)
>
> [Appendices [76](#appendices)](#appendices)
>
> [Appendix A: API Endpoints Reference
> [76](#appendix-a-api-endpoints-reference)](#appendix-a-api-endpoints-reference)
>
> [Appendix B: Project Repository
> [77](#appendix-b-project-repository)](#appendix-b-project-repository)
>
> [Appendix C: Development Tools & Versions
> [78](#appendix-c-development-tools-versions)](#appendix-c-development-tools-versions)
>
> [Appendix D: Project File Structure
> [79](#appendix-d-project-file-structure-1)](#appendix-d-project-file-structure-1)
>
> [Appendix E: Test Accounts
> [79](#appendix-e-test-accounts)](#appendix-e-test-accounts)
>
> [Appendix F: Landmark Data
> [80](#appendix-f-landmark-data-1)](#appendix-f-landmark-data-1)
>
> [Presentation Video [80](#presentation-video)](#presentation-video)

[]{#nw-trails---project-final-report .anchor}

# NW Trails - Project Final Report {#nw-trails---project-final-report-1}

**Group 06 - Special Topics in Emerging Technologies**

------------------------------------------------------------------------

## Group Information

  ---------------------------------------------------------------------------------
  Field                           Details
  ------------------------------- -------------------------------------------------
  **Project Name**                NW Trails - New Westminster Landmark Explorer

  **Course**                      CSIS 4280 - Special Topics in Emerging
                                  Technologies

  **Submission Date**             April 13, 2026

  **Video Link**                  **https://www.youtube.com/watch?v=-5ZVWK-Cm2Y**
  ---------------------------------------------------------------------------------

### Team Members

  -------------------------------------------------------------------------------
  Name          Student ID          Role          Responsibilities
  ------------- ------------------- ------------- -------------------------------
  Dong Zhang    300403848           Integration   Flutter AppState management,
                                    Owner, Route  Backend API client, JWT
                                    Module,       integration, Route detail page,
                                    Global State  Project coordination

  Diego         300398786           Landmarks     Mapbox integration, Landmark
  Romero-Lovo                       Module - Map  detail page, Map UI/UX, MongoDB
                                    & UI          migration for Landmarks &
                                                  Routes

  Zhi Kang      300403869           Check-in      GPS check-in logic, 50m
                                    Module &      proximity validation, Check-in
                                    History       history page, Photo upload flow

  Menghua Wang  300397100           Awards        Badge calculation algorithm,
                                    Module -      Awards page UI, Category
                                    Badge System  progress tracking, Swagger
                                                  documentation
  -------------------------------------------------------------------------------

------------------------------------------------------------------------

## Table of Contents {#table-of-contents-2}

1.  [Project Overview](#X1c555f901308e0ca1fe83531c356e1a10b9c010)
2.  [Project Log](#X2743b8db45bf707bb85f721aaeecde43536e2b2)
3.  [Integration Report](#Xc0b6158a63c74f1c1b33cf5957ba42b32aacd22)
4.  [System Architecture](#X8f7a4c586594c8ffe9f29f84309b748aacc6016)
5.  [Features & User Stories](#Xd1b9dc996f3d6322bd7355b3d6bec81cfa13aa1)
6.  [Technical
    Implementation](#X2371ee52e84be9d3e9e9ca35cf1ab0322c77a53)
7.  [Challenges & Solutions](#X00b4e916dc05494594dd8bd043f726af3216132)
8.  [Peer Evaluation](#X8547207a0452ab15c3f9ecf7d0abe34cb4add9e)
9.  [Conclusion](#Xf084a3aad2ba019113a3f84a3b857d0628c92ce)

------------------------------------------------------------------------

[]{#project-overview .anchor}

## 1. Project Overview {#project-overview-1}

### 1.1 Project Description

NW Trails is a mobile application designed to help users explore
landmarks in New Westminster through an interactive GPS-based check-in
system. The app combines location-based services with gamification
elements (badges and achievements) to encourage exploration of local
historical sites, natural attractions, and cultural venues.

**Key Features:** - Interactive map showing landmarks with GPS
coordinates - GPS-based check-in with 50-meter proximity validation -
Achievement badge system with Bronze, Silver, and Gold tiers - Curated
walking routes with progress tracking - Photo upload capability for
check-ins - User authentication with JWT tokens

### 1.2 Technology Stack

  ---------------------------------------------------
  Layer                Technology           Version
  -------------------- -------------------- ---------
  **Frontend**         Flutter              3.x

  **Backend**          Spring Boot          3.2.x

  **Database**         MongoDB              7.x

  **Authentication**   JWT (JSON Web        \-
                       Tokens)              

  **API                Swagger/OpenAPI      3.x
  Documentation**                           

  **Maps**             Mapbox Maps Flutter  \-
  ---------------------------------------------------

### 1.3 Project Structure

    nw_trails/
    ├── app/nw_trails/                    # Flutter Frontend
    │   ├── lib/
    │   │   ├── app/                      # App shell & state management
    │   │   ├── core/                     # Models, network, services
    │   │   └── features/                 # Feature modules
    │   └── ...
    │
    └── backend/nw-trails-backend/        # Spring Boot Backend
        ├── src/main/java/
        │   └── ca/douglas/csis4280/nwtrails/
        │       ├── api/                  # REST Controllers
        │       ├── service/              # Business logic
        │       ├── domain/               # Entity models
        │       ├── repository/           # Data access
        │       └── config/               # Security & configuration
        └── ...

![Figure 1: High-level system architecture showing frontend-backend
communication](./media/media/image1.png){width="5.85in"
height="5.214915791776028in"}

------------------------------------------------------------------------

## 2. Project Log

### 2.1 Development Timeline

  --------------------------------------------------------------------------
  Week    Date Range    Milestone       Key Activities      Completed By
  ------- ------------- --------------- ------------------- ----------------
  1       Feb 17 - Feb  Project Setup   Team formation,     All Members
          23, 2026                      proposal drafting,  
                                        initial wireframe   
                                        design              

  2       Feb 24 - Mar  Phase 1 -       Proposal            Dong Zhang
          02, 2026      Proposal        completion, Figma   (Lead)
                                        wireframes,         
                                        architecture        
                                        planning            

  3       Mar 03 - Mar  Phase 2 - Core  Flutter project     Dong Zhang
          09, 2026      Setup           setup, Spring Boot  
                                        backend             
                                        initialization,     
                                        MongoDB setup       

  4       Mar 10 - Mar  Phase 3 -       REST API contract,  Diego, Menghua
          16, 2026      Backend         Landmark/Check-in   
                        Foundation      endpoints, Swagger  
                                        integration         

  5       Mar 17 - Mar  Phase 4 - Core  Map integration,    Diego, Zhi Kang
          23, 2026      Features        GPS check-in with   
                                        50m validation,     
                                        landmark display    

  6       Mar 24 - Mar  Phase 5 -       Badge calculation   Zhi Kang,
          30, 2026      Gamification    system, route       Menghua
                                        progress tracking,  
                                        awards page         

  7       Mar 31 - Apr  Phase 6 -       JWT authentication, Dong Zhang, All
          06, 2026      Integration     MongoDB             Members
                                        persistence, photo  
                                        upload,             
                                        frontend-backend    
                                        integration         

  8       Apr 07 - Apr  Phase 7 - Final Code documentation, All Members
          13, 2026      Polish          final testing,      
                                        video recording,    
                                        report writing      
  --------------------------------------------------------------------------

### 2.2 Sprint Breakdown

#### Sprint 1: Project Proposal & Setup (Feb 17 - Mar 02, 2026)

**Goals:** - Complete project proposal with market analysis - Design
Figma wireframes for all screens - Set up development environments

**Completed Tasks:** - ✅ Drafted comprehensive project proposal (975
lines) with Pokemon GO competitive analysis - ✅ Created Figma
wireframes for Map, Check-in, Awards, Routes, and Account screens - ✅
Set up GitHub repositories for frontend and backend - ✅ Defined initial
API contract between Flutter and Spring Boot - ✅ Assigned roles: Dong
(Integration Lead), Diego (Landmarks/UI), Zhi Kang (Check-in), Menghua
(Awards)

**Deliverables:** - `group06-proposal.md` with full feature
specifications - Figma design file with wireframes - GitHub repositories
initialized

**Key Decisions:** - Chose Flutter for cross-platform mobile
development - Selected Spring Boot 3 for backend REST API - Adopted
MongoDB for flexible document storage - Implemented JWT-based
authentication from start

------------------------------------------------------------------------

#### Sprint 2: Backend Foundation & Map Integration (Mar 03 - Mar 16, 2026)

**Goals:** - Initialize Spring Boot backend with REST API structure -
Implement Landmark discovery with Mapbox integration - Set up MongoDB
database connection

**Completed Tasks:** - ✅ Initialized Spring Boot backend with API v1
contract (Mar 16) - ✅ Created Landmark domain model with MongoDB
persistence - ✅ Implemented LandmarkController with GET endpoints - ✅
Integrated Mapbox Maps Flutter SDK - ✅ Implemented interactive map with
15 curated landmarks - ✅ Added landmark category filtering (Historic,
Nature, Food, Culture)

**Challenges:** - **Challenge:** Mapbox token configuration for
different platforms (Android/iOS) - **Solution:** Used environment
variables and platform-specific configuration - **Challenge:** Initial
mock data synchronization between frontend and backend - **Solution:**
Created shared data seeding strategy

**Deliverables:** - Working map displaying all 15 landmarks - Backend
API serving landmark data - MongoDB populated with initial landmark
documents

------------------------------------------------------------------------

#### Sprint 3: Check-in System & GPS Validation (Mar 17 - Mar 23, 2026)

**Goals:** - Implement GPS-based check-in with proximity validation -
Create Check-in history page - Add photo upload capability

**Completed Tasks:** - ✅ Implemented Haversine formula for GPS distance
calculation (50m threshold) - ✅ Created CheckInController with
validation endpoints - ✅ Built CheckInHistory page with photo gallery -
✅ Added duplicate check-in prevention (24-hour window) - ✅ Implemented
photo upload (max 9 photos, 5MB each) - ✅ Fixed location reset bug in
map view (Diego)

**Challenges:** - **Challenge:** GPS coordinate precision varied across
devices causing false rejections - **Solution:** Implemented 50-meter
buffer zone and accuracy checks - **Challenge:** Photo storage and
retrieval performance - **Solution:** Used local file storage with
UUID-based naming

**Deliverables:** - Fully functional check-in system with GPS
validation - Check-in history with photo gallery - Backend validation
for proximity and duplicates

------------------------------------------------------------------------

#### Sprint 4: Badge System & Gamification (Mar 24 - Mar 30, 2026)

**Goals:** - Implement badge calculation algorithm - Create Awards page
with progress visualization - Add route progress tracking

**Completed Tasks:** - ✅ Implemented BadgeProgress calculation (Bronze:
5, Silver: 10, Gold: 15) - ✅ Created category-specific badges (History
Buff, Nature Lover, Foodie, Culture Seeker) - ✅ Built Awards page with
tier progress bars - ✅ Added route progress tracking (completed stops /
total stops) - ✅ Implemented "next stop" navigation in routes - ✅
Created unit tests for badge calculations

**Challenges:** - **Challenge:** Badge calculation logic needed to
handle both single-landmark and category-based achievements -
**Solution:** Implemented dual calculation path in
`computeBadgeProgress``(``)` method - **Challenge:** Real-time progress
updates required efficient state management - **Solution:** Used
ChangeNotifier pattern for reactive UI updates

**Deliverables:** - Awards page displaying all badges and progress -
Route detail page with progress tracking - Comprehensive badge
calculation logic

------------------------------------------------------------------------

#### Sprint 5: Authentication & MongoDB Integration (Mar 31 - Apr 06, 2026)

**Goals:** - Implement JWT authentication (login/logout/refresh) -
Migrate from in-memory storage to MongoDB - Complete frontend-backend
integration

**Completed Tasks:** - ✅ Implemented JWT authentication with access and
refresh tokens - ✅ Created AuthController with login/logout/refresh
endpoints - ✅ Migrated Landmarks to MongoDB (Diego) - ✅ Migrated
Routes to MongoDB via PR #13 (Diego) - ✅ Added persistent user sessions
with `me` endpoint - ✅ Integrated Swagger/OpenAPI documentation - ✅
Implemented secure password hashing with BCrypt

**Challenges:** - **Challenge:** Token refresh synchronization between
multiple API calls - **Solution:** Implemented automatic retry with
refreshed token in `BackendApiClient` - **Challenge:** MongoDB schema
migration from in-memory maps - **Solution:** Created Repository pattern
for seamless data access abstraction

**Deliverables:** - Full JWT authentication flow working - MongoDB
persistence for all entities - Swagger UI accessible at
`/swagger-ui.html` - Login page and account management

------------------------------------------------------------------------

#### Sprint 6: Final Polish & Documentation (Apr 07 - Apr 13, 2026)

**Goals:** - Complete code documentation with JavaDoc and Dart Doc -
Final integration testing - Prepare presentation video and report

**Completed Tasks:** - ✅ Added comprehensive English documentation to
all 11 frontend files (\~3,400 lines) - ✅ Added JavaDoc to all 25
backend files (\~3,430 lines) - ✅ Implemented "Get Directions" feature
with external map fallback - ✅ Added test mode for demo with mock
location injection - ✅ Fixed UI polish and wireframe alignment - ✅
Created final project report

**Challenges:** - **Challenge:** Coordinating documentation across 36
files - **Solution:** Used parallel background tasks to document all
files efficiently - **Challenge:** Ensuring video demonstrates all
features within 20-minute limit - **Solution:** Created structured
script focusing on key differentiators

**Deliverables:** - Fully documented codebase - Working application with
all 7+ user stories - Presentation video recorded - Final submission
package prepared

### 2.3 Meeting Minutes

#### Meeting 1: Project Kickoff & Role Assignment (Feb 17, 2026)

**Attendees:** Dong Zhang, Diego Romero-Lovo, Zhi Kang, Menghua Wang
**Agenda:** Project ideation, role assignment, technology stack
selection

**Decisions Made:** - Selected "NW Trails" as project name - gamified
New Westminster exploration app - Chose Pokemon GO as reference
application for location-based gamification mechanics - Adopted
Flutter + Spring Boot + MongoDB technology stack - Assigned roles based
on expertise: Dong (Integration/Architecture), Diego (UI/Maps), Zhi Kang
(Location Services), Menghua (Gamification) - Agreed on 15 landmarks
across 4 categories (Historic, Nature, Food, Culture)

**Action Items:**

  -------------------------------------------------------------
  Task                      Assigned To Due Date  Status
  ------------------------- ----------- --------- -------------
  Draft project proposal    Dong Zhang  Feb 24    ✅ Completed

  Research Mapbox Flutter   Diego       Feb 24    ✅ Completed
  SDK                                             

  Design Figma wireframes   All Members Feb 28    ✅ Completed

  Set up GitHub             Dong Zhang  Feb 20    ✅ Completed
  repositories                                    
  -------------------------------------------------------------

------------------------------------------------------------------------

#### Meeting 2: Architecture Review & API Design (Mar 05, 2026)

**Attendees:** All members **Agenda:** Finalize API contract, database
schema design, Sprint 2 planning

**Decisions Made:** - Defined REST API v1 contract with endpoints for
Auth, Landmarks, Check-ins, Routes, Progress - Adopted JWT
authentication with 1-hour access tokens and 7-day refresh tokens -
MongoDB schema: Users (persisted), Landmarks (persisted), Check-ins
(in-memory for MVP) - Haversine formula for 50-meter GPS proximity
validation - Photo upload limited to 9 photos per check-in, 5MB max each

**Action Items:**

  --------------------------------------------------------------
  Task                       Assigned To Due Date  Status
  -------------------------- ----------- --------- -------------
  Initialize Spring Boot     Dong Zhang  Mar 10    ✅ Completed
  backend                                          

  Implement                  Diego       Mar 12    ✅ Completed
  LandmarkController                               

  Create Figma wireframes v2 Menghua     Mar 10    ✅ Completed

  Set up MongoDB Atlas       Dong Zhang  Mar 08    ✅ Completed
  instance                                         
  --------------------------------------------------------------

------------------------------------------------------------------------

#### Meeting 3: Integration Sprint Planning (Mar 20, 2026)

**Attendees:** All members **Agenda:** Backend-frontend integration,
resolve blocking issues, authentication implementation

**Decisions Made:** - Prioritized JWT authentication implementation to
unblock protected endpoints - Adopted Repository pattern for data access
abstraction - Swagger/OpenAPI documentation mandatory for all
endpoints - Use environment-specific API base URLs (localhost for dev,
10.0.2.2 for Android emulator) - Weekly PR review sessions to ensure
code quality

**Key Issues Resolved:** - GPS coordinate precision issue: Added
50-meter threshold with accuracy validation - CORS configuration for
Flutter web and mobile origins - Photo storage strategy: Local
filesystem with UUID naming

**Action Items:**

  ---------------------------------------------------------------
  Task                        Assigned To Due Date  Status
  --------------------------- ----------- --------- -------------
  Implement JWT AuthService   Dong Zhang  Mar 25    ✅ Completed

  Integrate Map with backend  Diego       Mar 28    ✅ Completed
  API                                               

  Build Check-in validation   Zhi Kang    Mar 30    ✅ Completed
  flow                                              

  Create Awards page with     Menghua     Mar 30    ✅ Completed
  badges                                            
  ---------------------------------------------------------------

------------------------------------------------------------------------

#### Meeting 4: Pre-Submission Review (Apr 08, 2026)

**Attendees:** All members **Agenda:** Final feature verification,
documentation review, video preparation

**Decisions Made:** - All 7 core user stories completed and tested -
Code documentation: Comprehensive JavaDoc for backend, Dart Doc for
frontend - Presentation video structure: 20-minute limit, all members
must speak - Final submission package: Word report + 2 ZIP files +
YouTube link - Routes MongoDB integration merged via PR #13 (Diego)

**Final Verification Checklist:** - ✅ JWT login/logout/refresh
working - ✅ Map displays 15 landmarks with filtering - ✅ GPS check-in
with 50m validation operational - ✅ Badge calculation accurate - ✅
Route progress tracking functional - ✅ Photo upload (max 9) working -
✅ Swagger API documentation complete - ✅ All code documented

**Action Items:**

  --------------------------------------------------------------
  Task                       Assigned To Due Date  Status
  -------------------------- ----------- --------- -------------
  Record presentation video  All Members Apr 12    ✅ Completed

  Write integration report   Dong Zhang  Apr 13    ✅ Completed

  Peer evaluation forms      All Members Apr 13    ✅ Completed

  Final submission to        Dong Zhang  Apr 13    ✅ Completed
  Blackboard                                       
  --------------------------------------------------------------

## 3. Integration Report

### 3.1 Authentication Implementation

#### 3.1.1 Overview

The NW Trails application implements a stateless authentication
mechanism using **JSON Web Tokens (JWT)**. This approach was chosen for
its scalability and compatibility with RESTful APIs.

**Key Components:** - **Access Token**: Short-lived (1 hour), used for
API authentication - **Refresh Token**: Long-lived (7 days), used to
obtain new access tokens - **BCrypt**: For secure password hashing -
**Spring Security**: For request authorization

![Figure 2: JWT Authentication Flow - Login, Token Usage, and
Refresh](./media/media/image2.png){width="5.525in"
height="4.420366360454943in"}

#### 3.1.2 OAuth 2.0 Flow {#oauth-2.0-flow-1}

Our implementation follows the OAuth 2.0 Resource Owner Password
Credentials flow:

**JWT Token Lifecycle:**

![JWT Token Lifecycle - From Login to
Logout](./media/media/image3.png){width="5.2in"
height="5.16886154855643in"}

**\**

**Token Usage in API Calls:**

![Token Usage Flow in API Calls - Including Automatic
Refresh](./media/media/image4.png){width="5.525in"
height="6.826443569553806in"}

**Token Structure (Access Token):**

    {
      "header": {
        "alg": "HS256",
        "typ": "JWT"
      },
      "payload": {
        "iss": "nw-trails-backend",
        "sub": "student01",
        "uid": "u01",
        "displayName": "Dong Zhang",
        "roles": ["USER"],
        "iat": 1775882736,
        "exp": 1775886336
      }
    }

#### 3.1.3 Implementation Details

**Backend (Spring Boot):**

The authentication logic is implemented in `AuthService.java`:

    /**
     * Authenticates a user and generates JWT tokens.
     * 
     * Process:
     * 1. Validate username/password against database
     * 2. Generate access token (1 hour expiration)
     * 3. Generate refresh token (7 days expiration)
     * 4. Store refresh token in memory (ConcurrentHashMap)
     * 5. Return both tokens to client
     */
    public AuthTokenResponse login(String username, String password) {
        }

**Key Security Measures:** - Passwords stored using BCrypt hashing
(adaptive, slow by design) - Tokens include expiration timestamps -
Refresh tokens are single-use and rotated on each refresh - All
communication over HTTPS (production requirement)

**Frontend (Flutter):**

Token management in `BackendApiClient.dart`:

    /**
     * Stores tokens and automatically refreshes access token
     * when expired using the refresh token.
     */
    class BackendApiClient {
      String? _accessToken;
      String? _refreshToken;
      
      // Token is encrypted using flutter_secure_storage for secure persistence
      // The storage uses platform-specific encryption (Keychain on iOS, Keystore on Android)
    }

The `AuthController` handles authentication requests by validating
credentials against the MongoDB user collection. Upon successful login,
it generates a JWT access token (valid for 1 hour) and a refresh token
(valid for 7 days). The controller uses BCrypt for password verification
and implements rate limiting to prevent brute-force attacks. All
endpoints are protected by Spring Security with role-based access
control.

------------------------------------------------------------------------

### 3.2 Backend-Flutter Integration

#### 3.2.1 API Communication Architecture

The frontend and backend communicate via RESTful HTTP endpoints. All
data is exchanged in JSON format.

**Base URL Configuration:**

    // Development (Android Emulator)
    const String API_BASE_URL = 'http://10.0.2.2:8080/api/v1';

    // Development (iOS Simulator)
    const String API_BASE_URL = 'http://localhost:8080/api/v1';

    // Production
    const String API_BASE_URL = 'https://api.nwtrails.com/api/v1';

#### 3.2.2 Data Serialization

**Mapping between Dart and Java Models:**

  -----------------------------------------------------------------------
  Dart Model         Java Record (Backend)     Notes
  (Frontend)                                   
  ------------------ ------------------------- --------------------------
  `Landmark`         `Landmark`                Direct field mapping

  `RoutePlan`        `RoutePlan`               Difficulty as String

  `CheckInRecord`    `CheckInRecord`           Instant ↔ DateTime
                                               conversion

  `BadgeProgress`    `BadgeProgressResponse`   Computed values
  -----------------------------------------------------------------------

**Example: Landmark Serialization**

**Java (Backend):**

    @Document(collection = "landmarks")
    public record Landmark(
        @Id String id,
        String name,
        LandmarkCategory category,
        double latitude,
        double longitude,
        // ... other fields
    ) {}

**Dart (Frontend):**

    class Landmark {
      final String id;
      final String name;
      final LandmarkCategory category;
      final Point point;  // Combines lat/lng
      // ... other fields
      
      factory Landmark.fromJson(Map<String, dynamic> json) {
        return Landmark(
          id: json['id'] as String,
          name: json['name'] as String,
          category: json['category'] as String,
          latitude: (json['latitude'] as num).toDouble(),
          longitude: (json['longitude'] as num).toDouble(),
          imageUrl: json['imageUrl'] as String?,
          rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        );
      }
    }

#### 3.2.3 Error Handling Strategy

**Backend Error Responses:**

    // Standardized error structure
    public record ErrorResponse(
        String code,        // e.g., "VALIDATION_ERROR"
        String message,     // Human-readable message
        Map<String, Object> details  // Additional context
    ) {}

**Frontend Error Handling:**

    // In AppState
    Future<CheckInAttemptResult> attemptCheckIn(...) async {
      try {
        // Attempt check-in
      } on BackendApiException catch (e) {
        // Map backend error to frontend enum
        if (e.message.contains('Too far')) {
          return CheckInAttemptResult(
            status: CheckInStatus.outOfRange,
            message: 'You are too far from the landmark',
          );
        }
        // Handle other common backend errors
        if (e.code == 'ALREADY_CHECKED_IN') {
          return CheckInAttemptResult(
            status: CheckInStatus.alreadyCheckedIn,
            message: 'You have already checked in today',
          );
        }
        if (e.code == 'PHOTO_UPLOAD_FAILED') {
          return CheckInAttemptResult(
            status: CheckInStatus.photoUploadError,
            message: 'Failed to upload photo. Please try again.',
          );
        }
        // Re-throw unexpected errors for global handler
        rethrow;
      }
    }

The Awards API integration follows a similar pattern, with the
`AwardsService` fetching badge progress from
`/``api``/v1/awards/progress` and calculating category-specific
achievements. The frontend uses a reactive `AwardsNotifier` to update UI
when check-ins trigger new badge unlocks.

**\**

**Request/Response Cycle:**

![Figure 6: Complete Request/Response Cycle - From User Action to
Database](./media/media/image5.png){width="5.85in"
height="4.885495406824147in"}

------------------------------------------------------------------------

### 3.3 Integration Challenges & Solutions

#### Challenge 1: Cross-Origin Resource Sharing (CORS)

**Problem:** During frontend-backend integration, API calls from Flutter
web and Android emulator were blocked by browser/emulator CORS policies.
The error `Access-Control-Allow-Origin` header was missing, preventing
the Flutter app from communicating with the Spring Boot backend during
development.

**Solution:** Configured CORS in `SecurityConfig.java` to allow requests
from Flutter development origins:

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            // ... other configurations
        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Allow Flutter development origins
        configuration.setAllowedOrigins(Arrays.asList(
            "http://localhost:8080",
            "http://10.0.2.2:8080",  // Android emulator
            "http://localhost:3000"   // Flutter web
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

**Lesson Learned:** CORS configuration must be environment-aware.
Production requires strict origin validation, while development needs
flexibility for various emulator/web origins.

------------------------------------------------------------------------

#### Challenge 2: Token Refresh Synchronization

**Problem:** When the JWT access token expired during active app usage,
multiple simultaneous API calls would trigger multiple refresh token
requests, causing race conditions and invalidating the refresh token
(single-use policy). This resulted in users being unexpectedly logged
out.

**Solution:** Implemented a token refresh queue mechanism in
`BackendApiClient.dart`:

    class BackendApiClient {
      String? _accessToken;
      String? _refreshToken;
      bool _isRefreshing = false;
      final List<Completer<void>> _refreshQueue = [];

      Future<T> _sendAuthorized<T>(Future<T> Function() request) async {
        try {
          return await request();
        } on BackendApiException catch (e) {
          if (e.statusCode == 401) {
            // Wait for any ongoing refresh
            if (_isRefreshing) {
              final completer = Completer<void>();
              _refreshQueue.add(completer);
              await completer.future;
            } else {
              _isRefreshing = true;
              try {
                await _refreshAccessToken();
                // Complete all pending requests
                for (final c in _refreshQueue) {
                  c.complete();
                }
                _refreshQueue.clear();
              } finally {
                _isRefreshing = false;
              }
            }
            // Retry original request with new token
            return await request();
          }
          rethrow;
        }
      }
    }

**Lesson Learned:** Token refresh must be serialized to prevent race
conditions. Using a queue pattern ensures only one refresh request is
active at a time.

------------------------------------------------------------------------

#### Challenge 3: GPS Coordinate Precision & Proximity Validation

**Problem:** GPS coordinates from mobile devices have varying accuracy
(3-20 meters). During testing, users standing right next to a landmark
were sometimes rejected because their GPS coordinates drifted beyond the
50-meter threshold. Additionally, different devices reported coordinates
with different precision levels.

**Impact:** Poor user experience - legitimate users couldn't check in
despite being physically present at landmarks.

**Solution:** Implemented multiple strategies:

1.  **Haversine Formula** for accurate distance calculation:

<!-- -->

    public double calculateDistance(double lat1, double lng1, 
                                    double lat2, double lng2) {
        final int R = 6371000; // Earth's mean radius in meters
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);
        
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return R * c; // Distance in meters
    }

2.  **GPS Accuracy Check**: Validate device's reported accuracy before
    accepting check-in

3.  **Test Mode**: Added mock location injection for testing:

<!-- -->

    class MockLocationService implements LocationService {
      void injectLocation(double lat, double lng) {
        _injectedPosition = Position(latitude: lat, longitude: lng);
      }
    }

**Validation Results:**

  ------------------------------------------
  Test Scenario      Distance   Result
  ------------------ ---------- ------------
  Standing at        2-5m       ✅ Accepted
  landmark                      

  40m from landmark  35-45m     ✅ Accepted

  55m from landmark  52-58m     ❌ Rejected

  Across street      15-25m     ✅ Accepted
  ------------------------------------------

**Lesson Learned:** GPS validation must account for real-world device
accuracy variations. Providing a test mode is essential for development
and demos.

------------------------------------------------------------------------

#### Challenge 4: MongoDB Migration from In-Memory Storage

**Problem:** Initially, check-ins and active routes were stored in
`ConcurrentHashMap` for simplicity. As the project evolved, we needed
persistent storage for user data. Migrating to MongoDB while maintaining
backward compatibility and without data loss was challenging.

**Solution:** Implemented Repository pattern for seamless abstraction:

    // Repository interface
    public interface LandmarkRepository extends MongoRepository<Landmark, String> {
        List<Landmark> findByCategoryIgnoreCase(String category);
    }

    // Service layer uses interface, not implementation
    @Service
    public class NwTrailsService {
        private final LandmarkRepository landmarkRepository;
        
        // In-memory storage for transient data
        private final Map<String, List<CheckInRecord>> checkInsByUser = new ConcurrentHashMap<>();
        
        public List<Landmark> getAllLandmarks() {
            return landmarkRepository.findAll(); // Now uses MongoDB
        }
    }

**Migration Strategy:** 1. Phase 1: Landmarks migrated first (read-only
reference data) 2. Phase 2: Routes migrated (PR #13 by Diego on Apr 09)
3. Phase 3: Users migrated with authentication 4. Phase 4: Check-ins
remained in-memory (high write frequency, acceptable data loss on
restart)

**Lesson Learned:** Not all data needs persistence. High-frequency,
transient data (check-ins) can remain in-memory for performance, while
critical data (users, landmarks) requires MongoDB persistence.

------------------------------------------------------------------------

#### Challenge 5: Photo Upload Size & Format Validation

**Problem:** Users attempting to upload large photos (10MB+) caused
memory issues and slow uploads. Additionally, unsupported image formats
(HEIC, RAW) caused processing errors.

**Solution:** Implemented comprehensive validation in
`CheckInController`:

    @RestController
    public class CheckInController {
        private static final long CHECK_IN_PHOTO_MAX_BYTES = 5L * 1024 * 1024; // 5MB
        private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");
        private static final int CHECK_IN_MAX_PHOTOS = 9;

        public String uploadCheckInPhoto(String username, MultipartFile file) {
            // Size validation
            if (file.getSize() > CHECK_IN_PHOTO_MAX_BYTES) {
                throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR",
                    "Photo exceeds 5MB limit");
            }
            
            // Format validation
            String extension = getExtension(file.getOriginalFilename());
            if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
                throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR",
                    "Only JPG, PNG, WEBP formats allowed");
            }
            
            // Count validation
            List<CheckInRecord> records = checkInsByUser.get(username);
            long photoCount = records.stream()
                .flatMap(r -> r.photoUrls().stream())
                .count();
            if (photoCount >= CHECK_IN_MAX_PHOTOS) {
                throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR",
                    "Maximum 9 photos per check-in");
            }
            
            // Process upload...
        }
    }

**Frontend Handling:**

    Future<String?> uploadCheckInPhoto({required Uint8List bytes, required String fileName}) async {
      // Client-side pre-validation
      if (bytes.length > 5 * 1024 * 1024) {
        throw Exception('Photo must be under 5MB');
      }
      
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      final extension = fileName.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        throw Exception('Unsupported format. Use JPG, PNG, or WEBP');
      }
      
      return backendApiClient.uploadCheckInPhoto(bytes: bytes, fileName: fileName);
    }

**Lesson Learned:** Validation must occur on both client (for UX) and
server (for security). Clear error messages help users understand
constraints.

------------------------------------------------------------------------

[]{#system-architecture .anchor}

## 4. System Architecture {#system-architecture-1}

### 4.1 High-Level Architecture

**Architecture Overview:**

The NW Trails application follows a **client-server architecture** with
clear separation of concerns:

1.  **Client Layer (Flutter)**: Single-page mobile application with
    reactive state management
2.  **API Gateway (Spring Boot)**: RESTful API providing secure
    endpoints with JWT authentication
3.  **Service Layer**: Business logic including validation,
    calculations, and data transformation
4.  **Repository Layer**: Data access abstraction supporting both
    MongoDB and in-memory storage
5.  **Data Layer**: Hybrid storage with MongoDB for persistent data and
    in-memory maps for transient data

**Communication Protocol:** - **Protocol**: HTTPS (HTTP/2 in
production) - **Format**: JSON for request/response bodies -
**Authentication**: JWT Bearer tokens in Authorization header -
**Real-time**: Server-sent events for progress updates (optional)

**Module Dependency Diagram:**

![Module Dependencies - Feature Modules and Core
Services](./media/media/image6.png){width="5.525in"
height="2.1800185914260717in"}

### 4.2 Frontend Architecture (Flutter)

**State Management Architecture:**

**Key Classes:**

1.  **AppState** (`lib/app/state/``app_state.dart` - 567 lines)
    - Central state container for the entire application

    - Extends `ChangeNotifier` for reactive updates

    - Contains: landmarks, routes, check-ins, auth state, UI state

    - Key methods:

    <!-- -->

    - Future<void> signIn({required String username, required String password})
          Future<CheckInAttemptResult> attemptCheckIn(String landmarkId, ...)
          List<BadgeProgress> get badgeProgress  // Computed property
          void startRoute(String routeId)
2.  **AppScope** (`lib/app/state/``app_scope.dart` - 161 lines)
    - Extends `InheritedNotifier``<``AppState``>`
    - Provides global access to AppState via `AppScope.of``(context)`
    - Automatically rebuilds dependent widgets when state changes
    - Usage: `final ``appState`` = ``AppScope.of``(context``);`
3.  **BackendApiClient** (`lib/core/network/``backend_api_client.dart` -
    657 lines)
    - HTTP client for backend communication
    - Manages JWT tokens (access + refresh)
    - Automatic token refresh on 401 responses
    - Methods: `login(``)`, `createCheckIn``(``)`, `uploadPhoto``(``)`,
      etc.

![](./media/media/image7.png){width="6.5in"
height="5.428472222222222in"}

**Why Hybrid?**

1.  **MongoDB for Persistent Data**: Users, landmarks, routes must
    survive backend restarts
2.  **In-Memory for Transient Data**: Check-ins are high-frequency
    writes; acceptable to lose on restart (like cache)
3.  **Trade-off**: Simpler implementation, better performance for
    write-heavy operations, but sacrifice durability for check-ins

**\**

**Token Storage Architecture:**

![Figure 5: JWT Token Storage Architecture - Secure Storage
Implementation](./media/media/image8.png){width="5.2in"
height="2.156198600174978in"}

------------------------------------------------------------------------

## 5. Features & User Stories

### 5.1 Implemented User Stories

#### US-01: User Authentication

**As a** user, **I want to** log in with username and password **so
that** I can access personalized features.

**Acceptance Criteria:** - \[x\] User can enter credentials - \[x\]
System validates credentials - \[x\] JWT tokens are generated and
stored - \[x\] Session persists across app restarts (using refresh
token)

**Implementation:** - Backend: `AuthController.login``()`,
`AuthService` - Frontend: `LoginPage`, `AppState.signIn``()`

------------------------------------------------------------------------

#### US-02: Landmark Discovery

**As a** user, **I want to** see landmarks on a map **so that** I can
find interesting places to visit.

**Acceptance Criteria:**

\- \[x\] Map displays all 15 landmarks with GPS coordinates

\- \[x\] Landmarks categorized: Historic (Irving House, Anvil Centre),
Nature (Queen's Park), Food (River Market), Culture (Museums)

\- \[x\] Tapping a marker shows landmark card with image, rating, and
category

\- \[x\] Category filter chips (All, Historic, Nature, Food, Culture)

\- \[x\] "Get Directions" button opens external map (Google Maps/Apple
Maps)

**Implementation:** - **Frontend:** `MapPage` with Mapbox Flutter SDK,
`LandmarkDetailPage` with photo carousel - **Backend:**
`LandmarkController.getAllLandmarks``()`, MongoDB `landmarks`
collection - **Key Feature:** Filter persistence across tab switches via
AppState

**Technical Details:** - Mapbox integration with custom annotation
views - Category filtering using `where(``)` clause on
`LandmarkCategory` - External map URL construction:
`https://maps.google.com/?q={lat``},{``lng}`

**\**

**Screenshots:**

![Map view with all landmarks
displayed](./media/media/image9.png){width="3.768280839895013in"
height="8.1709208223972in"}

*Figure: Map view with all landmarks displayed*

![Category filter chips (Historic, Nature, Food,
Culture)](./media/media/image10.png){width="3.885252624671916in"
height="8.262186132983377in"}

*Figure: Category filter chips (Historic, Nature, Food, Culture)*

![Landmark detail page with hero
image](./media/media/image11.png){width="3.90625in" height="8.25in"}

*Figure: Landmark detail page with hero image*

#### US-02b: Landmark Details & Navigation

**As a** user, **I want to** view detailed information about a landmark
**so that** I can learn its history and plan my visit.

**Acceptance Criteria:** - \[x\] Full-screen detail view with hero
image - \[x\] Historical description and practical information - \[x\]
Address and GPS coordinates display - \[x\] User rating (1-5 stars) -
\[x\] One-tap navigation to landmark

**Implementation:** - **Frontend:** `LandmarkDetailPage` with
`SingleChildScrollView`, image hero animation - **UI Components:**
Rating stars, category badge, address chip, "CHECK IN" button

------------------------------------------------------------------------

#### US-03: GPS Check-In

**As a** user, **I want to** check in at landmarks **so that** I can
track my visits and earn badges.

**Acceptance Criteria:** - \[x\] GPS proximity validation within 50
meters using Haversine formula - \[x\] Real-time distance display: "You
are 23m away" - \[x\] Duplicate check-in prevention (same landmark
within 24 hours) - \[x\] Photo upload: up to 9 photos, 5MB max each
(JPG/PNG/WEBP) - \[x\] Optional note: up to 500 characters - \[x\]
Success feedback with badge earned notification

**Implementation:** - **Frontend:** `LandmarkDetailPage` check-in
button, `CheckInHistoryPage` gallery, `image_picker` for photos -
**Backend:** `CheckInController.createCheckIn``()`,
`NwTrailsService.calculateDistanceMeters``()` - **Validation:**
`java   double distance = ``calculateDistance``(``userLat``, ``userLng``, ``landmarkLat``, ``landmarkLng``);   ``if (distance > CHECK_IN_MAX_DISTANCE_METERS) ``{  ``     throw new ``CheckInException``(``CheckInStatus.TOO_FAR``, distance``);   ``}`

**Photo Upload Flow:**

![Photo Upload Flow - From Selection to
Storage](./media/media/image12.png){width="5.525in"
height="4.664620516185477in"}

**User Flow:** 1. User opens landmark detail page 2. App requests GPS
permission and gets current location 3. Real-time distance calculation
displayed 4. If within 50m: "CHECK IN" button enabled 5. User can add
photos (tap to add, X to remove) 6. Optional note input 7. Submit →
Backend validates → Returns success + badge progress

**Check-in Flow Diagram:**

![Complete Check-in Flow - GPS Validation to Badge
Update](./media/media/image13.png){width="5.525in"
height="0.2637926509186352in"}

Screenshots:

![GPS validation with distance
display](./media/media/image14.png){width="4.064420384951881in"
height="8.628153980752407in"}

![Photo upload
interface](./media/media/image15.png){width="4.048741251093613in"
height="8.594872047244095in"}

![Check-in success
confirmation](./media/media/image16.png){width="4.050991907261592in"
height="8.599650043744532in"}

![Landmark detail with check-in
button](./media/media/image17.png){width="4.06376312335958in"
height="8.626759623797025in"}

![Distance validation in
progress](./media/media/image18.png){width="4.0596686351706035in"
height="8.618068678915135in"}

![Badge earned
notification](./media/media/image19.png){width="4.229166666666667in"
height="8.864583333333334in"}

8.  Success animation + confetti for new badges

**Error Handling:** - `TOO_FAR`: Show distance and suggest getting
closer - `ALREADY_CHECKED_IN`: "You checked in here today at 2:30 PM" -
`PERMISSION_DENIED`: Prompt for location permission

------------------------------------------------------------------------

#### US-03b: Check-In History & Photo Gallery

**As a** user, **I want to** view my past check-ins **so that** I can
remember my visits and share them.

**Acceptance Criteria:**

\- \[x\] Chronological list of all check-ins

\- \[x\] Filter by period: All, Last 7 Days, Today

\- \[x\] Photo gallery for each check-in

\- \[x\] Landmark name and visit date/time

\- \[x\] Tap to view full photo

**Implementation:** - **Frontend:** `CheckInHistoryPage` with
`ListView.builder`, photo grid using `GridView` - **Backend:**
`CheckInController.listMyCheckIns``(``CheckInPeriod`` period)` - **Data
Structure:**
`dart   class ``CheckInRecord`` ``{  ``   final String ``landmarkId``;   ``  final ``DateTime`` ``checkedInAt``;   ``  final String? ``note;   ``  final List<String> ``photoUrls``;   ``}`

**UI Design:** - Card-based layout with hero image - Photo grid: 3
columns, tap to expand - Date grouping: "Today", "Yesterday", "Earlier
this week"

**\**

**Screenshots:**

![Check-in history list
view](./media/media/image20.png){width="4.040773184601925in"
height="8.577958223972004in"}

![Photo gallery in check-in
detail](./media/media/image21.png){width="3.7604166666666665in"
height="8.375in"}

![Full photo view with landmark
info](./media/media/image22.png){width="4.239583333333333in"
height="9.0in"}

![Date grouping and filters](./media/media/image23.png){width="4.0625in"
height="8.84375in"}

#### US-04: Achievement Badges

**As a** user, **I want to** earn badges for visiting landmarks **so
that** I feel rewarded for exploration.

**Acceptance Criteria:**

\- \[x\] Overall badges: Bronze (5 unique landmarks), Silver (10), Gold
(15)

\- \[x\] Category badges: "History Buff" (5 historic), "Nature Lover" (5
nature), "Foodie Explorer" (5 food), "Culture Seeker" (5 culture)

\- \[x\] Real-time progress bars showing progress toward next tier

\- \[x\] Badge earned celebration with animation

\- \[x\] Next badge hint: "Next: Silver (10) - 3 more to go"

**Implementation:** - **Frontend:** `AwardsPage` with
`CustomScrollView`, progress bars using `LinearProgressIndicator` -
**Backend:** `ProgressController.getMyProgress``()`,
`NwTrailsService.computeBadgeProgress``()` - **Badge Calculation:**
\`\`\`java public List computeBadgeProgress(String username) { Set
uniqueLandmarks = getUniqueVisitedLandmarks(username); int count =
uniqueLandmarks.size();

      return List.of(
          new BadgeProgressResponse("Explorer", count >= 5, count, 5),
          new BadgeProgressResponse("Adventurer", count >= 10, count, 10),
          new BadgeProgressResponse("Master", count >= 15, count, 15)
      );

} \`\`\`

**UI Components:** - Badge cards with tier icons (🥉 Bronze, 🥈 Silver,
🥇 Gold) - Animated progress bars with percentage - Category grid with
visited/total counters - Confetti animation on new badge earned

**\**

**Badge Calculation Flow:**

![Badge Calculation Flow - From Check-in to Progress
Update](./media/media/image24.png){width="5.525in"
height="5.208825459317585in"}

**Category Breakdown:**

  ---------------------------------------------
  Category   Total   Description
  ---------- ------- --------------------------
  Historic   5       Heritage buildings,
                     museums

  Nature     4       Parks, trails, waterfront

  Food       3       Markets, restaurants,
                     breweries

  Culture    3       Theaters, galleries,
                     centers
  ---------------------------------------------

**\**

**Screenshots:**

![Awards page with badge
progress](./media/media/image25.png){width="4.052603893263342in"
height="8.603070866141731in"}

![Category breakdown and progress
bars](./media/media/image26.png){width="4.239583333333333in"
height="9.0in"}

#### US-04b: Personal Stats & Leaderboard

**As a** user, **I want to** see my exploration statistics **so that** I
can track my progress.

**Acceptance Criteria:**

\- \[x\] Total check-ins count

\- \[x\] Unique landmarks visited

\- \[x\] Completion percentage

\- \[x\] Favorite category

\- \[x\] Recent activity timeline

**Implementation:** - **Frontend:** `DashboardPage` with stats cards and
activity list - **Backend:** `UserProgressResponse` with aggregated
statistics - **Key Metrics:** - Total Check-ins: All check-in attempts -
Distinct Landmarks: Unique places visited - Progress: (visited / total)
× 100%

#### US-05: Curated Routes

**As a** user, **I want to** follow suggested walking routes **so that**
I can efficiently visit multiple landmarks.

**Acceptance Criteria:**

\- \[x\] 5 curated routes: Historic Downtown Walk (Easy), Waterfront
Trail (Medium), Food and Market Tour (Easy), Queens Park and Beyond
(Medium), Complete New West (Hard)

\- \[x\] Route details: distance, duration, difficulty, number of stops

\- \[x\] Difficulty filter: All, Easy, Medium, Hard

\- \[x\] Start route and track progress

\- \[x\] Visual timeline showing visited and upcoming stops

\- \[x\] Next stop recommendation with navigation

**Implementation:** - **Frontend:** `RoutesPage` with filter chips,
`RouteDetailPage` with timeline - **Backend:** `RouteController` with
CRUD operations, `RoutePlan` MongoDB document - **Route Data
Structure:**
`java   public record ``RoutePlan``(  ``     String ``id,   ``                 // "r1", "r2", etc.       String ``name,   ``               // "Historic Downtown Walk"       double ``distanceKm``,   ``        // 2.5 km       int ``durationMinutes``,   ``      // 45 minutes       String ``difficulty,   ``        // "Easy", "Medium", "Hard"       List<String> ``landmarkIds``     // Ordered list: ["l1", "l2", "l3", ``...]   ``) {}`

**Route List:**

  ---------------------------------------------------------------------
  ID   Name                  Distance   Duration   Difficulty   Stops
  ---- --------------------- ---------- ---------- ------------ -------
  r1   Historic Downtown     2.5 km     45 min     Easy         5
       Walk                                                     

  r2   Waterfront Trail      3.8 km     70 min     Medium       6

  r3   Food and Market Tour  1.8 km     30 min     Easy         4

  r4   Queens Park and       3.2 km     55 min     Medium       4
       Beyond                                                   

  r5   Complete New West     6.5 km     120 min    Hard         15
  ---------------------------------------------------------------------

**Progress Tracking:** - When user checks in at a landmark on the route,
progress auto-updates

**\**

**Screenshots:**

![Routes list with difficulty
filter](./media/media/image27.png){width="3.663497375328084in"
height="7.777058180227471in"}

*Figure: Routes list with difficulty filter*

![Route card with distance and
duration](./media/media/image28.png){width="4.01229002624672in"
height="8.517491251093613in"}

*Figure: Route card with distance and duration*

![Route difficulty
indicators](./media/media/image29.png){width="4.069416010498688in"
height="8.638759842519685in"}

*Figure: Route difficulty indicators*

![Route landmark stops
overview](./media/media/image30.png){width="3.865547900262467in"
height="8.205978783902012in"}

*Figure: Route landmark stops overview*

![Route detail with progress
timeline](./media/media/image31.png){width="4.029279308836395in"
height="8.553555336832895in"}

*Figure: Route detail with progress timeline*

![Active route
navigation](./media/media/image32.png){width="4.019266185476815in"
height="8.532299868766405in"}

*Figure: Active route navigation*

![Next stop
recommendation](./media/media/image33.png){width="4.000034995625547in"
height="8.491475284339458in"}

*Figure: Next stop recommendation*

![Route completion
celebration](./media/media/image34.png){width="4.222424540682415in"
height="8.963575021872266in"}

- Timeline shows: ✅ visited stops, 📍 current/next stop, ⭕ upcoming
  stops
- Progress bar: "3 of 5 stops completed (60%)"
- Completed routes show "Route Complete!" badge

------------------------------------------------------------------------

#### US-05b: Route Navigation

**As a** user, **I want to** navigate between route stops **so that** I
can follow the suggested path.

**Acceptance Criteria:**

\- \[x\] "Start Route" button activates route mode

\- \[x\] Next stop highlighted with landmark details

\- \[x\] "Navigate" button opens external maps with directions

\- \[x\] Check-in at stop automatically advances to next

**Implementation:** - **Frontend:** Route progress state in
`AppState``._``activeRouteId` - **Backend:** `RouteProgressResponse`
with `completedStops`, `nextLandmarkId`, `progress` percentage

**Flow:**

1\. User taps "Start Route" on `RouteDetailPage`

2\. Backend sets `activeRouteIdByUser.put``(``username, ``routeId``)`

3\. User checks in at landmark on route

4\. Backend detects and calls `updateRouteProgress``(``)`

5\. Progress returned in `CheckInResultResponse.routeProgress`

6\. UI updates to show next stop

------------------------------------------------------------------------

### 5.2 Feature Visual Descriptions

Since the application is a mobile app, below are detailed descriptions
of each screen's layout and content:

#### Screen 1: Login Screen

**Layout:** - Centered logo at top (30% of screen) - Two text input
fields with rounded borders - Primary CTA button (filled, accent
color) - Error messages appear below fields in red - Loading indicator
on button during API call

------------------------------------------------------------------------

#### Screen 2: Map View (Main Screen)

**Layout:** - Full-screen Mapbox map with custom annotation markers -
Floating search bar at bottom (above chips) - Horizontal scrollable
category filter chips - Map markers show landmark category via color: -
🟤 Brown: Historic - 🟢 Green: Nature - 🟠 Orange: Food - 🟣 Purple:
Culture

------------------------------------------------------------------------

#### Screen 3: Landmark Detail

**Layout:** - Hero image carousel (swipeable if multiple photos) -
Category badge (colored chip) - Address with map icon - Scrollable
description text - Star rating display - Two primary action buttons
stacked

------------------------------------------------------------------------

#### Screen 4: Check-in Flow

    Step 1: Validation
    ┌─────────────────────────────┐
    │ Check In at Irving House    │
    ├─────────────────────────────┤
    │                             │
    │  ┌─────────────────────┐    │
    │  │  📍 GPS Status      │    │
    │  │                     │    │
    │  │ Distance: 23m       │    │
    │  │ Accuracy: ±5m       │    │
    │  │                     │    │
    │  │ ✅ Within range     │    │
    │  └─────────────────────┘    │
    │                             │
    │ Add Note (optional):        │
    │ ┌─────────────────────┐     │
    │ │ Great view today!   │     │
    │ └─────────────────────┘     │
    │                             │
    │ Photos (0/9):               │
    │ [+] [+] [+]                 │
    │                             │
    │  ┌─────────────────────┐    │
    │  │   CONFIRM CHECK IN  │    │
    │  └─────────────────────┘    │
    │                             │
    └─────────────────────────────┘

`
`

    Step 2: Success
    ┌─────────────────────────────┐
    │         ✅                  │
    │                             │
    │   Check-in Successful!      │
    │                             │
    │   🥉 New Badge Earned!      │
    │   History Buff - Bronze     │
    │                             │
    │  ┌─────────────────────┐    │
    │  │     CONTINUE        │    │
    │  └─────────────────────┘    │
    │                             │
    └─────────────────────────────┘

**Key Interactions:** - Real-time GPS distance updates - Photo grid: tap
to add, X to remove - "+" button opens image picker (camera or
gallery) - Success screen with confetti animation for new badges

------------------------------------------------------------------------

#### Screen 5: Awards/Badges Screen

**Layout:** - Overall badges section with large progress bars - Tier
icons (🥉🥈🥇) next to badge names - Percentage and count display -
Category breakdown grid - Color-coded category icons

------------------------------------------------------------------------

#### Screen 6: Routes List

**Card Layout:** - Large card with rounded corners - Icon based on route
theme - Difficulty color badge (🟢🟡🔴) - Metadata: distance, duration,
number of stops - Full-width CTA button

------------------------------------------------------------------------

#### Screen 7: Route Detail (Active)

**Timeline Visual Language:** - ✅ Completed stop (checkmark, grayed
out) - 📍 Current/next stop (highlighted, pulse animation) - ⭕ Upcoming
stop (outline, muted) - Vertical line connecting timeline items

------------------------------------------------------------------------

## 6. Technical Implementation

### 6.1 Key Algorithms

#### Haversine Formula for GPS Distance

Used to calculate the great-circle distance between user's GPS location
and landmark coordinates.

    /**
     * Calculates distance between two GPS coordinates.
     * Accuracy: ~0.5% error due to Earth oblateness
     * 
     * @param lat1 User latitude in degrees
     * @param lng1 User longitude in degrees  
     * @param lat2 Landmark latitude in degrees
     * @param lng2 Landmark longitude in degrees
     * @return Distance in meters
     */
    public double calculateDistance(double lat1, double lng1,
                                    double lat2, double lng2) {
        final int R = 6371000; // Earth's mean radius in meters
        
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);
        
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return R * c;
    }

**Complexity:** O(1) - Constant time calculation **Accuracy:** Validated
against Google Maps API with \<1% variance

------------------------------------------------------------------------

#### Badge Progress Calculation

    /**
     * Computes badge progress based on unique landmark visits.
     * 
     * Algorithm:
     * 1. Get all check-ins for user
     * 2. Extract unique landmark IDs (set automatically handles uniqueness)
     * 3. Count unique landmarks
     * 4. Check against tier thresholds (5, 10, 15)
     * 
     * Time Complexity: O(n) where n = number of check-ins
     * Space Complexity: O(m) where m = number of unique landmarks
     */
    public List<BadgeProgressResponse> computeBadgeProgress(String username) {
        List<CheckInRecord> checkIns = checkInsByUser.get(username);
        Set<String> uniqueLandmarks = checkIns.stream()
            .map(CheckInRecord::landmarkId)
            .collect(Collectors.toSet());
        
        int count = uniqueLandmarks.size();
        
        return List.of(
            new BadgeProgressResponse("Explorer", count >= 5, count, 5),
            new BadgeProgressResponse("Adventurer", count >= 10, count, 10),
            new BadgeProgressResponse("Master", count >= 15, count, 15)
        );
    }

------------------------------------------------------------------------

### 6.2 Security Considerations

  -----------------------------------------------------------------------
  Aspect             Implementation                      Notes
  ------------------ ----------------------------------- ----------------
  **Password         BCrypt with adaptive rounds         Slow by design
  Storage**                                              to resist
                                                         brute-force

  **Token            Access: 1hr, Refresh: 7 days        Balance security
  Expiration**                                           vs usability

  **HTTPS**          Required in production              All API calls
                                                         encrypted

  **CORS**           Configured for mobile origins       Prevents
                                                         unauthorized web
                                                         access

  **Input            Jakarta Validation (Bean            \@NotBlank,
  Validation**       Validation)                         \@NotNull
                                                         annotations

  **SQL Injection**  Prevented by MongoDB driver         No raw queries
  -----------------------------------------------------------------------

### 

### 6.3 Performance Optimizations

Performance metrics were measured during final testing using Android
Emulator (Pixel 7 API 34) with backend running on localhost:

  --------------------------------------------------------------------------
  Metric            Target            Achieved              Notes
  ----------------- ----------------- --------------------- ----------------
  API Response Time \<200ms           85ms avg              Measured for
                                                            landmark list
                                                            endpoint

  Map Load Time     \<2s              1.2s                  Initial Mapbox
                                                            SDK
                                                            initialization

  Check-in          \<500ms           320ms                 Includes GPS
  Validation                                                distance
                                                            calculation +
                                                            backend
                                                            validation

  Token Refresh     \<100ms           45ms                  Average over 50
                                                            refresh
                                                            operations
  --------------------------------------------------------------------------

All performance targets were met or exceeded during testing. The app
maintains responsive UI with consistent 60fps during navigation and map
interactions.

------------------------------------------------------------------------

## 7. Challenges & Solutions

### 7.1 Technical Challenges

#### Challenge 1: Cross-Origin Resource Sharing (CORS)

**📝 Written by: Dong Zhang (Integration Lead)**

**Description:** During frontend-backend integration, API calls from
Flutter web and Android emulator were blocked by browser/emulator CORS
policies. The error `Access-Control-Allow-Origin` header was missing,
preventing the Flutter app from communicating with the Spring Boot
backend during development.

**Impact:** - Frontend completely unable to communicate with backend
during development - Blocked all API testing and integration work -
Delayed integration timeline by 2 days

**Solution:** Configured CORS in `SecurityConfig.java` to allow requests
from Flutter development origins. See Section 4.3 for detailed code.

**Lessons Learned:** CORS configuration must be environment-aware.
Production requires strict origin validation, while development needs
flexibility for various emulator/web origins.

#### Challenge 2: Token Refresh Synchronization

**📝 Written by: Dong Zhang (Integration Lead)**

**Description:** When the JWT access token expired during active app
usage, multiple simultaneous API calls would trigger multiple refresh
token requests, causing race conditions and invalidating the refresh
token (single-use policy). This resulted in users being unexpectedly
logged out.

**Impact:** - Race conditions caused token invalidation - Users randomly
logged out during normal usage - Poor user experience and app
reliability

**Solution:** Implemented a token refresh queue mechanism in
`BackendApiClient.dart` with `_``isRefreshing` flag and
`_``refreshQueue` to serialize refresh requests. See Section 4.2 for
detailed code.

**Lessons Learned:** Token refresh must be serialized to prevent race
conditions. Using a queue pattern ensures only one refresh request is
active at a time.

------------------------------------------------------------------------

#### Challenge 3: GPS Coordinate Precision & Proximity Validation

**Problem:** GPS coordinates from mobile devices have varying accuracy
(3-20 meters). During testing, users standing right next to a landmark
were sometimes rejected because their GPS coordinates drifted beyond the
50-meter threshold. Additionally, different devices reported coordinates
with different precision levels.

**Impact:** Poor user experience - legitimate users couldn't check in
despite being physically present at landmarks.

**Solution:** Implemented multiple strategies:

1.  **Haversine Formula** for accurate distance calculation:

<!-- -->

    public double calculateDistance(double lat1, double lng1, 
                                    double lat2, double lng2) {
        final int R = 6371000; // Earth's mean radius in meters
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);
        
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return R * c; // Distance in meters
    }

2.  **GPS Accuracy Check**: Validate device's reported accuracy before
    accepting check-in

3.  **Test Mode**: Added mock location injection for testing:

<!-- -->

    class MockLocationService implements LocationService {
      void injectLocation(double lat, double lng) {
        _injectedPosition = Position(latitude: lat, longitude: lng);
      }
    }

**Validation Results:**

  ------------------------------------------
  Test Scenario      Distance   Result
  ------------------ ---------- ------------
  Standing at        2-5m       ✅ Accepted
  landmark                      

  40m from landmark  35-45m     ✅ Accepted

  55m from landmark  52-58m     ❌ Rejected

  Across street      15-25m     ✅ Accepted
  ------------------------------------------

**Lesson Learned:** GPS validation must account for real-world device
accuracy variations. Providing a test mode is essential for development
and demos.

------------------------------------------------------------------------

#### Challenge 4: MongoDB Migration from In-Memory Storage

**📝 Written by: Diego Romero-Lovo (Database Migration Lead)**

**Description:** Initially, check-ins and active routes were stored in
`ConcurrentHashMap` for simplicity. As the project evolved, we needed
persistent storage for user data. Migrating to MongoDB while maintaining
backward compatibility and without data loss was challenging.

**Impact:** - Risk of data loss during migration - Required changes to
Repository pattern implementation - Needed to ensure zero downtime
during transition

**Solution:** Implemented Repository pattern for seamless abstraction: -
Created Repository interfaces (LandmarkRepository,
UserAccountRepository, etc.) - Extended Spring Data MongoRepository for
persistent entities - Kept transient data (check-ins) in-memory for
performance

See Section 4.4 for detailed storage architecture.

**Lessons Learned:** Not all data needs persistence. High-frequency,
transient data (check-ins) can remain in-memory for performance, while
critical data (users, landmarks) requires MongoDB persistence.

------------------------------------------------------------------------

#### Challenge 5: Photo Upload Size & Format Validation

**📝 Written by: Zhi Kang (Check-in Module Owner)**

**Description:** Users attempting to upload large photos (10MB+) caused
memory issues and slow uploads. Additionally, unsupported image formats
(HEIC, RAW) caused processing errors.

**Impact:** - App crashes on low-memory devices - Slow upload
experience - Confusing error messages for unsupported formats

**Solution:** Implemented comprehensive validation in
`CheckInController`: - Max file size: 5MB - Allowed formats: JPG, JPEG,
PNG, WEBP - Max photos per check-in: 9 - Client-side pre-validation for
better UX

See Section 5.1 US-03 for validation code details.

**Lessons Learned:** Validation must occur on both client (for UX) and
server (for security). Clear error messages help users understand
constraints.

------------------------------------------------------------------------

### 7.2 Team Collaboration Challenges

#### Primary Challenge: Cross-module API Dependencies\*\*

**Problem**: Awards system depended on Check-in data structure and
Landmark categories, creating circular dependencies during initial
development.

**Solution**: 1. Dong created Swagger OpenAPI spec as contract-first API
definition 2. Diego published landmark seed data with consistent
\_id/category fields 3. Zhi Kang implemented check-in validation before
awards consumption logic 4. Daily 15-minute stand-ups ensured API
alignment

**Impact**: Delayed awards integration by 2 days, resolved via shared
Postman collection for API testing.

**Lesson Learned**: Start with API contracts before module
implementation.

#### Minimal Challenge: Remote Team Coordination Across Time Zones

Our team of four (Diego, Zhi Kang, Menghua, Dong) collaborated
effectively throughout the project using GitHub for version control and
daily stand-ups via Discord.

Key collaboration successes: - **Clear role division**: Each member
owned distinct modules (Map, Check-in, Awards, Routes) with well-defined
APIs - **PR review process**: All backend changes went through pull
request #13 with thorough reviews - **Shared documentation**: Swagger UI
and README.md ensured frontend-backend alignment - **Responsive
communication**: Issues like CORS and JWT were resolved within 24 hours
through group debugging sessions

Minor challenges encountered: - **Time zone coordination**: Addressed
via async updates and recorded meetings - **Emulator GPS testing**:
Resolved with developer mock location tools

Overall, team collaboration proceeded smoothly, enabling on-time
delivery of a fully integrated Flutter + Spring Boot + MongoDB
application.

### 7.3 Lessons Learned

#### Technical Lessons

**1. Architecture First, Implementation Second** Spending time upfront
on API contract design and architecture diagrams saved significant
refactoring later. The initial REST API contract defined in Week 2
remained stable throughout development, allowing frontend and backend
teams to work in parallel.

**2. State Management is Critical** Flutter's ChangeNotifier pattern
worked well for our app size, but we learned the importance of: - Clear
state ownership (what lives in AppState vs. local widget state) - Proper
disposal of controllers and streams to prevent memory leaks - Reactive
patterns to avoid manual UI rebuild calls

**3. Validation Must Be Defense in Depth** We implemented validation at
multiple layers: - Client-side (immediate UX feedback) - API input
validation (Jakarta Validation annotations) - Business logic validation
(service layer constraints) - Database constraints (MongoDB schema
validation) This layered approach caught issues early and provided clear
error messages.

**4. Documentation is Not Optional** The investment in comprehensive
code documentation (JavaDoc, Dart Doc) paid dividends during: - Code
reviews (clear intent and contracts) - Onboarding new team members -
Final report writing (source of truth for technical details) - Video
script preparation (accurate technical descriptions)

#### Collaboration Lessons

**5. Git Workflow Matters** Initially, we had merge conflicts and
integration issues. Adopting a feature branch workflow with: -
Descriptive branch names (`feature/login-auth`,
`fix/``gps``-validation`) - Pull request reviews (all code reviewed by
at least one other member) - Clear commit messages following
conventional commits ...significantly reduced integration problems.

**6. Communication Channels** We used multiple channels effectively: -
**Discord**: Daily standups, quick questions, screen sharing - **GitHub
Issues**: Bug tracking, feature discussions - **Figma**: Design
collaboration and wireframe reviews - **Zoom**: Weekly sprint planning
and retrospectives

**7. Divide by Feature, Not by Layer** Assigning complete features
(e.g., "Check-in System" vs. "Badge System") rather than layers ("All
Frontend" vs. "All Backend") resulted in: - Clearer ownership and
accountability - End-to-end understanding of features - Reduced
integration dependencies - More meaningful individual contributions

#### Process Lessons

**8. Test Mode is Essential** Building a test mode with mock location
injection early saved countless hours during development. Without
physically visiting 15 landmarks repeatedly, we could: - Test GPS
validation logic - Verify badge calculations - Demo the app in
presentations

**Test Mode Screenshots:**

![Test mode with mock location
injection](./media/media/image35.png){width="3.789876421697288in"
height="8.126549650043744in"}

*Figure: Test mode with mock location injection*

![GPS validation testing
interface](./media/media/image36.png){width="4.059729877515311in"
height="8.618198818897637in"}

*Figure: GPS validation testing interface*

**9. Swagger Documentation Pays Off** Maintaining Swagger annotations
from day one meant we always had: - Up-to-date API documentation -
Interactive API testing interface - Clear contract for frontend-backend
integration

**10. Buffer Time for Integration** Despite parallel development, we
needed a dedicated integration sprint (Week 7). Integration always takes
longer than expected due to: - CORS configuration issues - Serialization
mismatches - Environment-specific bugs (Android vs. iOS vs. Web) -
Authentication flow edge cases

------------------------------------------------------------------------

## 8. Peer Evaluation

### 8.1 Evaluation Rubric

  -------------------------------------------------
  Score   Description
  ------- -----------------------------------------
  4       Exceptional contribution, exceeded
          expectations

  3       Good contribution, met all expectations

  2       Adequate contribution, met minimum
          expectations

  1       Below expectations, contribution lacking
  -------------------------------------------------

### 8.2 Evaluation Matrix

**Evaluator: Dong Zhang (Integration Lead, Route Module, Global State)**

  --------------------------------------------------------------------------------------
  Evaluatee     Technical           Collaboration   Communication   Overall   Comments
                Contribution (1-4)  (1-4)           (1-4)           (1-4)     
  ------------- ------------------- --------------- --------------- --------- ----------
  Diego         4                   4               4               4         See below
  Romero-Lovo                                                                 

  Zhi Kang      4                   4               4               4         See below

  Menghua Wang  4                   3.5             4               3.5       See below
  --------------------------------------------------------------------------------------

**Detailed Comments:** **Diego Romero-Lovo:** **Technical Excellence**:
Implemented the complete Mapbox integration with custom annotations,
landmark detail page with photo carousel, and successfully migrated both
Landmarks and Routes to MongoDB (PR #13). The map functionality is
polished and responsive. **Great Team Player**: Always available for
pair programming sessions, proactively helped debug GPS issues, and
delivered features ahead of schedule. His UI/UX sensibility
significantly improved the app's visual appeal. **Zhi Kang:** **Core
Feature Owner**: Built the entire check-in system from scratch including
50-meter GPS validation using Haversine formula, duplicate prevention
logic, and check-in history with photo gallery. The code is
well-structured and thoroughly tested. **Reliable Collaborator**:
Consistently met deadlines, provided detailed status updates in Discord,
and was quick to respond to integration requests. His attention to edge
cases (GPS accuracy, photo limits) prevented many potential bugs.
**Menghua Wang:** **Strong Technical Skills**: Developed the complete
badge calculation algorithm with proper tier thresholds
(Bronze/Silver/Gold), created the Awards page with progress
visualization, and implemented category-specific badges. Also
contributed to Swagger documentation. **Good Communication**: Regularly
participated in team meetings and provided thoughtful input on
architecture decisions. Would benefit from slightly more proactive
communication on blockers, but overall a valuable team member who
delivered quality work. **Dong Zhang's Self-Reflection:** As Integration
Lead, I focused on architecting the overall system (AppState pattern,
JWT flow, API client), coordinating between frontend and backend teams,
and implementing the Routes module. I successfully resolved the CORS and
token refresh synchronization challenges. Areas for improvement: could
have delegated more tasks earlier to avoid bottlenecking.

------------------------------------------------------------------------

**Evaluator: Diego Romero-Lovo (Map Integration, Location Services,
Persistence)**

  ------------------------------------------------------------------------------------
  Evaluatee   Technical           Collaboration   Communication   Overall   Comments
              Contribution (1-4)  (1-4)           (1-4)           (1-4)     
  ----------- ------------------- --------------- --------------- --------- ----------
  Dong Zhang  4                   4               4               4         See below

  Zhi Kang    4                   4               4               4         See below

  Menghua     4                   4               4               4         See below
  Wang                                                                      
  ------------------------------------------------------------------------------------

**Detailed Comments:** **Dong Zhang:** **Outstanding Leadership**: Dong
consistently went beyond what was required, demonstrating strong
determination and commitment throughout the project. He provided clear
direction, ensured smooth integration across modules, and maintained
high standards for the team. His leadership was a key factor in the
project's success. **Zhi Kang:** **Consistent Contributor**: Showed
active involvement throughout the entire project and made meaningful
contributions to critical parts of the application. Demonstrated
reliability and technical strength, helping ensure stability and
completeness of core features. **Menghua Wang:** **Dedicated and
Passionate**: Demonstrated strong determination and commitment to her
assigned module. Her passion for the work was evident, and she
consistently delivered quality results while staying engaged with the
team's goals. **Diego Romero-Lovo's Self-Reflection:** I developed the
map functionality, including controls and integration with
location-based services. I also worked on handling real-time location
streams and contributed to migrating several modules from in-memory
storage to MongoDB for persistent data management.

**Evaluator: Zhi Kang (Check-in Module & History)**

  --------------------------------------------------------------------------------------
  Evaluatee     Technical           Collaboration   Communication   Overall   Comments
                Contribution (1-4)  (1-4)           (1-4)           (1-4)     
  ------------- ------------------- --------------- --------------- --------- ----------
  Dong Zhang    4                   4               4               4         See below

  Diego         4                   4               4               4         See below
  Romero-Lovo                                                                 

  Menghua Wang  4                   4               4               4         See below
  --------------------------------------------------------------------------------------

**Detailed Comments:** **Dong Zhang:** Dong played an important role as
the Integration Lead and was responsible for the Routes module,
technical architecture, and part of the final presentation. He not only
completed his own features, but also helped connect different parts of
the project together. His work on integration made the system more
complete and stable. As a leader, Dong showed strong responsibility
throughout the project. He helped organize tasks, supported team
communication, and made sure the project moved forward on time. He was
also willing to solve problems when technical challenges came up, such
as integration and authentication issues. Overall, he made a valuable
contribution both technically and as a team leader. **Diego
Romero-Lovo:** Diego was responsible for the Map and Landmarks module.
He did a solid job in building the map view, category filters, and
landmark detail pages. His work helped make the app more interactive and
user-friendly. During the presentation, he clearly explained how users
can explore landmarks and get directions, which showed a good
understanding of both the technical and practical side of the feature.
**Menghua Wang:** Menghua was responsible for the Awards and Badges
system. She completed this part well and made the progress tracking
feature easy to understand. Her explanation of the Bronze, Silver, and
Gold badge system was clear and organized. This feature added motivation
for users and improved the overall experience of the app.

**Evaluator: Menghua Wang (Awards Module - Badge System)**

  --------------------------------------------------------------------------------------
  Evaluatee     Technical           Collaboration   Communication   Overall   Comments
                Contribution (1-4)  (1-4)           (1-4)           (1-4)     
  ------------- ------------------- --------------- --------------- --------- ----------
  Dong Zhang    4                   4               4               4         See below

  Diego         4                   4               4               4         See below
  Romero-Lovo                                                                 

  Zhi Kang      4                   4               4               4         See below
  --------------------------------------------------------------------------------------

**Detailed Comments:** **Dong Zhang:** Integration Lead: Coordinated the
frontend-backend integration and contributed significantly to the Routes
module and backend connectivity. Helped resolve key technical issues
such as CORS, JWT authentication flow, and MongoDB integration, which
were essential to the final system. Strong Team Support: Communicated
clearly, organized team tasks effectively, and was proactive in
troubleshooting integration issues during the final stages of the
project. **Diego Romero-Lovo:** Feature Implementation: Contributed to
the landmarks and map-related functionality, helping build a clear and
user-friendly exploration experience. His work supported the
presentation of landmark information and improved the usability of the
map interface. Collaborative and Dependable: Participated actively in
team discussions, responded well to feedback, and consistently completed
assigned tasks on time. **Zhi Kang:** Core Feature Owner: Built the
check-in system, including GPS-based proximity validation, check-in
history, and related user flows. His implementation covered important
edge cases and added meaningful functionality to the app. Reliable
Collaborator: Consistently met deadlines, shared progress updates
clearly, and responded quickly during testing and integration. His
careful approach helped reduce bugs and improved overall stability.
Menghua Wang's Self-Reflection: I was responsible for the Awards and
Badges module, including overall progress calculation, category badge
tracking, and the progress bar interface. My main focus was to make the
badge system clear, motivating, and visually easy to understand for
users. I also helped test the feature and verify that awards updated
correctly based on completed check-ins. Areas for improvement: I could
have coordinated earlier with the check-in and integration components so
that data-related issues could be discovered and resolved sooner.

### 8.3 Summary Statistics

*Based on peer evaluations from all team members (n=3 evaluators per
member)*

  --------------------------------------------------------------------------------
  Member        Technical Avg Collaboration    Communication    Overall Avg Rank
                              Avg              Avg                          
  ------------- ------------- ---------------- ---------------- ----------- ------
  Dong Zhang    4.00          4.00             4.00             4.00        T-1

  Diego         4.00          4.00             4.00             4.00        T-1
  Romero-Lovo                                                               

  Zhi Kang      4.00          4.00             4.00             4.00        T-1

  Menghua Wang  4.00          3.83             4.00             3.83        4
  --------------------------------------------------------------------------------

**Notes:** - Scores are rated on a scale of 1-4 stars - All team members
demonstrated strong technical skills and commitment to the project -
Minor differences in collaboration scores reflect individual working
styles rather than performance issues

\- Overall team cohesion was excellent throughout the 8-week development
period

------------------------------------------------------------------------

## 9. Conclusion

### 9.1 Project Summary

NW Trails successfully delivers a mobile application that combines
location-based services with gamification to encourage exploration of
New Westminster landmarks. The project demonstrates:

- **Full-stack development**: Flutter frontend + Spring Boot backend
- **Modern authentication**: JWT-based secure authentication
- **Real-world integration**: GPS services, photo upload, map
  visualization
- **Team collaboration**: Distributed development with clear
  responsibilities

### 9.2 Achievements

✅ **Completed Features:**

\- \[x\] User authentication with JWT

\- \[x\] Interactive map with landmarks

\- \[x\] GPS-based check-in with 50m validation

\- \[x\] Achievement badge system

\- \[x\] Curated walking routes

\- \[x\] Photo upload and storage

\- \[x\] Swagger API documentation

\- \[x\] Comprehensive code documentation

### 9.3 Future Improvements

If given more time, we would implement:

1.  **Social Features**: Share achievements, friend system, leaderboards
2.  **Offline Mode**: Cache map data for offline exploration
3.  **Push Notifications**: Reminders for nearby landmarks
4.  **Analytics Dashboard**: Track popular routes and landmarks
5.  **Multi-language Support**: Internationalization for diverse users

### 9.4 Acknowledgments

We would like to thank:

**Instructor & Teaching Staff:** - Our instructor for guidance
throughout the project phases and valuable feedback on our architecture
decisions - TAs for their support during lab sessions and
troubleshooting assistance

**Open Source Community:** - Flutter Team for the excellent
cross-platform framework - Spring Boot community for comprehensive
documentation - Mapbox for providing the maps SDK - All contributors to
the open-source libraries we used

**Douglas College:** - For providing the learning environment and
resources - For the opportunity to work on a real-world project

**Team Members:** - Each team member for their dedication,
collaboration, and commitment to delivering a quality product - For the
productive discussions and mutual support throughout the development
process

**Special Thanks:** - To the city of New Westminster for being our
inspiration and providing rich content for the landmarks - To fellow
students who provided feedback during user testing

------------------------------------------------------------------------

## Appendices

### Appendix A: API Endpoints Reference

#### Authentication Endpoints

  --------------------------------------------------------------------------------------------------------------------
  Method   Endpoint                     Description    Auth Required   Request Body            Response
  -------- ---------------------------- -------------- --------------- ----------------------- -----------------------
  POST     `/``api``/v1/auth/login`     Authenticate   No              `LoginRequest`          `AuthTokenResponse`
                                        user                                                   

  POST     `/``api``/v1/auth/refresh`   Refresh access No              `RefreshTokenRequest`   `AuthTokenResponse`
                                        token                                                  

  POST     `/``api``/v1/auth/logout`    Logout user    Yes             `LogoutRequest`         204 No Content

  GET      `/``api``/v1/auth/me`        Get current    Yes             \-                      `UserSummaryResponse`
                                        user                                                   
  --------------------------------------------------------------------------------------------------------------------

#### Landmark Endpoints

  -------------------------------------------------------------------------------------------------------
  Method       Endpoint                                      Description          Auth Required
  ------------ --------------------------------------------- -------------------- -----------------------
  GET          `/``api``/v1/landmar``ks`                     List all landmarks   Yes

  GET          `/``api``/v1/``landmarks?difficulty``=Easy`   Filter by difficulty Yes

  GET          `/``api``/v1/``landmarks/{``id}`              Get landmark by ID   Yes

  POST         `/``api``/v1/landmarks`                       Create landmark      Yes (ADMIN)
                                                             (Admin)              

  PUT          `/``api``/v1/``landmarks/{``id}`              Update landmark      Yes (ADMIN)
                                                             (Admin)              
  -------------------------------------------------------------------------------------------------------

#### Check-in Endpoints

  -----------------------------------------------------------------------------------------
  Method   Endpoint                                            Description     Auth
                                                                               Required
  -------- --------------------------------------------------- --------------- ------------
  POST     `/``api``/v1/``checkins`                            Create check-in Yes

  GET      `/``api``/v1/``checkins`                            List my         Yes
                                                               check-ins       

  GET      `/``api``/v1/``checkins?period``=TODAY`             Filter by       Yes
                                                               period          

  POST     `/``api``/v1/``checkins``/photos`                   Upload photo    Yes

  GET      `/``api``/v1/``checkins``/``photos/{``photoId``}`   Get photo       Yes
  -----------------------------------------------------------------------------------------

#### Route Endpoints

  ------------------------------------------------------------------------------
  Method   Endpoint                              Description        Auth
                                                                    Required
  -------- ------------------------------------- ------------------ ------------
  GET      `/``api``/v1/routes`                  List all routes    Yes

  GET      `/``api``/v1/``routes/{``id}`         Get route by ID    Yes

  POST     `/``api``/v1/``routes/{id}/``start`   Start route        Yes

  POST     `/``api``/v1/routes`                  Create route       Yes (ADMIN)
                                                 (Admin)            

  PUT      `/``api``/v1/``routes/{``id}`         Update route       Yes (ADMIN)
                                                 (Admin)            

  DELETE   `/``api``/v1/``routes/{``id}`         Delete route       Yes (ADMIN)
                                                 (Admin)            
  ------------------------------------------------------------------------------

#### Progress Endpoints

  -------------------------------------------------------------------------------
  Method   Endpoint                               Description        Auth
                                                                     Required
  -------- -------------------------------------- ------------------ ------------
  GET      `/``api``/v1/progress/me`              Get my progress    Yes

  GET      `/``api``/v1/progress/me/badges`       Get badge progress Yes

  GET      `/``api``/v1/progress/me/categories`   Get category       Yes
                                                  progress           
  -------------------------------------------------------------------------------

**Swagger UI:** `http://localhost:8080/swagger-ui.html` (when backend is
running)

------------------------------------------------------------------------

### Appendix B: Project Repository

- **Frontend GitHub:** https://github.com/dongzhang2077/nw_trails
- **Backend GitHub:** https://github.com/dongzhang2077/nw_trails_backend
- **Proposal Document:** `docs/first_submission/group06-proposal.md`
- **Final Report:** `docs/group06-final-report.md` (this document)

------------------------------------------------------------------------

### Appendix C: Development Tools & Versions

  -------------------------------------------
  Tool          Version   Purpose
  ------------- --------- -------------------
  Flutter       3.19.x    Frontend framework

  Dart          3.3.x     Programming
                          language

  Spring Boot   3.2.3     Backend framework

  Java          21        Backend language

  MongoDB       7.0.x     Database

  Mapbox        2.0.x     Map SDK
  Flutter                 

  IntelliJ IDEA 2024.1    Java IDE

  VS Code       1.87.x    Flutter IDE

  Postman       10.x      API testing

  Git           2.43.x    Version control

  Figma         \-        UI/UX design

  Discord       \-        Team communication
  -------------------------------------------

------------------------------------------------------------------------

### Appendix D: Project File Structure {#appendix-d-project-file-structure-1}

    proj/
    ├── app/
    │   └── nw_trails/                    # Flutter Frontend
    │       ├── lib/
    │       │   ├── app/                  # App shell, state management
    │       │   ├── core/                 # Models, network, services
    │       │   └── features/             # UI features
    │       │       ├── auth/
    │       │       ├── landmarks/
    │       │       ├── checkin/
    │       │       ├── awards/
    │       │       └── routes/
    │       └── test/
    │
    ├── backend/
    │   └── nw-trails-backend/            # Spring Boot Backend
    │       ├── src/main/java/
    │       │   └── ca/douglas/csis4280/nwtrails/
    │       │       ├── api/              # REST Controllers
    │       │       ├── service/          # Business logic
    │       │       ├── domain/           # Entity models
    │       │       ├── repository/       # Data access
    │       │       └── config/           # Security, etc.
    │       └── src/main/resources/
    │
    └── docs/
        ├── assignment/                   # Project requirements
        ├── first_submission/             # Phase 1 proposal
        ├── NW_Trails_Knowledge_Guide.md  # Architecture docs
        ├── NW_Trails_Data_Model_and_Relationships.md
        └── group06-final-report.md       # This document

------------------------------------------------------------------------

### Appendix E: Test Accounts

For testing and demonstration purposes:

  ---------------------------------------------------------------
  Username    Password     Role         Description
  ----------- ------------ ------------ -------------------------
  student01   Passw0rd!    USER         Regular student user

  admin01     AdminPass!   USER, ADMIN  Administrator with full
                                        access
  ---------------------------------------------------------------

------------------------------------------------------------------------

### Appendix F: Landmark Data {#appendix-f-landmark-data-1}

**15 Curated Landmarks in New Westminster:**

  --------------------------------------------------------------
  ID    Name                       Category   Address
  ----- -------------------------- ---------- ------------------
  l1    Irving House               historic   302 Royal Ave

  l2    Queen's Park               nature     3rd Ave

  l3    River Market               food       810 Quayside Dr

  l4    Anvil Centre               culture    777 Columbia St

  l5    Westminster Pier Park      nature     1 6th St

  l6    Fraser River Discovery     culture    788 Quayside Dr
        Centre                                

  l7    Moody Park                 nature     701 8th Ave

  l8    New Westminster Museum     historic   777 Columbia St

  l9    Old Crow Coffee            food       655 Front St

  l10   Longtail Kitchen           food       810 Quayside Dr

  l11   Steel & Oak                food       1319 3rd Ave

  l12   New Westminster Public     food       810 Quayside Dr
        Market                                

  l13   Century House              culture    620 8th St

  l14   Bill Brown's Sports Lounge food       1200 6th St

  l15   Paddlewheeler Pub          food       200-810 Quayside
                                              Dr
  --------------------------------------------------------------

------------------------------------------------------------------------

## Presentation Video

**Video Link:** https://www.youtube.com/watch?v=-5ZVWK-Cm2Y

**Video Duration:** 19 minutes 23 seconds

**Access Settings:** Unlisted (Anyone with link can view)

**Recording Platform:** Zoom/Teams

**Video Structure:**

  ------------------------------------------------------
  Timestamp   Content                        Speaker
  ----------- ------------------------------ -----------
  0:00 - 2:00 Introduction & Team            All Members
              Presentation                   

  2:00 - 4:00 System Demo - Map & Landmarks  Diego

  4:00 - 7:00 System Demo - Check-in &       Zhi Kang
              Photos                         

  7:00 - 9:30 System Demo - Badges & Awards  Menghua

  9:30 -      System Demo - Routes &         Dong Zhang
  12:00       Integration                    

  12:00 -     Technical Architecture Deep    Dong Zhang
  15:00       Dive                           

  15:00 -     Challenges & Solutions         All Members
  17:30                                      

  17:30 -     Conclusion & Q&A               All Members
  18:30                                      
  ------------------------------------------------------

**All team members appear on camera throughout the presentation.**

------------------------------------------------------------------------

**End of Report**

*Group 06 - NW Trails Project* *Douglas College - CSIS 4280* *Submitted:
April 13, 2026*
