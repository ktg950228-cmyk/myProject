CREATE TABLE friend_request (
id NUMBER PRIMARY key,
requester_id VARCHAR2(150) NOT NULL,
receiver_id VARCHAR2(150) NOT null,
status VARCHAR2(20) DEFAULT 'pending',
request_date DATE DEFAULT sysdate,
CONSTRAINT fk_requester FOREIGN KEY (requester_id) REFERENCES MEMBER(userid),
CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES MEMBER(userid),
CONSTRAINT uq_friend UNIQUE (requester_id, receiver_id)
);

CREATE SEQUENCE friend_request_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE friend_request_log (
log_id NUMBER PRIMARY key,
friend_request_id NUMBER NOT null,
status VARCHAR2(20),
action_time TIMESTAMP DEFAULT SYSTIMESTAMP,
CONSTRAINT fk_log_to_request FOREIGN KEY (friend_request_id) REFERENCES FRIEND_REQUEST(id) ON DELETE CASCADE
);
COMMIT;
CREATE SEQUENCE friend_request_log_seq START WITH 1 INCREMENT BY 1;

--insert into friend_request (id, requester_id, receiver_id) values (friend_request_seq.nextval, 'qwer', 'ㅂㅈㄷㄱ');
--select * from friend_request where receiver_id = 'ㅂㅈㄷㄱ' and status = 'pending';
--UPDATE friend_request SET status = 'accepted' where id = 1;
--select m.* from friend_request f join member m on f.requester_id = m.userid where f.receiver_id = 'ㅂㅈㄷㄱ' and f.status = 'accepted' union select m.* from friend_request f join member m on f.receiver_id = m.userid where f.requester_id = 'qwer' and f.status = 'accepted';
--select * from friend_request where requester_id = 'qwer';
--select count(*) from friend_request where requester_id = 'qwer' and receiver_id = 'ㅂㅈㄷㄱ';
--update friend_request set status = 'pending', request_date = sysdate where requester_id = 'qwer' and receiver_id = 'ㅂㅈㄷㄱ';

CREATE TABLE survey (
	num NUMBER CONSTRAINT survey_num_pk PRIMARY key,
	sub VARCHAR(255),
	code NUMBER,																	--응답 개수
	sdate DATE
);
CREATE SEQUENCE survey_seq INCREMENT BY 1 START WITH 1;

CREATE TABLE surveycontent (
	subcode NUMBER(19) NOT null,
	surveycnt NUMBER(10),
	surveytitle VARCHAR(255),
	surveytype VARCHAR(255),
	CONSTRAINT surveycontent_surveycontent_FK FOREIGN KEY (subcode) REFERENCES SURVEY(num)
);

--SELECT s.num AS surveyNum, s.sub AS surveySub, s.code AS surveyCode, s.sdate AS surveyDate, sc.surveytype AS surveytype, sc.subcode AS subCode, sc.surveytitle AS surveytitle, sc.surveycnt AS surveycnt FROM SURVEY s, SURVEYCONTENT sc WHERE s.num = sc.subcode AND s.num = #{num};
--INSERT INTO (num, code, sdate, sub) VALUES (survey_seq.NEXTVAL, #{code, jdbcType=INTEGER}, SYSDATE, #{sub, jdbcType=VARCHAR});
--INSERT ALL INTO SURVEYCONTENT (subcode, surveycnt, surveytitle, surveytype) VALUES (survey_seq.CURRVAL, #{item.surveycnt}, #{item.surveytitle}, #{item.surveytype}) SELECT * FROM dual;
--UPDATE SURVEYCONTENT SET surveycnt = surveycnt + 1 WHERE subcode=#{subcode} AND surveytype=#{surveytype};