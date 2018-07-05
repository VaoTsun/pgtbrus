create or replace function tgf_i() returns trigger as $$
begin
  execute format('insert into %I select ($1).*','f_'||TG_RELNAME) using NEW;
  return NEW;
end;
$$ language plpgsql;

