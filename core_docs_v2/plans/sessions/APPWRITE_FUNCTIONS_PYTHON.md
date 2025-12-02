# Appwrite Functions: Python Implementation Sessions
## Astro GPT Backend Functions
**Total Duration:** 16 hours (4 sessions x 4 hours)

---

## Executive Summary

### Goal
Deploy all Appwrite serverless functions using Python runtime for AI chat, webhooks, and content automation.

### Functions to Build
| Function | Trigger | Priority | Session |
|----------|---------|----------|---------|
| `ai-chat-response` | HTTP | Critical | 1-2 |
| `subscription-webhook` | HTTP | High | 3 |
| `generate-daily-horoscope` | Scheduled (CRON) | Medium | 4 |
| `rotate-daily-content` | Scheduled (CRON) | Medium | 4 |

### Tech Stack
- **Runtime:** Python 3.11
- **SDK:** Appwrite Python SDK
- **AI:** OpenAI Python SDK (GPT-4)
- **Dependencies:** requests, openai, appwrite

### Prerequisites
- Appwrite Cloud project configured
- OpenAI API key
- RevenueCat webhook secret
- Collections seeded (astrologers, daily_content, horoscopes)

---

## Project Structure

```
functions/
  ai-chat-response/
    src/
      main.py
      utils/
        __init__.py
        moderation.py
        prompts.py
    requirements.txt
  subscription-webhook/
    src/
      main.py
    requirements.txt
  generate-daily-horoscope/
    src/
      main.py
    requirements.txt
  rotate-daily-content/
    src/
      main.py
    requirements.txt
```

---

## Session 1: AI Chat Response - Setup & Core Logic (4 hours)

### Objectives
1. Set up Appwrite Function project structure
2. Configure Python environment and dependencies
3. Implement core AI chat logic
4. Integrate OpenAI GPT-4 API
5. Add content moderation rules

### Key Deliverables

| Deliverable | Description | Duration |
|-------------|-------------|----------|
| Project scaffold | Folder structure, requirements.txt | 20 min |
| Appwrite SDK setup | Database client initialization | 30 min |
| OpenAI integration | GPT-4 API wrapper | 45 min |
| Fetch astrologer data | Get aiPersonaPrompt + profile from DB | 30 min |
| Fetch user context | Get user name, zodiacSign, gender | 20 min |
| Fetch chat history | Get last 10 messages for context | 30 min |
| Content moderation | FR-116-119 safety rules | 45 min |
| Core response logic | Generate AI response with persona | 40 min |

### Astrologer Collection Schema (from Appwrite)

```json
{
  "collection_id": "astrologers",
  "attributes": [
    {"key": "name", "type": "string", "size": 100},
    {"key": "photoUrl", "type": "string", "size": 500},
    {"key": "heroImageUrl", "type": "string", "size": 500},
    {"key": "bio", "type": "string", "size": 1000},
    {"key": "specialization", "type": "string", "size": 100},
    {"key": "expertiseTags", "type": "array"},
    {"key": "languages", "type": "array"},
    {"key": "rating", "type": "double"},
    {"key": "reviewCount", "type": "integer"},
    {"key": "chatCount", "type": "integer"},
    {"key": "category", "type": "string"},
    {"key": "isActive", "type": "boolean"},
    {"key": "aiPersonaPrompt", "type": "string", "size": 5000},
    {"key": "displayOrder", "type": "integer"},
    {"key": "createdAt", "type": "datetime"}
  ]
}
```

### User Collection Schema (for context)

```json
{
  "collection_id": "users",
  "attributes": [
    {"key": "fullName", "type": "string"},
    {"key": "gender", "type": "string"},
    {"key": "dateOfBirth", "type": "datetime"},
    {"key": "zodiacSign", "type": "string"},
    {"key": "preferredLanguage", "type": "string"}
  ]
}
```

### Function: ai-chat-response/src/main.py

```python
import os
import json
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
from openai import OpenAI

# Environment variables (set in Appwrite Console)
# APPWRITE_FUNCTION_API_ENDPOINT
# APPWRITE_FUNCTION_PROJECT_ID
# APPWRITE_API_KEY
# OPENAI_API_KEY
# DATABASE_ID

def main(context):
    """
    AI Chat Response Function

    Trigger: HTTP POST
    Input: { userId, astrologerId, message, sessionId }
    Output: { success, response, messageId }
    """
    try:
        # Parse request
        body = json.loads(context.req.body)
        user_id = body.get('userId')
        astrologer_id = body.get('astrologerId')
        message = body.get('message')
        session_id = body.get('sessionId')

        # Validate required fields
        if not all([user_id, astrologer_id, message, session_id]):
            return context.res.json({
                'success': False,
                'error': 'Missing required fields'
            }, 400)

        # Initialize clients
        client = init_appwrite_client()
        databases = Databases(client)
        openai_client = OpenAI(api_key=os.environ.get('OPENAI_API_KEY'))

        database_id = os.environ.get('DATABASE_ID')

        # 1. Fetch astrologer data (includes aiPersonaPrompt)
        astrologer = databases.get_document(
            database_id=database_id,
            collection_id='astrologers',
            document_id=astrologer_id
        )

        # 2. Fetch user data for personalization (FR-109)
        user = databases.get_document(
            database_id=database_id,
            collection_id='users',
            document_id=user_id
        )

        # 3. Fetch chat history (last 10 messages for context)
        history = databases.list_documents(
            database_id=database_id,
            collection_id='messages',
            queries=[
                Query.equal('sessionId', session_id),
                Query.order_desc('createdAt'),
                Query.limit(10)
            ]
        )

        # 4. Build conversation context with astrologer persona + user context
        messages = build_conversation(
            astrologer=astrologer,
            user=user,
            history=history['documents'],
            new_message=message
        )

        # 4. Call OpenAI GPT-4
        completion = openai_client.chat.completions.create(
            model='gpt-4',
            messages=messages,
            max_tokens=500,
            temperature=0.7
        )

        ai_response = completion.choices[0].message.content

        # 5. Save user message
        user_msg = databases.create_document(
            database_id=database_id,
            collection_id='messages',
            document_id='unique()',
            data={
                'sessionId': session_id,
                'senderId': user_id,
                'senderType': 'user',
                'content': message,
                'createdAt': get_timestamp()
            }
        )

        # 6. Save AI response
        ai_msg = databases.create_document(
            database_id=database_id,
            collection_id='messages',
            document_id='unique()',
            data={
                'sessionId': session_id,
                'senderId': astrologer_id,
                'senderType': 'astrologer',
                'content': ai_response,
                'createdAt': get_timestamp()
            }
        )

        return context.res.json({
            'success': True,
            'response': ai_response,
            'messageId': ai_msg['$id']
        })

    except Exception as e:
        context.log(f'Error: {str(e)}')
        return context.res.json({
            'success': False,
            'error': str(e)
        }, 500)


def init_appwrite_client():
    """Initialize Appwrite client with function credentials"""
    client = Client()
    client.set_endpoint(os.environ.get('APPWRITE_FUNCTION_API_ENDPOINT'))
    client.set_project(os.environ.get('APPWRITE_FUNCTION_PROJECT_ID'))
    client.set_key(os.environ.get('APPWRITE_API_KEY'))
    return client


def get_timestamp():
    """Get current ISO timestamp"""
    from datetime import datetime, timezone
    return datetime.now(timezone.utc).isoformat()
```

### Content Moderation: ai-chat-response/src/utils/moderation.py

```python
"""
Content Moderation Rules (FR-116-119)
Applied to all AI responses
"""

CONTENT_MODERATION_RULES = """
IMPORTANT CONTENT MODERATION RULES - YOU MUST FOLLOW THESE:

1. MEDICAL ADVICE (FR-116):
   - NEVER diagnose health conditions
   - NEVER recommend specific medications or treatments
   - For health questions, say: "I sense concern about your health. While the stars can offer guidance on wellness timing, please consult a qualified healthcare professional for medical advice."

2. FINANCIAL ADVICE (FR-117):
   - NEVER recommend specific stocks, investments, or financial products
   - NEVER guarantee financial outcomes
   - For financial questions, say: "The planetary alignments may suggest favorable periods for financial decisions, but please consult a certified financial advisor for specific investment guidance."

3. CRISIS RESPONSE (FR-118):
   - If user expresses suicidal thoughts or severe distress, respond with empathy
   - Provide crisis helpline numbers:
     * India: iCall 9152987821, Vandrevala Foundation 1860-2662-345
     * US: 988 Suicide & Crisis Lifeline
   - Say: "I hear that you're going through a difficult time. Your well-being matters deeply. Please reach out to a crisis helpline or mental health professional who can provide the support you deserve."

4. HARMFUL PREDICTIONS (FR-119):
   - NEVER predict death, serious illness, or catastrophic events
   - NEVER make predictions that could cause panic or harmful decisions
   - Keep predictions hopeful and constructive
   - Focus on guidance and positive possibilities

5. GENERAL GUIDELINES:
   - Keep responses spiritually uplifting and positive
   - Encourage self-reflection and personal growth
   - Respect all religious and spiritual beliefs
   - Maintain a warm, compassionate tone
"""


def get_system_prompt(astrologer_persona: str) -> str:
    """
    Combine astrologer persona with moderation rules

    Args:
        astrologer_persona: The aiPersonaPrompt from astrologer document

    Returns:
        Complete system prompt with moderation rules
    """
    return f"""{astrologer_persona}

{CONTENT_MODERATION_RULES}

Remember: You are a spiritual guide offering astrological insights. Your role is to provide comfort, guidance, and perspective - not professional medical, legal, or financial advice."""


def check_crisis_keywords(message: str) -> bool:
    """
    Check if message contains crisis indicators

    Args:
        message: User's message

    Returns:
        True if crisis keywords detected
    """
    crisis_keywords = [
        'suicide', 'kill myself', 'end my life', 'want to die',
        'no reason to live', 'better off dead', 'self harm',
        'hurt myself', 'overdose', 'jump off'
    ]
    message_lower = message.lower()
    return any(keyword in message_lower for keyword in crisis_keywords)
```

### Conversation Builder: ai-chat-response/src/utils/prompts.py

```python
"""
Prompt building utilities for AI chat
"""
from .moderation import get_system_prompt, check_crisis_keywords


CRISIS_RESPONSE = """I can sense you're going through an incredibly difficult time, and I want you to know that your feelings matter deeply. While the stars guide us through many of life's challenges, what you're experiencing deserves immediate support from someone trained to help.

Please reach out to a crisis helpline:
- India: iCall 9152987821 or Vandrevala Foundation 1860-2662-345
- US: 988 Suicide & Crisis Lifeline

You are not alone in this journey. These compassionate professionals are available 24/7 to listen and support you. Your life has meaning and purpose - the universe has plans for you that are yet to unfold."""


def build_conversation(astrologer: dict, history: list, new_message: str) -> list:
    """
    Build OpenAI conversation format

    Args:
        astrologer: Astrologer document with aiPersonaPrompt
        history: List of previous messages (newest first)
        new_message: Current user message

    Returns:
        List of messages in OpenAI format
    """
    # Check for crisis first
    if check_crisis_keywords(new_message):
        # Return minimal context for crisis response
        return [
            {
                'role': 'system',
                'content': get_system_prompt(astrologer.get('aiPersonaPrompt', ''))
            },
            {
                'role': 'user',
                'content': new_message
            },
            {
                'role': 'assistant',
                'content': CRISIS_RESPONSE
            }
        ]

    messages = []

    # System prompt with persona + moderation
    messages.append({
        'role': 'system',
        'content': get_system_prompt(astrologer.get('aiPersonaPrompt', ''))
    })

    # Add history (reverse to chronological order)
    for msg in reversed(history):
        role = 'user' if msg.get('senderType') == 'user' else 'assistant'
        messages.append({
            'role': role,
            'content': msg.get('content', '')
        })

    # Add new message
    messages.append({
        'role': 'user',
        'content': new_message
    })

    return messages
```

### Requirements: ai-chat-response/requirements.txt

```
appwrite>=4.1.0
openai>=1.0.0
```

### Session 1 Checklist

- [ ] Create `functions/ai-chat-response/` directory structure
- [ ] Implement `main.py` with core logic
- [ ] Implement `utils/moderation.py` with FR-116-119 rules
- [ ] Implement `utils/prompts.py` for conversation building
- [ ] Create `requirements.txt`
- [ ] Test locally with mock data

---

## Session 2: AI Chat Response - Deployment & Testing (4 hours)

### Objectives
1. Deploy function to Appwrite Cloud
2. Configure environment variables
3. Test with Flutter app
4. Handle edge cases and errors
5. Add rate limiting consideration

### Key Deliverables

| Deliverable | Description | Duration |
|-------------|-------------|----------|
| Appwrite deployment | CLI or Console deployment | 45 min |
| Environment config | Set API keys, DB IDs | 30 min |
| Error handling | Comprehensive try/catch | 45 min |
| Rate limiting | Track usage per user | 45 min |
| Flutter integration | Update AppwriteAIService | 60 min |
| End-to-end testing | Full chat flow test | 45 min |

### Enhanced Error Handling

```python
# Add to main.py

class AIServiceError(Exception):
    """Custom exception for AI service errors"""
    def __init__(self, message: str, code: str, status: int = 500):
        self.message = message
        self.code = code
        self.status = status
        super().__init__(message)


def validate_request(body: dict) -> tuple:
    """
    Validate request body

    Returns:
        Tuple of (user_id, astrologer_id, message, session_id)

    Raises:
        AIServiceError if validation fails
    """
    required_fields = ['userId', 'astrologerId', 'message', 'sessionId']

    for field in required_fields:
        if not body.get(field):
            raise AIServiceError(
                message=f'Missing required field: {field}',
                code='MISSING_FIELD',
                status=400
            )

    message = body['message'].strip()

    if len(message) < 1:
        raise AIServiceError(
            message='Message cannot be empty',
            code='EMPTY_MESSAGE',
            status=400
        )

    if len(message) > 2000:
        raise AIServiceError(
            message='Message too long (max 2000 characters)',
            code='MESSAGE_TOO_LONG',
            status=400
        )

    return (
        body['userId'],
        body['astrologerId'],
        message,
        body['sessionId']
    )


def check_rate_limit(databases, database_id: str, user_id: str) -> bool:
    """
    Check if user has exceeded rate limit

    Free tier: 5 messages per day
    Premium: Unlimited

    Returns:
        True if within limit, False if exceeded
    """
    from datetime import datetime, timezone, timedelta

    # Get user document
    user = databases.get_document(
        database_id=database_id,
        collection_id='users',
        document_id=user_id
    )

    # Premium users have no limit
    if user.get('isPremium', False):
        return True

    # Count messages in last 24 hours
    yesterday = (datetime.now(timezone.utc) - timedelta(days=1)).isoformat()

    messages = databases.list_documents(
        database_id=database_id,
        collection_id='messages',
        queries=[
            Query.equal('senderId', user_id),
            Query.equal('senderType', 'user'),
            Query.greater_than('createdAt', yesterday)
        ]
    )

    return messages['total'] < 5  # Free tier limit
```

### Deployment Commands

```bash
# Install Appwrite CLI
npm install -g appwrite-cli

# Login to Appwrite
appwrite login

# Initialize project (from functions/ directory)
cd functions/ai-chat-response
appwrite init function

# Deploy function
appwrite deploy function

# Or via Appwrite Console:
# 1. Go to Functions > Create Function
# 2. Name: ai-chat-response
# 3. Runtime: Python 3.11
# 4. Entrypoint: src/main.py
# 5. Upload zip of function folder
# 6. Set environment variables
```

### Environment Variables (Appwrite Console)

```
APPWRITE_API_KEY=your_server_api_key
OPENAI_API_KEY=sk-your_openai_key
DATABASE_ID=your_database_id
```

### Flutter Integration: lib/app/data/services/appwrite_ai_service.dart

```dart
import 'package:appwrite/appwrite.dart';
import '../interfaces/ai_service_interface.dart';

class AppwriteAIService implements IAIService {
  final Functions _functions;
  final String _functionId = 'ai-chat-response';

  AppwriteAIService(Client client) : _functions = Functions(client);

  @override
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  }) async {
    try {
      final execution = await _functions.createExecution(
        functionId: _functionId,
        body: jsonEncode({
          'userId': userId,
          'astrologerId': astrologerId,
          'message': message,
          'sessionId': sessionId,
        }),
        method: 'POST',
      );

      final response = jsonDecode(execution.responseBody);

      if (response['success'] == true) {
        return Result.success(response['response']);
      } else {
        return Result.failure(AppError(response['error'] ?? 'Unknown error'));
      }
    } catch (e) {
      return Result.failure(AppError(e.toString()));
    }
  }
}
```

### Session 2 Checklist

- [ ] Add comprehensive error handling to main.py
- [ ] Implement rate limiting logic
- [ ] Deploy function to Appwrite Cloud
- [ ] Configure environment variables
- [ ] Update Flutter AppwriteAIService
- [ ] Test complete chat flow
- [ ] Monitor function logs for errors

---

## Session 3: Subscription Webhook (4 hours)

### Objectives
1. Create RevenueCat webhook handler
2. Validate webhook signatures
3. Update user subscription status in Appwrite
4. Handle subscription events (purchase, renewal, cancellation)

### Key Deliverables

| Deliverable | Description | Duration |
|-------------|-------------|----------|
| Webhook handler | Process RevenueCat events | 60 min |
| Signature validation | Verify webhook authenticity | 45 min |
| Event handlers | Purchase, renewal, cancel | 90 min |
| User status update | Update isPremium in DB | 30 min |
| Testing | Test with RevenueCat sandbox | 45 min |

### Function: subscription-webhook/src/main.py

```python
import os
import json
import hmac
import hashlib
from appwrite.client import Client
from appwrite.services.databases import Databases
from datetime import datetime, timezone

# RevenueCat Event Types
EVENT_INITIAL_PURCHASE = 'INITIAL_PURCHASE'
EVENT_RENEWAL = 'RENEWAL'
EVENT_CANCELLATION = 'CANCELLATION'
EVENT_EXPIRATION = 'EXPIRATION'
EVENT_BILLING_ISSUE = 'BILLING_ISSUE'
EVENT_PRODUCT_CHANGE = 'PRODUCT_CHANGE'


def main(context):
    """
    RevenueCat Subscription Webhook Handler

    Trigger: HTTP POST (from RevenueCat)
    Input: RevenueCat webhook payload
    Output: { success: bool }
    """
    try:
        # Verify webhook signature
        signature = context.req.headers.get('X-RevenueCat-Signature', '')
        if not verify_signature(context.req.body, signature):
            context.log('Invalid webhook signature')
            return context.res.json({'success': False, 'error': 'Invalid signature'}, 401)

        # Parse payload
        payload = json.loads(context.req.body)
        event = payload.get('event', {})
        event_type = event.get('type')

        context.log(f'Processing event: {event_type}')

        # Initialize Appwrite
        client = init_appwrite_client()
        databases = Databases(client)
        database_id = os.environ.get('DATABASE_ID')

        # Extract user info
        app_user_id = event.get('app_user_id')

        if not app_user_id:
            return context.res.json({'success': False, 'error': 'Missing app_user_id'}, 400)

        # Handle event
        if event_type in [EVENT_INITIAL_PURCHASE, EVENT_RENEWAL]:
            handle_purchase(databases, database_id, app_user_id, event)
        elif event_type in [EVENT_CANCELLATION, EVENT_EXPIRATION]:
            handle_cancellation(databases, database_id, app_user_id, event)
        elif event_type == EVENT_BILLING_ISSUE:
            handle_billing_issue(databases, database_id, app_user_id, event)
        elif event_type == EVENT_PRODUCT_CHANGE:
            handle_product_change(databases, database_id, app_user_id, event)
        else:
            context.log(f'Unhandled event type: {event_type}')

        return context.res.json({'success': True})

    except Exception as e:
        context.log(f'Webhook error: {str(e)}')
        return context.res.json({'success': False, 'error': str(e)}, 500)


def verify_signature(body: str, signature: str) -> bool:
    """
    Verify RevenueCat webhook signature

    Args:
        body: Raw request body
        signature: X-RevenueCat-Signature header

    Returns:
        True if signature is valid
    """
    webhook_secret = os.environ.get('REVENUECAT_WEBHOOK_SECRET', '')

    if not webhook_secret or not signature:
        return False

    expected = hmac.new(
        webhook_secret.encode('utf-8'),
        body.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()

    return hmac.compare_digest(expected, signature)


def init_appwrite_client():
    """Initialize Appwrite client"""
    client = Client()
    client.set_endpoint(os.environ.get('APPWRITE_FUNCTION_API_ENDPOINT'))
    client.set_project(os.environ.get('APPWRITE_FUNCTION_PROJECT_ID'))
    client.set_key(os.environ.get('APPWRITE_API_KEY'))
    return client


def handle_purchase(databases, database_id: str, user_id: str, event: dict):
    """Handle initial purchase or renewal"""
    subscriber_info = event.get('subscriber_info', {})
    entitlements = subscriber_info.get('entitlements', {})

    # Determine subscription tier
    tier = 'free'
    expiration_date = None

    if 'premium' in entitlements:
        tier = 'premium'
        expiration_date = entitlements['premium'].get('expires_date')
    elif 'pro' in entitlements:
        tier = 'pro'
        expiration_date = entitlements['pro'].get('expires_date')
    elif 'basic' in entitlements:
        tier = 'basic'
        expiration_date = entitlements['basic'].get('expires_date')

    # Update user document
    databases.update_document(
        database_id=database_id,
        collection_id='users',
        document_id=user_id,
        data={
            'isPremium': tier != 'free',
            'subscriptionTier': tier,
            'subscriptionExpiry': expiration_date,
            'subscriptionStatus': 'active',
            'updatedAt': datetime.now(timezone.utc).isoformat()
        }
    )


def handle_cancellation(databases, database_id: str, user_id: str, event: dict):
    """Handle subscription cancellation or expiration"""
    databases.update_document(
        database_id=database_id,
        collection_id='users',
        document_id=user_id,
        data={
            'isPremium': False,
            'subscriptionTier': 'free',
            'subscriptionStatus': 'cancelled',
            'updatedAt': datetime.now(timezone.utc).isoformat()
        }
    )


def handle_billing_issue(databases, database_id: str, user_id: str, event: dict):
    """Handle billing issues (grace period)"""
    databases.update_document(
        database_id=database_id,
        collection_id='users',
        document_id=user_id,
        data={
            'subscriptionStatus': 'billing_issue',
            'updatedAt': datetime.now(timezone.utc).isoformat()
        }
    )


def handle_product_change(databases, database_id: str, user_id: str, event: dict):
    """Handle subscription tier change (upgrade/downgrade)"""
    # Treat like a new purchase
    handle_purchase(databases, database_id, user_id, event)
```

### Requirements: subscription-webhook/requirements.txt

```
appwrite>=4.1.0
```

### RevenueCat Webhook Configuration

1. Go to RevenueCat Dashboard > Project > Integrations > Webhooks
2. Add new webhook:
   - URL: `https://[APPWRITE_ENDPOINT]/v1/functions/subscription-webhook/executions`
   - Authorization: Bearer `[FUNCTION_API_KEY]`
3. Select events:
   - INITIAL_PURCHASE
   - RENEWAL
   - CANCELLATION
   - EXPIRATION
   - BILLING_ISSUE
   - PRODUCT_CHANGE

### Session 3 Checklist

- [ ] Create `functions/subscription-webhook/` directory
- [ ] Implement webhook handler with signature verification
- [ ] Implement event handlers for all subscription events
- [ ] Deploy to Appwrite Cloud
- [ ] Configure RevenueCat webhook URL
- [ ] Test with RevenueCat sandbox mode
- [ ] Verify user status updates in database

---

## Session 4: Scheduled Content Functions (4 hours)

### Objectives
1. Create daily horoscope generation function
2. Create daily content rotation function
3. Configure CRON schedules
4. Test scheduled execution

### Key Deliverables

| Deliverable | Description | Duration |
|-------------|-------------|----------|
| Horoscope generator | AI-generated daily horoscopes | 90 min |
| Content rotator | Rotate deity/mantra of day | 60 min |
| CRON configuration | Schedule functions | 30 min |
| Testing | Manual trigger and verify | 60 min |

### Function: generate-daily-horoscope/src/main.py

```python
import os
import json
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
from appwrite.id import ID
from openai import OpenAI
from datetime import datetime, timezone

ZODIAC_SIGNS = [
    'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo',
    'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'
]

CATEGORIES = ['love', 'career', 'health']


def main(context):
    """
    Generate Daily Horoscopes

    Trigger: CRON (daily at 00:00 UTC)
    Creates horoscope documents for all zodiac signs
    """
    try:
        context.log('Starting daily horoscope generation')

        client = init_appwrite_client()
        databases = Databases(client)
        openai_client = OpenAI(api_key=os.environ.get('OPENAI_API_KEY'))
        database_id = os.environ.get('DATABASE_ID')

        today = datetime.now(timezone.utc).strftime('%Y-%m-%d')

        generated_count = 0

        for sign in ZODIAC_SIGNS:
            # Check if already generated
            existing = databases.list_documents(
                database_id=database_id,
                collection_id='horoscopes',
                queries=[
                    Query.equal('zodiacSign', sign),
                    Query.equal('date', today),
                    Query.equal('period', 'daily')
                ]
            )

            if existing['total'] > 0:
                context.log(f'Skipping {sign} - already exists')
                continue

            # Generate horoscope
            horoscope = generate_horoscope(openai_client, sign, today)

            # Save to database
            databases.create_document(
                database_id=database_id,
                collection_id='horoscopes',
                document_id=ID.unique(),
                data={
                    'zodiacSign': sign,
                    'date': today,
                    'period': 'daily',
                    'generalReading': horoscope['general'],
                    'loveReading': horoscope['love'],
                    'careerReading': horoscope['career'],
                    'healthReading': horoscope['health'],
                    'luckyNumber': horoscope['luckyNumber'],
                    'luckyColor': horoscope['luckyColor'],
                    'luckyTime': horoscope['luckyTime'],
                    'energyPercentage': horoscope['energyPercentage'],
                    'dailyTip': horoscope['dailyTip'],
                    'createdAt': datetime.now(timezone.utc).isoformat()
                }
            )

            generated_count += 1
            context.log(f'Generated horoscope for {sign}')

        return context.res.json({
            'success': True,
            'generated': generated_count,
            'date': today
        })

    except Exception as e:
        context.log(f'Error: {str(e)}')
        return context.res.json({'success': False, 'error': str(e)}, 500)


def generate_horoscope(openai_client, sign: str, date: str) -> dict:
    """Generate horoscope content using GPT-4"""

    prompt = f"""Generate a daily horoscope for {sign.capitalize()} for {date}.

Return a JSON object with these fields:
- general: 2-3 sentence general reading (positive and insightful)
- love: 1-2 sentences about love/relationships
- career: 1-2 sentences about career/work
- health: 1-2 sentences about health/wellness
- luckyNumber: a number between 1-99
- luckyColor: a color name
- luckyTime: a time like "2:00 PM - 4:00 PM"
- energyPercentage: number 60-95 (cosmic energy level)
- dailyTip: one actionable tip for the day

Keep the tone warm, encouraging, and spiritually uplifting.
Return ONLY valid JSON, no markdown."""

    response = openai_client.chat.completions.create(
        model='gpt-4',
        messages=[
            {'role': 'system', 'content': 'You are a wise Vedic astrologer. Generate horoscopes in JSON format only.'},
            {'role': 'user', 'content': prompt}
        ],
        temperature=0.8,
        max_tokens=600
    )

    content = response.choices[0].message.content
    return json.loads(content)


def init_appwrite_client():
    client = Client()
    client.set_endpoint(os.environ.get('APPWRITE_FUNCTION_API_ENDPOINT'))
    client.set_project(os.environ.get('APPWRITE_FUNCTION_PROJECT_ID'))
    client.set_key(os.environ.get('APPWRITE_API_KEY'))
    return client
```

### Function: rotate-daily-content/src/main.py

```python
import os
import json
import random
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
from datetime import datetime, timezone

def main(context):
    """
    Rotate Daily Content (Deity & Mantra)

    Trigger: CRON (daily at 00:00 UTC)
    Selects random deity and mantra for "Today's" feature
    """
    try:
        context.log('Starting daily content rotation')

        client = init_appwrite_client()
        databases = Databases(client)
        database_id = os.environ.get('DATABASE_ID')

        today = datetime.now(timezone.utc).strftime('%Y-%m-%d')

        # Rotate deity
        deities = databases.list_documents(
            database_id=database_id,
            collection_id='daily_content',
            queries=[
                Query.equal('type', 'deity'),
                Query.equal('isActive', True)
            ]
        )

        if deities['total'] > 0:
            selected_deity = random.choice(deities['documents'])
            update_today_content(databases, database_id, 'deity', selected_deity['$id'], today)
            context.log(f"Today's deity: {selected_deity.get('nameEn')}")

        # Rotate mantra
        mantras = databases.list_documents(
            database_id=database_id,
            collection_id='daily_content',
            queries=[
                Query.equal('type', 'mantra'),
                Query.equal('isActive', True)
            ]
        )

        if mantras['total'] > 0:
            selected_mantra = random.choice(mantras['documents'])
            update_today_content(databases, database_id, 'mantra', selected_mantra['$id'], today)
            context.log(f"Today's mantra: {selected_mantra.get('titleEn')}")

        return context.res.json({
            'success': True,
            'date': today
        })

    except Exception as e:
        context.log(f'Error: {str(e)}')
        return context.res.json({'success': False, 'error': str(e)}, 500)


def update_today_content(databases, database_id: str, content_type: str, content_id: str, date: str):
    """Update or create today's content pointer"""

    # Check if today's record exists
    existing = databases.list_documents(
        database_id=database_id,
        collection_id='today_content',
        queries=[
            Query.equal('type', content_type),
            Query.equal('date', date)
        ]
    )

    if existing['total'] > 0:
        # Update existing
        databases.update_document(
            database_id=database_id,
            collection_id='today_content',
            document_id=existing['documents'][0]['$id'],
            data={
                'contentId': content_id,
                'updatedAt': datetime.now(timezone.utc).isoformat()
            }
        )
    else:
        # Create new
        from appwrite.id import ID
        databases.create_document(
            database_id=database_id,
            collection_id='today_content',
            document_id=ID.unique(),
            data={
                'type': content_type,
                'date': date,
                'contentId': content_id,
                'createdAt': datetime.now(timezone.utc).isoformat()
            }
        )


def init_appwrite_client():
    client = Client()
    client.set_endpoint(os.environ.get('APPWRITE_FUNCTION_API_ENDPOINT'))
    client.set_project(os.environ.get('APPWRITE_FUNCTION_PROJECT_ID'))
    client.set_key(os.environ.get('APPWRITE_API_KEY'))
    return client
```

### CRON Schedule Configuration

```
# In Appwrite Console > Functions > [Function] > Settings > Schedule

# generate-daily-horoscope
# Run daily at 00:00 UTC (05:30 IST)
0 0 * * *

# rotate-daily-content
# Run daily at 00:05 UTC (05:35 IST)
5 0 * * *
```

### Session 4 Checklist

- [ ] Create `functions/generate-daily-horoscope/` directory
- [ ] Implement horoscope generation with GPT-4
- [ ] Create `functions/rotate-daily-content/` directory
- [ ] Implement deity/mantra rotation logic
- [ ] Deploy both functions to Appwrite Cloud
- [ ] Configure CRON schedules
- [ ] Test manual execution
- [ ] Verify database records created

---

## Deployment Summary

### Function Deployment Order

1. **ai-chat-response** (Session 1-2) - Critical path for chat feature
2. **subscription-webhook** (Session 3) - Required for monetization
3. **generate-daily-horoscope** (Session 4) - Nice to have, can use seeded data initially
4. **rotate-daily-content** (Session 4) - Nice to have

### Environment Variables (All Functions)

| Variable | Description | Required For |
|----------|-------------|--------------|
| `APPWRITE_API_KEY` | Server API key | All |
| `DATABASE_ID` | Appwrite database ID | All |
| `OPENAI_API_KEY` | OpenAI API key | ai-chat-response, generate-daily-horoscope |
| `REVENUECAT_WEBHOOK_SECRET` | Webhook verification | subscription-webhook |

### Testing Checklist

- [ ] ai-chat-response: Send test message, verify response
- [ ] ai-chat-response: Test content moderation (crisis keywords)
- [ ] ai-chat-response: Test rate limiting for free users
- [ ] subscription-webhook: Test with RevenueCat sandbox
- [ ] subscription-webhook: Verify user status updates
- [ ] generate-daily-horoscope: Manual trigger, check database
- [ ] rotate-daily-content: Manual trigger, check today_content

---

## Troubleshooting

### Common Issues

1. **Function timeout**
   - Increase timeout in Appwrite Console (default 15s, max 900s)
   - OpenAI calls may take 5-10s

2. **Import errors**
   - Ensure all dependencies in requirements.txt
   - Check Python version compatibility

3. **Permission errors**
   - Verify APPWRITE_API_KEY has required scopes
   - Check collection permissions

4. **OpenAI rate limits**
   - Implement retry logic with exponential backoff
   - Consider caching responses

### Logs

```bash
# View function logs via CLI
appwrite functions get-execution \
  --function-id ai-chat-response \
  --execution-id [EXECUTION_ID]

# Or in Console: Functions > [Function] > Executions
```
