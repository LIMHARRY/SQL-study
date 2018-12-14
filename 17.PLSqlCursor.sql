--17.PLSqlCursor.sql
/*
 
1. 용도
	- 여러 개의 행을 처리하고자 할때 주로 사용
	- 참고
		:컴퓨터의 마우스 포인터를 커서
		:db의 커서도 무언가를 참조
			pl sql의 커서는 select 한 결과값을 보유하고 있는 내부 검색 데이터를 참조하는 것.
2. 문법
	1. 선언
		커서라는 키워드, 사용하고자 하는 커서명(사용자정의)
	2. open
		이미 존재하는 커서를 사용하겠다는 선언
	3. fetch
		: 명시적 커서의 데이터들로 부터 데이터를 한 건씩 읽어 변수로 할당하기 위해 fetch 사용
		반복문과 함께 주로 사용
		(loop/while/for[사용 빈도 높다])
	4. close
		:커서의 자원반환, 생략 불가
		:모든 언어가 동일함
3. 반복 
	- 기본적으론 선언, 오픈, fetch, close이나 반복문과 함께 사용되는 명시적 커서는 open, 레코드값 할당, close 는 오라클이 자동 수행
	for 레코드이름 IN 커서이름 loop
		-- 명시적 커서와 오픈이 자동수행됨
		statement1;
		statement2;
	end loop;  -- end loop시에 커서가 자동으로 close됨




*/
--1. cursor의 기본 문법 습득을 위한 emp table의 사번, 이름 검색
declare
	v_empno emp.empno%type;
	v_ename emp.ename%type;	
	-- 1. 커서 선언 : select한 결과값을 emp_kut로 사용겠다는 선언
	cursor 
		emp_kut
	is 
		select empno, ename from emp; 	
begin
	-- 2. 커서 활용을 위한 오픈 선언
	open emp_kut;	
	loop 
		--3. 커서 사용 시작
		fetch emp_kut into v_empno, v_ename;
		exit when emp_kut%NOTFOUND;		
		dbms_output.put_line(v_empno || ' ' || v_ename);		
	end loop;	
	--4. 커서 사용 종료
	close emp_kut;	
end;
/

--2.? dept의 모든 지역정보를 검색[cursor 기능 부여]
	-- dept_cursor
declare
	v_loc dept.loc%type;
	cursor dept_cursor
	is
		select loc from dept;
begin
	open dept_cursor;
	loop
		fetch dept_cursor
			into v_loc;
		exit when dept_cursor%NOTFOUND;

		dbms_output.put_line(v_loc ||'----'|| dept_cursor%rowcount);
	end loop;
	close dept_cursor;
end;
/
--?2번추가문제~~~~  for 문장으로 변환해보자!

declare
	cursor dept_cursor
	is
		select loc from dept;
begin
	for dept_data in dept_cursor  loop
		dbms_output.put_line(dept_data.loc);
	end loop;
end;
/



--cursor for
--3. 1번 로직과 동일 단 cursor for 문 사용 오픈, fetch, close, 변수 선언 생략

/*
파이썬과 흡사
-가령 파일로 부터 데이터를 read할 경우
파일 오픈 -> 사용 -> 자원반환(close)
함축해서 with로 일괄처리 가능 
*/
declare
	cursor emp_cursor
	is
		select empno, ename from emp;
begin
	for emp_data in emp_cursor loop
		dbms_output.put_line(emp_data.empno||' '|| emp_data.ename);
	end loop;
end;
/



--4.? 부서 번호에 해당하는 사번, 사원명 검색
--procedure emp_info로 만들어보셔라

declare
	v_empno emp.empno%type;
	v_ename emp.ename%type;	
	cursor 
		emp_info
	is 
		select empno, ename from emp; 	
begin
	open emp_info;	
	loop 
		fetch emp_info into v_empno, v_ename;
		exit when emp_info%NOTFOUND;		
		dbms_output.put_line(v_empno || ' ' || v_ename);		
	end loop;	
	close emp_info;	
end;
/



--5.부서 번호에 해당하는 사번, 사원명 검색
	-- 미존재하는 부서 번호로 검색시 '없다'
	-- 존재하는 부서 번호로 검색시 검색된 직원수 출력 
	-- emp_info
/*
1.필요한 변수
	1.실행시 부서 번호 받을 변수
	2.검색된 사번, 사원명 대입받을 변수
	3.직원수 counting 하기위한 변수
--실행을 위한 test
exec emp_info(10);
exec emp_info(20);
exec emp_info(30);
exec emp_info(40);
*/


declare
	ck_deptno number(4):= &v;
	cursor
		emp_info
	is
		select empno, ename from emp where deptno=ck_deptno;
	emp_data emp_info%type;
begin
	if(ck_deptno in deptno) then
		dbms_output.put_line(count(emp_data.ename));
	else
		dbms_output.put_line('없다');
end;
/
--이 위의 코드는 내가 허접이라 안됨 ㅇㅇ 밑에께 강사님 정답
--부서 번호에 해당하는 사번, 사원명 검색
create or replace procedure emp_info(v_deptno emp.deptno%type)
is
	cursor emp_cursor
	is
		select empno, ename from emp where deptno=v_deptno;
	v_empno emp.empno%type;
	v_ename emp.ename%type;
	v_count number:=0;
begin
	open emp_cursor;
		loop
			fetch
				emp_cursor
					into v_empno, v_ename;
				exit when emp_cursor%notfound;
				dbms_output.put_line(v_empno || '   ' || v_ename);
				v_count:=v_count+1;
		end loop;
	close emp_cursor;
	dbms_output.put_line('----------------------');
	if v_count!=0 then
		dbms_output.put_line('z검색된 직원수'|| v_count);
	else
		dbms_output.put_line('z없다');
	end if;
	dbms_output.put_line('----------------------');
end;
/




--6.rowtype을 사용을 위한 simple
-- 기본적으론 선언, 오픈, fetch, close이나 반복문가 함께 사용되는 명시적 커서는 open, 레코드값 할당, close 는 오라클이 자동 수행
--select empno, ename from emp;
--필수 전제조건: (rowtype/for~ 문) 사용

declare
	v_emp emp%rowtype;
	cursor emp_cursor
	is
	select empno, ename from emp;
begin
	for v_emp in emp_cursor loop
	dbms_output.put_line(v_emp.empno ||'   '|| v_emp.ename);
	end loop;
end;
/


















