/*  This view is used by the invoicing application to get patron information.
    However, it is not invoice-specific, so is owned by vger_support instead of invoice_owner.
    It can be used by other applications, but if changes are needed this must be 
    coordinated with all applications, or the view should be forked as needed.
*/
create or replace view vger_support.ucladb_patrons as
select 
  p.patron_id
, pb.patron_barcode
, p.normal_last_name
, p.normal_first_name
, pa_p.address_line1 as perm_address1
, pa_p.address_line2 as perm_address2
, pa_p.address_line3 as perm_address3
, pa_p.address_line4 as perm_address4
, pa_p.address_line5 as perm_address5
, pa_p.city as perm_city
, pa_p.state_province as perm_state
, pa_p.zip_postal as perm_zip
, pa_p.country as perm_country
, pa_t.address_line1 as temp_address1
, pa_t.address_line2 as temp_address2
, pa_t.address_line3 as temp_address3
, pa_t.address_line4 as temp_address4
, pa_t.address_line5 as temp_address5
, pa_t.city as temp_city
, pa_t.state_province as temp_state
, pa_t.zip_postal as temp_zip
, pa_t.country as temp_country
, pa_e.address_line1 as email
, pg.patron_group_display
, case               
    when pb.patron_group_id in (1,3,4,6,7,8,9,10,12,13,14,15,16,18,19,26,30,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,54) then 1
    else 0
  end as uc_community
from 
    ucladb.patron p
    inner join ucladb.patron_barcode pb on p.patron_id = pb.patron_id       
    inner join ucladb.patron_group pg on pb.patron_group_id = pg.patron_group_id
    left outer join ucladb.patron_address pa_p on p.patron_id = pa_p.patron_id and pa_p.address_type = 1
    left outer join ucladb.patron_address pa_t on p.patron_id = pa_t.patron_id and pa_t.address_type = 2      
    left outer join ucladb.patron_address pa_e on p.patron_id = pa_e.patron_id and pa_e.address_type = 3
where
    pb.barcode_status = 1
;
/

grant select on vger_support.ucladb_patrons to invoice_owner, invoice_service;
-- The following statement will fail on production server
grant select on vger_support.ucladb_patrons to invoice_owner_dev, invoice_service_dev;
