UPDATE SAWON SET sapay=3200, comm=1000 WHERE sabun=11;
DELETE FROM SAWON WHERE sabun=11;
ROLLBACK;

CREATE TABLE emp2 AS SELECT sabun, saname, sapay, deptno, sahire FROM SAWON; --기존엔 create table TN(col, col, col, col, col);
CREATE TABLE emp2 AS SELECT sabun, saname, sapay, deptno, sahire FROM SAWON WHERE 1=0; --같은 구조로 테이블은 생성하고 데이터는 안가져옴
SELECT * FROM EMP2;
DROP TABLE EMP2;

SELECT * FROM SAWON WHERE sajob='과장';
SELECT * FROM SAWON WHERE saname='류명한';
UPDATE SAWON SET sapay=(SELECT sapay FROM SAWON WHERE saname='류명한') WHERE sajob='과장'; --여기서도 서브쿼리 가능
DELETE FROM SAWON2 WHERE sapay > (SELECT sapay FROM SAWON WHERE saname='류명한');					--참조때문에 삭제 안됨
ROLLBACK;

CREATE TABLE SAWON2 AS SELECT * FROM SAWON;	--복사본 sawon2 생성
DESC SAWON2;
SELECT * FROM SAWON2;
COMMIT;

SELECT AVG(NVL(s.sapay,0)) FROM SAWON2 s, SAWON2 M WHERE s.deptno=m.deptno;
DELETE FROM SAWON M WHERE

--join: 옆으로 데이터 카타시안곱
--집합 연산자: 밑으로 데이터 합치기 union, union all, intersect, minus

CREATE TABLE A(col1 NUMBER(10));
CREATE TABLE B(col1 NUMBER(10));

INSERT INTO A VALUES(1);
INSERT INTO A VALUES(2);
INSERT INTO A VALUES(3);
INSERT INTO A VALUES(4);
INSERT INTO A VALUES(5);

INSERT INTO B VALUES(3);
INSERT INTO B VALUES(4);
INSERT INTO B VALUES(5);
INSERT INTO B VALUES(6);
INSERT INTO B VALUES(7);

COMMIT;
SELECT * FROM A UNION ALL SELECT * FROM B; --UNION ALL 중복 데이터 그대로 출력

SELECT deptno, SUM(sapay) FROM SAWON GROUP BY deptno UNION ALL SELECT TO_NUMBER(null), SUM(sapay) FROM SAWON;
SELECT sajob,SUM(sapay) FROM SAWON GROUP BY SAJOB UNION ALL SELECT 'total', SUM(sapay) FROM SAWON;

SELECT goname, RPAD(SUBSTR(gojumin,1,7),14,'*') jumin FROM GOGEK;

SELECT goname, DECODE(SUBSTR(gojumin,8,1),1,'남자',3,'남자',2,'여자',4,'여자') gender FROM GOGEK;
SELECT gender, COUNT(*) FROM (SELECT goname, DECODE(SUBSTR(gojumin,8,1),1,'남자',3,'남자',2,'여자',4,'여자') gender FROM GOGEK) GROUP BY gender;


CREATE TABLE C(col1 NUMBER(10));
CREATE TABLE D(col1 NUMBER(10));

INSERT INTO C VALUES(1);
INSERT INTO C VALUES(2);
INSERT INTO C VALUES(3);
INSERT INTO C VALUES(4);
INSERT INTO C VALUES(5);

INSERT INTO D VALUES(3);
INSERT INTO D VALUES(4);
INSERT INTO D VALUES(5);
INSERT INTO D VALUES(6);
INSERT INTO D VALUES(7);

COMMIT;
SELECT * FROM C UNION SELECT * FROM D; --UNION 중복없이 출력

SELECT * FROM C INTERSECT SELECT * FROM D; --intersect 교집합

SELECT * FROM SAWON WHERE deptno IN(10,20) INTERSECT SELECT * FROM SAWON WHERE deptno IN(20,30); --교집합, 두 쿼리에서 ★모든 컬럼★이 일치하는 데이터만 출력

SELECT * FROM SAWON WHERE deptno IN(10,20) MINUS SELECT * FROM SAWON WHERE deptno IN(20,30); --차집합

SELECT saname, LEVEL, sapay, sajob FROM SAWON START WITH saname='김길동' CONNECT BY PRIOR sabun=samgr;

SELECT RPAD(' ',level*3) || saname, saname, level, sapay, sajob FROM SAWON START WITH saname='김길동' CONNECT BY PRIOR sabun=samgr AND saname != '한국남'; --R/LPAD(문자,개수): 문자 좌우에 글자 추가



--절대경로 /로 시작, 상대경로 /없이 시작, ../=상위, ./=현재 (계층형 커리에서 비슷하게 구현가능)
--SYS_CONNECT_BY_PATH():계층형 쿼리 전용 함수, 컬럼 문자열로 구분자 넣어서 레벨순으로. order siblings by [col]은 레벨 같을 때 나열할 기준
SELECT saname, LTRIM(SYS_CONNECT_BY_PATH(saname, '/'),'/') AS PATH FROM SAWON START WITH saname='김길동' CONNECT BY PRIOR sabun=samgr order siblings BY saname;--L/RTRIM([col],문자):
SELECT LEVEL, sabun, saname, sajob, samgr FROM SAWON START WITH sabun=1 CONNECT BY PRIOR sabun=samgr;


SELECT * FROM SAWON2;
DELETE FROM SAWON2;			--평범한 데이터 삭제(DROP과는 다름)
TRUNCATE TABLE SAWON2;	--TRUNCATE Table TN: 테이블 데이터 한번에 삭제(자동 commit까지), DELETE랑 차이점은 더 빠르다
ROLLBACK;


--view: 물리적 테이블을 근거로 한 논리적 가상 테이블(테이블엔 데이터가 존재하지만 뷰에는 데이터가 존재하지않고 SQL만 저장되어있음. 읽기 전용)
--긴 쿼리문 뷰로 정의, 뷰 삭제해도 테이블 구조,데이터와는 무관, 특정 컬럼이나 행만 보이게 권한 관리 가능
--create or replace view: 사용 문법. 같은 뷰가 있으면 삭제 후 재생성. 그냥 CREATE VIEW해도되지만 이미 있으면 DROP VIEW 해야되기에. 원래는 CREATE VIEW 뷰이름 AS SELECT [col1], [col2] FROM 테이블 이름 WHERE 조건;
--force view: 기존 테이블 여부와 상관없이 생성(원본없이도 생성)
--with check option: 주어진 제약 조건에 맞는 데이터만 입력 및 수정 허용
--with read only: 검색 전용 뷰

CREATE table dept cp AS SELECT * FROM DEPT;
CREATE table sawon2 s2 AS SELECT * FROM DEPT;

CREATE FORCE VIEW sawon2view AS SELECT * FROM SAWON2;	--view대신 force view하면 강제 생성, 그때는 오류메세지는 뜨지만 sawon2를 바라보는 테이블은 생성됨. 테이블 열여봐도 데이터없고 오류문 나옴
SELECT * FROM tab;																		--view테이블 보임
SELECT * FROM tab WHERE tabtype='VIEW';
DESC user_views;																			--view정보 확인용 딕셔너리 테이블
SELECT * FROM user_views;															--데이터 실제로보면 테이블이 아니라 SQL코드가 들어있음


SELECT * FROM SAWON2;
SELECT * FROM SAWON2VIEW;--당장은 sawon2가 없어서 뷰테이블이 안보이는데
CREATE TABLE SAWON2 AS SELECT * FROM SAWON; --만들고나서
SELECT * FROM SAWON2VIEW;--다시보면 보임
DROP VIEW SAWON2VIEW;


SELECT s.saname, s.deptno, d.dname, d.loc FROM SAWON s, DEPT d WHERE s.deptno=d.deptno;

CREATE OR REPLACE VIEW sawonView AS SELECT s.saname, s.deptno, d.dname, d.loc FROM SAWON s, DEPT d WHERE s.deptno=d.deptno;
SELECT * FROM user_views;

SELECT * FROM sawonView WHERE deptno=10;	--view테이블도 sql문 가능하지만 테이블이 존재하진 않음 = 원본 테이블을 계속 참조하며 INSERT같은거 ㄴㄴ


--단순뷰
CREATE OR REPLACE VIEW Dview AS SELECT deptno, dname FROM DEPT cp; --dept의 deptno, dname 두개만 가지고 만든 뷰
SELECT view_name, text FROM user_views WHERE LOWER(view_name)='dview'; --내 뷰 검색 됨
DESC Dview;

INSERT INTO Dview VALUES(80,'qwe123'); --뷰를 이용해 데이터가 넣어지긴하는데 추천하지않음(3개중 2개 들어감)
SELECT deptno,dname,loc FROM DEPT cp;


--with check OPTION: 뷰로 데이터 삽입/수정할 때 조건 그 데이터가 뷰 조건 만족하게 강제, WITH READ ONLY: 뷰를 통한 데이터 삽입/수정 못하게 강제
CREATE OR REPLACE VIEW viewtest AS SELECT saname, sapay, deptno FROM SAWON WHERE deptno=30 with CHECK OPTION;


--rownum 데이터 식별 고유번호 칼럼(데이터를 아무리 삭제해도 인스턴스 생성시 처음부터 번호 나열, ORDER BY적용 전 기준 순서인것 주의)
SELECT sabun, saname FROM SAWON;
SELECT ROWNUM, sabun, saname FROM SAWON;

CREATE TABLE DEPT_3 AS SELECT * FROM DEPT;
DELETE FROM DEPT_3 WHERE deptno=30;
SELECT rownum, deptno, dname FROM DEPT_3; --행 삭제해도 여전히 rownum는 1부터 끊김없이 내려감

SELECT CEIL(rownum/5) five, AVG(NVL(sapay,0)) FROM SAWON GROUP BY CEIL(rownum/5); --5명씩 짝지어서 연봉 평균내기

CREATE TABLE qwer(	--sequence용 테스트 테이블, sequence는 테이블과 별개의 독립 개체(여러 테이블 동시 사용 가능), 시퀀스.NEXTVAL로 다음 숫자 반환, 여러 세션 동시에 사용해도 중복없게 DBMS가 직접 관리, 롤백으로도 현재 시퀀스 값 되돌리지 못함
num NUMBER PRIMARY KEY,
sname VARCHAR2(100),
sdate date
);
SELECT * FROM QWER;

CREATE SEQUENCE qwer_seq INCREMENT BY 1 START WITH 1; --qwer_seq란 이름의 시퀀스 제작(시작1 증가1)
SELECT qwer_seq.NEXTVAL FROM dual;
DROP SEQUENCE qwer_seq;																--삭제문법
INSERT INTO QWER VALUES(qwer_seq.NEXTVAL,'이름',sysdate);

CREATE TABLE myboard( --VARCHAR2(n): 가변 공간 사용, CHAR(n): n바이트 고정 사용(넘으면 오버플로우 일어남. 이름X 주민번호O)
num NUMBER CONSTRAINT myboard_num_pk PRIMARY key,
title VARCHAR2(100),
writer VARCHAR2(30),
CONTENT CLOB,				--content예약어 아님 준 예약어, CLOB 대 용량 문자열 VARCHAR2보다 훨씬.
hit NUMBER DEFAULT 0,
reip  VARCHAR2(30),
bdate DATE,
imgn  VARCHAR2(200),
vidn VARCHAR2(200)
);
DROP SEQUENCE myboard_seq;
CREATE SEQUENCE myboard_seq INCREMENT BY 1 START WITH 1;

INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 1', '글쓴이 1', '내용 1', 0, 'Reip 1', SYSDATE, 'img1.jpg', 'video1.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 2', '글쓴이 2', '내용 2', 0, 'Reip 2', SYSDATE, 'img2.jpg', 'video2.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 3', '글쓴이 3', '내용 3', 0, 'Reip 3', SYSDATE, 'img3.jpg', 'video3.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 4', '글쓴이 4', '내용 4', 0, 'Reip 4', SYSDATE, 'img4.jpg', 'video4.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 5', '글쓴이 5', '내용 5', 0, 'Reip 5', SYSDATE, 'img5.jpg', 'video5.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 6', '글쓴이 6', '내용 6', 0, 'Reip 6', SYSDATE, 'img6.jpg', 'video6.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 7', '글쓴이 7', '내용 7', 0, 'Reip 7', SYSDATE, 'img7.jpg', 'video7.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 8', '글쓴이 8', '내용 8', 0, 'Reip 8', SYSDATE, 'img8.jpg', 'video8.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 9', '글쓴이 9', '내용 9', 0, 'Reip 9', SYSDATE, 'img9.jpg', 'video9.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 10', '글쓴이 10', '내용 10', 0, 'Reip 10', SYSDATE, 'img10.jpg', 'video10.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 11', '글쓴이 11', '내용 11', 0, 'Reip 11', SYSDATE, 'img11.jpg', 'video11.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 12', '글쓴이 12', '내용 12', 0, 'Reip 12', SYSDATE, 'img12.jpg', 'video12.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 13', '글쓴이 13', '내용 13', 0, 'Reip 13', SYSDATE, 'img13.jpg', 'video13.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 14', '글쓴이 14', '내용 14', 0, 'Reip 14', SYSDATE, 'img14.jpg', 'video14.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 15', '글쓴이 15', '내용 15', 0, 'Reip 15', SYSDATE, 'img15.jpg', 'video15.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 16', '글쓴이 16', '내용 16', 0, 'Reip 16', SYSDATE, 'img16.jpg', 'video16.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 17', '글쓴이 17', '내용 17', 0, 'Reip 17', SYSDATE, 'img17.jpg', 'video17.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 18', '글쓴이 18', '내용 18', 0, 'Reip 18', SYSDATE, 'img18.jpg', 'video18.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '제목 19', '글쓴이 19', '내용 19', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
INSERT INTO myboard VALUES (myboard_seq.nextVal, '여기검색1', '테스형', '테스형님', 0, 'Reip 19', SYSDATE, 'img19.jpg', 'video19.mp4');
commit;

SELECT num, title, writer, content, hit, bdate, imgn, vidn, ROWNUM FROM MYBOARD;

SELECT num, title, writer, content, hit, bdate, imgn, vidn FROM (SELECT num, title, writer, content, hit, bdate, imgn, vidn, ROW_NUMBER() OVER(ORDER BY num desc) AS row_num FROM MYBOARD) numbered_rows WHERE row_num BETWEEN 1 AND 5;
SELECT num, title, writer, content, hit, bdate, imgn, vidn, ROW_NUMBER() OVER(ORDER BY num desc) AS row_num FROM MYBOARD;
