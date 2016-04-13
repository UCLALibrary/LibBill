create or replace view invoice_note_vw as
select
  invoice_number
, sequence_number
, internal
, created_by
, created_date
, note
from invoice_note
;
/
