-- IRAAC-016: direct execution of privileged helpers stays server-only.

begin;
create extension if not exists pgtap;
select plan(12);
set search_path to public, extensions, "$user", pg_catalog;

select ok(
  not has_function_privilege('anon', 'public.active_staff_roles(uuid)', 'execute'),
  'anon cannot execute active_staff_roles'
);
select ok(
  not has_function_privilege('authenticated', 'public.active_staff_roles(uuid)', 'execute'),
  'authenticated cannot execute active_staff_roles'
);
select ok(
  has_function_privilege('service_role', 'public.active_staff_roles(uuid)', 'execute'),
  'service role can execute active_staff_roles'
);

select ok(
  not has_function_privilege('anon', 'public.offboard_staff(uuid,text)', 'execute'),
  'anon cannot execute offboard_staff'
);
select ok(
  not has_function_privilege('authenticated', 'public.offboard_staff(uuid,text)', 'execute'),
  'authenticated cannot execute offboard_staff'
);
select ok(
  has_function_privilege('service_role', 'public.offboard_staff(uuid,text)', 'execute'),
  'service role can execute offboard_staff'
);

select ok(
  not has_function_privilege('anon', 'public.apply_suppression_to_state()', 'execute'),
  'anon cannot execute the suppression trigger helper'
);
select ok(
  not has_function_privilege('authenticated', 'public.apply_suppression_to_state()', 'execute'),
  'authenticated cannot execute the suppression trigger helper'
);
select ok(
  not has_function_privilege('service_role', 'public.apply_suppression_to_state()', 'execute'),
  'trigger helper has no direct service-role execution path'
);

select ok(
  not has_function_privilege('anon', 'public.upsert_consent_state_from_event()', 'execute'),
  'anon cannot execute the consent-state trigger helper'
);
select ok(
  not has_function_privilege('authenticated', 'public.upsert_consent_state_from_event()', 'execute'),
  'authenticated cannot execute the consent-state trigger helper'
);
select ok(
  not has_function_privilege('service_role', 'public.upsert_consent_state_from_event()', 'execute'),
  'consent trigger helper has no direct service-role execution path'
);

select * from finish();
rollback;
