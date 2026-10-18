CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS users (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), email text UNIQUE NOT NULL,
 password_hash text NOT NULL, role text NOT NULL CHECK(role IN ('driver','dispatcher')),
 display_name text NOT NULL, vehicle text, availability text NOT NULL DEFAULT 'offline'
);
CREATE TABLE IF NOT EXISTS refresh_tokens (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL REFERENCES users(id),
 token_hash text UNIQUE NOT NULL, expires_at timestamptz NOT NULL, revoked_at timestamptz
);
CREATE TABLE IF NOT EXISTS deliveries (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tracking_code text UNIQUE NOT NULL,
 driver_id uuid REFERENCES users(id), pickup text NOT NULL, destination text NOT NULL,
 pickup_lat double precision NOT NULL, pickup_lng double precision NOT NULL,
 drop_lat double precision NOT NULL, drop_lng double precision NOT NULL,
 status text NOT NULL DEFAULT 'assigned', version integer NOT NULL DEFAULT 0,
 eta_at timestamptz, updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS operations (
 operation_id uuid PRIMARY KEY, user_id uuid NOT NULL REFERENCES users(id),
 delivery_id uuid NOT NULL REFERENCES deliveries(id), result jsonb NOT NULL, created_at timestamptz DEFAULT now()
);
CREATE TABLE IF NOT EXISTS locations (
 id bigserial PRIMARY KEY, driver_id uuid NOT NULL REFERENCES users(id),
 lat double precision NOT NULL, lng double precision NOT NULL, accuracy double precision NOT NULL,
 recorded_at timestamptz NOT NULL, received_at timestamptz DEFAULT now(),
 sample_id uuid UNIQUE NOT NULL
);
CREATE INDEX IF NOT EXISTS locations_driver_time ON locations (driver_id, recorded_at DESC);
