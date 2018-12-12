--12.sequence.sql
/*
1. 시퀀스 
	: 순차적인 순법을 자동으로 반영할수 있는 매우 유용한 기술 
	: 기본은 1씩 자동 증가
		- 증가치, 최대값 추가 설정도 가능
		- 권장 : 하나의 시퀀스를 다수의 table에서 사용 비추
	: 개념, 필요성, 문법(create, drop, nextval, currval)

2. 대표적인 활용 영역
	- 게시물 글번호에 주로 사용

3. 특징
	- 절대 중복 불가 
 
 참고 : 질문
	몇천건의 게시글 존재
	500번은 작성후 삭제
	각 게시글의 게시번호는 재정렬 가급적 안함
	왜? 재정렬을 위한 내부 자원들을 절약,
		데이터 수들이 매우 많아짐에 따른 리소스 절약중 하나
*/

--1. sequence 생성 명령어
drop table seq_test;
-- 시퀀스 생성 문장
create sequence seq_test_seq;


--2. seq~를 활용한 insert
	-- 기본적으로 생성한 경우 1씩 자동 증가
create table seq_test(
	no1 number(2),
	no2 number(2)
);

insert into seq_test values(seq_test_seq.nextval, 1);
insert into seq_test values(seq_test_seq.nextval, 2);
insert into seq_test values(seq_test_seq.nextval, 3);
select * from seq_test;
	
--sequence값 검색
select seq_test_seq.currval from dual;











--3. 다수의 table에서 하나의 seq를 공동 사용시?
create table seq_test2(
	no1 number(2),
	no2 number(2)
);
insert into seq_test2 values(seq_test_seq.nextval, 1);
insert into seq_test2 values(seq_test_seq.nextval, 2);

insert into seq_test values(seq_test_seq.nextval, 1);

select * from seq_test;
select * from seq_test2;

--4. 시작index 지정 및 증가치도 지정하는 seq 생성 명령어
drop sequence seq_test_seq;

create sequence seq2_test
start with 5
increment by 2
maxvalue 20;


delete from seq_test;
delete from seq_test2;
commit;
insert into seq_test values(seq2_test.nextval, 1);
insert into seq_test values(seq2_test.nextval, 2);
insert into seq_test values(seq2_test.nextval, 2);
select * from seq_test;

--5. seq 삭제 명령어


--6. 현 sequence의 데이터값 검색하기
create sequence seq2_test start with 1 increment by 2 maxvalue 10;


