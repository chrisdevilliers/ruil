--
-- Database creation script
-- 

DROP DATABASE IF EXISTS ruil;
DROP USER IF EXISTS ruil;

CREATE USER ruil PASSWORD 'password';
CREATE DATABASE ruil OWNER ruil;

\connect ruil

-- Install uuid-osp extension before changing roles.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SET ROLE ruil;

-- Trigger functions
CREATE OR REPLACE
FUNCTION insert_handler()
    RETURNS TRIGGER
AS $$
BEGIN
    NEW.created_at = NOW();
    NEW.updated_at = NOW();
    RETURN NEW;
END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION update_handler()
    RETURNS TRIGGER
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END
$$
LANGUAGE plpgsql;

CREATE TYPE currency_type AS ENUM ('ZAR', 'BTC');

CREATE TABLE client
(
    id UUID PRIMARY KEY,
    email TEXT NOT NULL UNIQUE, -- consider creating a DOMAIN for this
    salt TEXT NOT NULL,
    hash_algorithm TEXT NOT NULL,
    hashed_password TEXT NOT NULL,
    api_id TEXT NOT NULL, -- only URL-safe characters
    api_secret TEXT NOT NULL, -- only URL-safe characters
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
COMMENT ON COLUMN client.id IS
'The client''s internal ID';
COMMENT ON COLUMN client.email IS
'The client''s email address.';
-- ...

CREATE TABLE wallet
(
    client_id UUID NOT NULL REFERENCES client(id) ON DELETE CASCADE,
    currency currency_type NOT NULL,
    balance NUMERIC NOT NULL,
    PRIMARY KEY (client_id, currency)
);

CREATE TABLE client_event
(
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    client_id UUID NOT NULL REFERENCES client(id) ON DELETE CASCADE,
--  event_id?
--  event_type
--  other info
    PRIMARY KEY (timestamp, client_id)
);

CREATE TYPE order_state AS ENUM ('unfilled', 'partial', 'filled');


CREATE TABLE template_order
(
    id UUID PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES client(id) ON DELETE CASCADE,
    state order_state NOT NULL,
    expiry TIMESTAMP WITH TIME ZONE NOT NULL,
    volume NUMERIC NOT NULL,
    volume_currency currency_type NOT NULL,
    amount NUMERIC NOT NULL,
    amount_currenct currency_type NOT NULL
-- created_at
-- updated_at
);

CREATE TABLE buy_order
(
    PRIMARY KEY (id),
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE
) INHERITS (template_order);

CREATE TABLE sell_order
(
    PRIMARY KEY(id),
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE
) INHERITS (template_order);


CREATE TABLE trades
(
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    volume NUMERIC NOT NULL,
    volume_currency currency_type NOT NULL,
    amount NUMERIC NOT NULL,
    amount_currency currency_type NOT NULL
);

