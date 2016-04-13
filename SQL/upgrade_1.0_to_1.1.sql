/***********************************************************  
* Change script to upgrade LibBill database from 1.0 to 1.1.
* 2011-06-30 akohler.
*
***********************************************************/

/***********************************************************
*
* Ticket 20053: Allow payment_approver to cancel unpaid invoices.
*
***********************************************************/
-- (Hack... I already added this in DEV/TEST...)
delete from invoice_status_change where role_name = 'payment_approver' and from_status = 'Unpaid' and to_status = 'Canceled';
insert into invoice_status_change values ('Unpaid', 'Canceled', 'payment_approver');
commit;

/***********************************************************  
*
* Ticket 20061: Add unit location info
*
***********************************************************/

/********************
  location table
********************/
-- Ensure location codes are unique
alter table location add constraint location_code_uk unique (location_code);

-- Add columns to location table
alter table location add (
  department_number char(4)
, phone_number varchar2(20)
);

-- Add data for existing rows
update location set
  department_number =
    case
      when location_code = 'BC' then '5415'
      when location_code = 'SR' then '5420'
      else '5400'
    end
;
update location set phone_number = '(310) 825-6940' where location_code = 'BC';
update location set phone_number = '(310) 206-9770' where location_code = 'BS';
update location set phone_number = '(310) 825-4932' where location_code = 'OH';
update location set phone_number = '(310) 825-2422' where location_code = 'SC';
update location set phone_number = '(310) 206-2010' where location_code = 'SR';
update location set phone_number = '(310) 825-4068' where location_code = 'UA';

-- Delete currently unused locations; they can be added via future admin interface if/when needed
delete from location where phone_number is null;

-- Add constraints on new columns
alter table location modify department_number not null;
alter table location modify phone_number not null;

-- Done with location table
commit;

/********************
  invoice table
********************/
-- Associate each invoice with one location
-- (was implicit via invoice number; make explicit)
alter table invoice add location_id int;

-- Set location_id from first 2 characters of invoice_number
update invoice set location_id = (
  select location_id from location where location_code = substr(invoice.invoice_number, 1, 2)
);

-- Add constraints on invoice.location_id
alter table invoice modify location_id not null;
alter table location add constraint invoice_location_id 
  foreign key (location_id) references location (location_id);

-- Done with invoice table
commit;

/********************
  invoice_vw view
********************/
-- Add new location info to view for web services to use
create or replace view invoice_vw as
select 
  i.invoice_number
, i.invoice_date
, i.status
, i.total_amount
, i.la_county_tax
, i.california_tax
, i.line_item_total
, i.taxable_total
, i.nontaxable_total
, calculate_balance_due(i.invoice_number) as balance_due
, i.created_by
, i.created_date
, i.patron_id
, i.patron_on_premises
, l.department_number
, l.location_name
, l.phone_number
from invoice i
inner join location l on i.location_id = l.location_id
;

-- Done with invoice_vw view

/********************
  insert_invoice procedure
********************/
create or replace procedure insert_invoice (
  p_location_code in location.location_code%type
, p_invoice_date in invoice.invoice_date%type
, p_status in invoice.status%type := 'Pending'
, p_user_name in staff_user.user_name%type
, p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_new_invoice_number out invoice.invoice_number%type
) as
  -- To work around JDBC-related problem storing CHAR(10) in passed-in output parameter
  v_new_invoice_number invoice.invoice_number%type;
  v_location_id invoice.location_id%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_invoice';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Could throw NO_DATA_FOUND, caught below
  select location_id into v_location_id
    from location
    where location_code = p_location_code;
    
  v_new_invoice_number := get_next_invoice_number(p_location_code);
  insert into invoice (
    invoice_number
  , invoice_date
  , status
  , created_by
  , patron_id
  , patron_on_premises
  , location_id
  ) values (
    v_new_invoice_number
  , p_invoice_date
  , p_status
  , p_user_name
  , p_patron_id
  , p_patron_on_premises
  , v_location_id
  );
  
  -- For output to caller, if all went well
  p_new_invoice_number := v_new_invoice_number;

exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Invalid location code: ' || p_location_code);
end insert_invoice;
/
-- Done with insert_invoice procedure

/***********************************************************  
*
* Ticket 20083: Add version information
*
***********************************************************/
-- Add data to application_setting table
insert into application_setting (setting_name, setting_value) values ('version', '1.1');
commit;

-- Allow web service to use get_application_setting function
exec allow_access('invoice_service', 'get_application_setting', 'execute');

-- Done with application_setting

/***** END *****/
