--16.PLSqlFunction.sql
/*
1. 저장 함수
	- 오라클 사용자 정의 함수 
	- 오라클 함수 종류
		- 지원함수(count(), avg(),.....) + 사용자 정의 함수
2. 주의사항
	- 절대 기존 함수명들과 중복 불가
3. 프로시저와 다른 문법
	- 리턴 타입 선언 + 리턴 값
*/
--1. emp table의 사번으로 사원 이름(이게 리턴값, 이름의 타입이 리턴 타입이 된다. 왜냐면 사번으로 -> 사원이름 검색하는거라서) 검색 로직 함수 



create function userFun45(no number)
return varchar2
is
v_ename emp.ename%type;
begin
	select ename
		into v_ename
	from emp where empno=no;
	return v_ename;
end;
/

-- 검색 문법
select userFun1(7369) from emp; --이렇게 하면 12명이나오니까(논리적 오류)
select userFun1(7369) from dual; --이게 낫다




--2.? %type 사용해서 사원명으로 해당 사원의 직무(job) 반환하는 함수 
-- 함수명 : emp_job

create or replace function jobjob1(ha varchar2)
return varhchar2
is
v_job emp.job%type;
begin
	select job
		into v_job
	from emp where ename=ha; 
	return v_job;
end;
/
select jobjob1('SMITH') from dual;

--3.? 특별 보너스를 지급하기 위한 저장 함수
	-- 급여를 200% 인상해서 지급(sal*2)
-- 함수명 : cal_bonus

create or replace function cal_bonus(v_empno emp.empno%type)
return emp.sal%type
is
	v_bonus emp.sal%type;
begin
	select sal*2
		into v_bonus
	from emp
	where empno = v_empno;
	return v_bonus;
end;
/





-- 4.? 부서 번호를 입력 받아 최고 급여액을 반환하는 함수
-- 함수명 : s_max_sal
drop function  s_max_sal;
create or replace function s_max_sal(no number)
return number
is
v_sal emp.sal%type;
begin
	select max(sal)
		into v_sal
	from emp where deptno=no;
	return v_sal;
end;
/
select s_max_sal(10) from dual;




--6. ? 부서 번호를 입력 받아 부서별 평균 급여를 구해주는 함수
-- 함수명 : avg_sal

create or replace function avg_sal( )
return number
is
	avg_sal number;
begin
	select rount(avg(sal),2)
		into avg_sal
	from emp
	where deptno=s_septno;
return avg_sal;
end;
/
select distinct deptno,avg_sal(deptno) from emp;
select avg_sal(10) from dual;




-- 함수 내용 검색
desc user_source;
select text from user_source where type='FUNCTION';





--7. dept table은 pk (deptno)설정되어 있음, dept에 새로운 데이터 저장 함수
/*고려사항
1. 정상 insert
	-pk rule에 벗어나지 않았을 때 저장
2.비정상 insert 로 인한 예외 발생 가능
	-이미 존재하는 deptno값 저장 시도
		경우의 수 1: 에러 발생은 그냥 둠
		경우의 수 2: 에러 처리
				경우의 수1:혹여 입력된 데이터에 +1 등의 가공?
				경우의 스2:경고 메세지 제공?
*/


create or replace procedure insert_dept3(
	v_deptno dept.deptno%type,
	v_dname dept.dname%type,
	v_loc dept.loc%type
)
is
begin
	insert into dept values(v_deptno, v_dname, v_loc);
	
	exception
		when dup_val_on_index then
			insert into dept values(v_deptno+1,
			v_dname, v_loc);
end;
/

exec insert_dept3(77,'a','a');
exec insert_dept3(77,'a','a');

--8. procedure 또는 function에 문제 발생시 show error로 메세지 출력하기





















