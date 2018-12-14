--15.PLSqlProcedure.sql

/*
1.저장 프로시저
	-이름을 부여해서 필요한 시점에 재사용 가능한 plsql
	-DB에 사용자 정의 기능을 등록 -> 필요한 시점에 사용
2.문법
	2-1. 생성만
		-이미 동일한 이름의 procedure가 존재할 경우 error 발생	
	2-2 생성 및 치환
		-
		-

	-저장 함수와의 차이점
		1.선언구가 다름
		2.저장 함수인 경우, 반환 타입 및 반환 값 표현 문법이 있음
		avg(sal)-> input -> output
*/

--1. procedure 정보 확인 sql문장
desc user_source;
select * from user_source;

--2. 실습을 위한 test table
drop table dept01;
create table dept01 as select * from dept;
drop table emp01;
create table emp01 as select * from emp;

--3. emp01의 부서 번호가 20인 모든 사원의 job을 STUDENT로 변경하는 프로시저 생성
--에러 발생시
show error
select job, deptno from emp01;

--없으면 새로 생성, 이미 존재할 경우 새로 치환
--db실행할 경우 이런 기능이 있다는 등록일 뿐, 실행을 위해서는 excute명령어로 호출 필수!

create or replace procedure update_20
begin
	update emp01 set job='STUDENT' where deptno=20;
end;
/

select job, deptno from emp01;
select * from user_source;

--프로시저 명으로 호출로 인한 실제 실행 
--호출 전과 호출 후 값을 비교해야한다
select job,deptno from emp01;
execute update_20;
select job, deptno from emp01;


--4. 이미 동일한 이름의 procedure가 존재할 경우 replace
똑같으니까생략


--5. 가변적인 사번(동적)으로 실행시마다 해당 사원의 급여에 +500 하는 프로시저 생성하기
--14장에서 이름이 없는 plsql에서 동적 변수 표현: &변수
select empno, sal from emp01 where empno=7369;

create or replace procedure sal_update(v_empno emp01, empno%type)
is
begin
	update emp01 set sal = sal + 500 where empno=v_empno;
end;
/
select empno, sal from emp01 where empno=7369;
exec sal_update(7369);
select empno,sal from emp01 where empno=7369;
execute sal_update(7369);
select empno, sal from emp01 where empno=7369;


--6.? 사번, 급여를 입력받아서 해당 직원의 희망급여를 변경하는 프로시저 
--update_sal이용

create or replace procedure update_sal(v_empno emp01.empno%type,v_sal emp01.sal%type)
is
begin
	update emp01 set sal=v_sal where empno=v_empno;
end;
/
select empno, sal from emp01 where empno=7369;
execute update(7369,2000);
select empno,sal from emp01 where empno=7369;

select empno, sal from emp01 where empno=7369;
exec update_sal(7369, 2000);
select empno, sal from emp01 where empno=7369;
execute update_sal(7369, 4000);
select empno, sal from emp01 where empno=7369;


--7. 사번으로 이름과 급여 검색하기
	-- 사번: input data/ 이름, 급여: 프로시저 실행 후에 변수에 데이터 대입해서 사용 할 수 있는
		상황이 됨
	-- inout 모드
	-- parameter로 procedure내에서 사용하면서 소진할 데이터 표현 : IN
	-- procedure내에서 검색등으로 결과값을 반환하고자 하는 데이터 표현 : OUT
		
create or replace procedure info_empinfo(v_empno IN emp01.empno%type,
	v_ename OUT emp01.ename%type,
	v_sal OUT emp01.sal%type)
is
begin
	select ename,sal
		into v_ename, v_sal
	from emp where empno=v_empno;
end;
/

-- 프로시저의 out 모드로 데이터값 획득할 변수 선언
variable vename varchar2(20);
variable vsal number;


-- 프로시저 실행 : out 모드의 데이터값들 바인딩되는 동적 변수에 할당
execute info_empinfo(7369, :vename, :vsal);


-- 동적 변수값 출력 
print vename;
print vsal;

 --? 개인이 in out 모든 review문제를 만들고 답안을 도출하여라
--제약조건은 dept01 table활용하기




--8. 이미 저장된 프로시저를 활용하는 새로운 프로시저

declare
	v_name emp.ename%type;
	v_sal emp.sal%type;
begin
	info_empinfo(7369,v_name,v_sal);
	dbms_output.put_line(v_name || ' ' || v_sal);
end;
/

--위의 경우 info_empinfo는 이미 만들어진 프로시저이다.(이미만들어진거 활용하는 예)




부서번호를 이용해서 부서이름과 지역 검색하기


create or replace procedure letsgo(v_deptno IN dept01.deptno%type,
				v_dname OUT dept01.dname%type,
				v_loc OUT dept01.loc%type)
is
begin
	select dname,loc
		into v_dname, v_loc
	from dept where deptno=v_deptno;
end;
/
variable vdname varchar2(20);
variable vloc varchar2(20);
execute letsgo(10, :vdname, :vloc);
print vdname;
print vloc;

















