-- The business service persists the owner through businesses.user_id.
-- A legacy deployment left owner_user_id as an additional NOT NULL column,
-- which makes new business creation fail because the current entity does not
-- and must not write two owner identifiers.
ALTER TABLE businesses DROP COLUMN owner_user_id;
