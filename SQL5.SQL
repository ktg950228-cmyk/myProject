--자바 연동테이블
CREATE TABLE board(
num NUMBER CONSTRAINT board_num_pk PRIMARY KEY,
title VARCHAR2(100) NOT NULL,
writer VARCHAR2(34),
cont VARCHAR2(300),
bdate date
);
CREATE SEQUENCE board_seq INCREMENT BY 1 START WITH 1;
SELECT * FROM user_sequences;