CREATE VIEW [Staff sector] AS
SELECT St.name, St.surname
FROM STAFF St, SECTOR Se
WHERE St.sector_id = Se.sector_id ;

CREATE VIEW [Best Books] AS
SELECT T.PLACE, B.title, C.CATEGORY_name
FROM BOOK B, CATEGORY C, TOP_BOOKS T
WHERE B.book_id = T.BOOK_ID AND B.category_id = C.CATEGORY_ID;
