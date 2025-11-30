# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Astro GPT** is a Flutter mobile application - an AI-powered astrology companion that provides personalized horoscopes, AI chat with astrologer personas, daily spiritual content, and numerology predictions.

## Development Commands

```bash
# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# Build for release
flutter build apk          # Android
flutter build ios          # iOS

# Run tests
flutter test
flutter test test/widget_test.dart   # Single test file

# Code analysis
flutter analyze

# Get dependencies
flutter pub get

# Clean build
flutter clean && flutter pub get

# Generate localization
flutter gen-l10n
```

## Technology Stack

- **Framework:** Flutter 3.x / Dart 3.x
- **State Management:** GetX
- **Backend:** Appwrite Cloud (Auth, Database, Storage, Realtime)
- **Ads:** Google AdMob
- **In-App Purchases:** RevenueCat / in_app_purchase

## Architecture

```
lib/
├── main.dart
├── app/
│   ├── bindings/          # GetX dependency injection
│   ├── controllers/       # GetX controllers (business logic)
│   ├── data/
│   │   ├── models/        # Data models
│   │   ├── providers/     # API providers (Appwrite, AdMob)
│   │   └── repositories/  # Data repositories
│   ├── modules/           # Feature modules (screens + widgets)
│   │   ├── home/
│   │   ├── chat/
│   │   ├── horoscope/
│   │   ├── astrologer/
│   │   └── settings/
│   ├── routes/            # GetX routing
│   ├── theme/             # Colors, typography, decorations
│   └── widgets/           # Shared widgets
└── l10n/                  # Localization (Hindi/English)
```

## Key Features

1. **AI Astrologer Chat** - GPT-powered chat with multiple astrologer personas
2. **Daily Horoscope** - 12 zodiac signs, 4 time periods, 3 categories
3. **Today's Bhagwan** - Daily rotating deity content
4. **Today's Mantra** - Daily spiritual mantras
5. **Numerology** - Birth date-based predictions

## Appwrite Collections

- `users` - User profiles with DOB and zodiac
- `astrologers` - AI persona profiles
- `chat_sessions` / `messages` - Chat history
- `horoscopes` - Daily/weekly/monthly/yearly predictions
- `daily_content` - Mantras and deity content
- `reviews` / `favorites` - User interactions

## Documentation Structure

The `core_docs_v2/` folder contains comprehensive project documentation:
- `FUNCTIONAL_SPECIFICATIONS.md` - Feature requirements, user stories, acceptance criteria
- `TECHNICAL_SPECIFICATIONS.md` - Architecture, Appwrite schema, code samples
- `frontend_description/astro_gpt_screens.md` - Pixel-perfect UI specifications
- `reference/Sample Screenshot/` - 12 reference screenshots

## Design System

- **Primary Color:** #F26B4E (Coral/Orange)
- **Background:** #FFF5F0 (Peach/Cream)
- **Cards:** White with 12dp border radius

## Code Style

- Uses `flutter_lints` for static analysis
- GetX naming conventions (Controller suffix, Binding suffix)
- Feature-based folder structure



# core_docs - Project Documentation Structure

## Overview
This folder contains comprehensive project documentation organized by purpose. Each subfolder serves a specific role in tracking, planning, and guiding development.

---
## Documentation and memory for future use
## Folder Structure & Purpose
core_docs/

### 📁 **memory/** - Development Progress & History
**Purpose**: Track major achievements, critical problems solved, and session-by-session progress

**Files**:
- `project_memory.md` - Major milestones, critical problems solved with Problem→Root Cause→Solution→Result format, file change tracking
- `module_memory.md` (There will be different module memory file for different modules, like auth_memory.md,dashboard_memory.md. They will follow the structure of module_memory.md) - Detailed session-by-session development progress for specific modules (auth, dashboard, billing, etc.)

**When to use**:
- Documenting major implementation milestones
- Recording critical problems and their solutions
- Tracking what files were changed and why
- Understanding project history and evolution
- Onboarding new team members

**Update frequency**: After major features, bug fixes, or architectural changes

---

### 📁 **learnings/** - Knowledge Base & Best Practices
**Purpose**: Capture development patterns, mistakes, corrections, and quick decision frameworks

**Files**:
- `development_patterns.md` - Repeated mistakes to avoid, successful patterns, quick decision rules

**When to use**:
- Before making architectural decisions
- Learning from past mistakes
- Quick reference for common patterns
- Understanding "why" behind certain approaches
- Preventing repeated errors

**Update frequency**: When discovering new patterns or making notable mistakes

---

### 📁 **code_reviews/** - Quality Audits & Compliance
**Purpose**: Track architecture compliance, code quality, and technical debt

**Files**:
- `architecture_audit_YYYYMMDD_HHMMSS.md` - Compliance ratings, numerical scoring, status indicators (✅ ⚠️ ❌)

**When to use**:
- Assessing project health
- Checking TDD compliance
- Identifying technical debt
- Planning refactoring efforts
- Stakeholder reporting

**Update frequency**: Weekly or at major milestones

---

### 📁 **plans/** - Implementation Roadmaps
**Purpose**: Define development phases, timelines, and strategic planning

**Files**:
- `development_plan.md` - Original phase-based implementation roadmap
- `adaptive_implementation_plan_v2.md` - Evolved version with adjustments
- `accelerated_implementation_plan_v3.md` - Latest accelerated timeline

**When to use**:
- Understanding project phases and timeline
- Planning sprint work
- Tracking against original estimates
- Adjusting timelines based on progress
- Resource allocation planning

**Update frequency**: At phase transitions or when timelines change

---

### 📁 **frontend_description/** - UI/UX Specifications
**Purpose**: Pixel-perfect UI specifications, design system, responsive breakpoints, component behavior

**Files**:
- `auth_screens.md` - Complete authentication UI specifications (login, register, verification, biometric setup, etc.)
- `dashboard.md` - Dashboard layout, widget specifications, grid system

**When to use**:
- Implementing any UI component
- Understanding exact spacing, colors, typography
- Responsive breakpoint requirements
- Component state behavior (hover, focus, loading, error)
- Design system reference

**Update frequency**: When design requirements change or new screens are added

---

### 📁 **reference/** - External Documentation
**Purpose**: Backend documentation, team coordination, setup scripts

**Files**:
- `backend_documentation.md` - Backend API documentation and service details
- `BACKEND_PROJECT_MEMORY.md` - Backend development progress and memory
- `work_division_timeline.md` - Team work distribution and coordination
- `dev_set_up.py` - Development environment setup scripts

**When to use**:
- Understanding backend services and APIs
- Cross-referencing frontend/backend integration
- Team coordination and task division
- Setting up development environment

**Update frequency**: When backend changes or team structure changes

---

### 📁 **meetings/** - Meeting Notes & Decisions
**Purpose**: Document client meetings, team discussions, and key decisions

**Files**:
- `meeting_YYYYMMDD.md` - Meeting notes with date stamps
- Meeting agendas, action items, and decisions made

**When to use**:
- Recording client feedback and requirements clarifications
- Documenting scope changes and approvals
- Tracking action items and their owners
- Understanding context behind major decisions
- Reference for future disputes or clarifications

**Update frequency**: After each meeting or discussion

---

### 📁 **reports/** - Testing & Analysis Reports
**Purpose**: Detailed testing plans, audit reports, and technical analysis documents

**Files**:
- `AUTOMATED_E2E_TESTING_PLAN.md` - End-to-end testing strategies and implementation
- Testing coverage reports and results
- Performance analysis reports
- Security audit reports

**When to use**:
- Planning testing strategies (unit, integration, E2E)
- Setting up CI/CD pipelines
- Understanding test coverage requirements
- Performance benchmarking and optimization
- Security compliance verification

**Update frequency**: When creating new testing strategies or after major testing milestones

---

### 📁 **summaries/** - Phase Completion Summaries
**Purpose**: Comprehensive summaries of completed development phases with metrics and outcomes

**Files**:
- `PHASE_X_Y_IMPLEMENTATION_SUMMARY.md` - Detailed phase completion reports
- Feature completion checklists
- Code metrics and statistics
- Known issues and follow-up items

**When to use**:
- Reviewing what was accomplished in a phase
- Understanding implementation details and decisions
- Tracking code metrics and quality improvements
- Identifying technical debt for future phases
- Stakeholder reporting and milestone reviews

**Update frequency**: At the end of each development phase or major milestone

---

### 📁 **timeline/** - Project Timeline & Scheduling
**Purpose**: Track project timeline, payment milestones, and schedule adjustments

**Files**:
- `project_timeline_v1.md` - Original project timeline
- `project_timeline_v2.md` - Updated timeline with adjustments
- Payment milestone tracking
- Risk mitigation schedules
- Critical path analysis

**When to use**:
- Understanding project deadlines and milestones
- Planning resource allocation
- Tracking payment schedules
- Managing client expectations
- Adjusting timelines based on progress or blockers
- Identifying critical dependencies

**Update frequency**: When timelines change, milestones are adjusted, or major scope changes occur

---

### 📁 **figma_design/** - Design Assets & UI Components
**Purpose**: Store Figma exports, design assets, and UI component specifications

**Files**:
- `components/` - Exported SVG/PNG components from Figma
- Design system assets (icons, logos, illustrations)
- UI mockups and wireframes
- Brand assets and style guides

**When to use**:
- Implementing UI components
- Referencing exact design specifications
- Extracting icons and visual assets
- Understanding brand guidelines
- Maintaining design consistency

**Update frequency**: When design assets are updated or new designs are created

---

### 📁 **archetechture/** - Architecture Documentation
**Purpose**: System architecture diagrams, data flow documentation, and infrastructure specifications

**Files**:
- System architecture diagrams
- Database schema visualizations
- API architecture documents
- Infrastructure setup guides
- Deployment architecture

**When to use**:
- Understanding system design and component interactions
- Planning infrastructure setup
- Onboarding new developers
- Making architectural decisions
- Documenting technical dependencies

**Update frequency**: When architecture changes or new components are added

---

### 📁 **Others/** - Miscellaneous Documentation
**Purpose**: Storage for documents that don't fit into other categories

**Files**:
- One-off documents
- Temporary analysis files
- External resources and references
- Legacy documents

**When to use**:
- Storing documents that don't fit existing categories
- Temporary storage before proper categorization
- Reference materials from external sources

**Update frequency**: As needed

---

## Root Level Files

### 📄 **Technical Design Document (TDD).md**
**Purpose**: Master technical architecture specification
**When to use**: All architectural decisions, system design, technology stack choices
**Authority**: This is the single source of truth for technical architecture

### 📄 **functional_specs.md**
**Purpose**: Functional requirements and business logic specifications
**When to use**: Understanding feature requirements, business rules, user flows
**Authority**: Defines what the system should do (not how)

