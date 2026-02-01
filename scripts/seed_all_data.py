#!/usr/bin/env python3
"""
Seed script for all Appwrite collections (except astrologers).
Run: python3 scripts/seed_all_data.py
"""

import random
from datetime import datetime, timedelta
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.id import ID

# Appwrite Configuration (Self-Hosted)
ENDPOINT = "https://appwrite.technoava.com/v1"
PROJECT_ID = "6975ebd500023bbf2235"
API_KEY = "standard_2333f015f16c160ed295899eac062bf283b168c7a7cddbb87d8005834a5b00e9f5ab1bdfd39fa2238b9e33bdfe7bdd3d9624e6cecdc3907093f762c27197e0520c3a29810cd2167efb1f941412a819552e096d662867f4a8cf5eb96b1388e2fde54487eccd415b60ba9ed0e429202b4c533d51716a6b0a302bf3b0e2d1f72d5e"
DATABASE_ID = "astro_gpt_db"

# Zodiac Signs
ZODIAC_SIGNS = [
    "aries", "taurus", "gemini", "cancer", "leo", "virgo",
    "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces"
]

ZODIAC_NAMES_HI = {
    "aries": "mesh", "taurus": "vrishabha", "gemini": "mithun",
    "cancer": "kark", "leo": "simha", "virgo": "kanya",
    "libra": "tula", "scorpio": "vrishchik", "sagittarius": "dhanu",
    "capricorn": "makar", "aquarius": "kumbh", "pisces": "meen"
}

# Horoscope templates
HOROSCOPE_TEMPLATES = {
    "love": [
        ("Today brings romantic opportunities. Venus influences your heart, making it an ideal time for deep conversations with your partner or meeting someone special.",
         "Aaj romantic avsar laata hai. Shukra aapke dil ko prabhavit karta hai, jo aapke partner ke saath gehri baatcheet ya kisi khaas se milne ka sahi samay hai."),
        ("Your emotional sensitivity is heightened today. Express your feelings openly and watch your relationships flourish under the stars' guidance.",
         "Aaj aapki bhavnatmak samvedanshilta badhi hui hai. Apni bhavnaon ko khulkar vyakt karein aur sitaron ke margdarshan mein apne rishton ko phalta-phulta dekhein."),
        ("A past connection may resurface today. Consider what your heart truly desires before making any decisions about rekindling old flames.",
         "Aaj koi purana rishta phir se samne aa sakta hai. Purane rishton ko phir se shuru karne se pehle sochein ki aapka dil sachmuch kya chahta hai."),
    ],
    "career": [
        ("Professional growth is highlighted today. Your hard work will be noticed by superiors, and new opportunities may arise unexpectedly.",
         "Aaj vyavsayik vikas par prakash padta hai. Aapki mehnat adhikariyon dwara dekhi jayegi, aur naye avsar achanak aa sakte hain."),
        ("Focus on collaboration today. Working with others will lead to innovative solutions and strengthen your position in the workplace.",
         "Aaj sahyog par dhyan dein. Doosron ke saath kaam karne se naveen samadhan milenge aur karyasthal mein aapki sthiti mazboot hogi."),
        ("Financial matters need attention today. Review your investments and consider seeking advice from a trusted mentor or advisor.",
         "Aaj vittiya mamlon par dhyan dena chahiye. Apne nivesh ki samiksha karein aur vishvasniya margdarshak se salah lene par vichar karein."),
    ],
    "health": [
        ("Energy levels are high today. Channel this vitality into physical activities and maintain a balanced diet for optimal wellness.",
         "Aaj urja star ucch hai. Is jeevantata ko sharirik gatividhiyon mein lagayen aur swasthya ke liye santulit aahar lein."),
        ("Mental wellness takes priority today. Practice meditation or deep breathing exercises to maintain inner peace and clarity.",
         "Aaj mansik swasthya praathmikta hai. Aantarik shanti aur spashtata ke liye dhyan ya gehri saans ke abhyas karein."),
        ("Listen to your body's signals today. Rest when needed and avoid overexertion to maintain your physical well-being.",
         "Aaj apne sharir ke sanket sunein. Jab zaroorat ho aaram karein aur sharirik swasthya ke liye zyada parishram se bachein."),
    ],
}

HOROSCOPE_TIPS = [
    ("Wear red for enhanced energy", "Urja badhane ke liye laal rang pehnen"),
    ("Chant Om 108 times for peace", "Shanti ke liye Om ka 108 baar jaap karein"),
    ("Donate food to the needy", "Zarooratmandon ko bhojan daan karein"),
    ("Light a diya in the evening", "Sham ko diya jalayein"),
    ("Feed birds early morning", "Subah jaldi pakshiyon ko dana dein"),
    ("Meditate for 15 minutes", "15 minute dhyan karein"),
    ("Offer water to Tulsi plant", "Tulsi ko jal arpan karein"),
    ("Read spiritual texts", "Adhyatmik granth padhein"),
]

# Daily Content - Mantras
MANTRAS = [
    {
        "title": "Gayatri Mantra",
        "titleHi": "Gayatri Mantra",
        "description": "Om Bhur Bhuva Swaha, Tat Savitur Varenyam, Bhargo Devasya Dhimahi, Dhiyo Yo Nah Prachodayat. This sacred mantra illuminates the mind and brings divine wisdom.",
        "descriptionHi": "Om Bhur Bhuva Swaha, Tat Savitur Varenyam, Bhargo Devasya Dhimahi, Dhiyo Yo Nah Prachodayat. Yeh pavitra mantra mann ko prakashit karta hai aur divya gyan laata hai.",
    },
    {
        "title": "Mahamrityunjaya Mantra",
        "titleHi": "Mahamrityunjaya Mantra",
        "description": "Om Tryambakam Yajamahe Sugandhim Pushtivardhanam, Urvarukamiva Bandhanan Mrityor Mukshiya Maamritat. This powerful mantra protects from illness and bestows longevity.",
        "descriptionHi": "Om Tryambakam Yajamahe Sugandhim Pushtivardhanam, Urvarukamiva Bandhanan Mrityor Mukshiya Maamritat. Yeh shaktishali mantra rog se bachata hai aur deergh aayu pradaan karta hai.",
    },
    {
        "title": "Ganesh Mantra",
        "titleHi": "Ganesh Mantra",
        "description": "Om Gam Ganapataye Namaha. Invoke Lord Ganesha to remove obstacles from your path and bring success in new beginnings.",
        "descriptionHi": "Om Gam Ganapataye Namaha. Apne marg se baadhaon ko door karne aur naye aarambh mein safalta laane ke liye Bhagwan Ganesh ka aahvaan karein.",
    },
    {
        "title": "Lakshmi Mantra",
        "titleHi": "Lakshmi Mantra",
        "description": "Om Shreem Mahalakshmiyei Namaha. This mantra invokes Goddess Lakshmi for abundance, prosperity, and spiritual wealth.",
        "descriptionHi": "Om Shreem Mahalakshmiyei Namaha. Yeh mantra samriddhi, dhanwan aur adhyatmik dhan ke liye Devi Lakshmi ka aahvaan karta hai.",
    },
    {
        "title": "Shiva Mantra",
        "titleHi": "Shiva Mantra",
        "description": "Om Namah Shivaya. The five-syllable mantra that purifies the soul and connects you to the cosmic consciousness of Lord Shiva.",
        "descriptionHi": "Om Namah Shivaya. Paanch akshar ka mantra jo aatma ko shuddh karta hai aur aapko Bhagwan Shiv ki brahmaand chetna se jodta hai.",
    },
    {
        "title": "Hanuman Mantra",
        "titleHi": "Hanuman Mantra",
        "description": "Om Hanumate Namaha. Chant this mantra for courage, strength, and protection from negative energies.",
        "descriptionHi": "Om Hanumate Namaha. Sahas, shakti aur nkaratmak urja se suraksha ke liye is mantra ka jaap karein.",
    },
    {
        "title": "Saraswati Mantra",
        "titleHi": "Saraswati Mantra",
        "description": "Om Aim Saraswatyai Namaha. Invoke Goddess Saraswati for knowledge, wisdom, and excellence in arts and education.",
        "descriptionHi": "Om Aim Saraswatyai Namaha. Gyan, buddhi aur kala-shiksha mein utkrishtata ke liye Devi Saraswati ka aahvaan karein.",
    },
    {
        "title": "Durga Mantra",
        "titleHi": "Durga Mantra",
        "description": "Om Dum Durgayei Namaha. This powerful mantra invokes Goddess Durga for protection and victory over evil forces.",
        "descriptionHi": "Om Dum Durgayei Namaha. Yeh shaktishali mantra suraksha aur buri shaktiyon par vijay ke liye Devi Durga ka aahvaan karta hai.",
    },
    {
        "title": "Vishnu Mantra",
        "titleHi": "Vishnu Mantra",
        "description": "Om Namo Narayanaya. Chant this mantra to invoke Lord Vishnu for peace, preservation, and spiritual liberation.",
        "descriptionHi": "Om Namo Narayanaya. Shanti, sanrakshan aur adhyatmik mukti ke liye Bhagwan Vishnu ka aahvaan karein.",
    },
    {
        "title": "Krishna Mantra",
        "titleHi": "Krishna Mantra",
        "description": "Hare Krishna Hare Krishna, Krishna Krishna Hare Hare, Hare Rama Hare Rama, Rama Rama Hare Hare. The Mahamantra for divine love and spiritual awakening.",
        "descriptionHi": "Hare Krishna Hare Krishna, Krishna Krishna Hare Hare, Hare Rama Hare Rama, Rama Rama Hare Hare. Divya prem aur adhyatmik jagriti ke liye Mahamantra.",
    },
]

# Daily Content - Deities
DEITIES = [
    {
        "title": "Lord Ganesha",
        "titleHi": "Bhagwan Ganesh",
        "description": "The elephant-headed god of beginnings and remover of obstacles. Worship Ganesha before starting any new venture for success and wisdom. He is the son of Shiva and Parvati.",
        "descriptionHi": "Aarambh ke devta aur vighnharta. Kisi bhi naye kary ki shuruat se pehle safalta aur buddhi ke liye Ganesh ji ki pooja karein. Ve Shiv aur Parvati ke putra hain.",
        "imageUrl": "https://images.unsplash.com/photo-1567591370504-80142b28f1c1?w=800&q=80",
        "significance": "Lord Ganesha is worshipped at the beginning of any new endeavor, ceremony, or venture. His blessings remove obstacles from your path and ensure success. Today is auspicious for starting new projects, signing contracts, or making important life decisions. Invoke his wisdom before examinations or business meetings.",
        "mantra": "Om Gam Ganapataye Namaha",
    },
    {
        "title": "Goddess Lakshmi",
        "titleHi": "Devi Lakshmi",
        "description": "The goddess of wealth, fortune, and prosperity. Worship her on Fridays and during Diwali for abundance and material blessings. She is the consort of Lord Vishnu.",
        "descriptionHi": "Dhan, bhagya aur samriddhi ki devi. Samriddhi aur bhautik ashirwad ke liye Shukravar aur Diwali mein unki pooja karein. Ve Bhagwan Vishnu ki patni hain.",
        "imageUrl": "https://images.unsplash.com/photo-1604424167228-7269452c8e82?w=800&q=80",
        "significance": "Goddess Lakshmi brings wealth, prosperity, and abundance into your life. Today is favorable for financial planning, investments, and business decisions. Light a lamp in her honor to attract material blessings and spiritual wealth. Keep your home and workplace clean to invite her divine presence.",
        "mantra": "Om Shreem Mahalakshmiyei Namaha",
    },
    {
        "title": "Lord Shiva",
        "titleHi": "Bhagwan Shiv",
        "description": "The destroyer and transformer in the Hindu trinity. Worship Shiva on Mondays and during Shravan for liberation and spiritual growth. He resides in Mount Kailash.",
        "descriptionHi": "Hindu tritay mein samharak aur parivartak. Mukti aur adhyatmik vikas ke liye Somvar aur Shravan mein Shiv ji ki pooja karein. Ve Kailash parvat par nivass karte hain.",
        "imageUrl": "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=800&q=80",
        "significance": "Lord Shiva represents transformation and spiritual awakening. Today is powerful for meditation, letting go of the past, and embracing change. Offer water and bilva leaves to Shiva for inner peace and liberation from worldly attachments. His energy helps destroy negative patterns and renew your spirit.",
        "mantra": "Om Namah Shivaya",
    },
    {
        "title": "Lord Vishnu",
        "titleHi": "Bhagwan Vishnu",
        "description": "The preserver of the universe. Worship Vishnu on Thursdays for peace, prosperity, and protection. He has taken ten avatars including Rama and Krishna.",
        "descriptionHi": "Brahmaand ke sanrakshak. Shanti, samriddhi aur suraksha ke liye Guruvar ko Vishnu ji ki pooja karein. Unhone Ram aur Krishna sahit das avatar liye hain.",
        "imageUrl": "https://images.unsplash.com/photo-1606560359959-a698c7fc7bb0?w=800&q=80",
        "significance": "Lord Vishnu maintains cosmic order and protects dharma. Today is ideal for seeking protection, maintaining balance in life, and upholding righteousness. His blessings bring stability to your family and career. Recite his name for peace of mind and divine grace in challenging times.",
        "mantra": "Om Namo Narayanaya",
    },
    {
        "title": "Goddess Durga",
        "titleHi": "Devi Durga",
        "description": "The warrior goddess who destroys evil. Worship her during Navratri for strength, protection, and victory over negative forces in life.",
        "descriptionHi": "Buraai ka naash karne wali yoddha devi. Shakti, suraksha aur jeevan mein nakaratmak shaktiyon par vijay ke liye Navratri mein unki pooja karein.",
        "imageUrl": "https://images.unsplash.com/photo-1633398142923-e8e049902a80?w=800&q=80",
        "significance": "Goddess Durga embodies divine feminine power and courage. Today is excellent for overcoming obstacles, fighting injustice, and protecting yourself from negativity. Her energy empowers you to face challenges with strength and grace. Invoke her blessings when you need courage and protection in difficult situations.",
        "mantra": "Om Dum Durgayei Namaha",
    },
    {
        "title": "Lord Hanuman",
        "titleHi": "Bhagwan Hanuman",
        "description": "The devoted servant of Lord Rama and symbol of strength. Worship Hanuman on Tuesdays and Saturdays for courage and protection from evil.",
        "descriptionHi": "Bhagwan Ram ke bhakt sevak aur shakti ke pratik. Sahas aur buraai se suraksha ke liye Mangalvar aur Shanivar ko Hanuman ji ki pooja karein.",
        "imageUrl": "https://images.unsplash.com/photo-1580835845421-e6f1e89b9e18?w=800&q=80",
        "significance": "Lord Hanuman grants immense physical and mental strength. Today is powerful for overcoming fear, building confidence, and defeating enemies. His devotion to Lord Rama inspires unwavering faith and loyalty. Chant his name for protection from negative energies, accidents, and health issues.",
        "mantra": "Om Hanumate Namaha",
    },
    {
        "title": "Goddess Saraswati",
        "titleHi": "Devi Saraswati",
        "description": "The goddess of knowledge, music, and arts. Worship her during Basant Panchami and before exams for wisdom and academic success.",
        "descriptionHi": "Gyan, sangeet aur kala ki devi. Buddhi aur shaikshik safalta ke liye Basant Panchami aur pariksha se pehle unki pooja karein.",
        "imageUrl": "https://images.unsplash.com/photo-1598524589462-891fba18d66c?w=800&q=80",
        "significance": "Goddess Saraswati bestows knowledge, wisdom, and creative abilities. Today is auspicious for students, artists, musicians, and writers. Seek her blessings before exams, presentations, or creative projects. Her divine grace enhances learning, eloquence, and artistic expression in all endeavors.",
        "mantra": "Om Aim Saraswatyai Namaha",
    },
    {
        "title": "Lord Krishna",
        "titleHi": "Bhagwan Krishna",
        "description": "The divine charioteer and speaker of Bhagavad Gita. Worship Krishna on Janmashtami and Wednesdays for love, wisdom, and divine grace.",
        "descriptionHi": "Divya sarathi aur Bhagavad Gita ke vakta. Prem, gyan aur divya kripa ke liye Janmashtami aur Budhvar ko Krishna ji ki pooja karein.",
        "imageUrl": "https://images.unsplash.com/photo-1606667082541-c22c2dd66912?w=800&q=80",
        "significance": "Lord Krishna teaches the path of devotion, duty, and wisdom. Today is ideal for deepening spiritual understanding and finding joy in life's challenges. His teachings from the Bhagavad Gita provide guidance in difficult decisions. Worship him for divine love, playfulness, and detachment from worldly outcomes.",
        "mantra": "Hare Krishna Hare Krishna, Krishna Krishna Hare Hare, Hare Rama Hare Rama, Rama Rama Hare Hare",
    },
    {
        "title": "Lord Rama",
        "titleHi": "Bhagwan Ram",
        "description": "The ideal king and embodiment of dharma. Worship Rama for righteousness, family harmony, and moral strength. Chant his name for peace.",
        "descriptionHi": "Adarsh raja aur dharma ke pratik. Dharm, parivarik sadbhav aur naitik shakti ke liye Ram ji ki pooja karein. Shanti ke liye unka naam japein.",
        "imageUrl": "https://images.unsplash.com/photo-1619524656850-5b8f64e3e8e3?w=800&q=80",
        "significance": "Lord Rama represents righteousness, truth, and ideal conduct. Today is perfect for strengthening family bonds, making ethical decisions, and upholding moral values. His life teaches us duty, honor, and compassion. Chant his name for inner peace, family harmony, and victory over personal demons.",
        "mantra": "Om Shri Ramaya Namaha",
    },
    {
        "title": "Lord Surya",
        "titleHi": "Bhagwan Surya",
        "description": "The sun god who brings light and life. Worship Surya on Sundays and offer water at sunrise for health, vitality, and success.",
        "descriptionHi": "Prakash aur jeevan dene wale surya devta. Swasthya, jeevantata aur safalta ke liye Ravivar ko Surya ji ki pooja karein aur suryoday mein jal arpan karein.",
        "imageUrl": "https://images.unsplash.com/photo-1593642532973-d31b6557fa68?w=800&q=80",
        "significance": "Lord Surya provides life energy and vitality to all beings. Today is excellent for boosting health, gaining recognition, and achieving success. Offer water to the rising sun for eye health and overall well-being. His divine light dispels darkness, ignorance, and diseases from your life.",
        "mantra": "Om Suryaya Namaha",
    },
]

# FAQs
FAQS = [
    {
        "questionEn": "How accurate are the horoscope predictions?",
        "questionHi": "Rashifal ki bhavishyavaniyan kitni sahi hoti hain?",
        "category": "general",
    },
    {
        "questionEn": "What is my lucky color for today?",
        "questionHi": "Aaj mera lucky color kya hai?",
        "category": "daily",
    },
    {
        "questionEn": "Which gemstone should I wear for my zodiac sign?",
        "questionHi": "Meri rashi ke liye kaunsa ratna pehenna chahiye?",
        "category": "remedies",
    },
    {
        "questionEn": "What does my birth chart reveal about my career?",
        "questionHi": "Meri kundali meri career ke baare mein kya batati hai?",
        "category": "career",
    },
    {
        "questionEn": "When will I get married according to astrology?",
        "questionHi": "Jyotish ke anusar meri shaadi kab hogi?",
        "category": "love",
    },
    {
        "questionEn": "How can I improve my relationship with my partner?",
        "questionHi": "Main apne partner ke saath rishta kaise sudhar sakta/sakti hoon?",
        "category": "love",
    },
    {
        "questionEn": "What are the remedies for Shani Dosh?",
        "questionHi": "Shani Dosh ke upay kya hain?",
        "category": "remedies",
    },
    {
        "questionEn": "Is this year favorable for starting a new business?",
        "questionHi": "Kya yeh saal naya vyapar shuru karne ke liye anukool hai?",
        "category": "career",
    },
    {
        "questionEn": "What mantra should I chant for peace of mind?",
        "questionHi": "Man ki shanti ke liye mujhe kaun sa mantra japna chahiye?",
        "category": "spiritual",
    },
    {
        "questionEn": "How does Rahu affect my life?",
        "questionHi": "Rahu meri zindagi ko kaise prabhavit karta hai?",
        "category": "planets",
    },
    {
        "questionEn": "What is Mangal Dosh and does it affect marriage?",
        "questionHi": "Mangal Dosh kya hai aur kya yeh shaadi ko prabhavit karta hai?",
        "category": "love",
    },
    {
        "questionEn": "Which day is auspicious for buying a new vehicle?",
        "questionHi": "Naya vahan khareedne ke liye kaun sa din shubh hai?",
        "category": "muhurta",
    },
    {
        "questionEn": "How can I know my moon sign?",
        "questionHi": "Main apni chandra rashi kaise jaan sakta/sakti hoon?",
        "category": "general",
    },
    {
        "questionEn": "What are the effects of Jupiter transit on my sign?",
        "questionHi": "Brihaspati gochar ka meri rashi par kya prabhav hai?",
        "category": "planets",
    },
    {
        "questionEn": "Should I fast on certain days based on my horoscope?",
        "questionHi": "Kya mujhe apni kundali ke aadhar par kisi din vrat rakhna chahiye?",
        "category": "remedies",
    },
    {
        "questionEn": "What does retrograde Mercury mean for me?",
        "questionHi": "Vakri Budh mera liye kya matlab rakhta hai?",
        "category": "planets",
    },
    {
        "questionEn": "How can astrology help with health issues?",
        "questionHi": "Jyotish swasthya samasyaon mein kaise madad kar sakta hai?",
        "category": "health",
    },
    {
        "questionEn": "What is the significance of Nakshatra in my chart?",
        "questionHi": "Meri kundali mein Nakshatra ka kya mahatva hai?",
        "category": "general",
    },
    {
        "questionEn": "Can astrology predict lottery or gambling luck?",
        "questionHi": "Kya jyotish lottery ya juye ki kismat bata sakta hai?",
        "category": "general",
    },
    {
        "questionEn": "What puja should I do for success in exams?",
        "questionHi": "Pariksha mein safalta ke liye mujhe kaun si puja karni chahiye?",
        "category": "education",
    },
]


def seed_horoscopes(databases: Databases):
    """Seed horoscope data for all zodiac signs."""
    print("\n--- Seeding Horoscopes ---")

    today = datetime.now()
    categories = ["love", "career", "health"]
    success = 0
    errors = 0

    for sign in ZODIAC_SIGNS:
        for category in categories:
            try:
                template = random.choice(HOROSCOPE_TEMPLATES[category])
                tip = random.choice(HOROSCOPE_TIPS)

                doc_data = {
                    "zodiacSign": sign,
                    "periodType": "daily",
                    "category": category,
                    "contentEn": template[0],
                    "contentHi": template[1],
                    "tipText": tip[0],
                    "tipTextHi": tip[1],
                    "energyLevel": random.randint(60, 95),
                    "validDate": today.strftime("%Y-%m-%d"),
                }

                databases.create_document(
                    database_id=DATABASE_ID,
                    collection_id="horoscopes",
                    document_id=ID.unique(),
                    data=doc_data
                )
                success += 1
            except Exception as e:
                print(f"[ERROR] {sign}/{category}: {e}")
                errors += 1

    print(f"Horoscopes: {success} created, {errors} errors")
    return success, errors


def seed_daily_content(databases: Databases):
    """Seed mantras and deities."""
    print("\n--- Seeding Daily Content (Mantras & Deities) ---")

    success = 0
    errors = 0
    mantra_ids = []
    deity_ids = []

    # Seed Mantras
    for mantra in MANTRAS:
        try:
            doc_data = {
                "type": "mantra",
                "title": mantra["title"],
                "titleHi": mantra["titleHi"],
                "description": mantra["description"],
                "descriptionHi": mantra["descriptionHi"],
                "isActive": True,
            }

            result = databases.create_document(
                database_id=DATABASE_ID,
                collection_id="daily_content",
                document_id=ID.unique(),
                data=doc_data
            )
            mantra_ids.append(result["$id"])
            success += 1
        except Exception as e:
            print(f"[ERROR] Mantra {mantra['title']}: {e}")
            errors += 1

    # Seed Deities
    for deity in DEITIES:
        try:
            doc_data = {
                "type": "deity",
                "title": deity["title"],
                "titleHi": deity["titleHi"],
                "description": deity["description"],
                "descriptionHi": deity["descriptionHi"],
                "imageUrl": deity["imageUrl"],
                "significance": deity["significance"],
                "mantra": deity["mantra"],
                "isActive": True,
            }

            result = databases.create_document(
                database_id=DATABASE_ID,
                collection_id="daily_content",
                document_id=ID.unique(),
                data=doc_data
            )
            deity_ids.append(result["$id"])
            success += 1
        except Exception as e:
            print(f"[ERROR] Deity {deity['title']}: {e}")
            errors += 1

    print(f"Daily Content: {success} created, {errors} errors")
    return success, errors, mantra_ids, deity_ids


def seed_today_content(databases: Databases, mantra_ids: list, deity_ids: list):
    """Seed today's featured content."""
    print("\n--- Seeding Today's Content ---")

    today = datetime.now().strftime("%Y-%m-%d")
    success = 0
    errors = 0

    # Today's Mantra
    if mantra_ids:
        try:
            databases.create_document(
                database_id=DATABASE_ID,
                collection_id="today_content",
                document_id=ID.unique(),
                data={
                    "type": "mantra",
                    "contentId": random.choice(mantra_ids),
                    "validDate": today,
                }
            )
            success += 1
            print(f"[OK] Today's Mantra set")
        except Exception as e:
            print(f"[ERROR] Today's Mantra: {e}")
            errors += 1

    # Today's Deity
    if deity_ids:
        try:
            databases.create_document(
                database_id=DATABASE_ID,
                collection_id="today_content",
                document_id=ID.unique(),
                data={
                    "type": "deity",
                    "contentId": random.choice(deity_ids),
                    "validDate": today,
                }
            )
            success += 1
            print(f"[OK] Today's Deity set")
        except Exception as e:
            print(f"[ERROR] Today's Deity: {e}")
            errors += 1

    print(f"Today Content: {success} created, {errors} errors")
    return success, errors


def seed_faqs(databases: Databases):
    """Seed FAQ questions."""
    print("\n--- Seeding FAQs ---")

    success = 0
    errors = 0

    for i, faq in enumerate(FAQS):
        try:
            doc_data = {
                "questionEn": faq["questionEn"],
                "questionHi": faq["questionHi"],
                "category": faq["category"],
                "displayOrder": i + 1,
                "isActive": True,
            }

            databases.create_document(
                database_id=DATABASE_ID,
                collection_id="faqs",
                document_id=ID.unique(),
                data=doc_data
            )
            success += 1
        except Exception as e:
            print(f"[ERROR] FAQ: {e}")
            errors += 1

    print(f"FAQs: {success} created, {errors} errors")
    return success, errors


def main():
    # Initialize Appwrite client
    client = Client()
    client.set_endpoint(ENDPOINT)
    client.set_project(PROJECT_ID)
    client.set_key(API_KEY)

    databases = Databases(client)

    print("=" * 60)
    print("SEEDING ALL DATA TO APPWRITE")
    print(f"Database: {DATABASE_ID}")
    print("=" * 60)

    total_success = 0
    total_errors = 0

    # Seed Horoscopes
    s, e = seed_horoscopes(databases)
    total_success += s
    total_errors += e

    # Seed Daily Content (returns IDs for today_content)
    s, e, mantra_ids, deity_ids = seed_daily_content(databases)
    total_success += s
    total_errors += e

    # Seed Today's Content
    s, e = seed_today_content(databases, mantra_ids, deity_ids)
    total_success += s
    total_errors += e

    # Seed FAQs
    s, e = seed_faqs(databases)
    total_success += s
    total_errors += e

    print("\n" + "=" * 60)
    print("SEEDING COMPLETE!")
    print(f"Total Success: {total_success}")
    print(f"Total Errors: {total_errors}")
    print("=" * 60)


if __name__ == "__main__":
    main()
