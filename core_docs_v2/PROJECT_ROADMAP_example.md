# Project Roadmap
## Manson Safety Report Generator

**Timeline:** 8-10 weeks
**Budget:** $7,000 - $9,000 CAD
**Team:** 2 Full-Stack Developers

---

## DEVELOPMENT PHASES

### Phase 1: Core MVP (Weeks 1-10)
Chemical and Noise report generation with PDF parsing

### Phase 2: Enhancements (Post-Launch)
Statistical analysis, additional features (future scope)

---

## WEEK-BY-WEEK BREAKDOWN

### **Week 1-2: Foundation & Authentication**

**Backend Tasks (Developer 1):**
- [ ] Setup FastAPI project structure
- [ ] Configure PostgreSQL database
- [ ] Implement database schema (users, reports, samples, etc.)
- [ ] Build authentication system (JWT)
- [ ] Create user registration endpoint
- [ ] Create login endpoint
- [ ] Create password reset endpoint
- [ ] Setup AWS S3 / Cloudinary for file storage
- [ ] Configure environment variables
- [ ] Write database migration scripts (Alembic)

**Frontend Tasks (Developer 2):**
- [ ] Setup Next.js 14 project (App Router)
- [ ] Configure TypeScript and ESLint
- [ ] Setup Tailwind CSS
- [ ] Implement shadcn/ui components
- [ ] Create authentication pages (login, register, reset password)
- [ ] Build main layout (header, sidebar, navigation)
- [ ] Create dashboard page (empty state)
- [ ] Setup React Query for API integration
- [ ] Configure routing

**Deliverable:** Users can register, login, and see dashboard

**Hours:** 80 hours (40h × 2 developers)

---

### **Week 3-4: Chemical Report Data Entry & PDF Upload**

**Backend Tasks (Developer 1):**
- [ ] Create reports table and API endpoints (CRUD)
- [ ] Implement PDF upload endpoint
- [ ] Integrate Claude API for PDF extraction
- [ ] Create samples table and endpoints
- [ ] Build data validation logic
- [ ] Implement OEL database seeding
- [ ] Create endpoint to retrieve extracted data
- [ ] Create endpoint to update extracted data

**Frontend Tasks (Developer 2):**
- [ ] Build "New Chemical Report" form:
  - [ ] Project information step
  - [ ] PDF upload step with drag-and-drop
  - [ ] Data review step (editable tables using TanStack Table)
  - [ ] Observations entry step
  - [ ] Photo upload step
- [ ] Implement React Hook Form with Zod validation
- [ ] Create progress indicator for multi-step form
- [ ] Build editable data table component
- [ ] Implement auto-save functionality
- [ ] Add loading states and error handling

**Deliverable:** User can create chemical report, upload PDF, review extracted data

**Hours:** 100 hours (50h × 2 developers)

---

### **Week 5: AI Integration & Calculations**

**Backend Tasks (Developer 1):**
- [ ] Setup Pinecone vector database
- [ ] Build RAG knowledge base:
  - [ ] Store O. Reg 833 sections
  - [ ] Store O. Reg 490/09 sections
  - [ ] Store NIOSH method details
  - [ ] Store example report sections
- [ ] Create embeddings for regulations
- [ ] Build retrieval function
- [ ] Implement TWA calculation function
- [ ] Implement OEL comparison logic
- [ ] Create compliance checking function
- [ ] Build AI text generation endpoints:
  - [ ] Executive summary
  - [ ] Introduction
  - [ ] Discussion
  - [ ] Recommendations
- [ ] Implement content validation logic
- [ ] Add retry mechanism for AI failures

**Frontend Tasks (Developer 2):**
- [ ] Build report preview interface
- [ ] Create section-by-section review UI
- [ ] Add "Generate" buttons for AI sections
- [ ] Add "Regenerate" functionality
- [ ] Implement text editor for manual edits
- [ ] Show loading states during AI generation
- [ ] Display validation warnings

**Deliverable:** System calculates TWAs, generates AI content, user can review

**Hours:** 120 hours (60h × 2 developers)

---

### **Week 6-7: Report PDF Generation**

**Backend Tasks (Developer 1):**
- [ ] Integrate CraftMyPDF API
- [ ] Create report template in CraftMyPDF dashboard:
  - [ ] Cover page layout
  - [ ] Table of contents
  - [ ] All section layouts
  - [ ] Table styles
  - [ ] Chart configurations
- [ ] Build chart data preparation logic
- [ ] Create endpoint to generate final PDF
- [ ] Implement chart generation (Victory for server-side)
- [ ] Handle appendices (photos, raw lab results)
- [ ] Add page numbering and headers/footers

**Frontend Tasks (Developer 2):**
- [ ] Build report preview with chart visualization (Recharts)
- [ ] Create download button
- [ ] Implement report status tracking
- [ ] Build report list page showing all reports
- [ ] Add filter/search for reports
- [ ] Create report detail view
- [ ] Add edit functionality for existing reports

**Deliverable:** User can generate and download professional PDF reports

**Hours:** 100 hours (50h × 2 developers)

---

### **Week 8: Noise Reports**

**Backend Tasks (Developer 1):**
- [ ] Create noise dosimetry table
- [ ] Create CSV import endpoint
- [ ] Build CSV parser for Quest Edge 5 format
- [ ] Create noise time series table
- [ ] Create spot measurements table
- [ ] Create equipment measurements table
- [ ] Build endpoints for noise data entry
- [ ] Adapt AI generation for noise reports
- [ ] Create time-series graph generation

**Frontend Tasks (Developer 2):**
- [ ] Build "New Noise Report" form:
  - [ ] Project info step
  - [ ] CSV upload step
  - [ ] Dosimetry data review
  - [ ] Spot measurements entry (table)
  - [ ] Equipment measurements entry
  - [ ] Observations
  - [ ] Photos
- [ ] Implement CSV file upload with preview
- [ ] Create time-series chart component (Recharts)
- [ ] Build editable tables for spot/equipment measurements
- [ ] Integrate noise report template in CraftMyPDF

**Deliverable:** User can create noise reports with dosimeter import

**Hours:** 100 hours (50h × 2 developers)

---

### **Week 9: Testing & Bug Fixes**

**Both Developers (Parallel Tasks):**
- [ ] End-to-end testing of complete workflows
- [ ] Test with real lab reports provided by client
- [ ] Verify TWA calculations against manual calculations
- [ ] Test AI generation quality
- [ ] Verify PDF output matches template examples
- [ ] Cross-browser testing (Chrome, Firefox, Safari)
- [ ] Mobile responsiveness testing
- [ ] Performance optimization
- [ ] Fix identified bugs
- [ ] Security review
- [ ] Code cleanup and refactoring

**Client Testing:**
- [ ] Client tests with real data
- [ ] Client provides feedback on AI quality
- [ ] Client approves PDF styling
- [ ] Client verifies calculation accuracy

**Deliverable:** Production-ready system with no critical bugs

**Hours:** 80 hours (40h × 2 developers)

---

### **Week 10: Deployment & Documentation**

**Backend Tasks (Developer 1):**
- [ ] Deploy FastAPI to Railway/Render
- [ ] Configure production database
- [ ] Setup database backups
- [ ] Configure file storage (S3/Cloudinary)
- [ ] Setup monitoring (error tracking)
- [ ] Configure API rate limits
- [ ] Setup SSL certificates
- [ ] Run security scan
- [ ] Load production data (OEL database, NIOSH methods)

**Frontend Tasks (Developer 2):**
- [ ] Deploy Next.js to Vercel
- [ ] Configure production environment variables
- [ ] Setup custom domain (if provided)
- [ ] Optimize bundle size
- [ ] Configure CDN for assets
- [ ] Setup analytics (optional)

**Documentation (Both):**
- [ ] Write user manual:
  - [ ] How to create chemical reports
  - [ ] How to upload lab reports
  - [ ] How to create noise reports
  - [ ] How to review AI content
  - [ ] How to download reports
- [ ] Create video tutorial (screen recording)
- [ ] Write technical documentation for maintenance
- [ ] Document API endpoints
- [ ] Create troubleshooting guide

**Client Handover:**
- [ ] Training session with client (2 hours)
- [ ] Walkthrough of all features
- [ ] Q&A session
- [ ] Provide credentials and access
- [ ] Share documentation

**Deliverable:** Live production system, trained client, complete documentation

**Hours:** 60 hours (30h × 2 developers)

---

## TIMELINE SUMMARY

| Week | Focus Area | Hours | Cumulative |
|------|------------|-------|------------|
| 1-2 | Foundation & Auth | 80h | 80h |
| 3-4 | Data Entry & PDF Upload | 100h | 180h |
| 5 | AI & Calculations | 120h | 300h |
| 6-7 | PDF Report Generation | 100h | 400h |
| 8 | Noise Reports | 100h | 500h |
| 9 | Testing & Fixes | 80h | 580h |
| 10 | Deployment & Docs | 60h | 640h |

**Total Development Time:** 640 hours (320h per developer)

**At 40 hours/week per developer:** 8 weeks minimum
**Buffer for delays/revisions:** +2 weeks
**Total Timeline:** **8-10 weeks**

---

## RISK MITIGATION TIMELINE

### High-Risk Items (Addressed Early)

**Week 3: PDF Parsing Validation**
- Test Claude API with all client-provided lab reports
- Identify parsing issues early
- Adjust extraction prompts if needed

**Week 5: AI Quality Review**
- Client reviews AI-generated content samples
- Adjust prompts based on feedback
- Ensures quality before proceeding

**Week 7: PDF Output Approval**
- Client approves generated PDF styling
- Make adjustments before noise reports
- Prevents rework later

---

## DEPENDENCIES & CRITICAL PATH

```mermaid
Week 1-2: Foundation
    ↓
Week 3-4: Data Entry ← Must complete before Week 5
    ↓
Week 5: AI Integration ← Needs data structure from Week 3-4
    ↓
Week 6-7: PDF Generation ← Needs AI content from Week 5
    ↓
Week 8: Noise Reports ← Can leverage patterns from chemical reports
    ↓
Week 9: Testing ← Needs all features complete
    ↓
Week 10: Deployment
```

**Critical Path:**
Foundation → Data Entry → AI Integration → PDF Generation

**Parallel Workstreams:**
- Noise reports (Week 8) can start earlier if chemical reports finish early
- Documentation can start in Week 7

---

## WEEKLY DEMO SCHEDULE

### Week 2 Demo
**What Client Can Test:**
- Login to system
- See dashboard
- Navigate interface

### Week 4 Demo
**What Client Can Test:**
- Create new chemical report
- Upload PDF lab report
- Review extracted data
- Enter observations

### Week 6 Demo
**What Client Can Test:**
- See AI-generated report sections
- Edit AI content
- Preview report structure

### Week 7 Demo
**What Client Can Test:**
- Download complete PDF report
- Verify calculations
- Check PDF styling

### Week 8 Demo
**What Client Can Test:**
- Create noise report
- Upload dosimeter CSV
- See time-series graphs

### Week 10 Demo
**What Client Can Test:**
- Full production system
- Final walkthrough
- Training

---

## POST-LAUNCH ROADMAP (Optional Phase 2)

### Month 2-3 (After Launch)

**Enhancements (Based on Usage Feedback):**
- [ ] Statistical analysis integration (Bayesian statistics)
- [ ] Support for additional laboratory formats
- [ ] NIOSH method auto-lookup (web scraping)
- [ ] Advanced OEL database (more chemicals)
- [ ] Report templates customization

**Estimated Effort:** 4-6 weeks, $3,000-5,000 CAD

### Month 4-6 (Growth Features)

**Advanced Features:**
- [ ] Multi-user team accounts
- [ ] Client portal (read-only report access)
- [ ] Report comparison tools
- [ ] Batch processing
- [ ] Custom branding per company

**Estimated Effort:** 6-8 weeks, $5,000-8,000 CAD

---

## RESOURCE ALLOCATION

### Developer 1 (Backend Specialist)
**Skills Required:**
- Python, FastAPI
- PostgreSQL, SQLAlchemy
- AI API integration (Claude, OpenAI)
- PDF processing
- Vector databases

**Weekly Commitment:** 40 hours/week

### Developer 2 (Frontend Specialist)
**Skills Required:**
- Next.js, TypeScript, React
- Tailwind CSS, shadcn/ui
- Form handling (React Hook Form)
- Chart libraries (Recharts, Victory)
- PDF preview/generation

**Weekly Commitment:** 40 hours/week

---

## CLIENT RESPONSIBILITIES

### Before Development Starts:
- [ ] Provide 5 sample lab reports (PDF) from different laboratories
- [ ] Provide 3 completed reports as quality benchmarks
- [ ] Provide company logo and branding assets
- [ ] Specify the 2-3 priority laboratory formats to support
- [ ] Provide API keys budget for Claude/OpenAI (or billing info)

### During Development:
- [ ] Weekly progress reviews (30 minutes)
- [ ] Provide feedback on demos
- [ ] Review and approve AI-generated content (Week 5)
- [ ] Approve PDF styling (Week 7)
- [ ] Participate in testing (Week 9)

### At Launch:
- [ ] Attend training session (2 hours)
- [ ] Test with real client project
- [ ] Provide final approval

---

## SUCCESS METRICS (3 Months Post-Launch)

### Efficiency Metrics:
- [ ] Report generation time reduced from 8 hours to < 1 hour
- [ ] 90%+ of lab reports parsed successfully
- [ ] User creates 10+ reports in first month

### Quality Metrics:
- [ ] 95%+ user satisfaction with AI content quality
- [ ] Zero calculation errors
- [ ] Generated PDFs match professional quality

### Business Metrics:
- [ ] Reduce report backlog from 4 weeks to < 1 week
- [ ] Increase report capacity by 2-3x
- [ ] Client satisfaction with faster turnaround

---

## CONTINGENCY PLANS

### If Week 3-4 PDF Parsing Issues:
- **Fallback:** Prioritize manual data entry, defer parsing to Phase 2
- **Timeline Impact:** None (manual entry already planned)

### If Week 5 AI Quality Issues:
- **Fallback:** Provide more example reports, refine prompts
- **Timeline Impact:** +1 week for prompt iteration

### If Week 7 PDF Generation Delays:
- **Fallback:** Use simpler template, enhance in Phase 2
- **Timeline Impact:** None if simplified approach accepted

### If Budget Overrun:
- **Mitigation:**
  - Defer statistical analysis to Phase 2
  - Use simpler PDF template (no CraftMyPDF, build custom)
  - Reduce number of supported lab formats to 1-2

---

## PAYMENT MILESTONES

| Milestone | Deliverable | Payment | Due Date |
|-----------|-------------|---------|----------|
| **M1: Foundation** | Auth system, database, basic UI | 20% ($1,400-1,800) | End of Week 2 |
| **M2: Data Entry** | Forms working, PDF extraction | 25% ($1,750-2,250) | End of Week 4 |
| **M3: AI & Reports** | AI generation, PDF output | 30% ($2,100-2,700) | End of Week 7 |
| **M4: Launch** | Noise reports, testing, deployment | 25% ($1,750-2,250) | End of Week 10 |

**Total:** 100% ($7,000-9,000 CAD)

**Payment Terms:** Net 7 days upon milestone completion and approval

---

## TOOLS & INFRASTRUCTURE COSTS

### One-Time Setup:
- Domain name: $15/year
- SSL certificate: Free (Let's Encrypt)

### Monthly Operating Costs:
| Service | Cost | Required |
|---------|------|----------|
| Vercel (Frontend) | $0-20 | Yes |
| Railway/Render (Backend) | $5-20 | Yes |
| PostgreSQL | Included | Yes |
| AWS S3 / Cloudinary | $5-10 | Yes |
| Pinecone Vector DB | $0-70 (free tier available) | Yes |
| CraftMyPDF | $29-99 | Phase 1 only |
| **Subtotal** | **$39-219/month** | |
| **Without CraftMyPDF (Phase 2)** | **$10-120/month** | |

### Per-Report AI Costs:
- Claude PDF parsing: $0.05-0.10
- Claude text generation (cached): $0.006
- **Total per report: ~$0.056-0.106**

**At 50 reports/month:** $2.80-5.30/month in AI costs

**Total Monthly Operating Cost:** $42-224/month

---

## QUALITY GATES

### Gate 1 (Week 2): Technical Foundation
**Criteria:**
- ✅ All developers can run project locally
- ✅ Database schema reviewed and approved
- ✅ Authentication working
- ✅ User can login successfully

### Gate 2 (Week 4): Data Extraction
**Criteria:**
- ✅ Claude API successfully extracts data from test PDFs
- ✅ Extraction accuracy > 90% for supported labs
- ✅ User can review and correct data
- ✅ Client approves data extraction quality

### Gate 3 (Week 6): AI Content Quality
**Criteria:**
- ✅ AI-generated executive summary passes client review
- ✅ Recommendations cite correct regulations
- ✅ Discussion section is factually accurate
- ✅ Tone matches professional standards
- ✅ Client approves AI quality

### Gate 4 (Week 7): PDF Output
**Criteria:**
- ✅ Generated PDF matches template styling
- ✅ Charts display correctly
- ✅ Tables formatted properly
- ✅ Calculations verified accurate
- ✅ Client approves final PDF quality

### Gate 5 (Week 10): Production Ready
**Criteria:**
- ✅ System deployed and accessible
- ✅ No critical bugs
- ✅ Performance meets requirements
- ✅ Documentation complete
- ✅ Client trained and satisfied

---

## COMMUNICATION PLAN

### Weekly Standups (30 minutes)
- **When:** Every Monday 10am EST
- **Who:** 2 Developers + Client (Niclas/Subashis)
- **Format:** What was completed, what's next, blockers

### Bi-Weekly Demos (1 hour)
- **When:** Every other Friday 2pm EST
- **Format:** Live demo of new features, client feedback

### Slack/WhatsApp Channel
- **Purpose:** Daily updates, quick questions
- **Response Time:** Within 4 hours during business hours

---

## DEFINITION OF DONE

### For Each Feature:
- [ ] Code complete and tested
- [ ] Unit tests written (backend)
- [ ] Integration tests pass
- [ ] Code reviewed by other developer
- [ ] Deployed to staging environment
- [ ] Client demo completed
- [ ] Feedback incorporated
- [ ] Documentation updated

### For Each Milestone:
- [ ] All features complete
- [ ] All tests passing
- [ ] Client approval received
- [ ] Payment processed
- [ ] Ready for next milestone

---

## TECHNICAL DEBT TRACKING

### Acceptable Debt in Phase 1:
- Simplified statistical analysis (defer to Phase 2)
- Limited lab format support (2-3 labs only)
- Basic error handling (enhance later)
- Minimal admin features

### Must Avoid:
- Security vulnerabilities
- Data loss risks
- Calculation errors
- Poor AI quality

---

## HANDOVER & TRAINING PLAN

### Week 10 - Day 1-2: System Walkthrough
- [ ] Login and navigation
- [ ] Creating chemical reports
- [ ] Uploading lab reports
- [ ] Reviewing extracted data
- [ ] Entering observations
- [ ] Reviewing AI content
- [ ] Generating final PDFs

### Week 10 - Day 3: Advanced Features
- [ ] Creating noise reports
- [ ] Importing dosimeter data
- [ ] Editing existing reports
- [ ] Understanding calculations

### Week 10 - Day 4: Troubleshooting
- [ ] Common error messages
- [ ] What to do if PDF extraction fails
- [ ] How to improve AI output
- [ ] When to contact support

### Week 10 - Day 5: Go-Live
- [ ] Client creates first production report
- [ ] Monitor for any issues
- [ ] Provide immediate support

---

## POST-LAUNCH SUPPORT

### Month 1 (Included in Budget):
- Bug fixes (critical issues)
- Performance issues
- Email/Slack support (response within 24 hours)

### Month 2-3 (Optional Support Contract):
- $500/month retainer
- 5 hours support included
- Additional features quoted separately

---

## VERSION CONTROL & RELEASES

### Version Numbering:
- **v1.0:** Initial launch (Week 10)
- **v1.1:** Bug fixes and minor enhancements (Month 2)
- **v2.0:** Statistical analysis and Phase 2 features (Month 3-4)

### Release Process:
1. Development → Staging → Client Testing → Production
2. Tagged releases in GitHub
3. Release notes for each version
4. Database migration scripts

---

## EXIT CRITERIA

### Phase 1 Complete When:
✅ All acceptance criteria met
✅ Client can generate both chemical and noise reports
✅ Client approves PDF quality
✅ System is deployed and stable
✅ Documentation delivered
✅ Training completed
✅ Final payment received

### Ready for Phase 2 When:
✅ Client has used system for 1 month
✅ Client provides feedback on enhancement priorities
✅ Budget approved for Phase 2
✅ No critical bugs outstanding

---

**END OF PROJECT ROADMAP**
