create sequence location_service_seq
  minvalue 1
  maxvalue 99999999 
  increment by 117 -- 116 rows of legacy data will be inserted without using the sequence, via load_location_service.sql
  start with 1
  nocache
  noorder
  nocycle
;

