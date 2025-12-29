CREATE TABLE MEMBER(
 mnum NUMBER NOT NULL CONSTRAINT MEMBER_num_pk PRIMARY key,--num값을 고유값으로 부여하기 위해 pk로 지정
 --(만약 name이 같을 경우 pk로 되어있는 num으로 구별할 수 있기 때문에 부여)
 mname VARCHAR2(50) NOT null,--회원의 id
 mid VARCHAR2(50) NOT null, -- 회원의 email
 PASSWORD VARCHAR2(30) NOT null, -- 회원의 password
 email VARCHAR2(30) NOT null,-- 회원의 이름
 mdate DATE DEFAULT SYSDATE, -- 최신 시간을 받아올 date 지정
 CONSTRAINT member_id_UQ UNIQUE(mid) --회원의 id값이 동일하면 안되니 unique로 지정
 );

CREATE SEQUENCE MEMBER_num_seq
INCREMENT BY 1
START WITH 1;--각 행의 고유한 번호를 주기 위해 시퀀스 생성

CREATE TABLE board(	--게시글 정보 저장할 테이블
bnum NUMBER NOT null PRIMARY KEY,
mnum NUMBER NOT NULL,						--게시글 작성자 번호(FOREIGN KEY)
category VARCHAR2(10) NOT NULL, --free,info,Prom
title VARCHAR2(50) NOT NULL,
writer VARCHAR2(10) NOT NULL,
udate TIMESTAMP NOT NULL,
image VARCHAR2(50),							--이미지 이름(문자열)
CONTENT VARCHAR2(600) NOT NULL,
CONSTRAINT board_mnum_FK FOREIGN KEY(mnum) REFERENCES MEMBER(mnum)	--'게시글 작성자'칼럼은 MEMBER 테이블의 유저 코드를 참조해야한다는 제약 부여
);

CREATE SEQUENCE board_num_pk START WITH 1 INCREMENT BY 1;


CREATE TABLE board_comments(	--댓글 정보 저장할 테이블
bcnum NUMBER NOT NULL PRIMARY KEY,
bnum NUMBER NOT NULL,					--'어느 게시글'의 댓글인지 코드를 저장할 칼럼
writer VARCHAR2(10) NOT NULL,
udate TIMESTAMP NOT NULL ,
comment_text VARCHAR2(180) NOT NULL,
parent NUMBER,								--추후 삭제예정
CONSTRAINT board_comments_board_num_fk FOREIGN KEY (bnum) REFERENCES BOARD(bnum),
CONSTRAINT board_comments_parent_fk FOREIGN KEY (parent) REFERENCES board_comments(bcnum)	--추후 삭제예정2
);

CREATE SEQUENCE board_comments_num_pk START WITH 1 INCREMENT BY 1;

CREATE TABLE lost( -- lost 분실물 게시판의 데이터 DB에 저장해놓은 용도의 테이블
 lnum NUMBER NOT NULL CONSTRAINT lost_num_pk PRIMARY KEY,-- 데이터 고유 번호. 순서대로 증가하기 때문에 sequence 이용
 mnum NUMBER,-- 멤버 테이블의 번호와 foreign key로 연결해서 회원 식별
 title VARCHAR2(150) NOT NULL, -- 제목
 category VARCHAR2(10) NOT NULL, --lost,found
 CONTENTS CLOB,
 writer VARCHAR2(50),
 reip VARCHAR2(100),
 itemcategory VARCHAR2(200), -- EX) 전자기기,가방,의류,기타... drop down 메뉴로 분실물 종류 선택 가능(추후)
 losttime DATE, -- 분실한 시간
 lostloc VARCHAR2(255), --EX) 본관,체육관,기숙사... -- 분실 장소
 ldate DATE,-- 게시글 작성 시간
CONSTRAINT lost_code_fk FOREIGN KEY(mnum) REFERENCES MEMBER(mnum)
);

CREATE SEQUENCE lost_seq INCREMENT BY 1 START WITH 1;

CREATE TABLE lost_comments(
 lcnum NUMBER NOT null PRIMARY key,  -- 고유 sequence로 추후 value 값 등록
 lnum NUMBER, -- 게시글 번호와 forein key로 연결해서 게시글 식별
 writer VARCHAR2(34) NOT NULL,
 content VARCHAR2(400) NOT null,
 lcdate DATE DEFAULT SYSDATE,
 CONSTRAINT lost_comments_lcode_fk FOREIGN KEY(lnum) REFERENCES lost(lnum)
);

CREATE SEQUENCE lost_comm_seq INCREMENT BY 1 START WITH 1;
-- lost 에  다중 이미지를 저장할 테이블
-- 1:n의 관계이므로 lost() foreignkey()
CREATE TABLE lostimgs(
    lostimgsid NUMBER,
    imgname VARCHAR2(255) NOT NULL, --이미지들의 이름 저장
    CONSTRAINT lostimgsid_fk FOREIGN KEY(lostimgsid) REFERENCES LOST(lnum) ON DELETE CASCADE
);

CREATE TABLE friend_req(
frid NUMBER NOT null PRIMARY key, --친구신청을 할때 신청을 한 회원의 id값을 받기 위해 pk지정
req_id VARCHAR2(50) NOT null,--친구신청이 온 다른회원에게 보여질 id
receiver_id VARCHAR2(50) NOT null, -- 친구신청을 할 id값
status VARCHAR2(20) DEFAULT 'pending',--친구신청이 온 상태값을 유지하기위해 pending을씀
frdate DATE DEFAULT sysdate, --최신 시간을 받아올 date
CONSTRAINT requester_fk FOREIGN KEY (req_id) REFERENCES MEMBER(mid),--member의 userid를 참조해 req_id를 지정함 --req_id의 값이 userid의 값으로 받아야 하기 때문
CONSTRAINT receiver_fk FOREIGN KEY (receiver_id) REFERENCES MEMBER(mid),--member의 userid를 참조해 req_id를 지정함 --req_id의 값이 userid의 값으로 받아야 하기 때문
CONSTRAINT friend_uq UNIQUE (req_id,receiver_id)
);
CREATE SEQUENCE friend_req_seq START WITH 1 INCREMENT BY 1; --각 행의 고유한 번호를 주기 위해 시퀀스 생성

-- 친구목록 조회
CREATE TABLE friend_req_log (
log_id NUMBER NOT NULL PRIMARY KEY, -- 나의 친구목록 id를 pk로 지정
friend_req_id NUMBER NOT null,--나의 친구목록에 요청이온 id
status VARCHAR2(20),-- 상태값 반영 (승인,거절..)
action_time TIMESTAMP DEFAULT SYSTIMESTAMP,--정확한 시간을 정밀하게 표현하기 위해 지정
CONSTRAINT log_to_request_fk FOREIGN KEY (friend_req_id) REFERENCES friend_req(frid) ON DELETE CASCADE--부모 테이블의 데이터가 삭제될 때
-- 그 부모를 참조하는 자식 테이블의 연관된 데이터도 삭제되도록 설정
);

CREATE SEQUENCE friend_req_log_seq INCREMENT BY 1 START WITH 1;--각 행의 고유한 번호를 주기 위해 시퀀스 생성

