# Schemat bazy danych

## Enums

- `translation_source`: ENUM('MANUAL', 'AI_GENERATED', 'AI_MODIFIED')

## 1. Tabele

### translations
- **id**: UUID PK DEFAULT `gen_random_uuid()`
- **user_id**: UUID FK → `auth.users(id)` ON DELETE CASCADE NOT NULL
- **original_text**: VARCHAR(500) NOT NULL
- **basic_translation**: VARCHAR(1000) NOT NULL
- **secondary_translations**: JSONB
- **examples**: JSONB
- **part_of_speech**: VARCHAR(100)
- **original_language**: CHAR(2) NOT NULL
- **target_language**: CHAR(2) NOT NULL
- **is_known**: BOOLEAN NOT NULL DEFAULT `false`
- **translation_source**: `translation_source` NOT NULL
- **generation_log_id**: UUID FK → `translation_generation_logs(id)`
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **updated_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`

**Ograniczenia**:
- PK (`id`)
- FK (`user_id`)
- FK (`generation_log_id`)
- UNIQUE (`user_id`, `original_text`, `original_language`, `target_language`)

### user_settings
- **id**: UUID PK DEFAULT `gen_random_uuid()`
- **user_id**: UUID UNIQUE FK → `auth.users(id)` ON DELETE CASCADE NOT NULL
- **send_time**: TIME WITHOUT TIME ZONE NOT NULL
- **monday**: BOOLEAN NOT NULL DEFAULT `true`
- **tuesday**: BOOLEAN NOT NULL DEFAULT `true`
- **wednesday**: BOOLEAN NOT NULL DEFAULT `true`
- **thursday**: BOOLEAN NOT NULL DEFAULT `true`
- **friday**: BOOLEAN NOT NULL DEFAULT `true`
- **saturday**: BOOLEAN NOT NULL DEFAULT `true`
- **sunday**: BOOLEAN NOT NULL DEFAULT `true`
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **updated_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`

**Ograniczenia**:
- PK (`id`)
- FK (`user_id`)
- UNIQUE (`user_id`)

### notification_history
- **id**: UUID PK DEFAULT `gen_random_uuid()`
- **user_id**: UUID FK → `auth.users(id)` ON DELETE CASCADE NOT NULL
- **translation_id**: UUID FK → `translations(id)` ON DELETE CASCADE NOT NULL
- **sent_at**: TIMESTAMPTZ NOT NULL
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **updated_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`

**Ograniczenia**:
- PK (`id`)
- FK (`user_id`)
- FK (`translation_id`)

### translation_generation_logs
- **id**: UUID PK DEFAULT `gen_random_uuid()`
- **user_id**: UUID FK → `auth.users(id)` ON DELETE CASCADE NOT NULL
- **model_name**: VARCHAR(100) NOT NULL
- **input_payload**: JSONB NOT NULL
- **response_payload**: JSONB NOT NULL
- **request_timestamp**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **duration_ms**: INT NOT NULL
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **updated_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`

**Ograniczenia**:
- PK (`id`)
- FK (`user_id`)

### translation_generation_error_logs
- **id**: UUID PK DEFAULT `gen_random_uuid()`
- **user_id**: UUID FK → `auth.users(id)` ON DELETE CASCADE NOT NULL
- **error_code**: VARCHAR(100) NOT NULL
- **error_message**: TEXT NOT NULL
- **request_payload**: JSONB NOT NULL
- **response_payload**: JSONB NOT NULL
- **error_timestamp**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **created_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`
- **updated_at**: TIMESTAMPTZ NOT NULL DEFAULT `now()`

**Ograniczenia**:
- PK (`id`)
- FK (`user_id`)

## 2. Relacje

- `auth.users` 1:N `translations`
- `auth.users` 1:1 `user_settings`
- `auth.users` 1:N `notification_history`
- `auth.users` 1:N `translation_generation_logs`
- `auth.users` 1:N `translation_generation_error_logs`
- `translations` 1:N `notification_history`

## 3. Indeksy

- `translations`:
  - UNIQUE (`user_id`, `original_text`, `original_language`, `target_language`)
  - GIN (`secondary_translations`)
  - GIN (`examples`)
  - GIN TRIGRAM (`original_text`)
  - GIN TRIGRAM (`basic_translation`)
- `user_settings`:
  - UNIQUE (`user_id`)
- `notification_history`:
  - INDEX (`user_id`)
  - INDEX (`translation_id`)
- `translation_generation_logs`:
  - INDEX (`user_id`)
  - INDEX (`request_timestamp`)
- `translation_generation_error_logs`:
  - INDEX (`user_id`)
  - INDEX (`error_timestamp`)

## 4. RLS (Row-Level Security)

Dla tabel:
- `translations`
- `user_settings`
- `notification_history`
- `translation_generation_logs`
- `translation_generation_error_logs`

Włączyć RLS i dodać polityki:

- **Policy**:  
  - `SELECT, INSERT, UPDATE, DELETE` dozwolone tylko gdy `auth.uid() = user_id`

## 5. Uwagi

- `secondary_translations` oraz `examples` jako JSONB z domyślną pustą tablicą, by uniknąć wartości NULL.
- `original_language` i `target_language` używają 2-znakowych kodów ISO.
- `translation_source` jako enum gwarantuje spójność źródeł wpisu.
- Kaskadowe usuwanie (`ON DELETE CASCADE`) zapewnia spójność referencyjną przy usuwaniu użytkowników i tłumaczeń. 