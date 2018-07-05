create or replace function pk(_t name) returns name as $$
  select attname
  from pg_constraint c
  join pg_attribute a on a.attrelid = conrelid and a.attnum = conkey[1]
  where conrelid = _t::regclass
  ; --of course you will need more complicated statement for PK on several attributes. and obviously we have some penalty for querying catalog on each row - this approah has a price
$$ language sql;


