create table taxable_zip_code (
  zip_code char(5) not null
, la_county_taxable char(1) not null check (la_county_taxable in ('N', 'Y'))
, california_taxable char(1) not null check (california_taxable in ('N', 'Y'))
, constraint taxable_zip_code_pk primary key (zip_code)
)
;
