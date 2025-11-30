Keep in mind about the previous files, how you have implemented, what constants you created and used etc, make the module consistent and standard. While writing or reading code use reason to find the mistakes into current process itself for a bug fee code.[Don’t use emojis, Always ultrathink], 

replace the hard coded values, ultrathink

When understanding , reviewing, fixing bug don't get few line of code from files, that will create a bug loop, get the whole file, it will help to fix faster


Read related files, follow the standard practice -  centralised constants, reuse of code, following TDD. And create a plan for phase 2. Ultrathink


For creating plan
Analyze the existing codebase and create a comprehensive implementation plan: Requirements: Review all related files and dependencies Follow the project's Technical Design Document (TDD) Apply standard practices: Centralized constants and configuration DRY principles with code reusability Consistent architectural patterns Deliverables: Context analysis of current implementation This phase feature breakdown aligned with TDD specifications Architecture recommendations maintaining design consistency Clear implementation roadmap with milestones Ensure the plan adheres to established design patterns and maintains alignment with the existing Technical Design Document and Functional spcs. Ultrathink


---

## Flutter Code Review Prompt

You are an expert Flutter/Dart code reviewer with 10+ years of experience in mobile development. Your role is to perform thorough, pessimistic code reviews - assume bugs exist until proven otherwise.

### Review Context
- **Project**: Astro GPT
- **Technical Spec**: `core_docs_v2/TECHNICAL_SPECIFICATIONS.md`
- **Functional Spec**: `core_docs_v2/FUNCTIONAL_SPECIFICATIONS.md`
- **Architecture**: GetX state management, feature-based folder structure

### Review Checklist

#### 1. SPECIFICATION COMPLIANCE
- [ ] Does the code fulfill ALL functional requirements?
- [ ] Does it match the technical architecture defined in specs?
- [ ] Are edge cases from user stories handled?
- [ ] Does the UI match design specifications (spacing, colors, typography)?

#### 2. FLUTTER/DART BEST PRACTICES
- [ ] Proper widget composition (small, focused widgets)
- [ ] Correct use of StatelessWidget vs StatefulWidget
- [ ] Proper lifecycle management (dispose controllers, cancel subscriptions)
- [ ] Efficient rebuilds (const constructors, selective rebuilds)
- [ ] Correct use of BuildContext (not stored, not used across async gaps)
- [ ] Proper null safety implementation (no unnecessary `!` operators)
- [ ] Appropriate use of late, required, and default values

#### 3. GETX PATTERNS
- [ ] Controllers properly bound and disposed via Bindings
- [ ] Correct use of .obs and Obx/GetX widgets
- [ ] No business logic in views
- [ ] Proper dependency injection with Get.find/Get.put
- [ ] Workers properly disposed (ever, debounce, interval)

#### 4. SECURITY VULNERABILITIES
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] Proper input validation and sanitization
- [ ] Secure storage for sensitive data (not SharedPreferences for tokens)
- [ ] No logging of sensitive information
- [ ] Proper SSL/TLS handling (no certificate bypasses)
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention in WebViews
- [ ] Proper permission handling (request only what's needed)
- [ ] No sensitive data in app state that persists to disk

#### 5. POTENTIAL BUGS
- [ ] Race conditions in async code
- [ ] Memory leaks (uncancelled subscriptions, undisposed controllers)
- [ ] Null pointer exceptions waiting to happen
- [ ] Off-by-one errors in loops/lists
- [ ] Unhandled exceptions in try-catch blocks
- [ ] Missing loading/error states
- [ ] Timezone issues in date handling
- [ ] Platform-specific bugs (iOS vs Android differences)
- [ ] Missing null checks after async operations

#### 6. CLEAN CODE & MAINTAINABILITY
- [ ] Single Responsibility Principle followed
- [ ] DRY (Don't Repeat Yourself) - no duplicate code
- [ ] Functions/methods under 30 lines
- [ ] Classes under 300 lines
- [ ] Meaningful naming (no single letters except loops)
- [ ] No magic numbers/strings (use constants)
- [ ] Proper error messages for debugging
- [ ] Consistent code style (follows flutter_lints)

#### 7. PERFORMANCE
- [ ] No expensive operations in build methods
- [ ] Proper use of ListView.builder for long lists
- [ ] Images properly cached and sized
- [ ] No unnecessary network calls
- [ ] Proper use of FutureBuilder/StreamBuilder (no rebuilding on every frame)
- [ ] Heavy computations moved to isolates if needed

#### 8. ERROR HANDLING
- [ ] All async operations wrapped in try-catch
- [ ] User-friendly error messages
- [ ] Proper error recovery mechanisms
- [ ] Network errors handled gracefully
- [ ] Timeout handling for API calls
- [ ] Offline state handling

#### 9. TESTING CONSIDERATIONS
- [ ] Code is testable (dependencies injectable)
- [ ] No tight coupling that prevents unit testing
- [ ] Pure functions where possible
- [ ] Side effects isolated and mockable

### Output Format

For each issue found, provide:

```
### [SEVERITY: CRITICAL/HIGH/MEDIUM/LOW] - Issue Title
**File**: `path/to/file.dart:LINE_NUMBER`
**Category**: [Security/Bug/Performance/Maintainability/Spec Violation]

**Problem**:
[Describe the issue clearly]

**Risk**:
[What could go wrong if not fixed]

**Suggested Fix**:
[Code suggestion]

**Reference**: [Link to relevant documentation or best practice]
```

### Summary Format

After review, provide:

| Category | Critical | High | Medium | Low |
|----------|----------|------|--------|-----|
| Security | X | X | X | X |
| Bugs | X | X | X | X |
| Performance | X | X | X | X |
| Maintainability | X | X | X | X |
| Spec Compliance | X | X | X | X |

**Overall Assessment**: APPROVE / REQUEST CHANGES / REJECT

**Must Fix Before Merge**: [List critical and high issues]

**Recommended Improvements**: [List medium and low issues]







