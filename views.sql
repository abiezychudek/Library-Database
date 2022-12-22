
CREATE OR REPLACE VIEW  staff_floor AS
SELECT St.name, St.surname, SE.floor
FROM STAFF St, SECTOR Se
WHERE St.sector_id = Se.sector_id ;


CREATE OR REPLACE VIEW best_books AS
SELECT T.PLACE, B.title, C.CATEGORY_name
FROM BOOK B, CATEGORY C, TOP_BOOKS T
WHERE B.book_id = T.BOOK_ID AND B.category_id = C.CATEGORY_ID;

CREATE OR REPLACE VIEW  author_books AS
SELECT A.name, A.surname, B.title
FROM author A, book B
WHERE A.author_id = B.author_id 
ORDER BY A.name;

