CREATE INDEX currently_loaned  ON member_status(currently_loan); 
CREATE INDEX title ON BOOK(title,availability);
CREATE INDEX member_name ON MEMBER(member_id, surname,name);
CREATE INDEX to_return ON loan_books(book_id,member_id);
CREATE INDEX title_ ON BOOK(title,book_id); 
CREATE INDEX place ON plan_of_building(sector_id, sector_name);

-- 1 wypisanie dostępnych książek
SELECT title From book WHERE availability=TRUE;

-- 2 wypisanie ile dany użytkownik ma obecnie wypożyczonych książek
SELECT name,surname, currently_loan
FROM member 
JOIN member_status ON member.member_id=member_status.member_id
WHERE surname='Samosia' AND name='Gosia';

-- 3 ksiazki, wypozyczone, dla konkretnego członka
SELECT title FROM BOOK
JOIN loan_books ON loan_books.book_id = BOOK.book_id
JOIN member ON member.member_id=loan_books.member_id
WHERE surname='Samosia' AND name='Gosia';

-- 4 wypisanie w jakim sektorze biblioteki znajduje się dana książka
SELECT sector_name FROM plan_of_building
JOIN book ON book.sector_id=plan_of_building.sector_id
WHERE title='Koziolek Matolek';
