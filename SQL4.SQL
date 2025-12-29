SELECT MAX(sapay) FROM SAWON;
SELECT sapay FROM SAWON;

SELECT MAX(sapay) FROM SAWON WHERE sajob='부장'; --최댓값 함수Max는 그룹함수. 그룹 분할을 안해놨기에 행은 하나만 나옴(그룹 N개였으면 행도 N개)

SELECT MAX(sapay) FROM SAWON GROUP BY sajob; --group by문을 이용해 그룹을 5개 만든 문법(sajob이 5종류니까. 결국 해도 5개 나옴)

SELECT deptno, MAX(sapay) FROM SAWON GROUP BY deptno; --그룹함수로는 COUNT, SUM, AVG, MAX, MIN등이 있음

SELECT sajob, MIN(sapay) FROM SAWON GROUP BY sajob ORDER BY 2 DESC; --sapay란 column은 없으니 ORDER BY SAPAY 불가능(ORDER BY MIN(sapay)하던가)

SELECT sajob, MIN(sapay) FROM SAWON WHERE sajob NOT IN('회장') GROUP BY sajob ORDER BY 2 DESC; -- sajon <> '회장'해도 됨

SELECT MIN(sapay) FROM SAWON WHERE 1=2;

SELECT AVG(NVL(comm,0)) FROM SAWON;

SELECT RANK() OVER(ORDER BY sapay) FROM SAWON;--rank()/dense_rank() over(order by [column])

SELECT * FROM nls_session_parameters;
ALTER SESSION SET NLS_DATE_FORMAT='RR/MM/DD';
SELECT * FROM SAWON WHERE SAHIRE BETWEEN '81/01/01' AND '81/12/31';

SELECT sajob, saname, sapay, DENSE_RANK() OVER(PARTITION BY sajob ORDER BY sapay DESC) "rank" FROM SAWON WHERE SAHIRE BETWEEN '80/01/01' AND '89/12/31';--PARTITION BY?

SELECT saname, comm FROM SAWON WHERE deptno = 30 ORDER BY comm ASC;

SELECT saname, comm FROM SAWON WHERE deptno IN(30,10) ORDER BY comm DESC NULLS LAST; --NULL값을 맨 뒤로 미룸

SELECT saname, sajob, comm, NTILE(4) OVER (ORDER BY comm NULLS last) FROM SAWON; --NTILE(n) OVER(ORDER BY [col]) 전체중 몇인지

SELECT saname, CUME_DIST() OVER(ORDER BY sapay desc) FROM SAWON; --CUME_DIST() 전체 1중 몇인지

SELECT LISTAGG(saname,',') WITHIN GROUP(ORDER BY saname) FROM SAWON; --LISTAGG(col, 구분자) WITHIN GROUP(ORDER BY col), 그룹함수임
SELECT LISTAGG(saname,',') WITHIN GROUP(ORDER BY saname), deptno FROM SAWON WHERE deptno IN(10,20) GROUP BY DEPTNO;

SELECT SYSDATE FROM dual; --SYSDATE: 현재시간 날짜타입
SELECT SYSDATE -1, SYSDATE +1 FROM dual; --날짜 +- 숫자: 일수 추가,감소/ 날짜 - 날짜: 일수 차이(날짜+날짜 지원안됨)
--add_month(날짜. 더할 개월 수)
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, SAHIRE)) FROM SAWON;

SELECT NEXT_DAY(SYSDATE, '수'), LAST_DAY(SYSDATE) FROM dual;-- 다음 X요일과 그 달 마지막 일

--TO_CHAR(날짜/숫자, 형식), TO_DATE(날짜형태 문자열, 날짜), TO_NUMBER(문자열 숫자)
--형식으로는 yyyy YEAR yy month q d dy day dd ddd hh mi ss
SELECT TO_CHAR(sysdate, 'yyyy"년 "mm"월 "dd"일 " day') FROM dual;

SELECT SYSDATE, TO_CHAR(sysdate, 'yyyy"년 "mm"월 "dd"일 "day"이며 "q"분기. "') || TO_CHAR(sysdate, '"앞으로 1년중에 "') || (365-TO_CHAR(sysdate,'ddd')) || '일 남았습니다' FROM dual;

SELECT LISTAGG(sapay,'&'), deptno FROM SAWON GROUP BY deptno;
