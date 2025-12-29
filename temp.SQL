CREATE TABLE board(																						--게시글 테이블
num NUMBER PRIMARY KEY,
title VARCHAR2(50) NOT NULL,
member VARCHAR2(10) NOT NULL,
udate TIMESTAMP NOT NULL,
image VARCHAR2(50),
CONTENT VARCHAR2(600) NOT NULL
);

CREATE SEQUENCE board_num_pk START WITH 1 INCREMENT BY 1;			--게시글 넘버링 시퀀스

CREATE TABLE comments(																				--댓글 테이블
num NUMBER PRIMARY KEY,
board_num NUMBER NOT NULL,
member VARCHAR2(10) NOT NULL,
udate TIMESTAMP NOT NULL,
comment_text VARCHAR2(180) NOT NULL,
parent NUMBER,											--부모 댓글(대댓글같은경우 있음)
DEPTH NUMBER NOT NULL,							--댓글인지 대댓글인지 대대댓글인지(0~2)
CONSTRAINT comments_board_fk FOREIGN KEY (board_num) REFERENCES BOARD(num),				--board_num이 board테이블을 참조하게
CONSTRAINT comments_comments_fk FOREIGN KEY (parent) REFERENCES COMMENTS(num)			--parent가 스스로 참조하게
);

CREATE SEQUENCE comments_num_pk START WITH 1 INCREMENT BY 1;	--댓글 넘버링 시퀀스

DROP TABLE BOARD;										--테이블 삭제 SQL문
DROP TABLE comments;
DROP SEQUENCE board_num_pk;					--시퀀스 삭제 SQL문
DROP SEQUENCE comments_num_pk;

COMMIT;

INSERT INTO BOARD (num, title, MEMBER, udate, image, CONTENT) VALUES (board_num_pk.NEXTVAL, '테스트용 제목', '테스형', SYSDATE, 'img/kitt.png', '대충 테스트용 작성 글 내용');
INSERT INTO BOARD (num, title, MEMBER, udate, image, CONTENT) VALUES (board_num_pk.NEXTVAL, '두번째 테스트용 제목', '유재석', SYSDATE,NULL, '대충 두번째 테스트용 작성 글 내용');
INSERT INTO BOARD (num, title, MEMBER, udate, image, CONTENT) VALUES (board_num_pk.NEXTVAL, TO_CHAR(board_num_pk.CURRVAL) || '번째 테스트용 제목', '유저' || TO_CHAR(board_num_pk.CURRVAL), SYSDATE,'img/image' || TO_CHAR(board_num_pk.CURRVAL) || '.jpg', '대충 ' || TO_CHAR(board_num_pk.CURRVAL) || '번째 테스트용 작성 글 내용');

SELECT num, title, member, udate, ROW_NUMBER(ORDER BY DESC num) FROM BOARD;