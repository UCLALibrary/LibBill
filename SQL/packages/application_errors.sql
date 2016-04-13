create or replace package application_errors as
  --INVALID_INVOICE_STATUS exception;
  --pragma EXCEPTION_INIT (INVALID_INVOICE_STATUS, -20001);
  INVALID_INVOICE_STATUS int := -20001;
  INVALID_DATA int := -20002;
  NOT_ALLOWED int := -20003;
  INVALID_VERSION int := -20004;
  DUPLICATE_ITEM_CODE int := -20005;
end application_errors;
/
