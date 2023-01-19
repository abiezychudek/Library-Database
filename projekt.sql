DROP DATABASE Library;
CREATE DATABASE Library;

CREATE TABLE MEMBER(
	member_ID  SERIAL PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	surname VARCHAR(20) NOT NULL,
	locality VARCHAR(25) NOT NULL,
	login VARCHAR(20) UNIQUE,
	password VARCHAR(20) NOT NULL	
);	

CREATE TABLE AUTHOR(
	author_id int PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	surname VARCHAR(20) NOT NULL	
);
CREATE TABLE SECTOR(
	sector_id INT PRIMARY KEY,
	floor INT NOT NULL,
	place_to_read INT,
	terminal INT	
);
CREATE TABLE PLAN_OF_BUILDING(
	sector_id INT PRIMARY KEY,
	sector_name VARCHAR(20) NOT NULL,	
	amout_of_books INT, CHECK(amout_of_books >=0),
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE BOOK(
	book_id INT PRIMARY KEY,
	category_id INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	author_id INT NOT NULL,
	date_of_publication DATE NOT NULL,
	sector_id INT NOT NULL,
	availability BOOL NOT NULL,
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id),	
	FOREIGN KEY(author_id) REFERENCES	AUTHOR(author_id)
);

CREATE TABLE MEMBERSHIP_HISTORY(
	member_ID INT NOT NULL,
	book_ID INT NOT NULL,
	loan_data DATE NOT NULL,
	return_data DATE NOT NULL,
	CHECK (loan_data <= return_data),
	FOREIGN KEY(member_ID) REFERENCES MEMBER(member_id),
	FOREIGN KEY(book_ID) REFERENCES BOOK(book_id)
);

CREATE TABLE CATEGORY(
	CATEGORY_ID SERIAL PRIMARY KEY,
	CATEGORY_name VARCHAR(20) NOT NULL	
);

ALTER TABLE book 
ADD CONSTRAINT category_id FOREIGN KEY  (category_id)  REFERENCES CATEGORY(CATEGORY_ID);

CREATE TABLE LOAN_BOOKS(
	book_id INT NOT NULL,
	member_id INT NOT NULL,
	loan_data DATE NOT NULL,
	return_data DATE NOT NULL,
	CHECK (loan_data <= return_data),
	FOREIGN KEY (book_id) REFERENCES book(book_id),
	FOREIGN KEY (member_id) REFERENCES member(member_id)	
);

CREATE TABLE RESERVATION(
	id SERIAL PRIMARY KEY,
	book_id INT NOT NULL,
	member_id INT NOT NULL,
	FOREIGN KEY (book_id) REFERENCES book(book_id),
	FOREIGN KEY (member_id) REFERENCES member(member_id)	
);

CREATE TABLE POSITION(
	position_id INT PRIMARY KEY,
	salary INT, CHECK(salary >= 0),
	bonus INT, CHECK(bonus >= 0)
);

CREATE TABLE STAFF_CATEGORY(
	staff_id SERIAL PRIMARY KEY,
	staff_type VARCHAR(20) NOT NULL
);
CREATE TABLE INTERN(
	staff_id INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	surname VARCHAR(20) NOT NULL,
	hours INT, CHECK(hours >=0),
	internship_start_date DATE NOT NULL,
	position_id INT NOT NULL,
	FOREIGN KEY (position_id) REFERENCES POSITION(position_id)
);
CREATE TABLE REGULAR_STAFF(
	staff_id INT PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	surname VARCHAR(20) NOT NULL,
	sector_id INT,
	position_id INT NOT NULL,
	FOREIGN KEY (sector_id) REFERENCES SECTOR(sector_id),
	FOREIGN KEY (position_id) REFERENCES POSITION(position_id)
);

CREATE TABLE SHELF(
	shelf_name VARCHAR(3) PRIMARY KEY,
	sector_id INT NOT NULL,
	FOREIGN KEY(sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE MEMBER_STATUS(
	member_id INT NOT NULL,
	currently_loan INT,
	max_to_loan INT,
	FOREIGN KEY (member_id) REFERENCES member(member_id)
);	

CREATE TABLE COPY(
	book_id INT NOT NULL,	
	total_copies INT, CHECK(total_copies >=0),
	current_copies INT, CHECK(total_copies >=0),
	FOREIGN KEY (book_id) REFERENCES book(book_id)	
);

CREATE TABLE publisher(
	book_id	INT NOT NULL,
	name VARCHAR(20) NOT NULL,
    	city VARCHAR(20),
    	street VARCHAR(20),
	FOREIGN KEY (book_id) REFERENCES book(book_id)	
);

CREATE TABLE TERMINAL(
	terminal_id INT PRIMARY KEY,
	availability BOOLEAN NOT NULL,
	sector_id INT NOT NULL,
	FOREIGN KEY (sector_id) REFERENCES SECTOR(sector_id)
);

CREATE TABLE TOP_BOOKS(
	PLACE INT, CHECK( PLACE BETWEEN 1 AND 10),
	BOOK_ID int NOT NULL,
	FOREIGN KEY (BOOK_ID) REFERENCES BOOK(book_id)	
);

CREATE TABLE changes (
   id INT GENERATED ALWAYS AS IDENTITY,
   member_id INT NOT NULL,
   surname VARCHAR(40) NOT NULL,
   changed_time TIMESTAMP(6) NOT NULL,
   FOREIGN KEY(member_ID) REFERENCES MEMBER(member_id)
);

 ALTER TABLE  intern
 ADD Constraint Intern FOREIGN KEY (position_id) REFERENCES Position(position_id) ON DELETE CASCADE ON UPDATE CASCADE;
 
 ALTER TABLE  regular_staff
 ADD Constraint regular FOREIGN KEY (position_id) REFERENCES Position(position_id) ON DELETE CASCADE ON UPDATE CASCADE;
