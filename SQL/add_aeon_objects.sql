/*  Add AEON-related objects to DEV database.
    Necessary for now due to long development cycle for AEON functionality in LibBill.
    Will eventually be repackaged as a schema upgrade script.
    
    Needed now because rebuilding the dev db from production removes these still-pending changes.
    
    References:
    * https://jira.library.ucla.edu/browse/WS-334
      * patron_aeon_seq
      * patron_aeon
      * insert_patron_aeon
      * patron_vw
    * https://jira.library.ucla.edu/browse/WS-335
      * patron_needs_stub
      * insert_invoice (uses patron_needs_stub?)
    * https://jira.library.ucla.edu/browse/WS-340
      * invoice_aeon_request
      * insert_invoice_aeon_request
    * https://jira.library.ucla.edu/browse/WS-340
      * invoice_aeon_request_vw

   Uses relative paths (from this script) to object definition scripts.
   Run as user invoice_owner_dev.    
*/    

@sequences/patron_aeon_seq.sql
@tables/patron_aeon.sql
@procedures/insert_patron_aeon.sql
@views/patron_vw.sql

@tables/invoice_aeon_request.sql
@procedures/insert_invoice_aeon_request.sql
@views/invoice_aeon_request_vw.sql

@functions/patron_needs_stub.sql
@procedures/insert_invoice.sql


-- First two already done via object creation sql
-- exec allow_access('invoice_service', 'insert_invoice_aeon_request', 'execute');
-- exec allow_access('invoice_service', 'insert_patron_aeon', 'execute');
exec allow_access('invoice_service', 'invoice_aeon_request_vw', 'select');

select * from user_errors;
select * from user_objects where status != 'VALID';
