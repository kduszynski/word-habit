# REST API Plan

## 1. Resources

- **Users** (Supabase Auth)
- **Translations** (table `translations`)
- **User Settings** (table `user_settings`)
- **Notification History** (table `notification_history`)
- **AI Generation Logs** (table `translation_generation_logs`)
- **AI Error Logs** (table `translation_generation_error_logs`)

## 2. Endpoints

### 2.1 Authentication (Supabase)
- Handled by Supabase Auth SDK; no custom endpoints.

### 2.2 Translations

#### List Translations
- **Method**: GET
- **URL**: /translations
- **Description**: Retrieve paginated list of user translations, with optional search and sort.
- **Query Params**:
  - `search` (string, optional): full-text search on `original_text` or `basic_translation`.
  - `sort` (string, optional): `asc` or `desc` (by `original_text`).
  - `page` (integer, default=1)
  - `limit` (integer, default=20)
- **Response**:
  ```json
  {
    "data": [ { "id": "...", "original_text": "...", "basic_translation": "...", "is_known": false, ... } ],
    "meta": { "page": 1, "limit": 20, "total": 42 }
  }
  ```
- **Success**: 200
- **Errors**: 401 Unauthorized, 400 Bad Request

#### Get Translation Details
- **Method**: GET
- **URL**: /translations/{id}
- **Description**: Fetch full details for a single translation.
- **Response**:
  ```json
  {
    "id": "...",
    "original_text": "...",
    "basic_translation": "...",
    "secondary_translations": [...],
    "examples": [...],
    "part_of_speech": "...",
    "original_language": "en",
    "target_language": "pl",
    "is_known": false,
    "translation_source": "MANUAL",
    "created_at": "...",
    "updated_at": "..."
  }
  ```
- **Success**: 200
- **Errors**: 401 Unauthorized, 404 Not Found

#### Create Translation
- **Method**: POST
- **URL**: /translations
- **Description**: Create a new translation entry.
- **Request Body**:
  ```json
  {
    "original_text": "...",
    "basic_translation": "...",
    "secondary_translations": ["..."],
    "examples": ["..."],
    "part_of_speech": "noun",
    "original_language": "en",
    "target_language": "pl",
    "translation_source": "..."
  }
  ```
- **Success**: 201 Created, returns created object
- **Errors**: 400 Validation, 409 Conflict, 401 Unauthorized

#### Generate AI Translation
- **Method**: POST
- **URL**: /translations/generate
- **Description**: Request AI-generated translation; logs success or error.
- **Request Body**:
  ```json
  {
    "original_text": "...",
    "original_language": "en",
    "target_language": "pl"
  }
  ```
- **Response** (success):
  ```json
  {
    "basic_translation": "...",
    "secondary_translations": [...],
    "examples": [...],
    "part_of_speech": "..."
  }
  ```
- **Errors**: 400 Validation, 500 AI Service Error (with message), 401 Unauthorized

#### Update Translation (Partial)
- **Method**: PUT
- **URL**: /translations/{id}
- **Description**: Modify fields, e.g., mark known or edit values.
- **Request Body** (any subset):
  ```json
  {
    "basic_translation": "...",
    "is_known": true
  }
  ```
- **Success**: 200 OK, returns updated object
- **Errors**: 400 Validation, 401 Unauthorized, 404 Not Found

#### Delete Translation
- **Method**: DELETE
- **URL**: /translations/{id}
- **Description**: Permanently delete a translation.
- **Success**: 204 No Content
- **Errors**: 401 Unauthorized, 404 Not Found

### 2.3 User Settings

#### Get Notification Settings
- **Method**: GET
- **URL**: /user-settings
- **Description**: Retrieve current user's notification preferences.
- **Response**:
  ```json
  {
    "send_time": "08:00",
    "monday": true,
    "tuesday": true,
    ...
  }
  ```
- **Success**: 200
- **Errors**: 401 Unauthorized

#### Update Notification Settings
- **Method**: PUT
- **URL**: /user-settings
- **Description**: Create or update notification preferences.
- **Request Body**:
  ```json
  {
    "send_time": "HH:MM",
    "monday": false,
    ...
  }
  ```
- **Success**: 200 OK
- **Errors**: 400 Validation, 401 Unauthorized

### 2.4 Notification History

#### List Notification History
- **Method**: GET
- **URL**: /notification-history
- **Description**: View past notifications sent to the user.
- **Query Params**: `start_date`, `end_date`, `page`, `limit`
- **Response**:
  ```json
  {
    "data": [ { "translation_id": "...", "sent_at": "..." } ],
    "meta": { "page": 1, "limit": 20, "total": 50 }
  }
  ```
- **Success**: 200
- **Errors**: 401 Unauthorized

#### Today's Notification (Client Pull)
- **Method**: GET
- **URL**: /notifications/today
- **Description**: Retrieve the translation scheduled for today.
- **Response**:
  ```json
  { "translation_id": "...", "original_text": "...", "basic_translation": "..." }
  ```
- **Success**: 200 or 204 No Content (if none)
- **Errors**: 401 Unauthorized

### 2.5 Admin Logs

#### List AI Generation Logs
- **Method**: GET
- **URL**: /admin/translation-generation-logs
- **Description**: Retrieve paginated list of AI generation logs; admin only.
- **Query Params**:
  - `user_id` (UUID, optional): filter by user.
  - `model_name` (string, optional): filter by AI model.
  - `sort_by` (string, optional, default: `request_timestamp`): field to sort.
  - `sort_order` (string, optional, default: `desc`): `asc` or `desc`.
  - `page` (integer, default=1)
  - `limit` (integer, default=20)
- **Response**:
  ```json
  {
    "data": [
      {
        "id": "...",
        "user_id": "...",
        "model_name": "...",
        "input_payload": {...},
        "response_payload": {...},
        "request_timestamp": "...",
        "duration_ms": 123,
        "created_at": "...",
        "updated_at": "..."
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 100 }
  }
  ```
- **Success**: 200 OK
- **Errors**: 401 Unauthorized, 403 Forbidden

#### List AI Error Logs
- **Method**: GET
- **URL**: /admin/translation-generation-error-logs
- **Description**: Retrieve paginated list of AI translation error logs; admin only.
- **Query Params**:
  - `user_id` (UUID, optional): filter by user.
  - `sort_by` (string, optional, default: `error_timestamp`): field to sort.
  - `sort_order` (string, optional, default: `desc`): `asc` or `desc`.
  - `page` (integer, default=1)
  - `limit` (integer, default=20)
- **Response**:
  ```json
  {
    "data": [
      {
        "id": "...",
        "user_id": "...",
        "error_code": "...",
        "error_message": "...",
        "request_payload": {...},
        "response_payload": {...},
        "error_timestamp": "...",
        "created_at": "...",
        "updated_at": "..."
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 50 }
  }
  ```
- **Success**: 200 OK
- **Errors**: 401 Unauthorized, 403 Forbidden

## 3. Authentication and Authorization

- **Mechanism**: Supabase Auth (JWT or session cookies) integrated via the Supabase Next.js SDK.
- **Enforcement**: Every endpoint checks valid auth token; RLS policies (`auth.uid() = user_id`) in PostgreSQL ensure per-user data isolation.
- **Rate Limiting**: Apply per-IP throttling on /auth/login to block after 5 failed attempts for 15 minutes (per PRD).
- **Admin Role**: Endpoints under `/admin/` require JWT with `role: "admin"` claim; return 403 Forbidden if unauthorized.

## 4. Validation and Business Logic

### Translations
- `original_text`: required, non-empty, max 500 chars
- `basic_translation`: required, non-empty, max 1000 chars
- `secondary_translations`, `examples`: arrays of strings
- `part_of_speech`: string
- `original_language`, `target_language`: required, 2-char ISO codes (e.g. "en", "pl")
- `translation_source`: enum: MANUAL, AI_GENERATED, AI_MODIFIED
- Composite uniqueness: (`user_id`, `original_text`, `original_language`, `target_language`) → 409 Conflict on duplicates

### AI Generation
- Logs to `translation_generation_logs` on success, `translation_generation_error_logs` on failure
- Timeout and error handling: respond with 500 and message, allow retry via client

### Listings
- Pagination (`page`, `limit`), sorting (`asc`/`desc`), full-text search (`search`) leveraging GIN TRIGRAM indexes

### Notifications
- Settings stored in `user_settings`; validate `send_time` format HH:MM, boolean flags for each weekday
- Daily notification selection algorithm (internal): choose non-`is_known` word not sent in last 60 days, else oldest eligible
- Expose `/notifications/today` for client pull

All business rules are enforced in service layer before database operations, with clear error messages and proper HTTP status codes. 