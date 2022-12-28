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

--5.DODANIE NOWE KSIAZKI

CREATE PROCEDURE add_book(category_name_ VARCHAR(20),title VARCHAR(25),a_name VARCHAR(20),a_surname VARCHAR(20),date_of_publication DATE)
LANGUAGE plpgsql
	AS
$$
	DECLARE author INT;
		    max_id_a INT;
			max_id_b INT;
			cat_id INT;
	
	BEGIN
		max_id_b:=(SELECT MAX(book_id) FROM book);
		cat_id:=(SELECT category_id FROM category WHERE category_name_=category_name );
		if(NOT exists(SELECT author_id FROM author WHERE name=a_name AND surname=a_surname ))
			THEN
				max_id_a:=(SELECT MAX(author_id) FROM author);
				INSERT INTO author VALUES(max_id_a+1,a_name,a_surname);
				INSERT INTO book VALUES(max_id_b+1,cat_id,title,max_id_a+1,date_of_publication,1,TRUE);
		ELSE 
			author:=(SELECT author_id FROM author WHERE name=a_name AND surname=a_surname );
			INSERT INTO book VALUES(max_id_b+1,cat_id,title,author,date_of_publication,1,TRUE);
		END IF;
		END;
		
		$$
		
		
--2.Funkcja wypisuje ksiazki z danego gatunku (uzywam widoku 7)!

CREATE OR REPLACE FUNCTION by_category(cat_name varchar)
	returns table (
		title_name varchar,
		category_name varchar
	)
	language plpgsql
	AS
	$$
	
	BEGIN
		return query
		SELECT B.title,B.category_name
		FROM book_cat B
		WHERE cat_name = B.category_name;
	END;
	
	$$
	
	
