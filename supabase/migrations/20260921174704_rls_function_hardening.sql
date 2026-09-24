-- IRAAC-016: keep internal SECURITY DEFINER helpers off the Data API.
--
-- PostgreSQL grants EXECUTE on new functions to PUBLIC by default. These
-- helpers either run as the function owner or mutate protected state, so they
-- must be callable only by the server-side service role. Trigger execution is
-- unaffected by revoking direct EXECUTE from API roles.

revoke execute on function public.active_staff_roles(uuid)
  from public, anon, authenticated;
grant execute on function public.active_staff_roles(uuid) to service_role;

revoke execute on function public.offboard_staff(uuid, text)
  from public, anon, authenticated;
grant execute on function public.offboard_staff(uuid, text) to service_role;

revoke execute on function public.apply_suppression_to_state()
  from public, anon, authenticated;

revoke execute on function public.upsert_consent_state_from_event()
  from public, anon, authenticated;
