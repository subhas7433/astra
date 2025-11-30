# Functional Specifications
## Manson Safety Report Generator

**Version:** 1.0
**Date:** October 27, 2025
**Client:** Manson Methods Inc.
**Project Budget:** $7,000 - $9,000 CAD
**Timeline:** 8-10 weeks

---

## 1. PROJECT OVERVIEW

### 1.1 Purpose
Build a web-based software application that automates the generation of industrial hygiene assessment reports, reducing report creation time from 8-10 hours to near-automated generation.

### 1.2 Business Problem
- Current manual report generation takes 8-10 hours per report
- 4-week lead time for client report delivery (industry standard)
- Manual data entry from PDF lab reports is time-consuming and error-prone
- Need competitive advantage through faster turnaround

### 1.3 Solution
Software that:
1. Accepts PDF lab reports and extracts data automatically
2. Accepts manual inputs for observations and project details
3. Generates professional consultant reports using AI
4. Produces visually appealing PDF output matching existing report templates

### 1.4 Success Criteria
- Reduce report generation time from 8-10 hours to under 1 hour
- Support multiple laboratory report formats (minimum 2-3 labs)
- Generate reports matching the quality of existing manual reports
- 90%+ accuracy in data extraction from PDF lab reports
- User can review and approve all AI-generated content before finalizing

---

## 2. REPORT TYPES

### 2.1 Chemical Exposure Assessment Reports (Phase 1 - PRIORITY)
Professional reports documenting worker exposure to chemical hazards (e.g., silica, benzene, welding fume)

### 2.2 Noise Exposure Assessment Reports (Phase 1 - INCLUDED)
Professional reports documenting worker exposure to noise hazards

---

## 3. USER ROLES

### 3.1 Primary User: Industrial Hygienist
**Profile:**
- Certified Industrial Hygienist (CIH) / Registered Occupational Hygienist (ROH)
- Conducts on-site exposure assessments
- Receives lab reports via PDF
- Creates consultant reports for clients

**Needs:**
- Upload PDF lab reports
- Enter field observations
- Add photos from site visits
- Generate professional reports quickly
- Edit/review AI-generated content before finalizing
- Download final PDF reports

---

## 4. CORE FEATURES

### 4.1 User Authentication
**FR-001:** System shall provide user registration and login
**FR-002:** System shall use secure authentication (JWT tokens)
**FR-003:** System shall allow password reset functionality

### 4.2 Lab Report Upload (PDF and Excel)
**FR-004:** System shall accept PDF file uploads (max 32MB, max 100 pages)
**FR-004a:** System shall accept Excel file uploads (.xlsx, .xls, max 10MB)
**FR-005:** System shall support SGS Galson laboratory report format (PDF and Excel)
**FR-006:** System shall support EMSL Analytical laboratory report format (PDF and Excel)
**FR-006a:** System shall support Bureau Veritas laboratory report format (PDF and Excel)
**FR-007:** System shall automatically extract data from uploaded PDF lab reports:
- Client company name
- Site name and location
- Date sampled
- Date analyzed
- Chemical/analyte names
- Sample IDs
- Concentration values
- Air volumes
- Flow rates
- Sample durations
- Detection limits
- Analysis methods
- Collection media

**FR-007a:** System shall automatically extract data from uploaded Excel lab reports with same data fields as FR-007

**FR-008:** System shall handle special cases in lab reports (both PDF and Excel):
- Values below detection limit (e.g., "<5.0", "ND", "BDL")
- Multiple analytes per sample
- Multiple samples per employee
- Area samples vs personal samples

**FR-009:** System shall display extracted data for user review and correction

### 4.3 Manual Data Entry

#### 4.3.1 Project Information
**FR-010:** System shall allow user to enter:
- Client company name (if not auto-extracted)
- Site name and address
- Assessment date
- Shift length (dropdown: 4hr, 8hr, 10hr, 12hr, 16hr) - default 8hr
- Regulatory standard to compare against (dropdown: O. Reg 833/Ontario, ACGIH)
- Consulting company name (default: Manson Methods Inc.)
- Report author name and credentials

#### 4.3.2 Sample Details
**FR-011:** System shall allow user to enter/edit:
- Employee names
- Job titles
- Sample locations
- Sample types (personal vs area)
- Break times (for TWA calculation)

#### 4.3.3 Observations
**FR-012:** System shall allow user to enter:
- General field notes
- Facility operations description
- Work practices observed
- Control measures observed (engineering, administrative, PPE)
- Equipment-specific observations

#### 4.3.4 Photos
**FR-013:** System shall allow user to upload photos
**FR-014:** System shall allow user to add captions to photos
**FR-015:** Photos shall be included in Appendix A of generated report

### 4.4 Automated Calculations

#### 4.4.1 Chemical Report Calculations
**FR-016:** System shall calculate Time Weighted Average (TWA) using formula:
```
TWA = (Concentration × Sampled_Time + 0 × Break_Time) / Shift_Length_Minutes
```
Where Shift_Length_Minutes is based on user-selected shift length (240, 480, 600, 720, or 960 minutes)

**FR-017:** System shall handle multiple samples per employee

**FR-018:** System shall compare TWA to Occupational Exposure Limits (OEL) based on user-selected regulatory standard:
- Option 1: O. Reg 833 (Ontario)
- Option 2: ACGIH TLV (American)

**FR-019:** System shall determine compliance status (above/below OEL)

**FR-020:** System shall calculate Additive Effect for chemicals affecting the same target organ:
```
Em = (C1/L1) + (C2/L2) + ... + (Cn/Ln)
```
Where:
- Cn = Measured concentration of substance n
- Ln = OEL for substance n
- Em = Combined exposure index

**FR-021:** If Em > 1.0, system shall flag as "combined exposure exceeds acceptable limit"

**FR-022:** AI shall identify chemicals affecting the same target organ and automatically calculate additive effects

**FR-023:** Additive effect results shall be included in Discussion and Recommendations sections

#### 4.4.2 Noise Report Calculations
**FR-024:** System shall accept dosimeter data (Lex, TWA, Dose %)
**FR-025:** System shall compare noise exposure to regulatory limit based on user-selected standard:
- Option 1: 85 dBA (O. Reg 381/15 - Ontario)
- Option 2: 90 dBA (ACGIH TLV - American)
**FR-026:** System shall determine compliance status for noise exposure
**FR-027:** System shall adjust noise dose calculations based on selected shift length (4hr, 8hr, 10hr, 12hr, 16hr)

### 4.5 AI-Generated Content

**FR-028:** System shall use AI to generate the following report sections:

#### Executive Summary
- Who retained whom for what purpose
- Assessment date and location
- List of contaminants sampled
- Brief summary of methods
- Brief summary of results
- Discussion and recommendations preview

#### Introduction
- Consulting company retained
- Purpose of assessment
- Assessment date and location
- Contaminants being sampled
- Facility operations overview (optional: leverage internet research on site)

#### Methods Section
- NIOSH methods used (auto-populated based on chemical name)
- Equipment specifications (pumps, flow rates, sampling media)
- Number of workers sampled with job titles and locations
- Laboratory accreditations

#### Discussion
- Explanation of results findings
- Comparison of TWA to OEL for each sample
- Interpretation of compliance status
- Contributing factors to exposures

#### Recommendations
- Based on Hierarchy of Controls framework:
  - Elimination
  - Substitution
  - Engineering controls
  - Administrative controls
  - Personal protective equipment (PPE)
- Cite relevant legislation (O. Reg 833, O. Reg 490/09 for chemicals; O. Reg 381/15 for noise)
- Specific control measures based on results

**FR-024:** User shall review and approve all AI-generated content before finalizing report
**FR-025:** User shall be able to edit any AI-generated text
**FR-026:** User shall be able to regenerate individual sections if unsatisfied

### 4.6 Report Generation

**FR-027:** System shall generate PDF reports matching the provided template examples
**FR-027a:** System shall generate Word/DOCX reports with identical content to PDF version
**FR-028:** Generated reports shall include:

#### Chemical Exposure Report Sections:
1. Cover page (with site photo if provided)
2. Table of Contents
3. Executive Summary
4. Introduction
5. Methods (with equipment table)
6. Observations
7. Results (with tables and bar charts)
8. Statistical Analysis (Phase 2)
9. Discussion
10. Recommendations
11. Appendix A - Pictures with captions
12. Appendix B - Raw Lab Results (attach original PDF)
13. Appendix E - Legislation

#### Noise Exposure Report Sections:
1. Cover page
2. Table of Contents
3. Executive Summary
4. Introduction
5. Methods
6. Observations
7. Results (with tables and time-series graphs)
8. Statistical Analysis (Phase 2)
9. Discussion
10. Recommendations
11. Appendix A - Pictures
12. Appendix B - Raw Dosimeter Data

**FR-029:** System shall generate visual charts:
- Bar charts comparing TWA to OEL (green bars = compliant, red bars = exceedance)
- Time-series graphs for noise dosimetry data
- Equipment table showing contaminant, pump/flow rate, sample media, analysis method

**FR-030:** System shall generate professional tables:
- Results table with Employee Name, Job Title, Sample ID, TWA, OEL columns
- Spot measurement tables (for noise reports)
- Equipment measurements table

**FR-031:** Reports shall include disclaimer text (provided by client)

### 4.7 Report Management

**FR-032:** User shall be able to view list of all created reports
**FR-033:** User shall be able to download generated PDF reports
**FR-034:** User shall be able to edit and regenerate existing reports
**FR-035:** System shall save report drafts automatically

### 4.8 CSV Import (Noise Reports)

**FR-036:** System shall accept CSV file uploads from Quest Edge 5 dosimeters
**FR-037:** System shall parse and import:
- Employee identifier
- Lex (dBA)
- TWA (dBA)
- Dose %
- Peak level
- Time-stamped measurements (for graphs)
- Sample duration

**FR-038:** System shall display imported dosimeter data for review/correction

---

## 5. DETAILED FEATURE SPECIFICATIONS

### 5.1 Chemical Exposure Report Workflow

**Step 1: Create New Chemical Report**
1. User clicks "New Chemical Report"
2. System displays project information form

**Step 2: Upload Lab Report PDF**
1. User uploads PDF lab report
2. System extracts data automatically
3. System displays extracted data in editable tables
4. User reviews and corrects any errors

**Step 3: Enter Manual Information**
1. User enters observations
2. User uploads photos with captions
3. User confirms sampling methods (auto-populated from chemical names)

**Step 4: Generate Report**
1. System calculates all TWAs
2. System compares to OELs
3. System retrieves relevant regulations (RAG)
4. System generates AI text for all sections
5. System displays preview of generated report

**Step 5: Review and Edit**
1. User reviews each section
2. User can edit any text
3. User can regenerate individual sections
4. User approves final content

**Step 6: Download Report**
1. System generates final PDF
2. User downloads professional report
3. System saves report to project history

### 5.2 Noise Exposure Report Workflow

**Step 1: Create New Noise Report**
1. User clicks "New Noise Report"
2. System displays project information form

**Step 2: Import Dosimeter Data**
1. User uploads CSV file from Quest Edge 5
2. System parses dosimeter data
3. System displays imported data in table
4. User reviews and confirms

**Step 3: Enter Spot Measurements**
1. User enters spot sound level measurements (location, time, dBA)
2. User enters equipment measurements
3. User enters observations

**Step 4: Upload Photos**
1. User uploads site photos
2. User adds captions

**Step 5: Generate Report**
1. System generates time-series graphs from dosimeter data
2. System compares Lex to 85 dBA limit
3. System generates AI text for all sections
4. System displays preview

**Step 6: Review and Download**
1. User reviews and edits as needed
2. User downloads final PDF

---

## 6. DATA REQUIREMENTS

### 6.1 Chemical Report - Required Data

**From Lab Report PDF (Auto-Extracted):**
- Laboratory name
- Client company
- Site name/address
- Date sampled
- Date analyzed
- Sample ID
- Employee name (if personal sample)
- Analyte name
- Concentration value
- Unit (mg/m³)
- Air volume
- Flow rate
- Sample duration
- Detection limit
- Analysis method
- Collection media
- Laboratory accreditations

**User-Provided (Manual Entry):**
- Consulting company name
- Report author credentials
- Assessment purpose
- Job titles for sampled employees
- Break times
- Facility operations description
- Observations (field notes, control measures)
- Photos with captions

### 6.2 Noise Report - Required Data

**From Dosimeter CSV (Auto-Imported):**
- Employee identifier
- Lex (dBA)
- TWA (dBA)
- Dose %
- Time-stamped measurements

**User-Provided (Manual Entry):**
- Employee names and job titles
- Spot sound level measurements (location, time, dBA)
- Equipment measurements (equipment name, sound level)
- Job duty descriptions
- Observations
- Photos with captions

---

## 7. OUTPUT REQUIREMENTS

### 7.1 PDF Report Format

**FR-039:** Reports shall be generated as PDF files
**FR-040:** PDFs shall match the style and format of provided template examples
**FR-041:** Reports shall include:
- Professional cover page with site photo (if provided)
- Consistent fonts and styling
- Page numbers
- Headers and footers
- Table of contents with page numbers
- Color-coded compliance tables (green = compliant, red = exceedance)

### 7.2 Visual Elements

**FR-042:** Bar charts shall:
- Display TWA values as bars
- Show OEL as reference line
- Use green color for values below OEL
- Use red color for values at or above OEL
- Include axis labels and units

**FR-043:** Time-series graphs (noise) shall:
- Display dBA values over time (x-axis = time, y-axis = dBA)
- Show 85 dBA reference line
- Include date/time labels

**FR-044:** Tables shall:
- Include all required columns per section
- Use consistent formatting
- Include units in headers
- Color-code compliance status

**FR-045:** Methods section shall include visual table showing:
- Contaminant name
- Pump & Flow Rate
- Sample Media
- Analysis Method

---

## 8. AI REQUIREMENTS

### 8.1 AI Model Selection

**FR-046:** System shall support multiple AI providers:
- Claude (Anthropic)
- GPT (OpenAI)
- Gemini (Google)

**FR-047:** System shall allow configuration of which AI provider to use

### 8.2 AI Content Generation Quality

**FR-048:** AI-generated text shall:
- Use professional, technical language appropriate for industrial hygiene reports
- Cite specific regulation sections (O. Reg 833, O. Reg 490/09, O. Reg 381/15)
- Follow the Hierarchy of Controls framework for recommendations
- Match the tone and style of provided example reports
- Be factually accurate based on input data
- Not include placeholders or incomplete sections

**FR-049:** System shall validate AI-generated content for:
- Presence of required elements (client name, date, regulations cited)
- Appropriate length (per section requirements)
- No placeholder text
- Factual consistency with input data

**FR-050:** If validation fails, system shall regenerate content automatically

---

## 9. REGULATORY COMPLIANCE

### 9.1 Regulations Referenced

**Chemical Reports:**
- Ontario Regulation 833 (Control of Exposure to Biological or Chemical Agents)
- Ontario Regulation 490/09 (Designated Substances)
- NIOSH Methods (various)

**Noise Reports:**
- Ontario Regulation 381/15 (Noise)

**FR-051:** System shall accurately cite relevant regulation sections in generated reports
**FR-052:** System shall compare results to correct regulatory limits based on jurisdiction (Ontario)

---

## 10. TECHNICAL REQUIREMENTS

### 10.1 Platform
**FR-053:** System shall be a web-based application accessible via browser
**FR-054:** System shall be responsive (work on desktop and tablet)

### 10.2 File Support
**FR-055:** System shall accept PDF files up to 32MB
**FR-055a:** System shall accept Excel files (.xlsx, .xls) up to 10MB for lab reports
**FR-056:** System shall accept CSV files from Quest Edge 5 dosimeters
**FR-057:** System shall accept common image formats (JPEG, PNG) for photos

**FR-057a:** System shall support the following laboratory formats:
- SGS Galson (PDF and Excel)
- EMSL Analytical (PDF and Excel)
- Bureau Veritas (PDF and Excel)

**FR-057b:** System shall export generated reports in the following formats:
- PDF (primary output)
- Word/DOCX (secondary output for editing)

### 10.3 Data Storage
**FR-058:** System shall store user data securely
**FR-059:** System shall store report drafts
**FR-060:** System shall store uploaded files (PDFs, Excel files, photos)
**FR-061:** System shall store generated reports (PDF and Word formats)

### 10.4 Performance
**FR-062:** PDF extraction shall complete within 10 seconds
**FR-063:** AI text generation shall complete within 30 seconds per section
**FR-064:** Full report generation shall complete within 2 minutes
**FR-065:** Final PDF generation shall complete within 30 seconds

---

## 11. CHEMICAL EXPOSURE REPORT SPECIFICATIONS

### 11.1 Executive Summary Section

**Content Requirements:**
1. Statement of who retained the consultant
2. Purpose: "to characterize employee exposure"
3. Assessment date and location
4. List of contaminants sampled
5. Brief methods summary:
   - Sampling methods used
   - Number of samples and locations
6. Brief results summary:
   - Reference to graphs comparing TWA to limits
7. Discussion and recommendations preview

**Format:**
- Length: 1-2 pages
- Include results tables showing:
  - Employee Name, Sample ID, Concentration, TWA, OEL
  - Color-coded for compliance

### 11.2 Introduction Section

**Content Requirements:**
1. Consulting company retained
2. Purpose of assessment (specific to chemicals being sampled)
   - Example: "to quantify employee exposure to silica, welding fume and respirable dust"
3. Assessment date
4. Assessment location
5. Contaminants being sampled
6. Facility operations overview (if site name available, optionally research operations)

**Format:** 1 page

### 11.3 Methods Section

**Content Requirements:**
1. List of samples taken and sampling areas
2. Field blanks usage
3. NIOSH methods used (auto-populated based on chemical names)
   - System shall look up NIOSH method from chemical name
   - Include method details from NIOSH website
4. Equipment specifications:
   - Pump type and flow rate
   - Sample media type
   - Analysis technique
5. Visual table showing: Contaminant | Pump & Flow Rate | Sample Media | Analysis
6. Personal sample methodology description
7. Area sample methodology description
8. Laboratory accreditations

**Format:** 2-3 pages with visual table

### 11.4 Observations Section

**Content Requirements:**
- User-entered observations (verbatim from manual entry)

**Format:** 1-2 pages

### 11.5 Results Section

**Content Requirements:**
1. Sampling information table:
   - Employee Name/Area, Sample ID, Actual Sample Duration, Flow Rate, Volume
2. Results table for each analyte:
   - Employee Name, Sample ID, Concentration, TWA, OEL
3. Bar charts comparing TWA to OEL (one chart per analyte)
   - Green bars for compliant results
   - Red bars for exceedances
   - OEL shown as reference line

**Format:** 3-5 pages

### 11.6 Statistical Analysis Section (Phase 2 - OPTIONAL)

**Content Requirements:**
- Descriptive statistics
- Lognormal distribution analysis
- Confidence intervals
- Tolerance limits

**Note:** Client uses external tool: https://lavoue.shinyapps.io/tool1/

**FR-066:** Statistical analysis integration is optional for Phase 1

### 11.7 Discussion Section

**Content Requirements:**
1. Explanation of findings
2. For each employee/sample:
   - State whether TWA exceeded OEL
   - Provide possible explanations based on observations
3. Reference to regulations
4. Overall compliance assessment

**AI Requirements:**
- Draw on information from results and observations
- Provide context-specific explanations
- Use technical language

**Format:** 2-3 pages

### 11.8 Recommendations Section

**Content Requirements:**
1. Based on legislation and results
2. Follow Hierarchy of Controls:
   - Elimination
   - Substitution
   - Engineering controls
   - Administrative controls
   - PPE
3. Specific, actionable recommendations
4. Cite regulatory requirements (O. Reg 490/09 for designated substances)

**AI Requirements:**
- Recommendations must be specific to the chemicals and results
- Must cite correct regulation sections
- Must follow established hierarchy of controls framework

**Format:** 1-2 pages

### 11.9 Appendices

**Appendix A - Pictures:**
- All user-uploaded photos with captions
- Photos of sampling areas and workers

**Appendix B - Raw Lab Results:**
- Original lab report PDF attached/embedded

**Appendix E - Legislation:**
- Relevant regulation text (pre-defined content)

---

## 12. NOISE EXPOSURE REPORT SPECIFICATIONS

### 12.1 Executive Summary Section

**Content Requirements:**
1. Consulting company retained
2. Assessment date
3. Purpose: "to characterize employee noise exposure and determine sound levels"
4. Assessment location
5. Brief methods summary:
   - Combination of Noise Dosimetry and Sound Level Meter
   - Equipment: Edge 5 from Quest or TSI
   - Number of samples and locations
6. Brief results summary with graphs
7. Discussion and recommendations preview

### 12.2 Introduction Section

**Content Requirements:**
1. Consulting company retained
2. Assessment date
3. Purpose: "to characterize employee exposure to noise"
4. Assessment location
5. Regulation reference (O. Reg 381/15)

### 12.3 Methods Section

**Content Requirements:**
1. Sampling methods (standard across noise reports):
   - Personal noise dosimetry (Edge 5 or TSI)
   - Spot sound level measurements
2. Equipment calibration details
3. Number of workers sampled with job titles and locations

**Note:** Methods are relatively standard across noise reports

### 12.4 Results Section

**Content Requirements:**
1. Personal dosimetry results table:
   - Employee Name, Job Title, TWA, Dose %, OEL (85 dBA)
2. Spot measurement tables:
   - Location, Time, Sound Level (dBA)
3. Equipment measurements table:
   - Equipment, Sound Level (dBA), Operating Condition
4. Bar charts comparing TWA to 85 dBA limit (green/red coding)
5. Time-series graphs showing noise exposure over time (from dosimeter data)

### 12.5 Discussion and Recommendations

**Content Requirements:**
- Similar to chemical reports but specific to noise control
- Hearing protection program requirements
- Engineering controls for noise reduction
- Administrative controls (job rotation)
- Warning signage requirements
- Cite O. Reg 381/15 sections

---

## 13. DATA EXTRACTION SPECIFICATIONS

### 13.1 PDF Parsing Requirements

**FR-067:** System shall use AI (Claude or GPT) to extract data from PDF lab reports
**FR-068:** System shall handle multiple table formats
**FR-069:** System shall extract data from multi-page reports
**FR-070:** System shall identify and skip non-data pages (cover letters, chain of custody)

### 13.2 Excel Parsing Requirements

**FR-070a:** System shall parse Excel files using structured table reading (pandas/openpyxl)
**FR-070b:** System shall extract data from Excel lab reports with same accuracy as PDF (95%+)
**FR-070c:** System shall handle multiple worksheet formats within Excel files
**FR-070d:** System shall map Excel column headers to database fields automatically

**Note:** Excel files are typically easier to parse than PDFs as data is already structured in cells. Most lab data will be extracted from PDF files; Excel is provided as an option when laboratories offer this format.

### 13.3 Data Mapping

**FR-071:** System shall map extracted values to correct database fields:
- Recognize variations: "Sample ID" = "Sample" = "ID"
- Recognize variations: "Concentration" = "Conc" = "Result"
- Handle non-detect values: "<5.0", "ND", "BDL"

### 13.3 Confidence and Review

**FR-072:** System shall assign confidence score to extracted data
**FR-073:** If confidence < 90%, system shall flag for manual review
**FR-074:** User shall always be able to review and correct extracted data before report generation

---

## 14. NIOSH METHOD INTEGRATION

**FR-075:** When user enters chemical name (e.g., "Ethyl Alcohol"), system shall:
1. Look up corresponding NIOSH method (e.g., NIOSH 1400)
2. Retrieve method details from NIOSH website
3. Auto-populate Methods section with:
   - NIOSH method number
   - Sampling equipment required
   - Flow rates
   - Collection media
   - Analysis technique

**FR-076:** System shall maintain database of NIOSH methods for common chemicals
**FR-077:** If NIOSH method not found, system shall allow manual entry

---

## 15. CALCULATIONS SPECIFICATIONS

### 15.1 TWA Calculation (Chemical Reports)

**Formula:**
```
TWA = (Concentration × Sample_Time + 0 × Break_Time) / 480 minutes
```

**Where:**
- Concentration = mg/m³ from lab report
- Sample_Time = actual sampling duration in minutes
- Break_Time = time when employee was on break (assumes zero exposure)
- 480 = standard 8-hour shift in minutes

**FR-078:** System shall account for break times in TWA calculation
**FR-079:** Default break time: 45 minutes (user-configurable)
**FR-080:** For multiple samples of same employee, system shall calculate composite TWA

### 15.2 OEL Comparison

**FR-081:** System shall retrieve OEL from database based on:
1. Check O. Reg 833 (Ontario Table)
2. If not found, check ACGIH TLV
3. If not found, system shall prompt user to enter OEL

**FR-082:** System shall calculate percentage of OEL:
```
% of OEL = (TWA / OEL) × 100
```

**FR-083:** System shall flag exceedances (TWA ≥ OEL)

### 15.3 Noise Calculations

**FR-084:** System shall accept Lex and Dose % values from dosimeter data (no calculation needed)
**FR-085:** System shall compare Lex to 85 dBA limit
**FR-086:** System shall flag exceedances (Lex ≥ 85 dBA)

---

## 16. USER INTERFACE REQUIREMENTS

### 16.1 Dashboard
**FR-087:** Dashboard shall display:
- List of recent reports
- Quick action buttons (New Chemical Report, New Noise Report)
- Report statistics (total reports, pending drafts)

### 16.2 Report Creation Forms
**FR-088:** Forms shall be organized in logical steps
**FR-089:** Forms shall validate required fields
**FR-090:** Forms shall auto-save progress
**FR-091:** Forms shall show progress indicator (e.g., "Step 2 of 5")

### 16.3 Data Review Interface
**FR-092:** Extracted PDF data shall be displayed in editable tables
**FR-093:** User shall be able to add/remove rows
**FR-094:** User shall be able to edit any cell value
**FR-095:** System shall highlight low-confidence extractions

### 16.4 Report Preview
**FR-096:** Before final generation, user shall see preview of:
- All generated text sections
- Charts and tables
- Overall report structure

**FR-097:** User shall be able to:
- Edit any section
- Regenerate individual sections
- Approve and proceed to final PDF

---

## 17. REPORT TEMPLATES

### 17.1 Visual Design
**FR-098:** Reports shall use consistent branding:
- Manson Methods Inc. logo
- Standard color scheme (navy blue, green accents based on examples)
- Professional fonts (Helvetica or similar)

**FR-099:** Cover page shall include:
- Report title (e.g., "Silica Air Sampling Report")
- Site photo (if provided)
- Site address
- Assessment date
- Report author name and credentials
- Company logo

### 17.2 Table Styling
**FR-100:** Tables shall have:
- Header row with background color
- Alternating row colors for readability
- Borders
- Aligned columns (numbers right-aligned)
- Units in headers

### 17.3 Chart Styling
**FR-101:** Charts shall have:
- Clear axis labels with units
- Legend (if multiple series)
- Title
- Grid lines for readability
- Professional color scheme

---

## 18. LIMITATIONS AND DISCLAIMERS

**FR-102:** Generated reports shall include disclaimer text:
```
"This report was generated using AI-assisted software.
The user must review all content for accuracy and completeness.
This report is not deemed to be legally binding without professional review."
```

**FR-103:** System shall not guarantee 100% accuracy of extracted data
**FR-104:** User is responsible for reviewing all generated content before distribution

---

## 19. OUT OF SCOPE (NOT INCLUDED)

The following features are NOT included in the initial implementation:

❌ Statistical analysis integration (Phase 2)
❌ Mobile applications (iOS/Android)
❌ Multi-user accounts or team collaboration
❌ Custom report templates (uses fixed template)
❌ Integration with external laboratory systems
❌ Automatic email delivery of reports
❌ Client portal for report access
❌ E-signature functionality
❌ Version control for reports
❌ Report comparison features
❌ Batch processing of multiple reports
❌ Advanced customization options
❌ White-label branding for different companies

---

## 20. TECHNICAL CONSTRAINTS

### 20.1 File Limits
- PDF files: Maximum 32MB, 100 pages
- CSV files: Maximum 10MB
- Photos: Maximum 10MB per photo, maximum 20 photos per report

### 20.2 Processing Limits
- AI API rate limits as per provider (Claude/OpenAI)
- Concurrent report generation: 1 per user at a time

### 20.3 Browser Support
- Chrome/Edge (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)

---

## 21. DATA FLOW DIAGRAMS

### 21.1 Chemical Report Generation Flow

```
User Login
    ↓
Create New Chemical Report
    ↓
Enter Project Info (client, site, date)
    ↓
Upload PDF Lab Report
    ↓
AI Extracts Data → Display for Review → User Confirms/Edits
    ↓
Enter Observations (manual)
    ↓
Upload Photos (optional)
    ↓
System Calculates TWAs
    ↓
System Retrieves Regulations (RAG)
    ↓
AI Generates Report Sections
    ↓
Display Preview → User Reviews → User Edits (if needed)
    ↓
User Approves
    ↓
System Generates Final PDF
    ↓
User Downloads Report
```

### 21.2 Noise Report Generation Flow

```
User Login
    ↓
Create New Noise Report
    ↓
Enter Project Info
    ↓
Upload Dosimeter CSV → System Parses → Display for Review
    ↓
Enter Spot Measurements (manual table entry)
    ↓
Enter Equipment Measurements (manual)
    ↓
Enter Observations
    ↓
Upload Photos
    ↓
System Generates Time-Series Graphs
    ↓
AI Generates Report Sections
    ↓
Preview → Review → Edit → Approve
    ↓
Generate Final PDF
    ↓
Download Report
```

---

## 22. ACCEPTANCE CRITERIA

### 22.1 PDF Extraction Accuracy
**AC-001:** System shall correctly extract data from SGS Galson reports with 95%+ accuracy
**AC-002:** System shall correctly handle below-detection-limit values
**AC-003:** System shall correctly identify all samples in multi-page reports

### 22.2 Report Generation Quality
**AC-004:** Generated executive summary shall include all required elements
**AC-005:** Generated discussion shall reference specific samples and results
**AC-006:** Generated recommendations shall cite correct regulation sections
**AC-007:** Generated recommendations shall follow Hierarchy of Controls framework

### 22.3 Visual Output Quality
**AC-008:** Generated PDFs shall match provided template styling
**AC-009:** Charts shall display correctly with proper color coding
**AC-010:** Tables shall be formatted professionally
**AC-011:** Photos shall be embedded in Appendix A with captions

### 22.4 Calculation Accuracy
**AC-012:** TWA calculations shall match manual calculations (verified against examples)
**AC-013:** OEL comparisons shall correctly identify exceedances
**AC-014:** Compliance color coding shall be accurate (green/red)

### 22.5 Performance
**AC-015:** Complete report generation shall take less than 5 minutes from start to download
**AC-016:** System shall handle reports with up to 50 samples
**AC-017:** System shall generate reports up to 30 pages

---

## 23. PRIORITY FEATURES (MoSCoW Method)

### MUST HAVE (Phase 1)
- User authentication
- Chemical report generation
- PDF lab report upload and extraction
- Manual data entry forms
- AI text generation (executive summary, introduction, discussion, recommendations)
- TWA calculations
- OEL comparison
- Bar chart generation
- PDF report output
- Noise report generation (basic)
- CSV dosimeter import
- Time-series graph generation

### SHOULD HAVE (Include if time permits)
- Multiple AI provider support (Claude + GPT-5)
- NIOSH method auto-lookup
- Photo uploads

### COULD HAVE (Phase 2)
- Statistical analysis integration
- Support for additional laboratory formats
- Advanced customization options

### WON'T HAVE (Out of Scope)
- Mobile apps
- Multi-user/team features
- Client portal
- E-signatures
- Advanced analytics

---

## 24. TESTING REQUIREMENTS

### 24.1 Test Data
**TR-001:** Client shall provide 5 sample lab reports for testing (various formats)
**TR-002:** Client shall provide 3 completed reports as quality benchmarks

### 24.2 User Acceptance Testing
**TR-003:** Client shall test complete workflow with real data
**TR-004:** Client shall verify AI-generated content matches professional standards
**TR-005:** Client shall confirm calculations are accurate
**TR-006:** Client shall approve visual styling of generated PDFs

---

## 25. DEPLOYMENT REQUIREMENTS

**DR-001:** System shall be deployed to cloud hosting (Vercel for frontend, Railway/Render for backend)
**DR-002:** System shall use managed database (PostgreSQL)
**DR-003:** System shall use cloud storage for files (AWS S3 or similar)
**DR-004:** System shall have SSL certificate (HTTPS)
**DR-005:** System shall have automated backups

---

## 26. DOCUMENTATION REQUIREMENTS

**DOC-001:** User manual explaining how to:
- Create new reports
- Upload lab reports
- Enter manual data
- Review and edit AI-generated content
- Download final reports

**DOC-002:** Technical documentation for future maintenance

---

## 27. DELIVERABLES

1. Web application (Next.js frontend)
2. Backend API (FastAPI)
3. Database schema and setup
4. AI integration (Claude/GPT APIs)
5. PDF generation system
6. User authentication system
7. Cloud deployment (production-ready)
8. User documentation
9. Source code repository

---

## 28. ASSUMPTIONS

1. Client has active API keys for Claude/OpenAI
2. Client will provide sample lab reports for testing
3. Client will provide logo and branding assets
4. Reports will be reviewed by qualified industrial hygienist before client distribution
5. Users have modern web browsers
6. Users have stable internet connection
7. Laboratory PDF reports are machine-readable (not scanned/handwritten)

---

## 29. RISKS AND MITIGATION

| Risk | Impact | Mitigation |
|------|--------|------------|
| **AI hallucinations** | High | Validation layer, user review required |
| **PDF parsing failures** | High | Manual review/correction interface |
| **New lab report formats** | Medium | Graceful degradation, manual entry fallback |
| **API costs exceed budget** | Low | Prompt caching, usage monitoring |
| **Regulatory changes** | Medium | RAG allows easy updates to regulation database |

---

## 30. SUCCESS METRICS

**Post-Launch (3 months):**
- Average report generation time reduced from 8 hours to < 1 hour
- 90%+ of lab reports parsed successfully
- 95%+ user satisfaction with AI-generated content quality
- Zero errors in TWA calculations
- Generated reports match professional quality of manual reports

---

## APPENDIX A: EXAMPLE DATA STRUCTURES

### Chemical Report Data Model

```json
{
  "report_id": "uuid",
  "report_type": "chemical",
  "status": "draft | in_review | finalized",
  "created_at": "2024-01-08T10:00:00Z",
  "project_info": {
    "client_company": "Steam Whistle Brewing Company",
    "site_name": "Steam Whistle",
    "site_address": "249 Evans, Etobicoke, Ontario",
    "assessment_date": "2024-01-08",
    "consulting_company": "Manson Methods Inc.",
    "report_author": "Niclas Manson B.KIN, MPH, CRSP, CIH, ROH"
  },
  "lab_report": {
    "pdf_file_url": "s3://bucket/lab_reports/...",
    "lab_name": "SGS Galson",
    "date_sampled": "2024-01-08",
    "date_analyzed": "2024-01-11",
    "accreditations": ["ISO/IEC 17025"]
  },
  "samples": [
    {
      "sample_id": "ASilica2027",
      "employee_name": "Adam",
      "job_title": "Filtration Operator",
      "sample_type": "personal",
      "analyte": "Respirable Dust",
      "concentration": 0.078,
      "unit": "mg/m3",
      "air_volume": 1092.2,
      "flow_rate": 2.5,
      "sample_duration": 430,
      "break_time": 45,
      "twa": 0.0706875,
      "oel": 3.0,
      "compliant": true,
      "analysis_method": "NIOSH 0600",
      "collection_media": "PVC PW 37mm"
    }
  ],
  "observations": {
    "general_notes": "Typical working day...",
    "facility_operations": "Steam Whistle Brewing Company is...",
    "control_measures": "LEV system in place..."
  },
  "photos": [
    {
      "file_url": "s3://...",
      "caption": "Personal samples on Adam and Dani",
      "order": 1
    }
  ],
  "ai_generated_content": {
    "executive_summary": "Manson Methods Inc. was retained...",
    "introduction": "Manson Methods Inc. was retained...",
    "discussion": "The calculated time weighted average...",
    "recommendations": "Based on the results, the following recommendations..."
  },
  "final_pdf_url": "s3://bucket/reports/..."
}
```

### Noise Report Data Model

```json
{
  "report_id": "uuid",
  "report_type": "noise",
  "status": "draft",
  "project_info": {
    "client_company": "CMP Group",
    "site_address": "300 New Huntington Road, Vaughn, Ontario",
    "assessment_date": "2020-10-08"
  },
  "dosimeter_data": [
    {
      "employee_name": "Jeya",
      "job_title": "Finishing",
      "lex": 86.2,
      "twa": 86.0,
      "dose_percent": 134,
      "compliant": false,
      "time_series": [
        {"timestamp": "2020-10-08T07:00:00", "dba": 85.3},
        {"timestamp": "2020-10-08T07:01:00", "dba": 86.1}
      ]
    }
  ],
  "spot_measurements": [
    {
      "location": "Location 1",
      "time": "10:00",
      "sound_level": 68.3
    }
  ],
  "equipment_measurements": [
    {
      "equipment_name": "Roto machine",
      "sound_level_range": "93.6 - 95.7",
      "operating_condition": "when cutting"
    }
  ]
}
```

---

## APPENDIX B: REGULATION REFERENCES

### Chemical Reports Must Reference:
1. **O. Reg 833** - Control of Exposure to Biological or Chemical Agents
   - Section 4: Exposure limits (TWA, STEL, C)
   - Table 1: Ontario exposure limits

2. **O. Reg 490/09** - Designated Substances
   - Section 18: Respirator requirements
   - Section 19: Assessment requirements
   - Section 20: Control program requirements
   - List of designated substances: Silica, Benzene, Lead, etc.

### Noise Reports Must Reference:
1. **O. Reg 381/15** - Noise
   - Section 2(4): 85 dBA limit
   - Section 2(5): Engineering controls required
   - Section 2(7): Warning signs
   - Section 3: Training requirements

---

## APPENDIX C: SAMPLE PROMPTS

### Executive Summary Generation Prompt

```
You are a Certified Industrial Hygienist (CIH) writing the Executive Summary
for a chemical exposure assessment report.

CONTEXT:
- Client: {client_company}
- Site: {site_name}, {site_address}
- Assessment Date: {assessment_date}
- Consultant: {consulting_company}
- Chemicals Sampled: {chemicals_list}

RESULTS:
{results_table}

COMPLIANCE STATUS:
- Samples exceeding OEL: {exceedances_count}
- Samples below OEL: {compliant_count}

REGULATIONS:
{retrieved_regulation_sections}

REQUIREMENTS:
1. State that {consulting_company} was retained by {client_company} to perform exposure monitoring
2. State the assessment date and location
3. List all chemicals/analytes sampled
4. Briefly describe sampling methods (personal samples, area samples, field blanks)
5. Present results with specific TWA values
6. Compare all results to O. Reg 833 OELs
7. Provide brief preview of recommendations

Format: 250-300 words, professional technical tone
Structure: 3-4 paragraphs

Generate the Executive Summary section:
```

### Recommendations Generation Prompt

```
You are a CIH writing the Recommendations section based on exposure assessment results.

RESULTS SUMMARY:
{results_with_compliance_status}

OBSERVATIONS:
{user_observations}

CONTROL MEASURES OBSERVED:
{existing_controls}

REGULATIONS:
{retrieved_regulation_sections}

REQUIREMENTS:
1. Follow the Hierarchy of Controls framework:
   - Elimination
   - Substitution
   - Engineering Controls
   - Administrative Controls
   - PPE
2. Provide specific, actionable recommendations
3. Cite specific regulation sections (O. Reg 833, O. Reg 490/09)
4. For designated substances (silica), mention specific requirements
5. If exceedances exist, prioritize recommendations for those
6. If all compliant, recommend ongoing monitoring and control maintenance

Format: Bulleted list, professional technical language
Length: 5-10 recommendations

Generate the Recommendations section:
```

---

## APPENDIX D: USER STORIES

**US-001:** As an industrial hygienist, I want to upload a PDF lab report so that data is extracted automatically and I don't have to type it manually.

**US-002:** As an industrial hygienist, I want to review extracted data so that I can correct any errors before report generation.

**US-003:** As an industrial hygienist, I want to enter my field observations so that they are included in the final report.

**US-004:** As an industrial hygienist, I want AI to generate the executive summary so that I don't have to write it from scratch.

**US-005:** As an industrial hygienist, I want to edit AI-generated text so that I can customize it for specific client needs.

**US-006:** As an industrial hygienist, I want TWA calculations to be automatic so that I don't risk calculation errors.

**US-007:** As an industrial hygienist, I want the system to tell me which samples exceeded limits so that I can focus recommendations on those.

**US-008:** As an industrial hygienist, I want to download a professional PDF report so that I can deliver it to my client.

**US-009:** As an industrial hygienist, I want to save report drafts so that I can work on reports over multiple sessions.

**US-010:** As an industrial hygienist, I want to upload photos from the site so that they are included in the report appendix.

**US-011:** As an industrial hygienist, I want the system to cite the correct regulations so that my reports are legally compliant.

**US-012:** As an industrial hygienist, I want to import dosimeter CSV files so that I don't have to manually enter noise data.

---

## APPENDIX E: VALIDATION RULES

### PDF Extraction Validation
- Sample ID must not be empty
- Concentration must be numeric or "<X.X" format
- Air volume must be positive number
- Date must be valid YYYY-MM-DD format
- At least 1 sample must be extracted

### Manual Entry Validation
- Client name: Required, max 200 characters
- Site address: Required, max 300 characters
- Assessment date: Required, must be valid date, cannot be future
- Employee name: Required per sample, max 100 characters
- Observations: Optional, max 10,000 characters

### Calculation Validation
- TWA result must be >= 0
- Sample duration must be > 0
- Break time must be >= 0
- Break time cannot exceed sample duration

### AI Content Validation
- Must contain client name
- Must contain assessment date
- Must mention at least one regulation
- Must not contain placeholder text like "[INSERT]", "TODO", "XXX"
- Length must be within acceptable range per section

---

## APPENDIX F: THIRD-PARTY INTEGRATIONS

### Required APIs
1. **Anthropic Claude API**
   - Purpose: PDF parsing and text generation
   - Estimated cost: $0.06 per report

2. **OpenAI API** (fallback)
   - Purpose: Backup for Claude
   - Estimated cost: $0.04 per report

### Optional External Tools
1. **Statistical Analysis Tool**
   - URL: https://lavoue.shinyapps.io/tool1/
   - Purpose: Bayesian statistics, confidence intervals
   - Phase: Phase 2 (optional)

2. **NIOSH Database**
   - URL: https://www.cdc.gov/niosh/npg/
   - Purpose: Sampling method lookup
   - Integration: Web scraping or manual database building

---

## DOCUMENT APPROVAL

**Prepared By:** Development Team
**Review Required:** Manson Methods Inc. (Niclas Manson)
**Approval Required:** InsightsTap Development Team

**Next Steps:**
1. Client review and approval of functional specifications
2. Technical architecture design
3. Database schema design
4. UI/UX mockups
5. Development kickoff

---

**END OF FUNCTIONAL SPECIFICATIONS**
