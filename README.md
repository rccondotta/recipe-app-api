# recipe-app-api
Recipe API project.

## Docker Commands
- Create a new app
    - docker-compose run --rm app sh -c "django-admin startproject app ."
- Create Superuser
    - docker-compose run --rm app sh -c "python manage.py createsuperuser"
- Make Migrations
    - docker-compose run --rm app sh -c "python manage.py makemigrations"
- Linting
    - docker-compose run --rm app sh -c "flake8"
- Tests
    - docker-compose run --rm app sh -c "python manage.py test"
- Build
    - docker-compose build .
- Run
    - docker-compose up

## Structure
- App Design
- Test Driven Development (TDD)
- Configure GitHub Actions
- TDD with Django
- Configure Database
- User Model
- Setup Django Admin
- API Documentation
- User API
- Tags API
- Ingredients API
- Image API
- Filtering

## App Design

### Recipe API
- Backend REST API -> App
- Backend REST API -> Web Browswer
- Backend REST API -> database

### Features
- 19 API Endpoints
	- Managing users, recipes, tags, ingredients
- User Authentication
- Browsable Admin Interface (Django Admin)
- Browsable API (Swagger)

### Technologies
- Python Programming Language
- Django - Python web framework
	- URL Mappings
	- Object Relational Mapper
	- Admin site
- Django REST Framework
- PostgreSQL - Database
- Docker - Container Software
- Swagger - Automated documentation for API
- Github Actions - Automation
	- Testing and Linting

### Django Project Structure
app/
    - Django project
app/core/
    - Code shared betwen multiple apps (database definition)
app/user/
    - User related code
app/recipe/
    - Recipe related code

## Test Driven Development (TDD)
Unit Tests
	- Code which tests code
	- Sets up conditions/inputs
	- Runs a piece of code
	- Checks outputs with assertions
Benefits
	- Ensures code runs as expected
	- catches bugs
	- improves realiability
	- Provides confidence

TDD
	- Development Practice
	- Write Test then write code
Process
	- Write test
    - run test (Fails)
    - Add Feature
    - Run Test (Pass)
    - Refactor
Why
	- Better understanding of Code
	- Make changes with confidence
	- Reduces bugs

## GitHub Actions
 - Automation Tool
 - Similar to Travis-CI, GitLab CI/CD, Jenkins
 - Run jobs when code changes
 - automate tasks

Commons uses:
 - Deployment, [code linting, unit tests]

How it works:
 - Triggers (Push to Github)
 - Setup jobs (Run unit tests)
 - Result (Success/fail)

Configuring:
 - Create config file @ .github/workflows/checks.yml (Must end in .yml)
	- Set trigger
	- Add steps

## TDD with Django
Django framework
 - built on unitttest library
 - test client - dummy web browser
 - simulate authentication
 - Temporary database

Django REST Framework Adds features
 - API test client

Placeholder tests.py added to each app or, creates tests/ subdirectory to split tests up
 - only use one or other of above
 - test modules must start with test_
 - test directories must contain __init__.py

Test Database
 - Specific database for test
 - Runs test then clears data for run again
 - Happens for every test (by default)

Test Classes:
 - SimpleTestCase
	- No database integration
	- Useful if no database is required
	- Save time executing tests
 - TestCase (We Use)
	- database integration
	- Useful for testing code that uses database

Mocking
 - Override or change behavior of dependencies
 - Avoid uninted side effects
 - Isolate code being tested

Why?
 - Avoid relying on external services
	- Can't guarantee they will be available
	- Make tests unpredicatable and inconsistent
 - Avoid unintended consequences
	- Accidentally sending emails
	- Overloading external services
 - Another Benefit:
 - Speed up tests
How?
 - Use unittest.mock
	- MagicMock/Mock - Replace real objects
	- patch - Overrides code for tests

Testing Web Requests
 - Test APIs -> Make actual requests and check results

Django REST Framework APIClient
 - Based on Djangos TestClient
 - Make requests
 - Check results
 - Override authentication

Using API Client
 - Import APIClient
 - Create client
 - Make request
 - Check result

Common Testing Problems
 - Tests not running (Ex. Ran 0 tests in 0.00s)
 - Ran less tests than you have

Possible Reasons for tests not running
 - Missing __init__.py in tests/ directory
 - Indentation of test cases
 - Missing test prefix for method
 - ImportError when running tests
	- Both tests/ directory and tests.py exist

## Configure Database

Architecture Overview
 - Database PostgreSQL
	- Popular open source DB
	- Integrates well with Django
 - Docker Compose
	- Defined with project (re-usable)
	- Persistent data using volumes
	- Handles network configuration
	- Environment variable configuration
 - Network Connectivity
	- "depends_on:
		- db"
	- set depends_on on app services to start db first
	- Docker compose creates network
	- the app service can use db hostname
 - Volumes
	- Store persisent data
	- Maps directory in container to local machine

Steps for configuring database
 - Configure Django
	- Tell django how to connect
 - Install database adaptor dependencies
	- Install the tool django uses to connect
 - Update Python Requirements

Django Needs to know
 - Engine (type of database)
 - Hostname (IP or domain name for database)
 - Port
 - Database Name
 - Username and Password

Defined in settings.py file
 - Pull from environment variables
	- config values from env values
	- Easily passed to Docker
	- Used in local dev or prod
	- Single place to configure project
	- Easy to do with Python (ex. Os.environ.get('DB_HOST')

Package Psycopg2
 - Most popular PostgreSQL adaptor for Python
 - Supported by Django officially
 - Installation options
	- pyscopg2-binary
		- OK for development
		- not good for production
	- pyscopg2
		- compiles from source
		- required additional dependencies
		- Easy to install with Docker
 - List of package dependencies in docs
	- C compiler
	- python3-dev
	- libpq-dev
 - For alpine
	- postgresql-client
	- build-base
	- postgresql-dev
	- musl-dev
 - Docker Best Practice:
	- Clean up build dependencies

Fixing database race condition
 - Make Django "wait for db"
	- Check for database availability
	- continue when database ready
 - Create custom Django management command
 - issue when using docker-compose locally
 - issue when running deployed environmen

Migrations
 - Django ORM
	- Object Relational Mapper (ORM)
	- Abstraction layer for data
		- Django handles database structure and changes
		- Focus on Python Code
		- Use any database (within reason)
 - How to use
	- Define Models -> Generate Migration Files -> Setup Database -> Store data
 - Models
	- Each model maps to a table
	- Contain Name, Fields, Other metadata, Custom Python Logic
 - Create Migrations
	- Ensure ap is enable in settings.py
	- Use Django CLI -> python manage.py makemigrations
 - Applying Migrations
	- Use Django CLI -> python manage.py migrate
	- run it after waiting for database

## User Model
Authentication
 - Built in for Django
 - Framework for basic features
	- Registration, Login, Authentication
 - Integrates with Django Admin

Django User Model
 - Foundation of the django auth system
 - default user model
	- Username instead of emails
	- Not easy to customise
 - Create a custom model for new projects
	- Allows for using email instead of username
	- Future proof project for later changes to user model

Customize User Model
 - Create Model
	- Base from AbstractBaseUser and PermissionsMixin
 - Create custom manager
	- Used for CLI integration
 - Set AUTH_USER_MODEL in settings.py
 - Create and run migrations

AbstractBaseUser
 - Provides features for authentication
 - Doesn't include fields

PermissionsMixin
 - Support for Django permission system
 - Includes fields and methods

Common Issues
 - Running migrations before setting custom model
	- Set custom model first
 - Typos in config
 - Indentation in manager or model

Design Custom User Model
 - email (EmailField)
 - name (CharField)
 - is_active (BooleanField)
 - is_staff (BooleanField)

User Model Manager
 - Used to manage objects
 - Custom logic for creating objects
	- Hash password
 - Used by Django ClI
	- Create Superuser

BaseUserManager
 - Base class for managing users
 - Useful helper methods
	- normalized_email: for storing emails consistently
 - Methods we'll define
	- create_user: called when creating user
	- create_superuser: used by the CLI to create a superuser (admin)

## Setup Django Admin
Django Admin
	- Graphical User Interface for models
		- Create, Read, Update, Delete
	- Very little coding required

How to enable
	- Enabled per model
	- inside admin.py
		- admin.site.register(Recipe)

Customising
	- Create class based off ModelAdmin or UserAdmin
	- Override/set class variables

Changing list of objects
	- ordering: changes order items appear
	- list_display: fields to appear in list

Add/update page
	- fieldsets: control layout of page
	- readonly_fields: fields that cannot be changed

Add page
	- add_fieldsets: field displayed only on add page

## API Documentation
Why document?
	- APIs are designed for developers to use
	- Need to know how to use it
	- An API is only as good as its documentation

What to document
	- Everything needed to use the API
	- Available endpoints (paths)
		- /api/recipes
	- Suported methods
		- GET, POST, PUT, PATCH, DELETE
	- Format of payloads (inputs)
		- parameters
		- post JSON format
	- Format of responses (output)
		- response JSON format
	- Authentication process

Options for documentation
	- Manual
		- word doc, markdown
	- Automated
		- Use metadata from code (comments)
		- Generate documentation page
	- Explore tools for making documentation seamless
	- Add documentation for our API

Auto docs with DRF
	- Auto generate docs (with 3rd party library)
		- drf-spectacular
	- Generate schema (JSON or YAML)
	- Browsable web interface
		- Make test requests
		- Handle auth
	- How?
		- Generate a 'schema' file
		- Parse schema into GUI
	- OpenAPI Schema
		- Standard for describings APIs
		- Popular in industry
		- Supported by most API documenation tools
		- Uses popular formats: YAML/JSON
	- Using a Schema
		- download and run in local Swagger instance
		- Serve Swagger with API

Documenation link
    - http://localhost:8000/api/docs/
Admin Link
    - http://localhost:8000/admin/

## User API
API
    - User registration
    - Creating auth tokens
    - Viewing/updating profile
Endpoints
	- user/create/
		- POST - register a new user
	- user/token/
		- POST - create a new token/
	- user/me/
		- PUT/PATCH - Update Profile
		- GET - View profile

Django types of authentication
 - Basic (BAD - user has to store in system)
	- Send username an dpassword with each request
 - Token
	- Use a token in the http header
 - JSON Web Token (JWT)
	- Use an acess and refresh token
 - Session
	- Use cookies

Token Authetntication
 - Balance and simplicity and security
 - Supported out of the box by DRF
 - well suported by most clients

How it works
 - Create token (Post Username/password)
 - Store Token on client (session storage, local storage, cookie, database)
 - include token in HTTP headers

Pros and Consistent
- Pros
    - Out the box
    - Simple to use
    - supported by all clients
    - Avoid sending usernamen and password each time
- Cons
	- Token needs to be secure on client side
	- Requires database requests

Logging out
    - Happens on client side
    - Delete token

Why no logout API?
    - unreliable (No guarantee it will be called)
    - Not useful on API

## Recipe API Design
Features (for authenticated user)
 - Create
 - List
 - View detail
 - Update
 - Delete

Endpoints
- /recipes/
	- GET - List all recipes
	- POST - Create recipe

- /recipes/<recipe_id>/
	- GET - View details of recipe
	- PUT/PATCH - Update recipe
	- DELETE - Delete recipe

APIView vs Viewsets
- view
	- Handles request made to a URL
	- Django uses functions
	- Django Rest Framework (DRF) uses classes
		- Reusable logic
		- Override behavior
	- DRF also supports decorators
	- APIView and Viewsets = DRF base classes

- APIView
	- Focused around HTTP methods
	- Class methods for HTTP methods
		- GET, POST, PUT, PATCH, DELETE
	- Provide flexibility over URLs and logic
	- Useful for non CRUD API's
		- Avoid for simple create, read update, delete APIs
		- Bespoke logic (eg auth, jobs, external apis)

- Viewsets
	- Focused around actions
		- Retrieve, list, update, partial update, destroy
	- Map to Django models
	- Use Routers to generate URLs
	- Great for CRUD operations on models

## Tags API
Add ability to add recipe tags
Create model for tags
Add tag API endpoints
Update recipe endpoing
	- Adding and listing

name - Name of the tag
user = User who created/owns tag

Tag endpoint
	- /api/recipe/tags
		- POST, PUT/PATCH, DELETE, GET

Nested Serializers
 - serializer within a serializer
 - used for fields which are objects

Limitations
 - read only by default
 - Custom logic to make writable

## Ingredients API
Ability to add ingredients to recipes
Create model for ingredients
Add ingredients API
Update recipe endpoint
	- Create and manage ingredients

Model
	- name and user

Endpoints
	- /api/recipe/ingredients/
		- GET
	- /api/reicpe/ingredients/<id>/
		- GET, PUT/PATCH, DELETE
	- /api/recipe/
		- POST
	- /api/recipe/<id>/
		- PUT/PATCH

## Recipe Image API
Handling static/media files
Adding image dependencies
Update recipe model with image field
Add image upload endpoint

Design
- /api/recipes/<id>/upload-image/
	- POST

Dependencies
- Pillow (Python Imaging Library)
	- zlib, zlib-dev
	- jpeg-dev

Static files with Django and Docker:
- File not generated by python code
	- images, css, javascript, icons
- Two Types:
	- Media - Uploaded at runtime (eg: user uploads)
	- Static - Generated on build
- Configs
	- STATIC_URL - Base static URL (eg. /static/static/)
	- MEDIA_URL - Base media URL (eg. /static/media/)
	- MEDIA_ROOT - Path to media on filesystem (eg: /vol/web/media)
	- STATIC_ROOT - Path to static files on filesystem (eg: /vol/web/static)
- Docker Volumes
	- Store persistent data
	- Volume we will setup:
		- /vol/web - store static and media subdirectories
- NGINX (reverse proxy service)
	- used to handle all static files

- Collect Static
	- python manage.py collectstatic
	- puts all static files into STATIC_ROOT

## Filtering
Filter recipes by ingredients / tags
	- Find certain types of recipes

Filter Tags / ingredients by assigned
	- List filter options for recipes

Define OpenAPI parameters
	- Update documentation

Example requests
	- Filter by tag(s)
		- get /api/recipe/recipes/?tags=1,2,3
	- Filter by ingredient(s):
		- get /api/recipe/recipes/?ingredients=1,2,3
	- Filter tags by assigned:
		- get /api/recipe/tags/?assigned_only=1
	- Filter ingredients by assigned
		- get /api/recipe/ingredients/?assigned_only=1

OpenAPI Schema:
	- Auto generated schema
	- Some things need to manually configured
		- Custom query params (filtering)
	- Use DRF Spectacular extend_schema_view decorator