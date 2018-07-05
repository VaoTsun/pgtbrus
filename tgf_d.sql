create or replace function tgf_d() returns trigger as $$
declare
  _c int := 0;
begin
  execute format ('delete from %I where %2$I = ($1).%2$I', 'f_'||TG_RELNAME::regclass, pk(TG_RELNAME)) using OLD;
  get diagnostics _c:= row_count;
  if _c < 1 then
    raise exception '%', 'This data is not replicated yet, thus can''t be deleted';
  end if;
  return OLD;
end;
$$ language plpgsql
;

