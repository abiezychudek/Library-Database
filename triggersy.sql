CREATE OR REPLACE FUNCTION log_last_name_changes()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	INSERT INTO membership_history
	VALUES(OLD.member_id,OLD.book_id,OLD.loan_data,now());
	RETURN NEW;
END;
$$

CREATE TRIGGER return_book
	BEFORE DELETE
	ON loan_books
	FOR EACH ROW 
	EXECUTE PROCEDURE log_last_name_changes();
	
	
CREATE OR REPLACE FUNCTION too_many_books()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
AS
 $$
BEGIN 
IF (SELECT currently_loan FROM member_status WHERE  NEW.member_id=member_id)= ((SELECT max_to_loan FROM member_status WHERE NEW.member_id=member_id))
 THEN  
 	RAISE NOTICE 'You have the limit';
	return null;
	END IF;
	return NEW;
	END; $$;

	
CREATE TRIGGER check_valid_loan_book
  BEFORE INSERT ON loan_books
FOR EACH ROW EXECUTE PROCEDURE   too_many_books();

