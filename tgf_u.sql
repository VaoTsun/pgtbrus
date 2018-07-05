create or replace function tgf_u() returns trigger as $$
declare
  _pk name;
  _val text;
  _cols text;
  _vals text;
  _sql text;
begin
    _pk := pk(TG_RELNAME);

  select
    string_agg(format('%1$I', attname, atttypid::regtype),',')
  , string_agg(format('row_alias.%I', attname),',')
    into _cols, _vals
  from pg_attribute
  where attrelid = TG_RELNAME::regclass and attnum > 0 and not attisdropped
  ;

  raise info '%', NEW;
  execute format('select ($1).%I',_pk) into _val using OLD; --in case update updates the PK value we use OLD, not NEW
  execute format('update %1$I set (%2$s) = (%3$s) from (select ($1).*) row_alias where %1$I.%4$I = %5$s', 'f_'||TG_RELNAME, _cols, _vals, _pk, _val) using NEW;
  /* at first I formatted %I = %L::%s with atttypid::regtype from pg_attribute, but surely UPDATE SET (LIST)=(NEW) is neater approach...
  */
  return NEW;
end;
$$ language plpgsql
;

