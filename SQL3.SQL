SELECT ' ict ', TRIM(' ict '), LTRIM(' ict '), RTRIM(' ict ') FROM dual;	--공백 제거
DESC SAWON;
SELECT * FROM SAWON;
SELECT LENGTH(saname), sapay, sajob FROM SAWON;														--길이 측정함수
SELECT saname, sapay, REPLACE(sapay,0,'*') FROM SAWON;										--REPLACE: 데이터를 치환시키는 함수(0이란 숫자가 전부 *로 치환)

CREATE TABLE test_name(
ename VARCHAR(20)
);

INSERT INTO TEST_NAME VALUES('김인호');
INSERT INTO TEST_NAME VALUES('김태규');
INSERT INTO TEST_NAME VALUES('뉴진스');
COMMIT;
SELECT REPLACE(ename,SUBSTR(ename,2,1),'*')AS 이름 FROM TEST_NAME;

SELECT saname,sapay,Rpad(sapay,2,'*') FROM SAWON;												--LPAD/RPAD: X칸 지정하고 빈칸은 지정한 문자(한글자)로 변경

SELECT ROUND(876.345,-2) FROM dual;																			--ROUND, TRUNC: 반올림, 내림(두번째 파라미터는 자리수 인덱스)

SELECT saname, ROUND(sapay/98),RPAD('■',ROUND(sapay/98),'■') FROM SAWON;

SELECT saname, MOD(sabun, 2) AS EvenOdd FROM SAWON;											--나머지 연산함수 MOD()
SELECT sabun, saname FROM SAWON WHERE MOD(sabun,2) = 0 ORDER by sabun;	--맨 뒤에 asc/desc생략하면 asc

--FLOOR/CEIL 상한/하한 함수 ex) FLOOR(10.2) = 10, CEIL(7.5) = 8

--decode: oracle에서만 제공하는 SQL함수, decode(기준값, 조건1, 결과1, 조건2, 결과2, ... , '예외시 값') ifelseif문과 유사, 기준값이 조건 1이면 결과1, 조건2면 결과2, ... , 전부 아니면 마지막 예외처리 값(예외처리 안하면 null값)
SELECT UNIQUE deptno FROM SAWON ORDER BY deptno;
SELECT saname, deptno, DECODE(deptno,10,'총무부',20,'영업부',30,'전산부',40,'관리부','unknown') FROM SAWON;
--SIGN(int) 양수면 1,0이면 0,음수면 -1
SELECT saname, sapay, DECODE(SIGN(sapay-3000), 1,'높은급여',0,'정확히3000',-1,DECODE(SIGN(sapay-1500),1,'중간급여',0,'정확히1500',-1,'낮은급여')) FROM SAWON; --이중 decode문을 이용해 다중분류 가능


--칼럼 함수 case when ~ then ~ when ~ then ~ when ~ then ~ when ~ then ~ when ~ then ~ else ~ end(case로 시작해서 end로 끝나는 칼럼 표현식. 조건문은 'when 조건 then 출력'을 사이에 각각 넣어서 표현)
SELECT saname, sajob, comm, CASE WHEN comm IS NOT NULL THEN 0 ELSE 500 END AS bonus FROM SAWON WHERE sajob IN('대리','부장') ORDER BY 2 desc, bonus;
SELECT saname, sajob, comm, DECODE(comm, NULL, 500, NOT NULL, 0) AS bonus FROM SAWON WHERE sajob IN('대리','부장');