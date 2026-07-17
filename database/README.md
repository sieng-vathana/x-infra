# Vyntra database profiles

The database-owning services use the `local` Spring profile by default.
That profile connects to `127.0.0.1:3306` as the loopback-only
`vyntra_local` account with an empty password.

Create the local databases with an account that has database-creation rights:

```bash
sudo mysql < database/local/create-databases.sql
```

The initialization script uses the host's socket-authenticated administrator
to create that restricted local account. The root account is not used by the
applications.

For production, activate the `production` profile and provide the variables
for the corresponding service:

```text
USER_DB_URL, USER_DB_USERNAME, USER_DB_PASSWORD
BUSINESS_DB_URL, BUSINESS_DB_USERNAME, BUSINESS_DB_PASSWORD
SHOP_DB_URL, SHOP_DB_USERNAME, SHOP_DB_PASSWORD
PRODUCT_DB_URL, PRODUCT_DB_USERNAME, PRODUCT_DB_PASSWORD
ORDER_DB_URL, ORDER_DB_USERNAME, ORDER_DB_PASSWORD
```

Production profiles default to Hibernate schema validation and do not create
or update schemas. Use versioned migrations before deploying to production.

The local K3s deployment uses its own MySQL StatefulSet and runtime Secret.
It does not use the host's socket-authenticated root account.
