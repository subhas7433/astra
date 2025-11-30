import json
import os
import time
from datetime import datetime
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.exception import AppwriteException
from appwrite.permission import Permission
from appwrite.role import Role
from appwrite.id import ID


def main(context):
    """
    Development Database Setup Function - Updated for Latest Appwrite

    Uses new context object with context.log() and context.error()

    Args:
        context: Appwrite context object with req, res, log, error

    Returns:
        JSON response with setup results
    """

    start_time = datetime.utcnow()

    try:
        # Log function start using new context.log()
        context.log(f"Development DB Setup started at {start_time.isoformat()}Z")

        # Validate request method
        if context.req.method not in ['POST', 'GET']:
            return context.res.json({
                'success': False,
                'error': 'Only POST or GET methods allowed',
                'timestamp': start_time.isoformat()
            }, 405)

        # Parse request body (if POST)
        body = {}
        if context.req.method == 'POST' and context.req.body:
            try:
                body = json.loads(context.req.body)
            except json.JSONDecodeError:
                body = {}

        # Check for force recreate flag
        force_recreate = body.get('force_recreate', False)

        # Initialize database setup with context
        db_setup = DevelopmentDatabaseSetup(context)

        # Execute setup
        setup_result = db_setup.execute_complete_setup(force_recreate)

        end_time = datetime.utcnow()
        duration = (end_time - start_time).total_seconds()

        context.log(f"Setup completed in {duration:.2f} seconds")

        if setup_result['success']:
            return context.res.json({
                'success': True,
                'message': 'Development database setup completed successfully',
                'environment': 'development',
                'database_id': 'eprescription_dev',
                'database_name': 'E-Prescription Platform - Development',
                'collections_created': setup_result.get('collections_created', 0),
                'indexes_created': setup_result.get('indexes_created', 0),
                'default_data_inserted': setup_result.get('default_data_inserted', False),
                'duration_seconds': duration,
                'setup_log': setup_result.get('log', []),
                'timestamp': end_time.isoformat()
            }, 200)
        else:
            return context.res.json({
                'success': False,
                'error': 'Development database setup failed',
                'details': setup_result.get('error', 'Unknown error'),
                'setup_log': setup_result.get('log', []),
                'duration_seconds': duration,
                'timestamp': end_time.isoformat()
            }, 500)

    except Exception as e:
        end_time = datetime.utcnow()
        duration = (end_time - start_time).total_seconds()

        context.error(f"Function execution failed: {str(e)}")

        return context.res.json({
            'success': False,
            'error': f'Function execution failed: {str(e)}',
            'duration_seconds': duration,
            'timestamp': end_time.isoformat()
        }, 500)


class DevelopmentDatabaseSetup:
    """
    Development Database Setup - Updated for Latest Appwrite Function Context
    """

    def __init__(self, context):
        # Store context for logging
        self.context = context

        # Initialize Appwrite client with correct environment variables
        self.client = Client()

        # Get environment variables with proper error handling
        endpoint = os.getenv('APPWRITE_FUNCTION_API_ENDPOINT')
        project_id = os.getenv('APPWRITE_FUNCTION_PROJECT_ID')

        # Log environment variable status
        self.context.log(f"Endpoint: {endpoint}")
        self.context.log(f"Project ID: {project_id}")

        if not endpoint:
            raise Exception("APPWRITE_FUNCTION_API_ENDPOINT environment variable not found")
        if not project_id:
            raise Exception("APPWRITE_FUNCTION_PROJECT_ID environment variable not found")

        self.client.set_endpoint(endpoint)
        self.client.set_project(project_id)

        # Use dynamic API key from headers (recommended) or environment variable
        api_key = None
        if hasattr(context.req, 'headers') and 'x-appwrite-key' in context.req.headers:
            api_key = context.req.headers['x-appwrite-key']
            self.context.log("Using dynamic API key from headers")
        else:
            api_key = os.getenv('APPWRITE_FUNCTION_API_KEY')
            self.context.log("Using API key from environment variable")

        if not api_key:
            raise Exception("API key not found in headers or environment variables")

        self.client.set_key(api_key)
        self.databases = Databases(self.client)

        # Development database configuration
        self.database_id = "eprescription_dev"
        self.database_name = "E-Prescription Platform - Development"

        # Setup tracking
        self.setup_log = []
        self.collections_created = 0
        self.indexes_created = 0

    def log(self, message: str, level: str = "info"):
        """Enhanced logging using context.log()"""
        timestamp = datetime.utcnow().isoformat()
        log_entry = {
            'timestamp': timestamp,
            'level': level.upper(),
            'message': message
        }
        self.setup_log.append(log_entry)

        # Use context logging methods
        if level.lower() == "error":
            self.context.error(message)
        else:
            self.context.log(message)

    def execute_complete_setup(self, force_recreate: bool = False) -> dict:
        """Execute complete development database setup"""
        try:
            self.log("Starting development database setup...")
            self.log(f"Database ID: {self.database_id}")
            self.log(f"Database Name: {self.database_name}")
            self.log(f"Force Recreate: {force_recreate}")

            # Create database
            if not self.create_database():
                return {
                    'success': False,
                    'error': 'Failed to create database',
                    'log': self.setup_log
                }

            # Setup collections in optimized order
            collections_config = self.get_collections_config()

            for collection_info in collections_config:
                collection_id = collection_info['id']
                self.log(f"Setting up collection: {collection_id}")

                if not self.setup_collection(collection_info):
                    return {
                        'success': False,
                        'error': f'Failed to setup collection: {collection_id}',
                        'log': self.setup_log
                    }

                self.collections_created += 1
                time.sleep(0.5)  # Brief pause between collections

            # Insert development-specific default data
            self.log("Inserting development default data...")
            default_data_success = self.insert_development_data()

            self.log(f"Development database setup completed successfully!")
            self.log(f"Collections created: {self.collections_created}")
            self.log(f"Indexes created: {self.indexes_created}")
            self.log(f"Default data inserted: {default_data_success}")

            return {
                'success': True,
                'collections_created': self.collections_created,
                'indexes_created': self.indexes_created,
                'default_data_inserted': default_data_success,
                'log': self.setup_log
            }

        except Exception as e:
            self.log(f"Setup failed with exception: {str(e)}", "error")
            return {
                'success': False,
                'error': str(e),
                'log': self.setup_log
            }

    def create_database(self) -> bool:
        """Create the development database"""
        try:
            response = self.databases.create(
                database_id=self.database_id,
                name=self.database_name
            )
            self.log(f"Database created successfully: {response['name']}")
            return True
        except AppwriteException as e:
            if e.code == 409:
                self.log(f"Database already exists: {self.database_id}")
                return True
            else:
                self.log(f"Error creating database: {e.message}", "error")
                return False

    def setup_collection(self, collection_info: dict) -> bool:
        """Setup a single collection with attributes and indexes"""
        collection_id = collection_info['id']
        collection_name = collection_info['name']

        # Create collection
        if not self.create_collection(collection_id, collection_name):
            return False

        # Create attributes
        for attr in collection_info['attributes']:
            if not self.create_attribute(collection_id, **attr):
                self.log(f"Failed to create attribute {attr['key']} in {collection_id}", "error")
                # Continue with other attributes

        # Small delay for attribute processing
        time.sleep(1)

        # Create indexes
        for index in collection_info.get('indexes', []):
            if self.create_index(collection_id, **index):
                self.indexes_created += 1

        return True

    def create_collection(self, collection_id: str, name: str) -> bool:
        """Create a collection"""
        try:
            permissions = [
                Permission.read(Role.users()),
                Permission.create(Role.users()),
                Permission.update(Role.users()),
                Permission.delete(Role.users())
            ]

            response = self.databases.create_collection(
                database_id=self.database_id,
                collection_id=collection_id,
                name=name,
                permissions=permissions,
                document_security=True
            )
            self.log(f"Collection created: {name}")
            return True
        except AppwriteException as e:
            if e.code == 409:
                self.log(f"Collection already exists: {name}")
                return True
            else:
                self.log(f"Error creating collection {name}: {e.message}", "error")
                return False

    def create_attribute(self, collection_id: str, key: str, attr_type: str,
                         size: int = None, required: bool = False,
                         default: any = None, **kwargs) -> bool:
        """Create an attribute"""
        try:
            if attr_type == "string":
                self.databases.create_string_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    size=size or 255,
                    required=required,
                    default=default
                )
            elif attr_type == "integer":
                self.databases.create_integer_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )
            elif attr_type == "float":
                self.databases.create_float_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )
            elif attr_type == "boolean":
                self.databases.create_boolean_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )
            elif attr_type == "datetime":
                self.databases.create_datetime_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )
            elif attr_type == "email":
                self.databases.create_email_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )
            elif attr_type == "url":
                self.databases.create_url_attribute(
                    database_id=self.database_id,
                    collection_id=collection_id,
                    key=key,
                    required=required,
                    default=default
                )

            return True
        except AppwriteException as e:
            if e.code == 409:
                return True  # Already exists
            else:
                self.log(f"Error creating attribute {collection_id}.{key}: {e.message}", "error")
                return False

    def create_index(self, collection_id: str, key: str, index_type: str,
                     attributes: list, **kwargs) -> bool:
        """Create an index"""
        try:
            self.databases.create_index(
                database_id=self.database_id,
                collection_id=collection_id,
                key=key,
                type=index_type,
                attributes=attributes
            )
            self.log(f"Index created: {collection_id}.{key}")
            return True
        except AppwriteException as e:
            if e.code == 409:
                self.log(f"Index already exists: {collection_id}.{key}")
                return True
            else:
                self.log(f"Error creating index {collection_id}.{key}: {e.message}", "error")
                return False

    def get_collections_config(self) -> list:
        """Get complete collections configuration for development environment"""
        return [
            {
                'id': 'user_profiles',
                'name': 'User Profiles',
                'attributes': [
                    {'key': 'appwrite_user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'digiidentity_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'title', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'professional_title', 'attr_type': 'string', 'size': 100, 'required': False},
                    {'key': 'gmc_number', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'gphc_number', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'gdc_number', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'professional_verified', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'verification_date', 'attr_type': 'datetime', 'required': False},
                    {'key': 'aes_certificate', 'attr_type': 'string', 'size': 5000, 'required': False},
                    {'key': 'aes_certificate_status', 'attr_type': 'string', 'size': 50, 'required': False,
                     'default': 'pending'},
                    {'key': 'aes_certificate_expires_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'two_factor_enabled', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'two_factor_secret', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'last_login', 'attr_type': 'datetime', 'required': False},
                    {'key': 'login_attempts', 'attr_type': 'integer', 'required': False, 'default': 0},
                    {'key': 'account_locked', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'locked_until', 'attr_type': 'datetime', 'required': False},
                    {'key': 'specialization', 'attr_type': 'string', 'size': 100, 'required': False},
                    {'key': 'practice_address', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'practice_phone', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'practice_email', 'attr_type': 'email', 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'active'},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_appwrite_user_id', 'index_type': 'unique', 'attributes': ['appwrite_user_id']},
                    {'key': 'idx_gmc_number', 'index_type': 'key', 'attributes': ['gmc_number']},
                    {'key': 'idx_professional_verified', 'index_type': 'key', 'attributes': ['professional_verified']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'clinics',
                'name': 'Clinics',
                'attributes': [
                    {'key': 'name', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'registration_number', 'attr_type': 'string', 'size': 50, 'required': False},
                    {'key': 'address', 'attr_type': 'string', 'size': 2000, 'required': True},
                    {'key': 'contact_info', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'settings', 'attr_type': 'string', 'size': 3000, 'required': False},
                    {'key': 'billing_info', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'active'},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_name', 'index_type': 'key', 'attributes': ['name']},
                    {'key': 'idx_registration_number', 'index_type': 'unique', 'attributes': ['registration_number']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'clinic_memberships',
                'name': 'Clinic Memberships',
                'attributes': [
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'appwrite_user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'role', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'permissions', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'billing_permissions', 'attr_type': 'string', 'size': 500, 'required': False},
                    {'key': 'invited_by', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'invitation_token', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'invitation_expires_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'joined_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'active'},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_clinic_id', 'index_type': 'key', 'attributes': ['clinic_id']},
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_appwrite_user_id', 'index_type': 'key', 'attributes': ['appwrite_user_id']},
                    {'key': 'idx_role', 'index_type': 'key', 'attributes': ['role']}
                ]
            },
            {
                'id': 'patients',
                'name': 'Patients',
                'attributes': [
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'created_by', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'nhs_number', 'attr_type': 'string', 'size': 10, 'required': False},
                    {'key': 'first_name', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'last_name', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'date_of_birth', 'attr_type': 'datetime', 'required': True},
                    {'key': 'gender', 'attr_type': 'string', 'size': 20, 'required': False},
                    {'key': 'contact_info', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'medical_info', 'attr_type': 'string', 'size': 5000, 'required': False},
                    {'key': 'emergency_contact', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'consent', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'active'},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_clinic_id', 'index_type': 'key', 'attributes': ['clinic_id']},
                    {'key': 'idx_nhs_number', 'index_type': 'unique', 'attributes': ['nhs_number']},
                    {'key': 'idx_patient_name', 'index_type': 'key', 'attributes': ['first_name', 'last_name']},
                    {'key': 'idx_created_by', 'index_type': 'key', 'attributes': ['created_by']}
                ]
            },
            {
                'id': 'prescriptions',
                'name': 'Prescriptions',
                'attributes': [
                    {'key': 'prescription_code', 'attr_type': 'string', 'size': 32, 'required': True},
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'patient_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'prescriber_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'prescription_type', 'attr_type': 'string', 'size': 20, 'required': False,
                     'default': 'standard'},
                    {'key': 'repeat_count', 'attr_type': 'integer', 'required': False, 'default': 0},
                    {'key': 'max_repeats', 'attr_type': 'integer', 'required': False, 'default': 0},
                    {'key': 'prescription_date', 'attr_type': 'datetime', 'required': True},
                    {'key': 'expiry_date', 'attr_type': 'datetime', 'required': True},
                    {'key': 'first_dispense_deadline', 'attr_type': 'datetime', 'required': True},
                    {'key': 'clinical_indication', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'prescriber_notes', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'special_instructions', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'aes_signature', 'attr_type': 'string', 'size': 5000, 'required': False},
                    {'key': 'signature_timestamp', 'attr_type': 'datetime', 'required': False},
                    {'key': 'signature_verification_status', 'attr_type': 'string', 'size': 20, 'required': False,
                     'default': 'pending'},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'draft'},
                    {'key': 'void_reason', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'voided_by', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'voided_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_prescription_code', 'index_type': 'unique', 'attributes': ['prescription_code']},
                    {'key': 'idx_clinic_id', 'index_type': 'key', 'attributes': ['clinic_id']},
                    {'key': 'idx_patient_id', 'index_type': 'key', 'attributes': ['patient_id']},
                    {'key': 'idx_prescriber_id', 'index_type': 'key', 'attributes': ['prescriber_id']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'prescription_items',
                'name': 'Prescription Items',
                'attributes': [
                    {'key': 'prescription_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'medication_name', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'medication_code', 'attr_type': 'string', 'size': 50, 'required': False},
                    {'key': 'medication_details', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'dosage_instructions', 'attr_type': 'string', 'size': 2000, 'required': True},
                    {'key': 'quantity_to_dispense', 'attr_type': 'float', 'required': True},
                    {'key': 'quantity_unit', 'attr_type': 'string', 'size': 20, 'required': True},
                    {'key': 'controlled_drug_info', 'attr_type': 'string', 'size': 500, 'required': False},
                    {'key': 'pricing', 'attr_type': 'string', 'size': 500, 'required': False},
                    {'key': 'item_order', 'attr_type': 'integer', 'required': False, 'default': 1},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_prescription_id', 'index_type': 'key', 'attributes': ['prescription_id']},
                    {'key': 'idx_medication_code', 'index_type': 'key', 'attributes': ['medication_code']}
                ]
            },
            {
                'id': 'dispensing_records',
                'name': 'Dispensing Records',
                'attributes': [
                    {'key': 'prescription_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'prescription_item_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'dispensed_quantity', 'attr_type': 'float', 'required': True},
                    {'key': 'dispensed_by', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'dispensed_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'patient_verified', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'verification_method', 'attr_type': 'string', 'size': 50, 'required': False},
                    {'key': 'pharmacist_notes', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_prescription_id', 'index_type': 'key', 'attributes': ['prescription_id']},
                    {'key': 'idx_dispensed_at', 'index_type': 'key', 'attributes': ['dispensed_at']}
                ]
            },
            {
                'id': 'subscription_plans',
                'name': 'Subscription Plans',
                'attributes': [
                    {'key': 'name', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'description', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'plan_type', 'attr_type': 'string', 'size': 20, 'required': True},
                    {'key': 'pricing', 'attr_type': 'string', 'size': 1000, 'required': True},
                    {'key': 'limits', 'attr_type': 'string', 'size': 2000, 'required': True},
                    {'key': 'features', 'attr_type': 'string', 'size': 3000, 'required': True},
                    {'key': 'is_active', 'attr_type': 'boolean', 'required': False, 'default': True},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_plan_type', 'index_type': 'key', 'attributes': ['plan_type']},
                    {'key': 'idx_is_active', 'index_type': 'key', 'attributes': ['is_active']}
                ]
            },
            {
                'id': 'user_subscriptions',
                'name': 'User Subscriptions',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'billing_entity_type', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'individual'},
                    {'key': 'plan_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'subscription_type', 'attr_type': 'string', 'size': 20, 'required': False,
                     'default': 'monthly'},
                    {'key': 'starts_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'ends_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'auto_renew', 'attr_type': 'boolean', 'required': False, 'default': True},
                    {'key': 'token_info', 'attr_type': 'string', 'size': 1000, 'required': True},
                    {'key': 'payment_info', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'active'},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_plan_id', 'index_type': 'key', 'attributes': ['plan_id']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'billing_transactions',
                'name': 'Billing Transactions',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'subscription_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'prescription_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'transaction_type', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'amount', 'attr_type': 'float', 'required': True},
                    {'key': 'currency', 'attr_type': 'string', 'size': 3, 'required': False, 'default': 'GBP'},
                    {'key': 'payment_data', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'token_data', 'attr_type': 'string', 'size': 500, 'required': False},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'pending'},
                    {'key': 'processed_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_clinic_id', 'index_type': 'key', 'attributes': ['clinic_id']},
                    {'key': 'idx_transaction_type', 'index_type': 'key', 'attributes': ['transaction_type']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'notifications',
                'name': 'Notifications',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'patient_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'prescription_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'template_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'notification_type', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'recipient', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'subject', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'message', 'attr_type': 'string', 'size': 5000, 'required': True},
                    {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'pending'},
                    {'key': 'sent_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'delivered_at', 'attr_type': 'datetime', 'required': False},
                    {'key': 'error_message', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'external_ids', 'attr_type': 'string', 'size': 500, 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_notification_type', 'index_type': 'key', 'attributes': ['notification_type']},
                    {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
                ]
            },
            {
                'id': 'notification_templates',
                'name': 'Notification Templates',
                'attributes': [
                    {'key': 'name', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'type', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'subject', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'template_body', 'attr_type': 'string', 'size': 5000, 'required': True},
                    {'key': 'variables', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'is_active', 'attr_type': 'boolean', 'required': False, 'default': True},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_name', 'index_type': 'key', 'attributes': ['name']},
                    {'key': 'idx_type', 'index_type': 'key', 'attributes': ['type']},
                    {'key': 'idx_is_active', 'index_type': 'key', 'attributes': ['is_active']}
                ]
            },
            {
                'id': 'contacts',
                'name': 'Contacts',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': True},
                    {'key': 'contact_details', 'attr_type': 'string', 'size': 3000, 'required': True},
                    {'key': 'professional_info', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'address', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'contact_type', 'attr_type': 'string', 'size': 50, 'required': False},
                    {'key': 'tags', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'notes', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'is_favorite', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_contact_type', 'index_type': 'key', 'attributes': ['contact_type']}
                ]
            },
            {
                'id': 'audit_logs',
                'name': 'Audit Logs',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'action', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'resource_type', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'resource_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'request_data', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'changes', 'attr_type': 'string', 'size': 10000, 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_action', 'index_type': 'key', 'attributes': ['action']},
                    {'key': 'idx_resource_type', 'index_type': 'key', 'attributes': ['resource_type']},
                    {'key': 'idx_created_at', 'index_type': 'key', 'attributes': ['created_at']}
                ]
            },
            {
                'id': 'security_events',
                'name': 'Security Events',
                'attributes': [
                    {'key': 'user_id', 'attr_type': 'string', 'size': 255, 'required': False},
                    {'key': 'event_type', 'attr_type': 'string', 'size': 50, 'required': True},
                    {'key': 'severity', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'info'},
                    {'key': 'description', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'request_data', 'attr_type': 'string', 'size': 2000, 'required': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_user_id', 'index_type': 'key', 'attributes': ['user_id']},
                    {'key': 'idx_event_type', 'index_type': 'key', 'attributes': ['event_type']},
                    {'key': 'idx_severity', 'index_type': 'key', 'attributes': ['severity']},
                    {'key': 'idx_created_at', 'index_type': 'key', 'attributes': ['created_at']}
                ]
            },
            {
                'id': 'system_settings',
                'name': 'System Settings',
                'attributes': [
                    {'key': 'setting_key', 'attr_type': 'string', 'size': 100, 'required': True},
                    {'key': 'setting_value', 'attr_type': 'string', 'size': 5000, 'required': False},
                    {'key': 'setting_type', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'string'},
                    {'key': 'description', 'attr_type': 'string', 'size': 1000, 'required': False},
                    {'key': 'is_encrypted', 'attr_type': 'boolean', 'required': False, 'default': False},
                    {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                    {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
                ],
                'indexes': [
                    {'key': 'idx_setting_key', 'index_type': 'unique', 'attributes': ['setting_key']},
                    {'key': 'idx_setting_type', 'index_type': 'key', 'attributes': ['setting_type']}
                ]
            },
            {
            'id': 'nhs_medicines',
            'name': 'NHS Medicines (DM+D)',
            'attributes': [
                {'key': 'snomed_code', 'attr_type': 'string', 'size': 20, 'required': True},
                {'key': 'name', 'attr_type': 'string', 'size': 500, 'required': True},
                {'key': 'type', 'attr_type': 'string', 'size': 10, 'required': True},
                {'key': 'form', 'attr_type': 'string', 'size': 100, 'required': False},
                {'key': 'ingredients', 'attr_type': 'string', 'size': 3000, 'required': False},
                {'key': 'strength', 'attr_type': 'string', 'size': 200, 'required': False},
                {'key': 'manufacturer', 'attr_type': 'string', 'size': 200, 'required': False},
                {'key': 'availability', 'attr_type': 'string', 'size': 100, 'required': False},
                {'key': 'prescribable', 'attr_type': 'boolean', 'required': False, 'default': True},
                {'key': 'controlled_drug', 'attr_type': 'boolean', 'required': False, 'default': False},
                {'key': 'pricing_info', 'attr_type': 'string', 'size': 1000, 'required': False},
                {'key': 'classification', 'attr_type': 'string', 'size': 500, 'required': False},
                {'key': 'release_id', 'attr_type': 'string', 'size': 50, 'required': True},
                {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
            ],
            'indexes': [
                {'key': 'idx_snomed_code', 'index_type': 'unique', 'attributes': ['snomed_code']},
                {'key': 'idx_name', 'index_type': 'fulltext', 'attributes': ['name']},
                {'key': 'idx_type', 'index_type': 'key', 'attributes': ['type']},
                {'key': 'idx_prescribable', 'index_type': 'key', 'attributes': ['prescribable']},
                {'key': 'idx_release_id', 'index_type': 'key', 'attributes': ['release_id']}
            ]
        },
        {
            'id': 'nhs_trud_sync',
            'name': 'NHS TRUD Sync Metadata',
            'attributes': [
                {'key': 'release_id', 'attr_type': 'string', 'size': 50, 'required': True},
                {'key': 'release_date', 'attr_type': 'datetime', 'required': True},
                {'key': 'release_name', 'attr_type': 'string', 'size': 255, 'required': False},
                {'key': 'total_products', 'attr_type': 'integer', 'required': True},
                {'key': 'products_updated', 'attr_type': 'integer', 'required': False, 'default': 0},
                {'key': 'products_failed', 'attr_type': 'integer', 'required': False, 'default': 0},
                {'key': 'sync_started', 'attr_type': 'datetime', 'required': True},
                {'key': 'sync_completed', 'attr_type': 'datetime', 'required': False},
                {'key': 'downloaded_at', 'attr_type': 'datetime', 'required': False},
                {'key': 'download_size_mb', 'attr_type': 'float', 'required': False},
                {'key': 'files_extracted', 'attr_type': 'integer', 'required': False},
                {'key': 'files_stored', 'attr_type': 'integer', 'required': False},
                {'key': 'total_xml_size_mb', 'attr_type': 'float', 'required': False},
                {'key': 'extracted_files', 'attr_type': 'string', 'size': 10000, 'required': False},
                {'key': 'duration_seconds', 'attr_type': 'float', 'required': False},
                {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': True},
                {'key': 'errors', 'attr_type': 'string', 'size': 5000, 'required': False},
                {'key': 'file_size_mb', 'attr_type': 'float', 'required': False},
                {'key': 'created_at', 'attr_type': 'datetime', 'required': True}
            ],
            'indexes': [
                {'key': 'idx_release_id', 'index_type': 'unique', 'attributes': ['release_id']},
                {'key': 'idx_release_date', 'index_type': 'key', 'attributes': ['release_date']},
                {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']}
            ]
        },
        {
            'id': 'medicine_search_cache',
            'name': 'Medicine Search Cache',
            'attributes': [
                {'key': 'cache_key', 'attr_type': 'string', 'size': 255, 'required': True},
                {'key': 'search_term', 'attr_type': 'string', 'size': 255, 'required': True},
                {'key': 'search_type', 'attr_type': 'string', 'size': 50, 'required': True},
                {'key': 'results', 'attr_type': 'string', 'size': 50000, 'required': True},
                {'key': 'results_count', 'attr_type': 'integer', 'required': True},
                {'key': 'cached_at', 'attr_type': 'datetime', 'required': True},
                {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
            ],
            'indexes': [
                {'key': 'idx_cache_key', 'index_type': 'unique', 'attributes': ['cache_key']},
                {'key': 'idx_search_term', 'index_type': 'key', 'attributes': ['search_term']},
                {'key': 'idx_search_type', 'index_type': 'key', 'attributes': ['search_type']},
                {'key': 'idx_cached_at', 'index_type': 'key', 'attributes': ['cached_at']}
            ]
        },
        {
            'id': 'clinic_token_balances',
            'name': 'Clinic Token Balances',
            'attributes': [
                {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': True},
                {'key': 'current_balance', 'attr_type': 'integer', 'required': True, 'default': 0},
                {'key': 'reserved_balance', 'attr_type': 'integer', 'required': False, 'default': 0},
                {'key': 'lifetime_purchased', 'attr_type': 'integer', 'required': False, 'default': 0},
                {'key': 'lifetime_consumed', 'attr_type': 'integer', 'required': False, 'default': 0},
                {'key': 'auto_topup_enabled', 'attr_type': 'boolean', 'required': False, 'default': False},
                {'key': 'auto_topup_threshold', 'attr_type': 'integer', 'required': False, 'default': 10},
                {'key': 'auto_topup_amount', 'attr_type': 'integer', 'required': False, 'default': 100},
                {'key': 'auto_topup_max_amount', 'attr_type': 'integer', 'required': False, 'default': 500},
                {'key': 'last_transaction_id', 'attr_type': 'string', 'size': 255, 'required': False},
                {'key': 'stripe_customer_id', 'attr_type': 'string', 'size': 255, 'required': False},
                {'key': 'payment_method_id', 'attr_type': 'string', 'size': 255, 'required': False},
                {'key': 'billing_admin_user_id', 'attr_type': 'string', 'size': 255, 'required': False},
                {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
            ],
            'indexes': [
                {'key': 'idx_clinic_id_unique', 'index_type': 'unique', 'attributes': ['clinic_id']},
                {'key': 'idx_billing_admin', 'index_type': 'key', 'attributes': ['billing_admin_user_id']},
                {'key': 'idx_stripe_customer', 'index_type': 'key', 'attributes': ['stripe_customer_id']}
            ]
        },
        {
            'id': 'invitations',
            'name': 'Team Invitations',
            # Purpose: Manage clinic team member invitations for Week 7 multi-user clinic administration
            # Used by: InvitationService to handle team invitation workflows (send/resend/cancel/accept)
            # Integration: Works with clinic_memberships collection on invitation acceptance
            # Features: 14-day expiry, unique tokens, email integration via notification-send function
            'attributes': [
                # Core invitation fields
                {'key': 'clinic_id', 'attr_type': 'string', 'size': 255, 'required': True},  # Link to clinics collection
                {'key': 'email', 'attr_type': 'email', 'required': True},  # Invitee email address
                {'key': 'name', 'attr_type': 'string', 'size': 255, 'required': True},  # Invitee full name

                # Role and permissions
                {'key': 'role', 'attr_type': 'string', 'size': 50, 'required': True},  # Enum: admin|prescriber|pharmacist|staff
                {'key': 'specialization', 'attr_type': 'string', 'size': 100, 'required': False},  # Optional medical specialization
                {'key': 'department', 'attr_type': 'string', 'size': 100, 'required': False},  # Optional department assignment

                # Invitation workflow
                {'key': 'token', 'attr_type': 'string', 'size': 255, 'required': True},  # Unique 32-character invitation token
                {'key': 'status', 'attr_type': 'string', 'size': 20, 'required': False, 'default': 'pending'},  # Enum: pending|accepted|declined|expired
                {'key': 'message', 'attr_type': 'string', 'size': 1000, 'required': False},  # Optional personal message from inviter

                # Tracking and metadata
                {'key': 'invited_by', 'attr_type': 'string', 'size': 255, 'required': True},  # User ID of inviter (admin)
                {'key': 'invited_date', 'attr_type': 'datetime', 'required': True},  # When invitation was sent
                {'key': 'expires_date', 'attr_type': 'datetime', 'required': True},  # Expiry date (14 days from invited_date)
                {'key': 'accepted_date', 'attr_type': 'datetime', 'required': False},  # When invitation was accepted (null if pending)

                # Standard audit fields
                {'key': 'created_at', 'attr_type': 'datetime', 'required': True},
                {'key': 'updated_at', 'attr_type': 'datetime', 'required': True}
            ],
            'indexes': [
                {'key': 'idx_clinic_id', 'index_type': 'key', 'attributes': ['clinic_id']},  # Query invitations by clinic
                {'key': 'idx_email', 'index_type': 'key', 'attributes': ['email']},  # Check existing invitations for email
                {'key': 'idx_status', 'index_type': 'key', 'attributes': ['status']},  # Filter by status (pending/accepted/etc)
                {'key': 'idx_token', 'index_type': 'unique', 'attributes': ['token']}  # Unique token for acceptance workflow
            ]
        }
        ]

    def insert_development_data(self) -> bool:
        """Insert development-specific default data"""
        try:
            current_time = datetime.utcnow().isoformat() + "Z"

            # Development subscription plans
            dev_plans = [
                {
                    "name": "Development Starter",
                    "description": "Development testing plan",
                    "plan_type": "development",
                    "pricing": '{"monthly": 0.00, "annual": 0.00, "currency": "GBP"}',
                    "limits": '{"max_prescriptions": 1000, "max_users": 10, "max_clinics": 5}',
                    "features": '["unlimited_testing", "debug_mode", "sample_data", "rapid_iteration"]',
                    "is_active": True,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "name": "Professional Dev",
                    "description": "Development advanced testing",
                    "plan_type": "professional_dev",
                    "pricing": '{"monthly": 10.00, "annual": 100.00, "currency": "GBP"}',
                    "limits": '{"max_prescriptions": 5000, "max_users": 25, "max_clinics": 10}',
                    "features": '["advanced_testing", "performance_profiling", "load_testing", "integration_testing"]',
                    "is_active": True,
                    "created_at": current_time,
                    "updated_at": current_time
                }
            ]

            for plan in dev_plans:
                try:
                    self.databases.create_document(
                        database_id=self.database_id,
                        collection_id="subscription_plans",
                        document_id=ID.unique(),
                        data=plan
                    )
                    self.log(f"Inserted development plan: {plan['name']}")
                except AppwriteException as e:
                    self.log(f"Error inserting plan {plan['name']}: {e.message}", "error")

            # Development notification templates
            dev_templates = [
                {
                    "name": "dev_prescription_ready",
                    "type": "email",
                    "subject": "[DEV] Your test prescription is ready",
                    "template_body": "[DEVELOPMENT MODE] Dear {{patient_name}}, your test prescription {{prescription_code}} is ready for testing. This is a development environment.",
                    "variables": '["patient_name", "prescription_code"]',
                    "is_active": True,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "name": "dev_test_notification",
                    "type": "sms",
                    "subject": None,
                    "template_body": "[DEV] Test notification {{test_id}}. This is a development environment message.",
                    "variables": '["test_id"]',
                    "is_active": True,
                    "created_at": current_time,
                    "updated_at": current_time
                }
            ]

            for template in dev_templates:
                try:
                    self.databases.create_document(
                        database_id=self.database_id,
                        collection_id="notification_templates",
                        document_id=ID.unique(),
                        data=template
                    )
                    self.log(f"Inserted development template: {template['name']}")
                except AppwriteException as e:
                    self.log(f"Error inserting template {template['name']}: {e.message}", "error")

            # Development system settings
            dev_settings = [
                {
                    "setting_key": "environment",
                    "setting_value": "development",
                    "setting_type": "string",
                    "description": "Current environment mode",
                    "is_encrypted": False,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "setting_key": "debug_mode",
                    "setting_value": "true",
                    "setting_type": "boolean",
                    "description": "Enable debug logging and features",
                    "is_encrypted": False,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "setting_key": "prescription_validity_days",
                    "setting_value": "30",
                    "setting_type": "integer",
                    "description": "Shorter validity for development testing",
                    "is_encrypted": False,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "setting_key": "max_login_attempts",
                    "setting_value": "10",
                    "setting_type": "integer",
                    "description": "Higher limit for development testing",
                    "is_encrypted": False,
                    "created_at": current_time,
                    "updated_at": current_time
                },
                {
                    "setting_key": "api_rate_limit",
                    "setting_value": "10000",
                    "setting_type": "integer",
                    "description": "Higher rate limit for development",
                    "is_encrypted": False,
                    "created_at": current_time,
                    "updated_at": current_time
                }
            ]

            for setting in dev_settings:
                try:
                    self.databases.create_document(
                        database_id=self.database_id,
                        collection_id="system_settings",
                        document_id=ID.unique(),
                        data=setting
                    )
                    self.log(f"Inserted development setting: {setting['setting_key']}")
                except AppwriteException as e:
                    self.log(f"Error inserting setting {setting['setting_key']}: {e.message}", "error")

            self.log("Development default data insertion completed")
            return True

        except Exception as e:
            self.log(f"Error inserting development data: {str(e)}", "error")
            return False


# Function execution entry point for local testing
if __name__ == "__main__":
    # This allows local testing of the function
    import sys


    class MockContext:
        def __init__(self):
            self.req = MockRequest()
            self.res = MockResponse()

        def log(self, message):
            print(f"[LOG] {message}")

        def error(self, message):
            print(f"[ERROR] {message}")


    class MockRequest:
        def __init__(self):
            self.method = "POST"
            self.body = '{"confirm_setup": true}'
            self.headers = {}


    class MockResponse:
        def json(self, data, status_code=200):
            print(f"Status: {status_code}")
            print(f"Response: {json.dumps(data, indent=2)}")
            return data


    # Test locally
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        result = main(MockContext())
        print("Local test completed")
    else:
        print("This is an Appwrite Function. Deploy it to Appwrite to use.")
