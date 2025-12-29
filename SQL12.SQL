CREATE TABLE memo(
num NUMBER CONSTRAINT memo_num_pk primary KEY,
writer VARCHAR2(50) NOT null,
conts VARCHAR2(400) NOT NULL,
mreip VARCHAR2(25),
mdate date
);

CREATE SEQUENCE memo_seq INCREMENT BY 1 START WITH 1;

CREATE TABLE UPBOARD (
    NUM NUMBER PRIMARY KEY, -- 기본 키
    TITLE VARCHAR2(255) NOT NULL, -- 제목
    WRITER VARCHAR2(100) NOT NULL, -- 작성자
    CONTENT CLOB, -- 내용
    IMGN VARCHAR2(255), -- 이미지 파일명
    HIT NUMBER DEFAULT 0, -- 조회수, 기본값 0
    REIP VARCHAR2(50), -- 등록 IP
    BDATE DATE DEFAULT SYSDATE -- 등록 날짜, 기본값 현재 날짜
);
CREATE SEQUENCE UPBOARD_SEQ INCREMENT BY 1  START WITH 1;
SELECT * FROM UPBOARD;

SELECT num,title, writer, content, hit, reip, bdate, imgn, row_num FROM (SELECT num, title, writer, content, hit, reip, bdate, imgn, ROW_NUMBER() OVER(ORDER BY num desc) AS row_num FROM UPBOARD) numbered_rows WHERE row_num BETWEEN 1 AND 10;


CREATE TABLE UPBOARD_comm(
	num NUMBER PRIMARY key,
	ucode number,
	uwriter VARCHAR(34) NOT NULL,
	ucontent VARCHAR(400) NOT null,
	reip VARCHAR(23),
	uregdate DATE DEFAULT sysdate,
	CONSTRAINT fk_upboard_num FOREIGN KEY (ucode) REFERENCES UPBOARD(num)
);

CREATE SEQUENCE upboard_comm_seq INCREMENT BY 1 START WITH 1;
DROP SEQUENCE upboard_comm_seq;

INSERT INTO UPBOARD_COMM VALUES(upboard_comm_seq.NEXTVAL, 1, 'ㅇㅇ', '임시내용','192.168.0.XX',sysdate);
SELECT * FROM UPBOARD_COMM;
ROLLBACK;

COMMIT;

select * from upboard_comm where ucode=90 order by 1 DESC;

SELECT * FROM UPBOARD WHERE writer LIKE 'ㅇㅇ';

SELECT num, title, writer, content, hit, reip, bdate, imgn, row_num FROM (SELECT num, title, writer, content, hit, reip, bdate, imgn, ROW_NUMBER() OVER(ORDER BY num desc) AS row_num FROM UPBOARD) numbered_rows WHERE row_num BETWEEN 11 AND 20;

CREATE TABLE gallery(
	num NUMBER PRIMARY key,
	title VARCHAR2(200),
	CONTENTS CLOB,
	writer VARCHAR2(100),
	reip VARCHAR2(50),
	hit NUMBER DEFAULT 0,
	gdate DATE DEFAULT sysdate
);

CREATE SEQUENCE gallery_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE galleryimages(
	galleryid number,
	imagename VARCHAR2(255),
	CONSTRAINT fk_galleryid FOREIGN KEY (galleryid) REFERENCES GALLERY(num) ON DELETE CASCADE
);

insert into gallery (num, title, contents, writer, reip, hit, gdate) values (gallery_seq.nextVal,'qqq','www','eee','zzz',0,sysdate);

INSERT ALL
INTO GALLERYIMAGES (galleryid, imagename) VALUES(gallery_seq.CURRVAL, 'a.png')
INTO GALLERYIMAGES (galleryid, imagename) VALUES(gallery_seq.CURRVAL, 'b.png')
INTO GALLERYIMAGES (galleryid, imagename) VALUES(gallery_seq.CURRVAL, 'c.png') SELECT * FROM dual;		--INSERT ALL문

DELETE FROM GALLERY;
DELETE FROM galleryimages;
DROP TABLE GALLERY;
DROP TABLE galleryimages;
DROP SEQUENCE gallery_seq;

SELECT num, title, writer, content, hit, reip, bdate, imgn, row_num FROM (SELECT num, title, writer, content, hit, reip, bdate, imgn, ROW_NUMBER() OVER(ORDER BY num desc) AS row_num FROM UPBOARD WHERE writer LIKE '%테스트%') numbered_rows WHERE row_num BETWEEN 11 AND 20;


SELECT num, title, contents, writer, reip, hit, gdate FROM GALLERY WHERE WRITER LIKE '%테스%';
--
SELECT num, title, writer, contents, hit, reip, gdate, ROW_NUMBER() OVER (ORDER BY num DESC) ROW_NUM  FROM GALLERY WHERE writer LIKE '%테스%';
--
SELECT galleryid, imagename, ROW_NUMBER() OVER (PARTITION BY galleryid ORDER BY imagename ASC) RN FROM GALLERYIMAGES;
--
SELECT galleryid, imagename FROM (SELECT galleryid, imagename, ROW_NUMBER() OVER (PARTITION BY galleryid ORDER BY imagename ASC) RN FROM GALLERYIMAGES) WHERE RN=1;
--
SELECT g.NUM, g.TITLE, g.WRITER, g.CONTENTS, g.HIT, g.REIP, g.GDATE,ROW_NUMBER() OVER (ORDER BY g.NUM DESC) ROW_NUM, gc.GALLERYID, gc.IMAGENAME
FROM (SELECT * FROM GALLERY WHERE WRITER LIKE '%테스%' ORDER BY 1 desc) g,
(SELECT GALLERYid, IMAGENAME FROM (SELECT galleryid, imagename, ROW_NUMBER() OVER (PARTITION BY galleryid ORDER BY IMAGENAME desc) RN FROM GALLERYIMAGES) WHERE RN=1) gc
WHERE g.num = gc.galleryid;

SELECT g.num, g.title, g.writer, TO_CHAR(g.contents) contents, g.hit, g.reip, g.gdate, g.row_num, gc.imagename
FROM (SELECT num, title, writer, contents, hit, reip, gdate, ROW_NUMBER() OVER(ORDER BY num DESC) AS row_num FROM GALLERY WHERE WRITER LIKE '%테스%') g,
(SELECT GALLERYid, IMAGENAME FROM (SELECT galleryid, imagename, ROW_NUMBER() OVER (PARTITION BY galleryid ORDER BY IMAGENAME) rn FROM GALLERYIMAGES) WHERE rn=1) gc
WHERE g.num = gc.galleryid AND g.row_num BETWEEN 1 AND 10 ORDER BY num DESC;														--contents CLOB타입이라 JSON으로 매핑할 때 string으로 바꿔줘야 됨

COMMIT;

SELECT num, title, writer, contents, hit, reip, gdate, ROW_NUMBER() OVER(ORDER BY num DESC) AS row_num FROM GALLERY) g;

SELECT g.num, g.title, g.writer, TO_CHAR(g.contents), g.hit, g.reip, g.gdate, gc.galleryid, gc.imagename FROM GALLERY g, GALLERYIMAGES gc WHERE g.num =+ gc.galleryid AND g.num=10;		-- +달린건 NULL포함

SELECT g.NUM AS num, g.TITLE AS title, g.WRITER AS writer, g.CONTENTS AS contents, g.HIT AS hit, g.REIP AS reip, g.GDATE AS gdate, gc.galleryid AS galleryid, gc.imagename AS imagename FROM GALLERY g LEFT JOIN GALLERYIMAGES gc ON g.num = gc.galleryid WHERE g.num = 10;