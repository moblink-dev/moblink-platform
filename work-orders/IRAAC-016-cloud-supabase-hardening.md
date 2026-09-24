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
- No deletion of local Docker volumes or backups before cloud reconciliation
  and Docker-stopped proof. Rhys explicitly authorised their removal after
  those gates passed on 2026-09-24; source checkouts remain out of scope.
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

Revert application environment variables to synthetic demo mode and roll back
the additive grants and policies with a reviewed successor migration; never
rewrite an applied migration. The local raw/logical backups and Docker volumes
were retained through every migration and Docker-stopped verification gate,
then removed on 2026-09-24 at Rhys's explicit direction. Recovery now depends
on the hosted project and the Git-tracked append-only migrations; there is no
remaining local database copy.

## Evidence

- Local raw-volume and logical backups are checksum-verified under the private
  backup directory; a PostgreSQL 17 disposable restore completed successfully.
- The initial cloud reconciliation added five substantive consent-wording
  records without overwriting existing rows. A final pre-deletion audit found
  those canonical rows plus the recorded V1 survey release absent despite
  their migration versions appearing in hosted migration history. The
  idempotent data sections already tracked in migrations `00600` and `00700`
  were replayed through the Management API. Hosted verification now shows one
  canonical survey definition, the expected
  `9f98a7b96d15a2837f8aa033cf843b1b635846d53fda90dd53492e7dd6d5152f`
  content hash, 40 canonical questions and five consent wordings.
- The cloud function hardening migration and the paired website RLS, storage,
  and referral migrations are applied to project `xfrhwibtmpjnasbcxdlw`.
- Fresh local database suites pass: platform 187 pgTAP tests and website 53
  pgTAP tests. Platform lint/typecheck/app tests/build pass (79 admin and 35
  contract tests); website tests/typecheck/build pass (51 application tests).
- Supabase security advisor has no critical finding from this work. Two
  no-policy tables remain deliberately deny-by-default; moving the existing
  `citext` extension is deferred because it is unrelated and migration-risky.
- Protected Vercel Preview deployment
  `moblink-website-61szd2s6r-rhycollabs-projects.vercel.app` is Ready. With
  Docker stopped, the browser journey proved anonymous login, referral and
  support-message persistence, private profile upload persistence, customer
  inbox restoration, and guest rejection from `/admin`; the clean test tab
  produced no console errors or warnings. All synthetic browser records,
  storage objects and the anonymous test user were deleted and verified at
  zero afterward.
- After every Docker-stopped cloud gate passed, `docker system prune -a`
  removed stopped disposable test containers and replaceable images,
  reclaiming 22.43 GB. On Rhys's subsequent explicit instruction, all 15
  Supabase/inventory Docker volumes, the 205 MB private backup, Supabase CLI
  traces, cache, branch metadata and local link metadata were removed. Docker
  itself and both source checkouts remain; Docker is stopped. Docker now
  reports zero images, containers, volumes and build cache. Git-tracked
  migrations/configuration and required application client libraries remain.
- Independent human review, merge, and any production activation remain open.
