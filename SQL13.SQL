CREATE TABLE MEMBER(
	num NUMBER CONSTRAINT member_num_pk PRIMARY key,
	userid VARCHAR(60) NOT null,
	email VARCHAR(100) NOT null,
	password VARCHAR(20) NOT null,
	name VARCHAR(50) NOT null,
	regdate DATE DEFAULT sysdate,
	CONSTRAINT member_userid_uq UNIQUE(userid)
);

CREATE SEQUENCE member_seq INCREMENT BY 1 START WITH 1;

INSERT INTO MEMBER (num, userid, email, password, name, regdate) VALUES (member_seq.NEXTVAL,'', '', '', '', SYSDATE);

SELECT COUNT(*) FROM MEMBER WHERE email = '';

DROP TABLE MEMBER;
DROP SEQUENCE member_seq;

COMMIT;

SELECT NAME, COUNT(*) cnt FROM MEMBER WHERE userid='qwer' AND PASSWORD='1q2w3e4r' GROUP BY name;