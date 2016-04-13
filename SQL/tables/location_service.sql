/*  Services are associated with line items: each line item has one service.
    Each service has two textual descriptions, basically a primary and secondary name.
    These seem hierarchical but aren't - really just two attributes of same thing.
    What's relevant is the combination of location and service:
    * Each location wants to be able to set its own name(s) and price for each service.
*/

create table location_service (
  location_service_id int not null
, location_id int not null
, service_name varchar2(50) not null
, subtype_name varchar2(100) not null
, uc_price number(10, 2) -- allow null for these amounts, some services apply only to UC or non-UC patrons
, non_uc_price number(10, 2) 
, uc_minimum_amount number(10, 2)
, non_uc_minimum_amount number(10, 2)
, taxable char(1) default 'N' not null check(taxable in ('N', 'Y'))
, require_custom_price char(1) default 'N' not null check(require_custom_price in ('N', 'Y'))
, unit_measure varchar2(20) not null
, item_code char(12) not null -- per cashnet documentation
, fau varchar2(32) not null -- not clear if format will vary, leaving room for spaces
, constraint location_service_pk primary key (location_service_id)
, constraint location_service_location_id foreign key (location_id) references location (location_id)
);

