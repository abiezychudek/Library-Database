-- 1 wstawienie do histori członka oddana ksiazke
CREATE OR REPLACE FUNCTION update_membership()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	INSERT INTO membership_history
	VALUES(OLD.member_id,OLD.book_id,OLD.loan_data,now());
	RETURN NEW;
END;
$$;

CREATE TRIGGER return_book
	BEFORE DELETE
	ON loan_books
	FOR EACH ROW 
	EXECUTE PROCEDURE update_membership();
	
-- 2 brak moziiwosci pozyczenie ksiazki, jesli ktos ma juz limit	
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

-- 3 brak mozliwosci dodania, bądź zmiany daty publikacji książki jeśli jest wczesniejsza niz dzisiejsza data

CREATE OR REPLACE FUNCTION not_possible_data()
 RETURNS TRIGGER 
  LANGUAGE PLPGSQL
AS
$$
BEGIN 
		IF NEW.date_of_publication   > now()
 		 THEN  
 		RAISE NOTICE 'You have the limit';
			return null;
		END IF;
			return NEW;
END;
$$;
	
CREATE OR REPLACE TRIGGER check_valid_publication_book
   BEFORE INSERT OR UPDATE ON book
FOR EACH ROW EXECUTE PROCEDURE   not_possible_data();

-- 4 Zmiana sumy ilosci ksiazek w danym sektorze

CREATE OR REPLACE FUNCTION update_amount()
 RETURNS TRIGGER 
  LANGUAGE PLPGSQL
AS
 $$
 BEGIN 
 	UPDATE plan_of_building SET amout_of_books=amout_of_books+1 WHERE sector_id=NEW.sector_id;
	UPDATE plan_of_building SET amout_of_books=amout_of_books-1 WHERE sector_id=OLD.sector_id;
	RETURN NEW;
	END;
$$;

CREATE TRIGGER amount
AFTER UPDATE of sector_id ON book
FOR EACH ROW EXECUTE PROCEDURE  update_amount();

-- 5 wpisuje do tabelki changes informacje o zmianie kogos nazwiska 



CREATE OR REPLACE FUNCTION change_surname_add()
  RETURNS TRIGGER 
  language PLPGSQL
  AS
$$
BEGIN
	IF NEW.surname <> OLD.surname THEN
		 INSERT INTO changes(member_id,surname,changed_time)
		 VALUES(OLD.member_id,OLD.surname,now());
	END IF;

	RETURN NEW;
END;
$$;


CREATE TRIGGER new_surname
  BEFORE UPDATE
  ON member
  FOR EACH ROW
  EXECUTE PROCEDURE change_surname_add();
  
