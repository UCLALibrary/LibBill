create or replace function get_crypto_key (
  p_id_key in staff_user.id_key%type
) return staff_user.crypto_key%type as
  v_crypto_key staff_user.crypto_key%type;
begin
  select crypto_key into v_crypto_key
    from staff_user
    where id_key = p_id_key;
  return v_crypto_key;
end get_crypto_key;
/
