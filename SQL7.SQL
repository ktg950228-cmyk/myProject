SELECT SYSDATE + TO_YMINTERVAL('01-00') FROM dual; --날짜 연산 함수, YEAR MONTH 기준으로 단위 옮길 수 있음(마이너스 붙여서 빼기도 가능)
SELECT SYSDATE + TO_DSINTERVAL('100 00:00:00') FROM dual; --일, 시간단위로 이동

SELECT SUM(sapay) FROM SAWON;
SELECT SUM(DECODE(deptno,10,sapay)), --DECODE(expression, search1, result1, search2, result2, ..., default) expression이 search1이면 result1 반환.... 일치값 없으면 default반환
SUM(DECODE(deptno,20,sapay)),
SUM(DECODE(deptno,30,sapay)),
NVL(SUM(DECODE(deptno,40,sapay)),0),
SUM(DECODE(deptno,50,sapay)) FROM SAWON;

SELECT UNIQUE sajob FROM SAWON;
SELECT
TRUNC(AVG(DECODE(sajob,'부장',sapay))) AS 부평,
TRUNC(AVG(DECODE(sajob,'과장',sapay))) AS 과평,
TRUNC(AVG(DECODE(sajob,'대리',sapay))) AS 대평,
TRUNC(AVG(DECODE(sajob,'사원',sapay))) AS 사평 FROM SAWON;

SELECT sajob, SUM(sapay) FROM SAWON GROUP BY sajob;
SELECT sajob, SUM(sapay) FROM SAWON GROUP BY ROLLUP(SAjob); --ROLLUP() 그룹별 집계, 총집계

SELECT deptno, sajob, SUM(sapay) FROM SAWON GROUP BY deptno, sajob;
SELECT deptno, sajob, SUM(sapay) FROM SAWON GROUP BY ROLLUP(deptno, sajob);
SELECT deptno, sajob, SUM(sapay) FROM SAWON GROUP BY CUBE(deptno, sajob); --CUBE()그룹별 집계, 총집계

DESC DEPT;
DESC SAWON;
SELECT s.sabun, s.saname, s.deptno, s.sajob, d.dname, d.loc FROM SAWON s, DEPT d WHERE s.deptno=d.deptno; --from 절에 여러 테이블을 선언하면 카타시안 곱 형태로 join가능, column 어디 소속인지 명시(안해도 되는데 속도 차이남), 공유 column은 명시 필수
SELECT * FROM SAWON s, DEPT d WHERE s.deptno=d.deptno;

SELECT * FROM dept, SAWON; --카타시안 곱, 여기서 where절로 sawon.deptno=dept.deptno인 조건만 골라내면 위의 결과가 나오는 것, JOIN문이 실제로 내부적으로 하는 동작
SELECT s.sabun, s.saname, s.deptno, d.deptno, s.sajob, d.dname, d.loc FROM SAWON s, DEPT d WHERE s.deptno=d.deptno and s.SAJOB='부장' OR s.sajob='대리'; --where절에서 and/or사용, and와 or 섞이면 and먼저 실행 추측

SELECT dept.loc, SUM(sawon.sapay) FROM dept, SAWON WHERE dept.deptno=sawon.deptno GROUP BY dept.loc;

SELECT sawon.sabun, sawon.saname, sawon.sajob, sawon.sapay, sawonphone.pnum, sawonphone.pmodel, sawonphone.phnum, sawonphone.pdate, sawon.deptno, dept.dname FROM DEPT,SAWON,SAWONPHONE WHERE sawon.deptno=dept.deptno AND sawon.sabun=sawonphone.pnum AND sawon.deptno=10;

SELECT s.saname, s.sajob, m.saname, m.sajob FROM SAWON s, SAWON M WHERE s.samgr=m.sabun;--alias이용해서 같은 테이블 내에서 조인

SELECT gogek.goname, gogek.gotel, sawon.saname FROM GOGEK LEFT JOIN SAWON ON gogek.godam=sawon.sabun; --left outer join 테이블 붙이기(NULL도 출력). FROM 기준 테이블 LEFT JOIN 붙일 테이블 ON 조건
SELECT gogek.goname, gogek.gotel, sawon.saname FROM GOGEK, SAWON WHERE gogek.godam=sawon.sabun(+); --구 표현식

SELECT * FROM sawon, DEPT WHERE sawon.deptno=dept.deptno; --eqjoin(원래는 FROM 기준 테이블 JOIN 붙일 테이블 ON 조건)
SELECT * FROM SAWON NATURAL JOIN DEPT; --NATURAL JOIN으로 테이블만 붙이면 이름 같은 칼럼 알아서 추론해줌

SELECT S.saname, S.sajob, S.sapay, D.loc, D.deptno FROM SAWON S, DEPT D WHERE S.deptno=D.deptno AND S.SAJOB='부장' AND D.deptno=30;
