# KhojLive API (public source)

TypeScript/Express backend for delivery management, driver GPS updates, dispatcher visibility, PostgreSQL persistence and Socket.IO events. **No admin frontend is included in this repository.**

## Setup

1. Install Node.js, npm and PostgreSQL.
2. From this folder: `npm install`
3. Copy `.env.example` to `.env` and replace **all placeholder values** with your own local credentials. Never commit `.env`.
4. Create your database and apply `sql/schema.sql` using `psql` (e.g. `psql "$DATABASE_URL" -f sql/schema.sql` after exporting the URL in your shell).
5. Run `npm run check`, `npm test`, then `npm run dev`.
6. The health endpoint is `GET http://localhost:4000/health`.

### Demo accounts (optional)

Set `SEED_DEMO=true` only for a private/local environment and configure a **unique** `SEED_DEMO_PASSWORD` (at least 12 characters). This seeds `driver@khojlive.test` and `dispatcher@khojlive.test`, with the password hashed using bcrypt. The example file disables seeding by default. Never publish real access credentials or run demo seeding on a publicly reachable deployment.

### Environment variables

| Name | Usage |
|---|---|
| `PORT` | HTTP API port; defaults to 4000 |
| `DATABASE_URL` | Your PostgreSQL connection string |
| `JWT_SECRET` | Secure random signing secret, minimum 32 chars |
| `CORS_ORIGIN` | Comma-separated allowed frontend origins |
| `SEED_DEMO` | Opt-in local demo records; default off |
| `SEED_DEMO_PASSWORD` | Developer-supplied demo account password, if seeding enabled |

Access tokens expire after 15 minutes; refresh tokens are stored hashed in PostgreSQL and rotated. Never log or commit issued tokens.

## Security notes

Do not commit `.env`, credential files, database dumps, local logs, or live credentials. Before publishing, inspect all Git history and remote branches and revoke/rotate any real secret that may have been exposed previously. `.gitignore` cannot remove credentials already committed. This review covers the supplied archive, not your Git history or any absent admin frontend.

## Available scripts

- `npm run dev` — start the API in watch mode
- `npm run check` — TypeScript type checking
- `npm test` — domain tests
- `npm start` — launch the TypeScript API
