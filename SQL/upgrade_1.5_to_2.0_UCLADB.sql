-- Allow invoice_owner to access ucla patron db for new view
-- Revoke use of old vger_support view.
-- Need grant option so invoice_owner can let invoice_service use the view

-- For PROD and TEST databases
grant select on ucladb.patron to invoice_owner with grant option;
grant select on ucladb.patron_address to invoice_owner with grant option;
grant select on ucladb.patron_barcode to invoice_owner with grant option;
grant select on ucladb.patron_group to invoice_owner with grant option;
grant select on ucladb.patron_phone to invoice_owner with grant option;

--- *** TEMP - these grants must be in place during the 1.5 -> 2.0 upgrade*** ---
grant select on vger_support.ucladb_patrons to invoice_owner with grant option;
grant select on vger_support.ucladb_patrons to invoice_service;
--- *** TEMP *** ---

-- Revoke after upgrade
revoke select on vger_support.ucladb_patrons from invoice_owner;
revoke select on vger_support.ucladb_patrons from invoice_service;

-- For DEV database; will fail on production
grant select on ucladb.patron to invoice_owner_dev with grant option;
grant select on ucladb.patron_address to invoice_owner_dev with grant option;
grant select on ucladb.patron_barcode to invoice_owner_dev with grant option;
grant select on ucladb.patron_group to invoice_owner_dev with grant option;
grant select on ucladb.patron_phone to invoice_owner_dev with grant option;

-- Revoke after upgrade
revoke select on vger_support.ucladb_patrons from invoice_owner_dev;
revoke select on vger_support.ucladb_patrons from invoice_service_dev;
