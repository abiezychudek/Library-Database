--1.Wszystkie ksiązki autorów
CREATE OR REPLACE VIEW  authors_books AS
SELECT DISTINCT B.title, A.name, A.surname
FROM author A, book B
WHERE A.author_id = B.author_id 
ORDER BY A.name;

--2.Ranking najlepszych książek z tytłem wraz z kategoria
CREATE OR REPLACE VIEW best_books AS
SELECT T.PLACE, B.title, C.CATEGORY_name
FROM BOOK B, CATEGORY C, TOP_BOOKS T
WHERE B.book_id = T.BOOK_ID AND B.category_id = C.CATEGORY_ID;


--3.Nazwa pracownika z piętrem na którym obecnie ma stanowisko
CREATE OR REPLACE VIEW  staff_floor AS
SELECT St.name, St.surname, SE.floor
FROM STAFF St, SECTOR Se
WHERE St.sector_id = Se.sector_id ;


--4.Użytkownicy, którzy za długo trzymają swoją książke
CREATE OR REPLACE VIEW  memebr_who_should_return_books AS
SELECT m.member_id, m.surname, m.name
FROM member m
JOIN loan_books d ON d.member_id = m.member_id
WHERE (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', return_data::date)
+DATE_PART('month', CURRENT_DATE) - DATE_PART('month', return_data::date)
+DATE_PART('day', CURRENT_DATE) - DATE_PART('day', return_data::date))>0

--5 Widok osoby wraz z tytułem i kategoria książki na jaki oczekuje oraz pełna nazwa osoby, która ją prztrzymuje
SELECT T.Full_name_booker,T.title,C.category_name ,loan.Full_name_loaner
	FROM(
		SELECT 
			b.title, b.book_id,b.category_id,
			m.name || ' ' || m.surname AS Full_name_booker
		FROM member	m
		JOIN reservation ON reservation.member_id = m.member_id
		JOIN book  b ON b.book_id = reservation.book_id ) T
	
	JOIN (
		SELECT 
			mem.name || ' ' || mem.surname AS Full_name_loaner,
			loan_books.book_id
		FROM  member mem
		JOIN loan_books ON loan_books.member_id = mem.member_id
	) loan  ON loan.book_id= T.book_id
	
	JOIN category C ON C.category_id=T.category_id

