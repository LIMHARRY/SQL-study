--18.PLSqlTrigger.sql

/*
필요성
	-혹여 사이트에 회원가입을 할 때, 회원정보는 반드시 실시간 사용 가능한 DB에 저장한다.
	-탈퇴
		-개인(user): 그 사이트 사용 안 함
		-사이트: 그냥 삭제? ㄴㄴ
			탈퇴한 자의 정보를 어딘가에 back up?
	-기술적 처리 로직
		경우의 수 1: back up table에 insert를 하고, 고객 테이블에 delete문장을 한다.
				즉 2개의 문장을 따로따로 명시적으로 실행한다.
		경우의 수 2: delete 요청시 db 내부적으로 back up 테이블에 
				자동 insert 할 수 있는 설정을 미리 등록해놓고 
				delete문만 명시적으로 실행

1. 트리거란?
	- PLSQL 블록으로 오라클에서 특정 이벤트 발생시 연관된 다른 작업이 자동 수행
	가령 입고 table에 상품입고시 재고 table에 자동으로 재고 증가
2. trigger 구조[문법]
	1. 구성 
	  실행되는 시점(timing) 
	  실행시키는 사건(event) 
	  trigger가 영향받는 table/view../trigger 
	  body

	2. 문법
		create [or replace] tirgger trigger_name
		timing
			event 1[ or event2 or ...]
		on 
			table_name or view_name
		[referencing old or new]
		[for each row]
			trigger body
	3. 부여설명
		- timing : trigger가 실행되는 시점 지정을 event 발생 전과 후 의미
				- before
				- after

3. trigger 유형
	- DML trigger
		1. 문장 trigger
			-컬럼의 각 데이터 행 제어 불가
			-즉 컬럼의 데이터 값이 무엇이냐가 아니라 컬럼 자체에 변화가 일어남을 감지하여 실행
			-1번은 table 자체에 시간을 매핑해서 제어했던 예제
									
		2. 행 trigger
			- 특정 데이터로 인해 영향받는 행에 한해서만 trigger실행
			- for each row
			- 예: 기존 row값을 새로운 table의 row로 이관 작업시에도 설정
				-:OLD/ :NEW 이런 문구 사용시 반드시 추가 설정
				-문장 레벨 단위의 설정에서는 사용 불가
			- 데이터 구조
				1. OLD : trigger가 처리한 레코드의 원래 값을 저장
				2. NEW : 새값 포함  */

--1. trigger 생성 변경 삭제 권한 부여
connect system/manager
grant create trigger to SCOTT;
grant alter any trigger to SCOTT;
grant drop any trigger to SCOTT;

conn SCOTT/TIGER
--1. 정해진 시간에만 입력한 경우만 입력 허용, 그 외 오류 발생
drop table order_table;
create table order_table(
	no number,
	ord_code varchar2(10),
	ord_date date
);

-- 문장 레벨 trigger
/*
1. 오전 10~12시 저장시 insert 허용 
	-10:00 12:00
	-시간을 HH:MI
	-sysdate -> 가공(to_char(sysdate,'HH24:MI')) ->10:00
2. 오전 10~11시 저장시 insert 허용
	기능: 정해진 시간만 insert 되는 로직
	DB엔진: insert 하고 시간검증? or insert 전에 시간검증?
		-이 설정은 개발자
*/
create or replace trigger timeorder
before insert
on
	order_table
begin
	--10~12시가 아닌 경우 if 로직에서 에러 메세지 발생
	if (to_char(sysdate,'HH24:MI') not between '10:00' and '11:00') then
		--오라클 자체 error처럼 no설정 및 메세지 등록
		RAISE_APPLICATION_ERROR(-20100,'허용시간 아님');
	end if;
end;
/



-- test 문장
insert into order_table values(1, 'c001', sysdate);
select * from order_table;
drop trigger timeorder;


--2. ord_code 컬럼에 'c001' 제품 번호가 입력될 경우를 제외한 다른 데이터 입력시 에러 발생하는 trigger 
-- 행 레벨 trigger : for each row	
-- insert되는 row에 한해서 검증을 하고 저장? 저장불가? 선택 처리하는 기능
-- for each row 키워드 활용
-- insert 하려는 새로운 데이터 표현 - :NEW.ord_code
	--ord_code 컬럼에 c001이 아니면 insert 불가
	--?일반 user가 ord_code값을 어떤 데이터를 넣으려 할까요?
drop trigger datafilterorder;


create or replace trigger datafilterorder
before insert
on
	order_table
for each row
begin
	if(:NEW.ord_code) not in ('c001') then
		raise_application_error(-20300,'제품코드가 달라서 불가');
	end if;
end;
/


step02: for each row 생략시 오류 발생
--데이터 검증시에는 for each row
/*--error
drop trigger datafilterorder;


create or replace trigger datafilterorder
before insert
on
	order_table
for each row
begin
	if(:NEW.ord_code) not in ('c001') then
		raise_application_error(-20300,'제품코드가 달라서 불가');
	end if;
end;
/
*/


-- test 문장
insert into order_table values(1, 'c001', sysdate);
insert into order_table values(2, 'c002', sysdate);
select * from order_table;


--3. 기존 table의 데이터가 업데이트 될 경우 다른 백업 table로 기존 데이터를 이관시키는 로직
--원본 table : order_table
--백업 table : backup_order
drop table backup_order;
create table backup_order(
	no number,
	ord_code varchar2(10),
	ord_date date
);



select * order_table;

drop trigger backup_order;

--order_table에 update가 발생이 되면 자동으로 backup_order에 insert
/*
필요한 구성요소
1.트리거 이름
2.trigger에 필요한 sql 문장:insert
	insert into backup_order values() 
3.insert하게 되는 데이터는 order_table에 이미 존재했던, 단 update로 인해 수정되는 데이터
(수정 직전 데이터)
	for each row
4.update가 정상 실행되면 insert? after
	update 전에 insert? before
*/
create or replace trigger backtrigger
before update
on order_table
for each row
begin
	insert into backup_order values(:old.no, :old.ord_code, :old.ord_date);
end;
/



-- test 문장
select * from backup_order;
select * from order_table;
update order_table set ord_code='c002' where no=1;
select * from backup_order;
select * from order_table;
/*
? 다수의 row 데이터를 수정
이 경우 update 발생시
1.back up table에는 update 된 다수의 row 수 만큼 insert?
	-update되는 수: trigger 호출 수=1:1
	-정답
		해결책: for each row가 있어야 row 수만큼 trigger 수 호출
2." "				단 하나의 row만 insert? 삑 오류
	-update되는 수: trigger 호출 수=*:1

*/


--4. 기존 table의 데이터가 delete 될때 기존  내용을 backup table로 이동
--원본 table : order_table2
--백업 table : backup_order2
drop table backup_order2;
drop table order_table2;

create table order_table2(
	no number,
	ord_code varchar2(10)
);

create table backup_order2(
	no number,
	ord_code varchar2(10),
	time date
);

insert into order_table2 values(1, 'c001');
select * from order_table2;
select * from backup_order2;

/*
1.필요한 SQL: insert
	insert into backup_order2 values(:old.no, :old.ord_code, sysdate);
2.insert 하는 시점: 정상 삭제 후
	after insert
*/
create table order_table2(
	no number,
	ord_code varchar2(10)
);
drop trigger delete_backup;

create or replace trigger delete_backup
after delete
on order_table2
for each row
begin
   insert into backup_order2 values(:old.no, :old.ord_code, sysdate);
end;
/


-- test 문장
select * from order_table2;
select * from backup_order2;
delete from order_table2 where no=1;
select * from order_table2;
select * from backup_order2;

