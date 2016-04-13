create or replace view line_item_note_vw as
select
  invoice_number
, line_number
, sequence_number
, internal
, created_by
, created_date
, note
from line_item_note
;
/
