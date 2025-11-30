# Technical Specifications
## Manson Safety Report Generator

**Version:** 1.0
**Date:** October 27, 2025

---

## 1. TECHNOLOGY STACK

### 1.1 Frontend
- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript
- **UI Components:** shadcn/ui + Radix UI
- **Forms:** React Hook Form + Zod validation
- **Tables:** TanStack Table
- **Charts:** Recharts (interactive) + Victory (PDF export)
- **PDF Preview:** react-pdf
- **File Upload:** react-dropzone
- **State Management:** React Query (server state) + Zustand (client state)
- **Styling:** Tailwind CSS
- **Deployment:** Vercel

### 1.2 Backend
- **Framework:** FastAPI (Python 3.11+)
- **Database:** PostgreSQL 15+
- **ORM:** SQLAlchemy 2.0
- **Migrations:** Alembic
- **Authentication:** JWT (python-jose)
- **File Storage:** AWS S3 or Cloudinary
- **Deployment:** Railway / Render / DigitalOcean

### 1.3 AI/ML Services
- **Primary AI:** Anthropic Claude Sonnet 4.5
- **Fallback AI:** OpenAI GPT-5
- **Vector Database:** Pinecone (managed) or Chroma (open-source)
- **Embeddings:** OpenAI text-embedding-3-small

### 1.4 PDF Generation
- **Phase 1:** CraftMyPDF API (faster development)
- **Phase 2:** @react-pdf/renderer (custom implementation)

### 1.5 Development Tools
- **Version Control:** Git + GitHub
- **API Testing:** Postman / Bruno
- **Code Quality:** ESLint, Prettier, Black, mypy
- **Testing:** Jest (frontend), Pytest (backend)

---

## 2. SYSTEM ARCHITECTURE

```
┌─────────────────────────────────────────────────────────┐
│                     USER (Browser)                       │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│              Next.js Frontend (Vercel)                   │
│  - Authentication UI                                     │
│  - Report creation forms                                 │
│  - Data review interface                                 │
│  - Report preview                                        │
└─────────────────────────────────────────────────────────┘
                           ↓ HTTPS/REST API
┌─────────────────────────────────────────────────────────┐
│           FastAPI Backend (Railway/Render)               │
│  ┌─────────────────────────────────────────┐            │
│  │  Auth Module (JWT)                      │            │
│  └─────────────────────────────────────────┘            │
│  ┌─────────────────────────────────────────┐            │
│  │  PDF Processing Module                  │            │
│  │  - Upload handler                       │            │
│  │  - Claude API integration               │            │
│  │  - Data extraction                      │            │
│  └─────────────────────────────────────────┘            │
│  ┌─────────────────────────────────────────┐            │
│  │  Calculation Engine                     │            │
│  │  - TWA calculations                     │            │
│  │  - OEL comparison                       │            │
│  │  - Compliance checking                  │            │
│  └─────────────────────────────────────────┘            │
│  ┌─────────────────────────────────────────┐            │
│  │  AI Report Generator                    │            │
│  │  - RAG system (Pinecone)                │            │
│  │  - Claude API (text generation)         │            │
│  │  - Prompt management                    │            │
│  │  - Content validation                   │            │
│  └─────────────────────────────────────────┘            │
│  ┌─────────────────────────────────────────┐            │
│  │  Report Generation Module               │            │
│  │  - Template engine                      │            │
│  │  - Chart generation                     │            │
│  │  - PDF assembly                         │            │
│  └─────────────────────────────────────────┘            │
└─────────────────────────────────────────────────────────┘
                    ↓           ↓           ↓
         ┌──────────────┐ ┌──────────┐ ┌──────────┐
         │ PostgreSQL   │ │ S3/Cloud │ │ Pinecone │
         │   Database   │ │ Storage  │ │ VectorDB │
         └──────────────┘ └──────────┘ └──────────┘
```

---

## 3. API ENDPOINTS

### 3.1 Authentication Endpoints

```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/refresh
POST   /api/auth/reset-password
```

### 3.2 Report Endpoints

```
GET    /api/reports                    # List all reports
POST   /api/reports                    # Create new report
GET    /api/reports/{id}               # Get report details
PUT    /api/reports/{id}               # Update report
DELETE /api/reports/{id}               # Delete report
POST   /api/reports/{id}/generate      # Generate final PDF
```

### 3.3 PDF Processing Endpoints

```
POST   /api/lab-reports/upload         # Upload PDF
POST   /api/lab-reports/extract        # Extract data from PDF
GET    /api/lab-reports/{id}/data      # Get extracted data
PUT    /api/lab-reports/{id}/data      # Update extracted data
```

### 3.4 CSV Import Endpoints

```
POST   /api/dosimeter/upload           # Upload CSV
POST   /api/dosimeter/parse            # Parse dosimeter data
```

### 3.5 AI Generation Endpoints

```
POST   /api/ai/generate-section        # Generate specific section
POST   /api/ai/regenerate-section      # Regenerate section
POST   /api/ai/validate-content        # Validate generated content
```

### 3.6 File Upload Endpoints

```
POST   /api/files/upload               # Upload photo
GET    /api/files/{id}                 # Get file
DELETE /api/files/{id}                 # Delete file
```

---

## 4. DATABASE SCHEMA

### 4.1 Core Tables

#### users
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    credentials VARCHAR(255), -- e.g., "B.KIN, MPH, CRSP, CIH, ROH"
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

#### reports
```sql
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    report_type VARCHAR(50) NOT NULL, -- 'chemical' or 'noise'
    status VARCHAR(50) NOT NULL, -- 'draft', 'in_review', 'finalized'

    -- Project Info
    client_company VARCHAR(255) NOT NULL,
    site_name VARCHAR(255),
    site_address TEXT,
    assessment_date DATE NOT NULL,
    shift_length INTEGER DEFAULT 480, -- minutes (4hr=240, 8hr=480, 10hr=600, 12hr=720, 16hr=960)
    regulatory_standard VARCHAR(50) DEFAULT 'Ontario', -- 'Ontario' or 'ACGIH'
    consulting_company VARCHAR(255) DEFAULT 'Manson Methods Inc.',
    report_author VARCHAR(255),

    -- Lab Info (chemical reports)
    lab_name VARCHAR(255),
    lab_pdf_url TEXT,
    date_sampled DATE,
    date_analyzed DATE,

    -- Observations
    observations TEXT,
    facility_operations TEXT,
    control_measures TEXT,

    -- AI Generated Content
    ai_executive_summary TEXT,
    ai_introduction TEXT,
    ai_methods TEXT,
    ai_discussion TEXT,
    ai_recommendations TEXT,

    -- Final Output
    final_pdf_url TEXT,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_reports_user ON reports(user_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_type ON reports(report_type);
```

#### samples (chemical reports)
```sql
CREATE TABLE samples (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id) ON DELETE CASCADE,

    -- Sample Identification
    sample_id VARCHAR(100) NOT NULL,
    lab_id VARCHAR(100),
    employee_name VARCHAR(255),
    job_title VARCHAR(255),
    sample_type VARCHAR(50), -- 'personal' or 'area'

    -- Sample Parameters
    analyte VARCHAR(255) NOT NULL,
    concentration DECIMAL(10, 6),
    unit VARCHAR(50) DEFAULT 'mg/m3',
    air_volume DECIMAL(10, 2),
    flow_rate DECIMAL(10, 2),
    sample_duration INTEGER, -- minutes
    break_time INTEGER DEFAULT 45, -- minutes

    -- Analysis Details
    amount_found DECIMAL(10, 6),
    detection_limit DECIMAL(10, 6),
    below_detection BOOLEAN DEFAULT FALSE,
    analysis_method VARCHAR(255),
    collection_media VARCHAR(255),

    -- Calculated Values
    twa DECIMAL(10, 6),
    oel DECIMAL(10, 6),
    percent_of_oel DECIMAL(10, 2),
    compliant BOOLEAN,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_samples_report ON samples(report_id);
```

#### noise_dosimetry (noise reports)
```sql
CREATE TABLE noise_dosimetry (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id) ON DELETE CASCADE,

    employee_name VARCHAR(255) NOT NULL,
    job_title VARCHAR(255),

    -- Dosimeter Results
    lex DECIMAL(5, 2), -- dBA
    twa DECIMAL(5, 2), -- dBA
    dose_percent DECIMAL(10, 2),
    peak_level DECIMAL(5, 2),

    -- Compliance
    oel DECIMAL(5, 2) DEFAULT 85.0,
    compliant BOOLEAN,

    -- Job Description
    job_duties TEXT,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_dosimetry_report ON noise_dosimetry(report_id);
```

#### noise_time_series
```sql
CREATE TABLE noise_time_series (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dosimetry_id UUID REFERENCES noise_dosimetry(id) ON DELETE CASCADE,

    timestamp TIMESTAMP NOT NULL,
    dba DECIMAL(5, 2) NOT NULL,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_time_series_dosimetry ON noise_time_series(dosimetry_id);
CREATE INDEX idx_time_series_timestamp ON noise_time_series(timestamp);
```

#### spot_measurements (noise reports)
```sql
CREATE TABLE spot_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id) ON DELETE CASCADE,

    location VARCHAR(255) NOT NULL,
    measurement_time TIME NOT NULL,
    sound_level DECIMAL(5, 2) NOT NULL, -- dBA

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_spot_report ON spot_measurements(report_id);
```

#### equipment_measurements (noise reports)
```sql
CREATE TABLE equipment_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id) ON DELETE CASCADE,

    equipment_name VARCHAR(255) NOT NULL,
    sound_level_min DECIMAL(5, 2),
    sound_level_max DECIMAL(5, 2),
    operating_condition VARCHAR(255),

    created_at TIMESTAMP DEFAULT NOW()
);
```

#### photos
```sql
CREATE TABLE photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES reports(id) ON DELETE CASCADE,

    file_url TEXT NOT NULL,
    caption TEXT,
    display_order INTEGER DEFAULT 0,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_photos_report ON photos(report_id);
```

#### oel_database
```sql
CREATE TABLE oel_database (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    chemical_name VARCHAR(255) NOT NULL,
    cas_number VARCHAR(50),

    -- OEL Values
    oel_twa DECIMAL(10, 6),
    oel_stel DECIMAL(10, 6),
    oel_ceiling DECIMAL(10, 6),
    unit VARCHAR(50),

    -- Source
    jurisdiction VARCHAR(100), -- 'Ontario', 'ACGIH', 'NIOSH'
    regulation VARCHAR(100), -- 'O. Reg 833', 'ACGIH TLV'
    source_document TEXT,

    -- Designated Substance
    is_designated_substance BOOLEAN DEFAULT FALSE,

    -- Additive Effect
    target_organ VARCHAR(255), -- e.g., 'respiratory', 'liver', 'kidneys', 'blood'
    has_additive_effect BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_oel_chemical ON oel_database(chemical_name);
CREATE INDEX idx_oel_jurisdiction ON oel_database(jurisdiction);
CREATE INDEX idx_oel_target_organ ON oel_database(target_organ);
```

#### niosh_methods
```sql
CREATE TABLE niosh_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    method_number VARCHAR(50) NOT NULL, -- e.g., 'NIOSH 0600'
    chemical_name VARCHAR(255),
    analyte VARCHAR(255),

    -- Method Details
    description TEXT,
    sampling_equipment TEXT,
    flow_rate VARCHAR(100),
    collection_media VARCHAR(255),
    analysis_technique VARCHAR(255),

    -- Reference
    niosh_url TEXT,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_niosh_method ON niosh_methods(method_number);
CREATE INDEX idx_niosh_chemical ON niosh_methods(chemical_name);
```

---

## 5. API REQUEST/RESPONSE SPECIFICATIONS

### 5.1 Upload Lab Report PDF

**Endpoint:** `POST /api/lab-reports/upload`

**Request:**
```json
{
  "report_id": "uuid",
  "file": "multipart/form-data"
}
```

**Response:**
```json
{
  "success": true,
  "file_id": "uuid",
  "file_url": "https://...",
  "message": "PDF uploaded successfully"
}
```

### 5.2 Extract Data from PDF

**Endpoint:** `POST /api/lab-reports/extract`

**Request:**
```json
{
  "file_id": "uuid",
  "lab_name": "SGS Galson"
}
```

**Response:**
```json
{
  "success": true,
  "confidence": 0.95,
  "extracted_data": {
    "lab_name": "SGS Galson",
    "client_company": "Manson Methods Inc",
    "site_name": "Steam Whistle - 249 Evans",
    "date_sampled": "2024-01-08",
    "date_analyzed": "2024-01-11",
    "samples": [
      {
        "sample_id": "ASilica2027",
        "employee_name": "Adam",
        "analyte": "Respirable Dust",
        "concentration": 0.078,
        "unit": "mg/m3",
        "air_volume": 1092.2,
        "flow_rate": 2.5,
        "sample_duration": 430,
        "detection_limit": 0.050,
        "below_detection": false,
        "analysis_method": "mod. NIOSH 0600; Gravimetric",
        "collection_media": "PVC PW 37mm"
      }
    ]
  }
}
```

### 5.3 Generate Report Section

**Endpoint:** `POST /api/ai/generate-section`

**Request:**
```json
{
  "report_id": "uuid",
  "section": "executive_summary",
  "context": {
    "client": "Steam Whistle Brewing Company",
    "site": "249 Evans, Etobicoke, Ontario",
    "date": "2024-01-08",
    "chemicals": ["Respirable Dust", "Silica - Quartz"],
    "results_summary": [
      {"employee": "Adam", "analyte": "Respirable Dust", "twa": 0.0706875, "oel": 3.0, "compliant": true}
    ]
  }
}
```

**Response:**
```json
{
  "success": true,
  "generated_text": "Manson Methods Inc. was retained by Steam Whistle Brewing Company to perform silica sampling exposure monitoring at the 249 Evans, Etobicoke, Ontario manufacturing facility located on January 8th, 2024...",
  "confidence": 0.92,
  "validated": true
}
```

### 5.4 Generate Final Report

**Endpoint:** `POST /api/reports/{id}/generate`

**Request:**
```json
{
  "report_id": "uuid"
}
```

**Response:**
```json
{
  "success": true,
  "pdf_url": "https://s3.../final_report.pdf",
  "file_size_bytes": 2457600,
  "page_count": 22,
  "generated_at": "2024-01-15T14:30:00Z"
}
```

---

## 6. CALCULATION ALGORITHMS

### 6.1 TWA Calculation (Chemical Reports)

```python
def calculate_twa(
    concentration: float,
    sample_duration: int,
    break_time: int = 45,
    shift_length: int = 480
) -> float:
    """
    Calculate Time Weighted Average

    Args:
        concentration: Concentration in mg/m³
        sample_duration: Sample time in minutes
        break_time: Break time in minutes (default 45)
        shift_length: Full shift in minutes (default 480 = 8 hours)

    Returns:
        TWA in mg/m³
    """
    exposure_time = sample_duration
    non_exposure_time = break_time

    twa = ((concentration * exposure_time) + (0 * non_exposure_time)) / shift_length

    return round(twa, 7)

# Example from Steam Whistle report:
# Concentration: 0.0046 mg/m³
# Sample duration: 435 minutes (480 - 45 break)
# TWA = (0.0046 × 435 + 0 × 45) / 480 = 0.00416875 mg/m³
```

### 6.2 Multi-Sample TWA

```python
def calculate_multi_sample_twa(
    samples: List[Dict],
    break_time: int = 45,
    shift_length: int = 480
) -> float:
    """
    Calculate TWA when multiple samples taken for same employee

    Args:
        samples: List of {concentration, duration} dicts
        break_time: Break time in minutes
        shift_length: Full shift in minutes

    Returns:
        Composite TWA
    """
    total_exposure = sum(s['concentration'] * s['duration'] for s in samples)
    total_time = shift_length

    twa = total_exposure / total_time

    return round(twa, 7)
```

### 6.3 OEL Comparison

```python
def check_compliance(twa: float, oel: float) -> Dict:
    """
    Check if TWA exceeds OEL

    Returns:
        {
            'compliant': bool,
            'percent_of_oel': float,
            'severity': str
        }
    """
    percent = (twa / oel) * 100

    if twa >= oel:
        severity = 'exceedance'
        compliant = False
    elif twa >= (oel * 0.5):
        severity = 'action_level'
        compliant = True
    else:
        severity = 'well_controlled'
        compliant = True

    return {
        'compliant': compliant,
        'percent_of_oel': round(percent, 2),
        'severity': severity
    }
```

### 6.4 Additive Effect Calculation (Chemical Mixtures)

```python
def calculate_additive_effect(samples: List[Dict], oel_database: Dict) -> Dict:
    """
    Calculate additive effect for chemicals affecting the same target organ

    Formula: Em = (C1/L1) + (C2/L2) + ... + (Cn/Ln)
    If Em > 1.0, combined exposure exceeds acceptable limit

    Args:
        samples: List of samples with same target organ
        oel_database: Database lookup for OELs and target organs

    Returns:
        {
            'em_value': float,
            'exceeds_limit': bool,
            'chemicals_involved': List[str],
            'target_organ': str
        }
    """
    # Group samples by target organ
    organ_groups = {}

    for sample in samples:
        chemical = sample['analyte']
        oel_info = oel_database.get(chemical)

        if not oel_info or not oel_info['has_additive_effect']:
            continue

        target_organ = oel_info['target_organ']

        if target_organ not in organ_groups:
            organ_groups[target_organ] = []

        organ_groups[target_organ].append({
            'chemical': chemical,
            'concentration': sample['twa'],  # Use TWA
            'oel': oel_info['oel_twa']
        })

    # Calculate Em for each target organ group
    results = []

    for organ, chemicals in organ_groups.items():
        if len(chemicals) < 2:
            continue  # Additive effect only applies to 2+ chemicals

        # Calculate Em = sum of (Cn/Ln)
        em = sum(c['concentration'] / c['oel'] for c in chemicals)

        results.append({
            'target_organ': organ,
            'em_value': round(em, 4),
            'exceeds_limit': em > 1.0,
            'chemicals_involved': [c['chemical'] for c in chemicals],
            'individual_ratios': [
                {
                    'chemical': c['chemical'],
                    'concentration': c['concentration'],
                    'oel': c['oel'],
                    'ratio': round(c['concentration'] / c['oel'], 4)
                }
                for c in chemicals
            ]
        })

    return results

# Example:
# Employee exposed to:
# - Toluene: TWA = 40 ppm, OEL = 50 ppm (affects CNS)
# - Xylene: TWA = 60 ppm, OEL = 100 ppm (affects CNS)
#
# Em = (40/50) + (60/100) = 0.8 + 0.6 = 1.4
# Result: Em > 1.0 → Combined exposure EXCEEDS limit
```

### 6.5 Get OEL by Regulatory Standard

```python
def get_oel(chemical: str, regulatory_standard: str = 'Ontario') -> Optional[float]:
    """
    Retrieve OEL based on selected regulatory standard

    Args:
        chemical: Chemical/analyte name
        regulatory_standard: 'Ontario' or 'ACGIH'

    Returns:
        OEL value in appropriate units, or None if not found
    """
    oel = db.query(OEL).filter(
        OEL.chemical_name == chemical,
        OEL.jurisdiction == regulatory_standard
    ).first()

    if not oel:
        # Fallback to other standard
        oel = db.query(OEL).filter(
            OEL.chemical_name == chemical
        ).first()

    return oel.oel_twa if oel else None
```

### 6.6 Noise Dose Calculation (Reference Only)

```python
def calculate_dose_percent(lex: float, criterion_level: float = 85.0) -> float:
    """
    Calculate dose percentage for noise exposure (3dB exchange rate)

    Note: This is typically provided by dosimeter, not calculated
    """
    dose = 100 * (2 ** ((lex - criterion_level) / 3))
    return round(dose, 2)

# Example from CMP report:
# Lex = 95.9 dBA
# Dose = 100 * (2^((95.9-85)/3)) = 1242.2%
```

---

## 7. AI INTEGRATION SPECIFICATIONS

### 7.1 Claude API Integration

**Configuration:**
```python
CLAUDE_CONFIG = {
    "model": "claude-sonnet-4-5",
    "max_tokens": 4096,
    "temperature": 0.3,  # Low for consistency
    "api_key": settings.ANTHROPIC_API_KEY,
    "timeout": 60  # seconds
}
```

**PDF Extraction:**
```python
import anthropic
import base64

async def extract_lab_data(pdf_bytes: bytes) -> dict:
    client = anthropic.Anthropic(api_key=CLAUDE_CONFIG["api_key"])

    pdf_b64 = base64.standard_b64encode(pdf_bytes).decode("utf-8")

    message = await client.messages.create(
        model=CLAUDE_CONFIG["model"],
        max_tokens=CLAUDE_CONFIG["max_tokens"],
        messages=[{
            "role": "user",
            "content": [
                {
                    "type": "document",
                    "source": {
                        "type": "base64",
                        "media_type": "application/pdf",
                        "data": pdf_b64
                    }
                },
                {
                    "type": "text",
                    "text": PDF_EXTRACTION_PROMPT
                }
            ]
        }]
    )

    return json.loads(message.content[0].text)
```

**Text Generation with RAG:**
```python
async def generate_executive_summary(report_data: dict) -> str:
    # 1. Retrieve relevant regulations from vector DB
    query = f"Ontario regulations for {report_data['chemicals']} exposure"
    relevant_docs = await vectorstore.similarity_search(query, k=5)

    # 2. Build context
    context = format_context(report_data, relevant_docs)

    # 3. Generate with Claude (using prompt caching)
    message = await client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=2048,
        temperature=0.3,
        system=[
            {
                "type": "text",
                "text": SYSTEM_PROMPT,
                "cache_control": {"type": "ephemeral"}
            }
        ],
        messages=[{
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": REGULATION_CONTEXT,
                    "cache_control": {"type": "ephemeral"}
                },
                {
                    "type": "text",
                    "text": EXECUTIVE_SUMMARY_PROMPT.format(**context)
                }
            ]
        }]
    )

    return message.content[0].text
```

### 7.2 RAG (Retrieval-Augmented Generation) System

**Vector Database Setup:**
```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Pinecone
from langchain.text_splitter import RecursiveCharacterTextSplitter

# Initialize
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = Pinecone(embeddings=embeddings, index_name="regulations")

# Store regulations
async def build_knowledge_base():
    documents = [
        # O. Reg 833
        {"content": "Section 4: Every employer shall...", "metadata": {"source": "O. Reg 833", "section": "4"}},

        # O. Reg 490/09
        {"content": "Section 18(2): A worker who is exposed...", "metadata": {"source": "O. Reg 490/09", "section": "18.2"}},

        # NIOSH Methods
        {"content": "NIOSH 0600: Respirable Dust...", "metadata": {"method": "NIOSH 0600"}},

        # Example reports
        {"content": "[Steam Whistle Executive Summary]", "metadata": {"section": "executive_summary", "type": "example"}},
    ]

    # Split and embed
    splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    chunks = splitter.split_documents(documents)

    await vectorstore.add_documents(chunks)
```

**Retrieval:**
```python
async def retrieve_relevant_context(query: str, k: int = 5) -> List[str]:
    """Retrieve relevant regulation sections"""
    docs = await vectorstore.similarity_search(query, k=k)
    return [doc.page_content for doc in docs]
```

### 7.3 Content Validation

```python
def validate_ai_content(
    generated_text: str,
    section_type: str,
    report_data: dict
) -> Dict:
    """Validate AI-generated content"""

    validations = {
        "contains_client": report_data["client"] in generated_text,
        "contains_date": report_data["date"] in generated_text,
        "contains_regulation": any(reg in generated_text for reg in ["O. Reg", "Ontario Regulation"]),
        "no_placeholders": not any(p in generated_text for p in ["[INSERT]", "TODO", "XXX", "[TBD]"]),
        "appropriate_length": is_appropriate_length(generated_text, section_type),
    }

    all_passed = all(validations.values())

    return {
        "passed": all_passed,
        "checks": validations,
        "issues": [k for k, v in validations.items() if not v]
    }

def is_appropriate_length(text: str, section: str) -> bool:
    """Check if text length is appropriate for section"""
    word_count = len(text.split())

    ranges = {
        "executive_summary": (200, 400),
        "introduction": (150, 300),
        "discussion": (300, 800),
        "recommendations": (200, 600)
    }

    min_words, max_words = ranges.get(section, (50, 1000))
    return min_words <= word_count <= max_words
```

---

## 8. PDF GENERATION SPECIFICATIONS

### 8.1 Phase 1: CraftMyPDF API

**Configuration:**
```python
CRAFTMYPDF_CONFIG = {
    "api_key": settings.CRAFTMYPDF_API_KEY,
    "base_url": "https://api.craftmypdf.com/v1",
    "timeout": 60
}
```

**Template Structure:**
```json
{
  "template_id": "chemical_report_template",
  "data": {
    "cover": {
      "title": "Air Sampling Report",
      "site_name": "{site_name}",
      "site_address": "{site_address}",
      "assessment_date": "{assessment_date}",
      "author": "{author_name}",
      "logo_url": "{logo_url}",
      "site_photo_url": "{site_photo_url}"
    },
    "executive_summary": "{ai_generated_text}",
    "results_table": [
      {
        "employee": "Adam",
        "sample_id": "ASilica2027",
        "concentration": 0.078,
        "twa": 0.0706875,
        "oel": 3.0,
        "compliant": true
      }
    ],
    "chart_data": {
      "type": "bar",
      "labels": ["Adam", "Dani", "Jason"],
      "values": [0.0706875, 0.090625, 0.0779375],
      "oel_line": 3.0,
      "colors": ["#22c55e", "#22c55e", "#22c55e"]
    }
  }
}
```

### 8.2 Phase 2: @react-pdf/renderer

**Component Structure:**
```tsx
import { Document, Page, Text, View, Image, StyleSheet } from '@react-pdf/renderer';

const ChemicalReport = ({ data }) => (
  <Document>
    <CoverPage data={data} />
    <TableOfContents sections={data.sections} />
    <ExecutiveSummary content={data.ai_executive_summary} results={data.samples} />
    <Introduction content={data.ai_introduction} />
    <Methods data={data} />
    <Observations content={data.observations} />
    <Results samples={data.samples} />
    <Discussion content={data.ai_discussion} />
    <Recommendations content={data.ai_recommendations} />
    <AppendixPhotos photos={data.photos} />
    <AppendixLabResults pdfUrl={data.lab_pdf_url} />
  </Document>
);
```

---

## 9. CHART GENERATION SPECIFICATIONS

### 9.1 Bar Chart (TWA vs OEL)

**Libraries:**
- Interactive (web): Recharts
- PDF export: Victory

**Specifications:**
```typescript
interface ChartData {
  employee: string;
  twa: number;
  oel: number;
  compliant: boolean;
}

const chartConfig = {
  type: 'bar',
  xAxis: 'employee',
  yAxis: {
    label: 'TWA (mg/m³)',
    min: 0,
    max: 'auto' // or max OEL * 1.2
  },
  bars: [
    {
      dataKey: 'twa',
      fill: (data) => data.compliant ? '#22c55e' : '#ef4444', // green : red
      label: true
    }
  ],
  referenceLine: {
    y: data.oel,
    stroke: '#000',
    strokeDasharray: '5 5',
    label: 'OEL'
  }
}
```

### 9.2 Time-Series Graph (Noise Dosimetry)

**Specifications:**
```typescript
interface TimeSeriesData {
  timestamp: Date;
  dba: number;
}

const timeSeriesConfig = {
  type: 'line',
  xAxis: {
    dataKey: 'timestamp',
    type: 'time',
    format: 'HH:mm'
  },
  yAxis: {
    label: 'Sound Level (dBA)',
    domain: [60, 100]
  },
  line: {
    dataKey: 'dba',
    stroke: '#3b82f6',
    strokeWidth: 2
  },
  referenceLine: {
    y: 85,
    stroke: '#dc2626',
    strokeWidth: 2,
    label: '85 dBA Limit'
  }
}
```

---

## 10. FILE STORAGE STRUCTURE

```
s3://manson-reports/
  users/
    {user_id}/
      lab_reports/
        {report_id}/
          original.pdf
      photos/
        {report_id}/
          photo_001.jpg
          photo_002.jpg
      generated_reports/
        {report_id}/
          draft_v1.pdf
          final.pdf
```

---

## 11. SECURITY REQUIREMENTS

**SEC-001:** All passwords must be hashed using bcrypt
**SEC-002:** JWT tokens must expire after 24 hours
**SEC-003:** Refresh tokens must expire after 7 days
**SEC-004:** All API endpoints (except auth) must require valid JWT
**SEC-005:** Users can only access their own reports
**SEC-006:** File uploads must be scanned for malware
**SEC-007:** API keys must be stored in environment variables, not code
**SEC-008:** HTTPS must be enforced for all connections
**SEC-009:** SQL injection protection via ORM (SQLAlchemy)
**SEC-010:** XSS protection via input sanitization

---

## 12. ERROR HANDLING

### 12.1 PDF Extraction Errors

**Scenario:** PDF parsing fails or low confidence
**Response:**
```json
{
  "success": false,
  "error": "Low confidence extraction",
  "confidence": 0.65,
  "extracted_data": {...},
  "message": "Please review and correct the extracted data",
  "requires_manual_review": true
}
```

### 12.2 AI Generation Errors

**Scenario:** AI generates invalid content
**Response:**
```json
{
  "success": false,
  "error": "Content validation failed",
  "issues": ["Missing client name", "No regulation cited"],
  "retry_count": 1,
  "message": "Regenerating content..."
}
```

**Retry Logic:**
- Attempt 1: Regenerate with corrective prompt
- Attempt 2: Switch to fallback AI provider
- Attempt 3: Return error, require manual intervention

---

## 13. PERFORMANCE REQUIREMENTS

**PERF-001:** Page load time < 2 seconds
**PERF-002:** Form auto-save < 500ms
**PERF-003:** PDF extraction < 10 seconds
**PERF-004:** AI text generation < 30 seconds per section
**PERF-005:** Chart rendering < 1 second
**PERF-006:** Final PDF generation < 30 seconds
**PERF-007:** API response time < 1 second (excluding AI operations)

---

## 14. MONITORING AND LOGGING

**MON-001:** Log all AI API calls with:
- Timestamp
- Model used
- Token count
- Cost
- Success/failure

**MON-002:** Log all PDF extractions with:
- File size
- Extraction confidence
- Number of samples extracted
- Processing time

**MON-003:** Alert on:
- AI API failures
- Database connection errors
- High error rates (>5%)

---

## 15. BACKUP AND RECOVERY

**BACK-001:** Database backups daily
**BACK-002:** File storage backups daily
**BACK-003:** Retain backups for 30 days
**BACK-004:** Recovery point objective (RPO): 24 hours
**BACK-005:** Recovery time objective (RTO): 4 hours

---

## 16. SCALABILITY CONSIDERATIONS

**SCALE-001:** System should handle 100 concurrent users
**SCALE-002:** System should support 1,000 reports per month
**SCALE-003:** Database should support 100,000 samples
**SCALE-004:** File storage should support 100GB

---

## 17. THIRD-PARTY SERVICE DEPENDENCIES

| Service | Purpose | Cost | Required |
|---------|---------|------|----------|
| **Anthropic Claude** | PDF parsing, text generation | $0.06/report | Yes |
| **OpenAI** | Fallback AI, embeddings | $0.04/report | Yes |
| **Pinecone** | Vector database (RAG) | $70/month or free tier | Yes |
| **CraftMyPDF** | PDF generation | $29-99/month | Phase 1 |
| **Vercel** | Frontend hosting | $0-20/month | Yes |
| **Railway/Render** | Backend hosting | $5-20/month | Yes |
| **AWS S3 / Cloudinary** | File storage | $5-10/month | Yes |

**Total Monthly Operating Cost:** $109-219/month (with CraftMyPDF)
**or $10-40/month** (if building PDF templates in Phase 2)

---

## 18. DEVELOPMENT MILESTONES

### Week 1-2: Foundation
- [ ] Project setup (Next.js + FastAPI)
- [ ] Database schema implementation
- [ ] Authentication system
- [ ] Basic UI scaffolding

### Week 3-4: Data Input
- [ ] Chemical report forms
- [ ] PDF upload functionality
- [ ] Claude API integration for extraction
- [ ] Data review interface

### Week 5-6: AI & Calculations
- [ ] RAG system setup
- [ ] AI text generation
- [ ] TWA calculation engine
- [ ] OEL comparison logic

### Week 7: Report Generation
- [ ] CraftMyPDF integration
- [ ] Chart generation
- [ ] Report preview
- [ ] PDF download

### Week 8: Noise Reports
- [ ] CSV import
- [ ] Noise data forms
- [ ] Time-series graphs
- [ ] Noise report template

### Week 9: Testing & Polish
- [ ] User acceptance testing
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] UI/UX refinement

### Week 10: Deployment
- [ ] Production deployment
- [ ] User training
- [ ] Documentation
- [ ] Handover

---

## 19. API RATE LIMITS

### Claude API
- Tier 1: 50 requests/minute, 40,000 tokens/minute
- Tier 2: 1,000 requests/minute, 80,000 tokens/minute

### OpenAI API
- Tier 1: 500 requests/minute, 30,000 tokens/minute
- Tier 3: 5,000 requests/minute, 200,000 tokens/minute

**Implementation:**
- Queue system for batch processing
- Retry logic with exponential backoff
- User notification if rate limit hit

---

## 20. COMPLIANCE & LEGAL

**COMP-001:** Generated reports must include disclaimer about AI-assisted generation
**COMP-002:** System must not claim reports are legally binding without professional review
**COMP-003:** User data must be stored securely (GDPR/privacy compliant)
**COMP-004:** System must not store API keys in database
**COMP-005:** User must explicitly approve AI-generated content before finalizing

---

**END OF TECHNICAL SPECIFICATIONS**
