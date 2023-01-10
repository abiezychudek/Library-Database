DROP DATABASE Library;
CREATE DATABASE Library;

CREATE TABLE MEMBER(
	member_ID  SERIAL PRIMARY KEY,
	name VARCHAR(20),
	surname VARCHAR(20),
	locality VARCHAR(25),
	login VARCHAR(20) UNIQUE,
	password VARCHAR(20)	
);	

CREATE TABLE AUTHOR(
	author_id int PRIMARY KEY,
	name VARCHAR(20),
	surname VARCHAR(20)	
);
CREATE TABLE SECTOR(
	sector_id INT PRIMARY KEY,
	floor INT,
	place_to_read INT,
	terminal INT	
);
CREATE TABLE PLAN_OF_BUILDING(
	sector_id INT PRIMARY KEY,
	sector_name VARCHAR(20),	
	amout_of_books INT,
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE BOOK(
	book_id INT PRIMARY KEY,
	category_id INT,
	title VARCHAR(50),
	author_id INT,
	date_of_publication DATE,
	sector_id INT,
	availability BOOL,
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id),	
	FOREIGN KEY(author_id) REFERENCES	AUTHOR(author_id)
);

CREATE TABLE MEMBERSHIP_HISTORY(
	member_ID INT,
	book_ID INT,
	loan_data DATE,
	return_data DATE,
	FOREIGN KEY(member_ID) REFERENCES MEMBER(member_id),
	FOREIGN KEY(book_ID) REFERENCES BOOK(book_id)
);

CREATE TABLE CATEGORY(
	CATEGORY_ID SERIAL PRIMARY KEY,
	CATEGORY_name VARCHAR(20)	
);

ALTER TABLE book 
ADD CONSTRAINT category_id FOREIGN KEY  (category_id)  REFERENCES CATEGORY(CATEGORY_ID);

CREATE TABLE LOAN_BOOKS(
	book_id INT ,
	member_id INT ,
	loan_data DATE,
	return_data DATE,
	FOREIGN KEY (book_id) REFERENCES book(book_id),
	FOREIGN KEY (member_id) REFERENCES member(member_id)	
);

CREATE TABLE RESERVATION(
	id SERIAL PRIMARY KEY,
	book_id INT,
	member_id INT,
	FOREIGN KEY (book_id) REFERENCES book(book_id),
	FOREIGN KEY (member_id) REFERENCES member(member_id)	
);

CREATE TABLE POSITION(
	position_id INT PRIMARY KEY,
	salary INT,
	bonus INT
);

CREATE TABLE STAFF(
	staff_id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	surname VARCHAR(20),
	sector_id INT,
	position_id INT,
	FOREIGN KEY (sector_id) REFERENCES SECTOR(sector_id),
	FOREIGN KEY (position_id) REFERENCES POSITION(position_id)
);

CREATE TABLE SHELF(
	shelf_name VARCHAR(3) PRIMARY KEY,
	sector_id INT,
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE MEMBER_STATUS(
	member_id INT,
	currently_loan INT,
	max_to_loan INT,
	FOREIGN KEY (member_id) REFERENCES member(member_id)
);	

CREATE TABLE COPY(
	book_id INT,	
	total_copies INT,
	current_copies INT,
	FOREIGN KEY (book_id) REFERENCES book(book_id)	
);

CREATE TABLE publisher(
	book_id	INT,
	name VARCHAR(20) ,
	FOREIGN KEY (book_id) REFERENCES book(book_id)	
);

CREATE TABLE TERMINAL(
	terminal_id INT PRIMARY KEY,
	availability BOOLEAN,
	sector_id INT,
	FOREIGN KEY (sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE TOP_BOOKS(
	PLACE INT,
	BOOK_ID int,
	FOREIGN KEY (BOOK_ID) REFERENCES BOOK(book_id)	
);

CREATE TABLE changes (
   id INT GENERATED ALWAYS AS IDENTITY,
   member_id INT NOT NULL,
   surname VARCHAR(40) NOT NULL,
   changed_time TIMESTAMP(6) NOT NULL,
   FOREIGN KEY(member_ID) REFERENCES MEMBER(member_id)
);
