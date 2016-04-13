/*  Builds all objects in empty invoicing database.
    Assumes users invoice_owner and invoice_service exist.
    Uses relative paths (from this script) to object definition scripts.

    Run as user invoice_owner or invoice_owner_dev.    
*/

-- Supporting objects used by other code but not by the application
@support/db_grants.sql
@support/allow_access.sql

@packages/application_errors.sql

@sequences/invoice_seq.sql
@sequences/location_service_seq.sql
@sequences/location_seq.sql
@sequences/tax_rate_seq.sql

-- Tables: Order matters for constraints
@tables/application_setting.sql
@tables/invoice_role.sql
@tables/invoice_privilege.sql
@tables/staff_user.sql
@tables/location.sql
@tables/location_service.sql

@tables/message_log.sql
@tables/payment_type.sql
@tables/tax_rate_type.sql
@tables/tax_rate.sql
@tables/taxable_zip_code.sql

@tables/invoice_status.sql
@tables/invoice_status_change.sql
@tables/invoice.sql
@tables/invoice_adjustment_type.sql
@tables/invoice_adjustment.sql
@tables/invoice_note.sql
@tables/line_item.sql
@tables/line_item_adjustment_type.sql
@tables/line_item_adjustment.sql
@tables/line_item_note.sql
@tables/payment.sql
@tables/role_privilege_status.sql

-- Functions used in views, and their dependencies
@functions/get_invoice_status.sql;
@functions/calculate_balance_due.sql

-- Views: Order matters - some views use others
--@views/ucladb_patrons.sql -- owned by vger_support, not created by invoice_owner
@views/location_service_vw.sql
@views/invoice_line_vw.sql
@views/invoice_adjustment_vw.sql
@views/invoice_adjustment_type_vw.sql
@views/invoice_line_adjustment_vw.sql
@views/invoice_note_vw.sql
@views/invoice_status_vw.sql
@views/invoice_status_change_vw.sql
@views/invoice_vw.sql
@views/line_item_adjustment_type_vw.sql
@views/line_item_note_vw.sql
@views/payment_type_vw.sql
@views/payment_vw.sql
@views/tax_rate_type_vw.sql
@views/tax_rate_vw.sql
@views/invoice_line_full_vw.sql
@views/audit_log_vw.sql
@views/user_role_privilege_status_vw.sql
@views/user_role_privilege_vw.sql
@views/location_vw.sql

-- Other Functions: Order matters
@functions/get_application_setting.sql;
@functions/get_tax_rate.sql;
@functions/get_county_tax_by_zip_code.sql;
@functions/get_crypto_key.sql;
@functions/get_next_invoice_number.sql;
@functions/get_nontaxable_total.sql;
@functions/is_patron_uc.sql;
@functions/get_price_for_service.sql;
@functions/get_state_tax_by_zip_code.sql;
@functions/get_taxable_total.sql;
@functions/get_user_info.sql;
@functions/get_user_info_by_id_key.sql;
@functions/user_can_change_status.sql;
@functions/user_has_privilege.sql;

-- Procedures: Order matters
@procedures/insert_message.sql
@procedures/update_invoice_taxes.sql
@procedures/update_invoice_total.sql
@procedures/update_invoice_amounts.sql
@procedures/apply_refund_adjustment.sql
@procedures/cancel_invoice_tax.sql
@procedures/insert_invoice_adjustment.sql

@procedures/delete_invoice_note.sql
@procedures/delete_line_item.sql
@procedures/delete_line_item_note.sql
@procedures/delete_location.sql
@procedures/delete_location_service.sql
@procedures/insert_invoice.sql
@procedures/insert_invoice_note.sql
@procedures/insert_line_item.sql
@procedures/insert_line_item_adjustment.sql
@procedures/insert_line_item_note.sql
@procedures/insert_location.sql
@procedures/insert_location_service.sql
@procedures/insert_payment.sql
@procedures/assign_role_to_user.sql
@procedures/insert_staff_user.sql
@procedures/insert_tax_rate.sql
@procedures/insert_taxable_zip_code.sql
@procedures/update_invoice.sql
@procedures/update_invoice_note.sql
@procedures/update_line_item.sql
@procedures/update_line_item_note.sql
@procedures/update_location.sql
@procedures/update_location_service.sql
@procedures/update_staff_user.sql
@procedures/update_tax_rate.sql
@procedures/update_taxable_zip_code.sql

-- Load production data: mostly lookup tables, initial user(s)
@data/load_allow_access.sql
@data/load_application_setting.sql
@data/load_invoice_role.sql
@data/load_invoice_privilege.sql
@data/load_invoice_status.sql
@data/load_role_privilege_status.sql
@data/load_invoice_status_change.sql
@data/load_invoice_adjustment_type.sql
@data/load_line_item_adjustment_type.sql
@data/load_location.sql
@data/load_payment_type.sql
@data/load_staff_user.sql
@data/load_tax_rate_type.sql
@data/load_tax_rate.sql
@data/load_taxable_zip_code.sql
-- Location_service data from production db exported to Excel file line_items.xls, converted to SQL insert statements
@data/load_location_service.sql

-- Load TEST data: do not load into production system
@data/test/load_test_users.sql

-- Custom grants for reporting
@support/grant_reporting_rights.sql

-- Apply patches not yet folded into main object scripts
--@upgrade_1.4.3_to_1.4.4.sql

-- Check for compilation errors
select * from user_errors;
