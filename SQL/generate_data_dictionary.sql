select 
  table_name
, column_id
, column_name
, case 
    when data_type in ('CHAR', 'VARCHAR2', 'NVARCHAR2') then data_type || '(' || char_length || ')'
    when data_type = 'NUMBER' then data_type || '(' || coalesce(data_precision, data_length) || ',' || coalesce(data_scale, 0) || ')'
    else data_type
  end as column_type
--, data_type
--, data_length
--, data_precision
--, data_scale
--, nullable
--, data_default as default_value
from user_tab_cols
where table_name not like '%_VW' -- tables
--where table_name like '%_VW' -- views
order by table_name, column_id
--order by column_name, table_name
;

-- view data for confluence table
-- column name, column type, (empty) notes
select 
  table_name
, '| ' || column_name || ' | ' ||
  case 
    when data_type in ('CHAR', 'VARCHAR2', 'NVARCHAR2') then data_type || '(' || char_length || ')'
    when data_type = 'NUMBER' then data_type || '(' || coalesce(data_precision, data_length) || ',' || coalesce(data_scale, 0) || ')'
    else data_type
  end || ' | |'
  as confluence_data
from user_tab_cols
where table_name like '%_VW' -- views
order by table_name, column_id
;
