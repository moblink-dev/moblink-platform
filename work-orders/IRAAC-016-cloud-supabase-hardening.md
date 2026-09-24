---
id: IRAAC-016
title: Harden the existing Sydney Supabase project before connecting MobLink
owner: Rhys Coombes
implementer: codex
independent_reviewer: named human
risk: high
data_classification: personal
depends_on: [SEC-001, OPS-001]
---

## Goal

Preserve and verify the local database, reconcile its existing records into the
confirmed Sydney Supabase project, close exposed database-function and RLS
gaps through append-only migrations, and connect a synthetic-data Vercel
preview without exposing privileged credentials.

## Non-goals

- No outreach, invitations, emails, SMS messages or calls.
- No deletion of local Docker volumes, backups or source checkouts.
- No public launch, new production data collection or report publication.
- No reclassification of consent, privacy or cultural-governance decisions.

## Files

- `supabase/migrations/`
- `supabase/tests/`
- `BOT_TASKS.md`
- `work-orders/IRAAC-016-cloud-supabase-hardening.md`
- Paired MobLink website branch: database hardening migration, tests and the
  minimum authentication/persistence integration required for preview proof.

## Acceptance tests

- Local raw-volume and logical backups remain readable outside Git.
- Cloud row reconciliation is count- and hash-verified without overwriting
  pre-existing rows.
- Anonymous and authenticated callers cannot execute internal trigger or
  offboarding functions.
- Authenticated callers can resolve only their own active staff roles; the
  service role retains the existing server-side lookup path.
- Services, referrals, staff profiles and support conversations have explicit,
  tested least-privilege RLS policies.
- Database lint has no high-severity function-exposure finding introduced by
  this work.
- Application lint, typecheck, tests and production build pass.
- A synthetic-data Vercel preview proves login, persistence, role boundaries,
  referrals, support messages and uploads before Docker is stopped.
- Docker-stopped verification passes before any local cleanup is proposed.

## Human decisions

- Rhys directed the local-to-cloud migration and Vercel connection in this
  task. A named human must still review the final diff and decide whether to
  merge or activate production.
- Real staff invitations, real outreach, and public collection remain separate
  human-authorised releases.

## Rollback

Keep all pre-migration backups and Docker volumes. Revert application
environment variables to synthetic demo mode and roll back the additive grants
and policies with a reviewed successor migration; never rewrite an applied
migration or delete preserved data during rollback.

## Evidence

- Local raw-volume and logical backups are checksum-verified under the private
  backup directory; a PostgreSQL 17 disposable restore completed successfully.
- Cloud reconciliation added five missing substantive records without
  overwriting existing rows; post-import counts and content hashes matched.
- The cloud function hardening migration and the paired website RLS, storage,
  and referral migrations are applied to project `xfrhwibtmpjnasbcxdlw`.
- Fresh local database suites pass: platform 187 pgTAP tests and website 53
  pgTAP tests. Platform lint/typecheck/app tests/build pass (79 admin and 35
  contract tests); website tests/typecheck/build pass (48 application tests).
- Supabase security advisor has no critical finding from this work. Two
  no-policy tables remain deliberately deny-by-default; moving the existing
  `citext` extension is deferred because it is unrelated and migration-risky.
- Preview deployment, browser journeys, Docker-stopped proof, independent
  human review, and any local cleanup remain open.
