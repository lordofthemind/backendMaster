-- Create the "accounts" table to store account information
CREATE TABLE accounts (
  id BIGSERIAL PRIMARY KEY,
  owner TEXT NOT NULL,
  balance BIGINT NOT NULL,
  currency VARCHAR(3) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create the "entries" table to record transactions for each account
CREATE TABLE entries (
  id BIGSERIAL PRIMARY KEY,
  account_id bigint NOT NULL,
  amount BIGINT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  -- Amount should be signed
  CONSTRAINT signed_amount CHECK (amount <> 0)
);

-- Create the "transfers" table to record transfers between accounts
CREATE TABLE transfers (
  id BIGSERIAL PRIMARY KEY,
  from_account_id BIGINT NOT NULL,
  to_account_id BIGINT NOT NULL,
  amount BIGINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- Amount must be unsigned
  CONSTRAINT unsigned_amount CHECK (amount > 0)
);

-- Indexes for faster lookup
CREATE INDEX ON accounts (owner);
CREATE INDEX ON entries (account_id);
CREATE INDEX ON transfers (from_account_id);
CREATE INDEX ON transfers (to_account_id);
CREATE INDEX ON transfers (from_account_id, to_account_id);

-- Comments
COMMENT ON COLUMN entries.amount IS 'Amount of the transaction (should be signed)';
COMMENT ON COLUMN transfers.amount IS 'Amount of the transfer (must be unsigned)';

-- Foreign keys to maintain referential integrity
ALTER TABLE entries ADD CONSTRAINT fk_entries_account_id FOREIGN KEY (account_id) REFERENCES accounts (id);
ALTER TABLE transfers ADD CONSTRAINT fk_transfers_from_account_id FOREIGN KEY (from_account_id) REFERENCES accounts (id);
ALTER TABLE transfers ADD CONSTRAINT fk_transfers_to_account_id FOREIGN KEY (to_account_id) REFERENCES accounts (id);
