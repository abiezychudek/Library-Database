--1.Procedura zmienia status ksiązki na niedostępna oraz dodaje infomracje do tabeli o wypożyczonych książkach
CREATE PROCEDURE Loan_BOOK (bookid INT, memberid INT)
	LANGUAGE SQL
	AS $$
	
		UPDATE book
		SET availability=FALSE
		WHERE book_id=bookid;
	
		INSERT INTO loan_books VALUES
		(bookid,memberid,CURRENT_DATE,NOW() + interval '1 month')
		$$
		
--2.Procedura odopwiadajace za poprawne dane dane w tabeki copy		
CREATE PROCEDURE copyOfBooks ()
 LANGUAGE plpgsql AS
$$
DECLARE

		rows INTEGER;
		i INT;
		title_name VARCHAR(25);
	BEGIN
	SELECT COUNT(*) FROM book AS rows;
	i=1;
	WHILE(i<=rows) loop
		
			title_name:=(SELECT title FROM book WHERE book_id=i LIMIT 1);
		IF(NOT exists(select title from copy where title = title_name))
			   then 
		   		INSERT INTO copy VALUES(i,
										(SELECT COUNT(*) FROM book WHERE title=title_name AND availability=TRUE ),
										( SELECT COUNT(*) FROM book WHERE title=title_name));
		   	
	    END IF;
			i:=i+1;
		END LOOP;
		END
$$

--1.Funkcja sprawdzająca czy występuje dane książka w bibliotece		
CREATE OR REPLACE FUNCTION available (title_name VARCHAR(25),authorSur VARCHAR(20)) 
   returns BOOLEAN
	language plpgsql
	as
	$$
		begin
 	      if (exists(select title from book where title = title_name  AND  availability=TRUE)
			  AND
			  exists(select surname from author where surname = authorSur) 
			 )
      		  then
          		return 'true';
      	   else
         		return 'false';
      	   end if;
   		end;
	$$	
	
	
	
--3.Przedłużenie książki
CREATE TYPE long AS ENUM ('day', 'week', 'month');
CREATE PROCEDURE longer_return_data(date long, id_member INT,id_book INT)
	LANGUAGE SQL
	AS 
$$
	UPDATE loan_books SET
	 return_data = CASE
             WHEN (date='day') THEN return_data+interval '1 day'
 	 		  WHEN (date='week') THEN return_data+interval '1 week'
 	         WHEN (date='month') THEN return_data+interval '1 month'
              
	END
	WHERE id_member=member_id AND id_book=book_id
$$

--4.Oddanie ksiązki 
CREATE PROCEDURE return_book(id_member INT,id_book INT)
	LANGUAGE plpgsql
	AS
$$
	DECLARE loan DATE;
	
	BEGIN
		loan:=(SELECT loan_data FROM loan_books WHERE (member_id=id_member AND book_id=id_book));
	
		INSERT INTO membership_history VALUES(id_member,id_book, loan,CURRENT_DATE);

		DELETE FROM loan_books WHERE (member_id=id_member AND book_id=id_book);
	END;	
$$	

