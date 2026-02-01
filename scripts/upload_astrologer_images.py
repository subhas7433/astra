#!/usr/bin/env python3
"""
Upload astrologer images to Appwrite storage and update document URLs.
"""

import os
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.services.storage import Storage
from appwrite.input_file import InputFile

# Appwrite Configuration
ENDPOINT = "https://appwrite.technoava.com/v1"
PROJECT_ID = "6975ebd500023bbf2235"
API_KEY = "standard_2333f015f16c160ed295899eac062bf283b168c7a7cddbb87d8005834a5b00e9f5ab1bdfd39fa2238b9e33bdfe7bdd3d9624e6cecdc3907093f762c27197e0520c3a29810cd2167efb1f941412a819552e096d662867f4a8cf5eb96b1388e2fde54487eccd415b60ba9ed0e429202b4c533d51716a6b0a302bf3b0e2d1f72d5e"
DATABASE_ID = "astro_gpt_db"
BUCKET_ID = "astrologer-images"
IMAGES_DIR = "core_docs_v2/astrologers"

# Initialize client
client = Client()
client.set_endpoint(ENDPOINT)
client.set_project(PROJECT_ID)
client.set_key(API_KEY)

databases = Databases(client)
storage = Storage(client)

def get_file_url(file_id: str) -> str:
    """Generate public URL for a file"""
    return f"{ENDPOINT}/storage/buckets/{BUCKET_ID}/files/{file_id}/view?project={PROJECT_ID}"

def main():
    print("=" * 60)
    print("Uploading Astrologer Images to Appwrite Storage")
    print("=" * 60)

    # Get all PNG files
    images_path = os.path.join(os.path.dirname(__file__), "..", IMAGES_DIR)
    images_path = os.path.abspath(images_path)

    if not os.path.exists(images_path):
        print(f"Error: Directory not found: {images_path}")
        return

    png_files = [f for f in os.listdir(images_path) if f.endswith('.png')]
    print(f"Found {len(png_files)} images\n")

    success = 0
    errors = 0

    for filename in sorted(png_files):
        # Document ID matches filename without extension
        doc_id = filename.replace('.png', '')
        file_path = os.path.join(images_path, filename)

        try:
            # Upload image to storage
            print(f"Uploading: {filename}...", end=" ")

            result = storage.create_file(
                bucket_id=BUCKET_ID,
                file_id=doc_id,  # Use same ID as document
                file=InputFile.from_path(file_path),
            )

            file_url = get_file_url(result['$id'])

            # Update astrologer document with new URL
            databases.update_document(
                database_id=DATABASE_ID,
                collection_id="astrologers",
                document_id=doc_id,
                data={"photoUrl": file_url}
            )

            print(f"OK")
            success += 1

        except Exception as e:
            error_msg = str(e)
            if "already exists" in error_msg.lower():
                # File exists, just update the URL
                try:
                    file_url = get_file_url(doc_id)
                    databases.update_document(
                        database_id=DATABASE_ID,
                        collection_id="astrologers",
                        document_id=doc_id,
                        data={"photoUrl": file_url}
                    )
                    print(f"EXISTS (URL updated)")
                    success += 1
                except Exception as e2:
                    print(f"ERROR: {e2}")
                    errors += 1
            else:
                print(f"ERROR: {e}")
                errors += 1

    print("\n" + "=" * 60)
    print(f"Upload Complete! Success: {success}, Errors: {errors}")
    print("=" * 60)

if __name__ == "__main__":
    main()
