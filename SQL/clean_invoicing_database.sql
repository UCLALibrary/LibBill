/*  Removes all objects, leaving empty invoicing database.
    Assumes users invoice_owner and invoice_service (or _dev equivalents) exist.

    Run as user invoice_owner or invoice_owner_dev.
*/

drop view invoice_adjustment_vw;
drop view invoice_adjustment_type_vw;
drop view invoice_line_adjustment_vw;
drop view invoice_line_full_vw;
drop view invoice_line_vw;
drop view invoice_note_vw;
drop view invoice_status_vw;
drop view invoice_status_change_vw;
drop view invoice_vw;
drop view line_item_adjustment_type_vw;
drop view line_item_note_vw;
drop view location_vw;
drop view location_service_vw;
drop view payment_type_vw;
drop view payment_vw;
drop view tax_rate_type_vw;
drop view tax_rate_vw;
drop view audit_log_vw;
drop view user_role_privilege_vw;
drop view user_role_privilege_status_vw;

drop procedure apply_refund_adjustment;
drop procedure assign_role_to_user;
drop procedure cancel_invoice_tax;
drop procedure delete_invoice_note;
drop procedure delete_line_item;
drop procedure delete_line_item_note;
drop procedure delete_location;
drop procedure delete_location_service;
drop procedure insert_invoice;
drop procedure insert_invoice_adjustment;
drop procedure insert_invoice_note;
drop procedure insert_line_item;
drop procedure insert_line_item_adjustment;
drop procedure insert_line_item_note;
drop procedure insert_location;
drop procedure insert_location_service;
drop procedure insert_message;
drop procedure insert_payment;
drop procedure insert_staff_user;
drop procedure insert_tax_rate;
drop procedure insert_taxable_zip_code;
drop procedure update_invoice;
drop procedure update_invoice_amounts;
drop procedure update_invoice_note;
drop procedure update_invoice_taxes;
drop procedure update_invoice_total;
drop procedure update_line_item;
drop procedure update_line_item_note;
drop procedure update_location;
drop procedure update_location_service;
drop procedure update_staff_user;
drop procedure update_tax_rate;
drop procedure update_taxable_zip_code;

drop function calculate_balance_due;
drop function get_application_setting;
drop function get_county_tax_by_zip_code;
drop function get_crypto_key;
drop function get_invoice_status;
drop function get_next_invoice_number;
drop function get_nontaxable_total;
drop function get_price_for_service;
drop function get_state_tax_by_zip_code;
drop function get_taxable_total;
drop function get_tax_rate;
drop function get_user_info;
drop function get_user_info_by_id_key;
drop function is_patron_uc;
drop function user_can_change_status;
drop function user_has_privilege;

drop table application_setting;
drop table message_log;

drop table role_privilege_status;

drop table payment;
drop table line_item_adjustment;
drop table line_item_adjustment_type;
drop table line_item_note;
drop table line_item;
drop table invoice_adjustment;
drop table invoice_adjustment_type;
drop table invoice_note;
drop table invoice;
drop table invoice_status_change;
drop table invoice_status;

drop table location_service;
drop table location;

drop table payment_type;
drop table tax_rate;
drop table tax_rate_type;
drop table taxable_zip_code;

drop table staff_user;
drop table invoice_privilege;
drop table invoice_role;

drop sequence invoice_seq;
drop sequence location_service_seq;
drop sequence location_seq;
drop sequence tax_rate_seq;

drop package application_errors;

drop procedure allow_access;
drop table db_grants;

purge recyclebin;
select * from user_objects;
