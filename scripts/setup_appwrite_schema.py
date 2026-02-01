#!/usr/bin/env python3
"""
Appwrite Schema Setup Script for Astro GPT
Creates all collections, attributes, and indexes matching Flutter models exactly.

Usage:
    python scripts/setup_appwrite_schema.py
"""

from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.id import ID
import time

# ============================================
# CONFIGURATION - Update these values
# ============================================
ENDPOINT = "https://appwrite.technoava.com/v1"
PROJECT_ID = "6975ebd500023bbf2235"
API_KEY = "standard_2333f015f16c160ed295899eac062bf283b168c7a7cddbb87d8005834a5b00e9f5ab1bdfd39fa2238b9e33bdfe7bdd3d9624e6cecdc3907093f762c27197e0520c3a29810cd2167efb1f941412a819552e096d662867f4a8cf5eb96b1388e2fde54487eccd415b60ba9ed0e429202b4c533d51716a6b0a302bf3b0e2d1f72d5e"
DATABASE_ID = "astro_gpt_db"

# ============================================
# Initialize Client
# ============================================
client = Client()
client.set_endpoint(ENDPOINT)
client.set_project(PROJECT_ID)
client.set_key(API_KEY)

databases = Databases(client)

def wait_for_attribute(collection_id: str, attribute_key: str, max_retries: int = 30):
    """Wait for attribute to be ready (not 'processing')"""
    for _ in range(max_retries):
        try:
            attr = databases.get_attribute(DATABASE_ID, collection_id, attribute_key)
            if attr.get('status') != 'processing':
                return True
        except:
            pass
        time.sleep(0.5)
    return False

def create_collection_safe(collection_id: str, name: str):
    """Create collection if it doesn't exist"""
    try:
        databases.get_collection(DATABASE_ID, collection_id)
        print(f"  Collection '{collection_id}' already exists")
        return True
    except:
        pass

    try:
        databases.create_collection(
            database_id=DATABASE_ID,
            collection_id=collection_id,
            name=name,
            permissions=[
                'read("any")',
                'create("users")',
                'update("users")',
                'delete("users")',
            ]
        )
        print(f"  Created collection: {collection_id}")
        return True
    except Exception as e:
        print(f"  Error creating collection {collection_id}: {e}")
        return False

def create_string_attr(collection_id: str, key: str, size: int, required: bool = False, default: str = None, array: bool = False):
    """Create string attribute"""
    try:
        if array:
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                size=size,
                required=required,
                array=True
            )
        elif default is not None:
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                size=size,
                required=required,
                default=default
            )
        else:
            databases.create_string_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                size=size,
                required=required
            )
        wait_for_attribute(collection_id, key)
        print(f"    + {key} (string, size={size})")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ {key} already exists")
        else:
            print(f"    ! Error creating {key}: {e}")

def create_integer_attr(collection_id: str, key: str, required: bool = False, default: int = None, array: bool = False):
    """Create integer attribute"""
    try:
        if array:
            databases.create_integer_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required,
                array=True
            )
        elif default is not None:
            databases.create_integer_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required,
                default=default
            )
        else:
            databases.create_integer_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required
            )
        wait_for_attribute(collection_id, key)
        print(f"    + {key} (integer)")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ {key} already exists")
        else:
            print(f"    ! Error creating {key}: {e}")

def create_float_attr(collection_id: str, key: str, required: bool = False, default: float = None):
    """Create float attribute"""
    try:
        if default is not None:
            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required,
                default=default
            )
        else:
            databases.create_float_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required
            )
        wait_for_attribute(collection_id, key)
        print(f"    + {key} (float)")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ {key} already exists")
        else:
            print(f"    ! Error creating {key}: {e}")

def create_boolean_attr(collection_id: str, key: str, required: bool = False, default: bool = None):
    """Create boolean attribute"""
    try:
        if default is not None:
            databases.create_boolean_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required,
                default=default
            )
        else:
            databases.create_boolean_attribute(
                database_id=DATABASE_ID,
                collection_id=collection_id,
                key=key,
                required=required
            )
        wait_for_attribute(collection_id, key)
        print(f"    + {key} (boolean)")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ {key} already exists")
        else:
            print(f"    ! Error creating {key}: {e}")

def create_datetime_attr(collection_id: str, key: str, required: bool = False):
    """Create datetime attribute"""
    try:
        databases.create_datetime_attribute(
            database_id=DATABASE_ID,
            collection_id=collection_id,
            key=key,
            required=required
        )
        wait_for_attribute(collection_id, key)
        print(f"    + {key} (datetime)")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ {key} already exists")
        else:
            print(f"    ! Error creating {key}: {e}")

def create_index(collection_id: str, key: str, index_type: str, attributes: list, orders: list = None):
    """Create index"""
    try:
        if orders is None:
            orders = ["ASC"] * len(attributes)
        databases.create_index(
            database_id=DATABASE_ID,
            collection_id=collection_id,
            key=key,
            type=index_type,
            attributes=attributes,
            orders=orders
        )
        print(f"    + Index: {key} ({index_type})")
    except Exception as e:
        if "already exists" in str(e).lower():
            print(f"    ~ Index {key} already exists")
        else:
            print(f"    ! Error creating index {key}: {e}")


# ============================================
# COLLECTION DEFINITIONS (from Flutter models)
# ============================================

def setup_users_collection():
    """Users collection - matches UserModel"""
    print("\n[1/11] Setting up 'users' collection...")
    if not create_collection_safe("users", "Users"):
        return

    # Attributes from user_model.dart toMap()
    create_string_attr("users", "userId", 36, required=True)
    create_string_attr("users", "email", 255, required=True)
    create_string_attr("users", "fullName", 100, required=True)
    create_string_attr("users", "gender", 10, required=True)
    create_datetime_attr("users", "dateOfBirth", required=True)
    create_string_attr("users", "zodiacSign", 20, required=False)
    create_string_attr("users", "preferredLanguage", 5, required=False, default="en")
    create_string_attr("users", "profilePhotoUrl", 500, required=False)
    create_string_attr("users", "fcmToken", 500, required=False)
    create_datetime_attr("users", "createdAt", required=False)
    create_datetime_attr("users", "updatedAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("users", "userId_idx", "unique", ["userId"])
    create_index("users", "email_idx", "unique", ["email"])

def setup_astrologers_collection():
    """Astrologers collection - matches AstrologerModel"""
    print("\n[2/11] Setting up 'astrologers' collection...")
    if not create_collection_safe("astrologers", "Astrologers"):
        return

    # Attributes from astrologer_model.dart toMap()
    create_string_attr("astrologers", "name", 100, required=True)
    create_string_attr("astrologers", "photoUrl", 500, required=True)
    create_string_attr("astrologers", "heroImageUrl", 500, required=False)
    create_string_attr("astrologers", "bio", 2000, required=True)
    create_string_attr("astrologers", "specialization", 100, required=True)
    create_string_attr("astrologers", "expertiseTags", 100, required=False, array=True)
    create_string_attr("astrologers", "languages", 50, required=False, array=True)
    create_float_attr("astrologers", "rating", required=False, default=0.0)
    create_integer_attr("astrologers", "reviewCount", required=False, default=0)
    create_integer_attr("astrologers", "chatCount", required=False, default=0)
    create_string_attr("astrologers", "category", 20, required=True)
    create_boolean_attr("astrologers", "isActive", required=False, default=True)
    create_string_attr("astrologers", "aiPersonaPrompt", 10000, required=False)
    create_integer_attr("astrologers", "displayOrder", required=False, default=0)
    create_datetime_attr("astrologers", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("astrologers", "category_idx", "key", ["category"])
    create_index("astrologers", "isActive_idx", "key", ["isActive"])
    create_index("astrologers", "displayOrder_idx", "key", ["displayOrder"])

def setup_messages_collection():
    """Messages collection - matches MessageModel"""
    print("\n[3/11] Setting up 'messages' collection...")
    if not create_collection_safe("messages", "Messages"):
        return

    # Attributes from message_model.dart toMap()
    create_string_attr("messages", "sessionId", 36, required=True)
    create_string_attr("messages", "senderType", 20, required=True)
    create_string_attr("messages", "content", 5000, required=True)
    create_boolean_attr("messages", "isRead", required=False, default=False)
    create_datetime_attr("messages", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("messages", "sessionId_idx", "key", ["sessionId"])
    create_index("messages", "sessionId_createdAt_idx", "key", ["sessionId", "createdAt"])

def setup_chat_sessions_collection():
    """Chat Sessions collection - matches ChatSessionModel"""
    print("\n[4/11] Setting up 'chat_sessions' collection...")
    if not create_collection_safe("chat_sessions", "Chat Sessions"):
        return

    # Attributes from chat_session_model.dart toMap()
    create_string_attr("chat_sessions", "userId", 36, required=True)
    create_string_attr("chat_sessions", "astrologerId", 36, required=True)
    create_datetime_attr("chat_sessions", "lastMessageAt", required=False)
    create_integer_attr("chat_sessions", "messageCount", required=False, default=0)
    create_boolean_attr("chat_sessions", "isActive", required=False, default=True)
    create_datetime_attr("chat_sessions", "createdAt", required=False)
    create_datetime_attr("chat_sessions", "updatedAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("chat_sessions", "userId_idx", "key", ["userId"])
    create_index("chat_sessions", "userId_astrologerId_idx", "unique", ["userId", "astrologerId"])

def setup_horoscopes_collection():
    """Horoscopes collection - matches HoroscopeModel (with extra fields from model)"""
    print("\n[5/11] Setting up 'horoscopes' collection...")
    if not create_collection_safe("horoscopes", "Horoscopes"):
        return

    # Attributes from horoscope_model.dart toMap()
    create_string_attr("horoscopes", "zodiacSign", 20, required=True)
    create_string_attr("horoscopes", "periodType", 10, required=True)
    create_string_attr("horoscopes", "category", 20, required=True)

    # Content fields - support both naming conventions
    create_string_attr("horoscopes", "contentEn", 3000, required=False)  # Appwrite name
    create_string_attr("horoscopes", "contentHi", 3000, required=False)  # Appwrite name
    create_string_attr("horoscopes", "predictionText", 3000, required=False)  # Legacy name
    create_string_attr("horoscopes", "predictionTextHi", 3000, required=False)  # Legacy name

    create_string_attr("horoscopes", "tipText", 500, required=False)
    create_string_attr("horoscopes", "tipTextHi", 500, required=False)
    create_integer_attr("horoscopes", "energyLevel", required=False, default=50)

    # Category-specific predictions (from Flutter model)
    create_integer_attr("horoscopes", "lovePercentage", required=False, default=0)
    create_string_attr("horoscopes", "lovePrediction", 1000, required=False)
    create_integer_attr("horoscopes", "careerPercentage", required=False, default=0)
    create_string_attr("horoscopes", "careerPrediction", 1000, required=False)
    create_integer_attr("horoscopes", "healthPercentage", required=False, default=0)
    create_string_attr("horoscopes", "healthPrediction", 1000, required=False)

    # Lucky items (from Flutter model)
    create_integer_attr("horoscopes", "luckyNumbers", required=False, array=True)
    create_string_attr("horoscopes", "luckyColor", 50, required=False)
    create_string_attr("horoscopes", "luckyTime", 50, required=False)

    create_datetime_attr("horoscopes", "validDate", required=True)
    create_datetime_attr("horoscopes", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("horoscopes", "zodiac_period_date_idx", "key", ["zodiacSign", "periodType", "validDate"])
    create_index("horoscopes", "validDate_idx", "key", ["validDate"])

def setup_daily_content_collection():
    """Daily Content collection - matches DailyContentModel"""
    print("\n[6/11] Setting up 'daily_content' collection...")
    if not create_collection_safe("daily_content", "Daily Content"):
        return

    # Attributes from daily_content_model.dart toMap()
    create_string_attr("daily_content", "type", 20, required=True)
    create_string_attr("daily_content", "title", 200, required=True)
    create_string_attr("daily_content", "titleHi", 200, required=False)
    create_string_attr("daily_content", "description", 5000, required=True)
    create_string_attr("daily_content", "descriptionHi", 5000, required=False)
    create_string_attr("daily_content", "imageUrl", 500, required=False)
    create_string_attr("daily_content", "audioUrl", 500, required=False)
    create_boolean_attr("daily_content", "isActive", required=False, default=True)
    create_datetime_attr("daily_content", "validDate", required=False)
    create_datetime_attr("daily_content", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("daily_content", "type_idx", "key", ["type"])
    create_index("daily_content", "isActive_idx", "key", ["isActive"])

def setup_today_content_collection():
    """Today Content collection - for daily content selection"""
    print("\n[7/11] Setting up 'today_content' collection...")
    if not create_collection_safe("today_content", "Today Content"):
        return

    # Attributes from schema reference
    create_string_attr("today_content", "type", 20, required=True)
    create_string_attr("today_content", "contentId", 36, required=True)
    create_string_attr("today_content", "validDate", 10, required=True)  # YYYY-MM-DD format
    create_datetime_attr("today_content", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("today_content", "type_date_idx", "unique", ["type", "validDate"])

def setup_subscriptions_collection():
    """Subscriptions collection"""
    print("\n[8/11] Setting up 'subscriptions' collection...")
    if not create_collection_safe("subscriptions", "Subscriptions"):
        return

    # Attributes from schema reference
    create_string_attr("subscriptions", "userId", 36, required=True)
    create_string_attr("subscriptions", "tier", 20, required=True)
    create_string_attr("subscriptions", "status", 20, required=True)
    create_string_attr("subscriptions", "platform", 10, required=True)
    create_string_attr("subscriptions", "productId", 100, required=False)
    create_string_attr("subscriptions", "transactionId", 100, required=False)
    create_datetime_attr("subscriptions", "startDate", required=True)
    create_datetime_attr("subscriptions", "endDate", required=False)
    create_integer_attr("subscriptions", "chatCredits", required=False, default=5)
    create_boolean_attr("subscriptions", "adsRemoved", required=False, default=False)
    create_datetime_attr("subscriptions", "createdAt", required=False)
    create_datetime_attr("subscriptions", "updatedAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("subscriptions", "userId_idx", "unique", ["userId"])

def setup_reviews_collection():
    """Reviews collection - matches ReviewModel"""
    print("\n[9/11] Setting up 'reviews' collection...")
    if not create_collection_safe("reviews", "Reviews"):
        return

    # Attributes from review_model.dart toMap()
    create_string_attr("reviews", "astrologerId", 36, required=True)
    create_string_attr("reviews", "userId", 36, required=True)
    create_string_attr("reviews", "userName", 100, required=True)
    create_integer_attr("reviews", "rating", required=True)
    create_string_attr("reviews", "text", 1000, required=False)
    create_datetime_attr("reviews", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("reviews", "astrologerId_idx", "key", ["astrologerId"])
    create_index("reviews", "userId_astrologerId_idx", "unique", ["userId", "astrologerId"])

def setup_favorites_collection():
    """Favorites collection"""
    print("\n[10/11] Setting up 'favorites' collection...")
    if not create_collection_safe("favorites", "Favorites"):
        return

    # Attributes from schema reference
    create_string_attr("favorites", "userId", 36, required=True)
    create_string_attr("favorites", "astrologerId", 36, required=True)
    create_datetime_attr("favorites", "createdAt", required=False)

    # Indexes
    print("  Creating indexes...")
    create_index("favorites", "userId_idx", "key", ["userId"])
    create_index("favorites", "userId_astrologerId_idx", "unique", ["userId", "astrologerId"])

def setup_faqs_collection():
    """FAQs collection - matches FAQModel"""
    print("\n[11/11] Setting up 'faqs' collection...")
    if not create_collection_safe("faqs", "FAQs"):
        return

    # Attributes from faq_model.dart toMap()
    create_string_attr("faqs", "questionEn", 500, required=True)
    create_string_attr("faqs", "questionHi", 500, required=True)
    create_string_attr("faqs", "category", 20, required=False)
    create_string_attr("faqs", "astrologerId", 36, required=False)
    create_integer_attr("faqs", "displayOrder", required=False, default=0)
    create_boolean_attr("faqs", "isActive", required=False, default=True)

    # Indexes
    print("  Creating indexes...")
    create_index("faqs", "category_idx", "key", ["category"])
    create_index("faqs", "isActive_idx", "key", ["isActive"])
    create_index("faqs", "displayOrder_idx", "key", ["displayOrder"])


def main():
    print("=" * 60)
    print("Astro GPT - Appwrite Schema Setup")
    print("=" * 60)
    print(f"Endpoint: {ENDPOINT}")
    print(f"Project:  {PROJECT_ID}")
    print(f"Database: {DATABASE_ID}")
    print("=" * 60)

    # Verify database exists
    try:
        databases.get(DATABASE_ID)
        print(f"\nDatabase '{DATABASE_ID}' found.")
    except Exception as e:
        print(f"\nError: Database '{DATABASE_ID}' not found. Create it first.")
        print(f"Run: appwrite databases create --database-id {DATABASE_ID} --name 'Astro GPT'")
        return

    # Setup all collections
    setup_users_collection()
    setup_astrologers_collection()
    setup_messages_collection()
    setup_chat_sessions_collection()
    setup_horoscopes_collection()
    setup_daily_content_collection()
    setup_today_content_collection()
    setup_subscriptions_collection()
    setup_reviews_collection()
    setup_favorites_collection()
    setup_faqs_collection()

    print("\n" + "=" * 60)
    print("Schema setup complete!")
    print("=" * 60)
    print("\nNext steps:")
    print("1. Run seed scripts to populate data")
    print("2. Update Flutter app config to use self-hosted endpoint")


if __name__ == "__main__":
    main()
