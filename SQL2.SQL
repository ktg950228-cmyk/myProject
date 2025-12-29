SELECT saname, sapay FROM SAWON ORDER BY SAPAY ASC;
SELECT saname, sapay FROM SAWON ORDER BY SAPAY DESC;

SELECT saname, sapay AS 월급 FROM SAWON ORDER BY 월급 DESC;									--sapay를 '월급'이란 이름으로 보기(ASC/DESC조건 생략하면 디폴트로 ASC) ★order by로 '월급'이라 적었는데 잘됨
SELECT saname, deptno, sapay FROM SAWON ORDER BY deptno ASC, sapay DESC;	--부서번호 오름차순 후 급여 내림차순
SELECT saname, deptno, sapay FROM SAWON ORDER BY 2 ASC, 3 DESC;						--윗줄과 같음
SELECT saname, sapay, sajob FROM SAWON WHERE sapay=3000;									--WHERE절은 항상 'from 테이블'다음에
SELECT saname AS 이름, sapay AS 월급 , gender AS 성별 FROM SAWON WHERE sapay >= 3000; --★where '월급'하면 안됨
SELECT saname, sapay, sajob, sahire, DEPTNO FROM SAWON WHERE saname='김길동';

ALTER SESSION SET NLS_DATE_FORMAT='RR/MM/DD';															--기본포멧 변경
SELECT saname, sahire FROM SAWON WHERE sahire >= '81/11/17';							--바꾼 포멧대로 검색

DESC nls_session_parameters;																							--nls_session_parameters테이블의 구조 볼 수 있음
SELECT * FROM nls_session_parameters WHERE PARAMETER='NLS_DATE_FORMAT';		--뽑아보면 RR/MM/DD로 변경된 상태

SELECT 300+200 FROM dual;																									--dual은 가상테이블(select * from tab; 검색해봐도 안보임)
SELECT 300*2 || ' = ?' AS 문제 FROM dual;																		--||는 문자열 연결연산자

SELECT saname, sapay, sajob, DEPTNO FROM SAWON WHERE sapay <= 3000 AND sapay >= 1000;	--밑에랑 같음
SELECT saname, sapay FROM SAWON WHERE sapay BETWEEN 1000 AND 3000;				--BETWEEN은 이상+이하, 그리고 이거 BETWEEN 3000 AND 1000하면 안나옴

SELECT saname, SAHIRE FROM SAWON WHERE SAHIRE BETWEEN '85/01/01' AND '85/12/31';
SELECT saname, SAHIRE FROM SAWON WHERE SAHIRE NOT BETWEEN '85/01/01' AND '85/12/31';
SELECT saname, sapay FROM SAWON WHERE saname LIKE '_순%';									--LIKE는 문자비교열, %는 와일드 카드, _는 한 글자 와일드 카드
SELECT deptno, saname, samgr FROM SAWON WHERE samgr IS NOT NULL;					--IS NULL/IS NOT NULL 이렇게 해야됨

ALTER TABLE SAWON ADD comm NUMBER(10);																		--comm이란 column 추가로 테이블 설정을 변경(ALTER)
DESC SAWON;
SELECT deptno,sapay,comm FROM SAWON WHERE deptno=10 OR deptno=20;
COMMIT;
UPDATE SAWON SET comm=500 WHERE deptno=10 OR deptno=20;
SELECT deptno, sapay, NVL(comm, 0) AS comm, saname, sajob FROM SAWON;			--NVL 밸류 정해주는 함수

SELECT COUNT(*) FROM SAWON WHERE saname LIKE '이%';

SELECT DISTINCT sajob FROM SAWON;																					--distinct(별개의)대신 unique써도 똑같음
SELECT UNIQUE sajob FROM SAWON;

SELECT saname, sapay, sajob FROM SAWON WHERE sajob NOT IN('과장','대리','회장') ORDER BY 3; --IN으로 AND/OR 대체가능
SELECT saname, sapay, sajob FROM SAWON WHERE (sajob != '과장'AND sajob != '대리'AND sajob != '회장') ORDER BY 3;

SELECT UPPER('ictpassword study') UPPER FROM dual;
SELECT LOWER('ictpassword study') FROM dual;
SELECT INitcap('ictpassword study') FROM dual;

SELECT 'smith',LENGTH('SMITH'),SUBSTR('SMITH',2) FROM dual;								--SUBSTR(문자,시작점,글자 수)

SELECT 'qwerSMITHqwer' , SUBSTR('qwerSMITHqwer', INSTR('qwerSMITHqwer','SMITH'), 3) FROM dual;
