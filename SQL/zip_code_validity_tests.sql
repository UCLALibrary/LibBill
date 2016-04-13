with d as (
  select '12345' as z, 'valid' as status from dual union all
  select '12345-6789' as z, 'valid' as status from dual union all
  select '123456789' as z, 'valid' as status from dual union all
  select '12345678' as z, 'invalid' as status from dual union all
  select '123456789x' as z, 'invalid' as status from dual union all
  select 'x123456789' as z, 'invalid' as status from dual union all
  select '1234567890' as z, 'invalid' as status from dual union all
  select '12345-67890' as z, 'invalid' as status from dual
)
select *
from d
where not regexp_like(z, '^[0-9]{5}[-]{0,1}([0-9]{4}){0,1}$')
order by status, z
;

select * from vger_support.ucladb_patrons
where not regexp_like(perm_zip, '^[0-9]{5}[-]{0,1}([0-9]{4}){0,1}$')
and (perm_country is null or perm_country in ('US', 'UNITED', 'USA', 'usa'))
and rownum < 10;

select *
from vger_support.ucladb_patrons
where temp_zip is not null
and (perm_country is null or perm_country in ('US', 'UNITED', 'USA', 'usa'))
and (perm_zip is null or not regexp_like(perm_zip, '^[0-9]{5}[-]{0,1}([0-9]{4}){0,1}$')
;
