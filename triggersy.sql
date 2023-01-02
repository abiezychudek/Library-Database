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
	
	