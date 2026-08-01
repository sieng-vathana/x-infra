-- Repeated bootstrap seeding created duplicate system roles. Keep the oldest
-- role for each business/code pair, then prevent the duplicates from returning.
DELETE duplicate_role
FROM roles AS duplicate_role
JOIN roles AS canonical_role
  ON canonical_role.business_id = duplicate_role.business_id
 AND canonical_role.role_code = duplicate_role.role_code
 AND canonical_role.id < duplicate_role.id;

ALTER TABLE roles
  ADD CONSTRAINT uk_roles_business_role_code UNIQUE (business_id, role_code);
