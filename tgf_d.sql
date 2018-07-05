create or replace function tgf_d() returns trigger as $$
begin
  execute format ('delete from %I where %2$I = ($1).%2$I', 'f_'||TG_RELNAME::regclass, pk(TG_RELNAME)) using OLD;
  return OLD;
end;
$$ language plpgsql
;

