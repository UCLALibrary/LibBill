create or replace procedure insert_message (
  p_user_name in message_log.user_name%type
, p_message_type in message_log.message_type%type
, p_error_code in message_log.error_code%type
, p_message in message_log.message%type
) as
begin
  insert into message_log (user_name, message_type, error_code, message)
    values (p_user_name, p_message_type, p_error_code, p_message);
  
  
end insert_message;
/

