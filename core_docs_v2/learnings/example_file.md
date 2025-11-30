# Development Patterns - Key Learnings

## Repeated Mistakes & Corrections

### 1. Creating New Constants Files
**Mistake:** Making new constant files instead of using existing ones.
**Fix:** Always check `app_constants.dart`, `duration_constants.dart` first. Extend existing files.

### 2. Hardcoded Strings
**Mistake:** Using quoted strings for events, status, actions.
**Fix:** Every string goes in centralized constants. No exceptions.

### 3. Ignoring TDD Structure
**Mistake:** Creating folders without checking TDD document structure.
**Fix:** Reference TDD Section 1.3 before any core infrastructure. Match exactly.

### 4. Platform-Specific Implementation
**Mistake:** Building desktop-only or mobile-only solutions.
**Fix:** Always ask "How will this work on the other platform?" Create adaptive abstractions.

### 5. Runtime Dependency Resolution
**Mistake:** Using Service Locator pattern with runtime crashes.
**Fix:** Use Riverpod providers for compile-time safety.

## Quick Decision Rules

**Before coding anything:**
- Check TDD document structure
- Check existing constants files
- Consider both desktop and mobile
- Write tests first
- Update memory after major changes

**If unsure, check existing patterns first.**

## Successful Development Patterns

### 1. Centralized Constants Architecture
**Pattern:** All values in organized constant files following strict organization.
**Files:** app_dimensions.dart (sizes), app_constants.dart (strings/behaviors), app_colors.dart (colors), duration_constants.dart (timings)
**Result:** Single point of change, design token integration ready, 6x development velocity

### 2. TDD Structure Compliance
**Pattern:** Follow TDD document file organization exactly before creating new infrastructure.
**Result:** Consistent architecture, predictable code organization, team scalability

### 3. Adaptive Architecture Design
**Pattern:** Platform-agnostic business logic with responsive presentation layers.
**Result:** Zero refactoring mobile transition, consistent user experience

### 4. Progressive TDD Adoption
**Pattern:** Implement TDD patterns based on project scale and immediate value.
**Result:** Appropriate complexity, fast delivery, upgrade path maintained