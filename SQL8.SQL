SELECT * FROM SAWON WHERE sapay > (SELECT sapay FROM SAWON WHERE saname='이순신'); --서브쿼리. 이순신보다 더 잘버는 사원들 데이터
-- 이순신대신 무궁화는 두명이라 에러뜸 = 이순신 서브쿼리는 단일 행, 무궁화는 다중 행 서브쿼리
-- 단일행 연산자 =>, =, !=, <= ..., 다중행 연산자 In, >all, ...

SELECT * FROM SAWON WHERE sapay IN(SELECT sapay FROM SAWON WHERE saname='무궁화'); --무궁화1이나 무궁화2랑 월급 같은사람 다 나옴

SELECT * FROM SAWON WHERE sabun NOT IN(SELECT samgr FROM SAWON WHERE samgr IS NOT null);	--자기가 '매니저로 할당 안된' '사원'전부 출력

SELECT saname, sapay FROM SAWON WHERE sapay > (SELECT MAX(sapay) FROM SAWON WHERE deptno=20); --1답

SELECT sabun, saname, sahire, sapay FROM SAWON WHERE deptno IN(select deptno FROM SAWON WHERE saname LIKE '강%');--2답

SELECT s.saname, s.deptno, d.dname, d.loc FROM SAWON s, DEPT d WHERE s.deptno=d.deptno AND s.deptno IN(select deptno FROM dept WHERE loc='가산'); --3답

SELECT s.saname, d.deptno, s.sapay, d.dname, d.loc FROM SAWON s, (SELECT deptno, dname, loc FROM DEPT WHERE dname IN('총무부','개발부')) d WHERE s.deptno=d.deptno AND d.dname IN('총무부','개발부');
--from절 뒤에 서브쿼리 = 인라인 뷰

SELECT v.saname, v.sapay, v.순위 FROM (SELECT saname, sapay, DENSE_RANK() OVER(order BY sapay desc) "순위" FROM SAWON) v WHERE v.순위 <= 5;

SELECT Saname, (SELECT MAX(sapay) FROM SAWON WHERE sajob='부장') FROM SAWON WHERE sajob='부장'; --column에도 서브쿼리

SELECT sajob, SUM(sapay) FROM SAWON GROUP BY sajob HAVING SUM(sapay) > (SELECT SUM(sapay) FROM SAWON WHERE sajob='부장'); --having에도 서브쿼리, ★★★where는 row필터링이고 having은 group필터링

EXPLAIN PLAN FOR SELECT * FROM SAWON WHERE sapay > all(SELECT sapay FROM SAWON WHERE deptno=30); --EXPLAIN 내부 동작 설명 테이블 생성

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY()); --설명 테이블 보기

SELECT MAX(avg_salary) FROM (SELECT deptno, AVG(NVL(sapay,0)) AS avg_salary FROM SAWON WHERE sajob='과장' GROUP BY deptno) tmp; --서브쿼리에서 등록한 alias를 외부쿼리에서도 쓸 수 있음

SELECT sabun, saname, deptno, sapay, rn FROM (SELECT sabun, saname, deptno, sapay, ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sapay desc) AS rn FROM SAWON ORDER BY deptno) info; --ROW_NUMBER()데이터 일련 번호(rank,dense_rank는 동점이면 같은 등수인데 이건 고유번호 부여)

SELECT * FROM SAWON WHERE sapay > all(SELECT sapay FROM SAWON WHERE deptno=30);	--그냥 select max(sapay)보다 큰지 비교해도되지만 다중쿼리 연산자 ALL,EXISTS 사용법 알아두기
SELECT * FROM SAWON WHERE EXISTS(SELECT * FROM DEPT WHERE deptno=80);						--where조건에 false가 와있으니 sawon테이블의 데이터중 남는것 없음

SELECT * FROM SAWON WHERE sapay > ANY(SELECT sapay FROM SAWON WHERE deptno=30); --말그대로 ANY = 최종적으로 MIN보다 크기만하면 ok

COMMIT;
