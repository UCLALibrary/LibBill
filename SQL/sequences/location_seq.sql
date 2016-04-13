create sequence location_seq
  minvalue 1
  maxvalue 99999999 
  increment by 1
  start with 11 -- (up to) 10 rows of legacy data will be inserted without using the sequence, via load_location.sql
  nocache
  noorder
  nocycle
;

