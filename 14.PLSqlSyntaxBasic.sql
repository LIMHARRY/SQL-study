--14.PLSqlSyntaxBasic.sql
/* 
1. oracle db만의 프로그래밍 개발 방법
	1.이름 없이 단순 개발
	2.프로스저라는 타이틀로 개발 -이름부여(재사용)
	3.함수라는 타이틀로 개발 -이름부여(재사용)
2. 장점
	- 단 한번의 실행 만으로 db 자체의 내장 함수와 실행 가능한 알고리즘으로 저장 및관리
	이름을 부여해서 내부에 내장시키는 구조(함수, 저장 프로시점)
	첫 실행시 -> 컴파일(db 인식 언어인 pcode라는 것으로 변경) -> pcode
	따라서 두번째 요청 부터는 단순 sql 실행보다 performance가 좋음
	
3. test를 위한 필수 셋팅 
	- set serveroutput on

4,필수 암기!!
	1.할당(대입) 연산자 :=
	2.선언,시작,끝을 의미하는 
		declare~ begin~ end;/
	3.변수?
		-프로그램 상에서 데이터를 표현할 수 있는 단위
		-김민석/26/남성: 데이터 수 3개
			방법1: 하나의 변수에 다저장!
			방법2: 개별 변수에 각각 저장(ex, 이름, 나이 등등 에 따로저장)
			~~>당연히 2번 방법이 좋다. 따라서 데이터 수 만큼 변수가 나와줘야된다.
*/

--1. 실행 결과 확인을 위한 필수 설정 명령어
set serveroutput on


--2. 연산을 통한 간단한 문법 습득
/*1. 이름없음, 
	2.코드 내부에 값 자체를 타이핑(동적 데이터 사용 안함, 즉 parameter 값이 없음)
	3.로직:
		숫자값 보유 변수 하나 선언, 나누기, 나눈 결과값을 출력
		declare
			변수이름(선언)
		begin
			나누기 로직
			결과값 출력
		end;
		/
*/
--step01
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r 출력 결과'||no);
end;
/


--step02
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r 출력'||no);
	no:=no/2;
	dbms_output.put_line('r결과'||no);
end;
/


--step03
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r 출력'||no);
	no:=no/0;
	dbms_output.put_line('r결과'||no);
	exception
		when others then
			dbms_output.put_line('exception');
	dbms_output.put_line('running?-예외가 발생되도 처리했기때문에 실행되는 기능'); 
end;
/
--참고로 others는 그렇지 않은 모든 경우를 통틀어서이다)


DECLARE -변수,상수 선언부 초기화 가능
BEGIN-실행부
EXCEPTION-예외처리부, 예외 상황에 따른 when블록 실행
END;



--?3. 연산을 통한 간단한 문법 습득 + 예외 처리 문장 
/*모든 프로그램 언어의 정서: 혹여 예외가 발생 경우, 프로그램 중지가 아닌 유연한 처리로 인한 실행 유지
예외처리= exception
(java/java script/python 등등 예외처리는 어떤 컴퓨터 언어에도 모오오옹ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ두있다)
*/



--5. 중첩 block
/*1.변수: 데이터 표현 요소, 가변적인 데이터값 가능
	2.변수의 선언 위치에 따른 사용 범위
			전역변수(멤버변수)-코드 전체에서 사용?
			로컬변수- 선언된 근접영역(local)에서만 사용?

/*
--step01
declare
	v_global varchar2(10):='global';
begin
	declare
		v_local varchar2(10):='local';
	begin
		dbms_output.put_line('g -'||v_global);
		dbms_output.put_line('l -'||v_global);
	end;
end;
/

--step02: 중첩된 내부 블록에서 선언된 로컬변수는 외부 블록에서 사용 불가
declare
	v_global varchar2(10):='global';
begin
	declare
		v_local varchar2(10):='local';
	begin
		dbms_output.put_line('g -'||v_global);
		dbms_output.put_line('l -'||v_global);
	end;

	dbms_output.put_line('2.g -'||v_global);
	dbms_output.put_line('2.l -'||v_global);
end;
/






--6. emp01 table의 컬럼을 사용해서 %type 표기법 학습
/* %type
-오라클 db의 특정 컬럼 타입을 표현하는 표기
-emp의 ename 타입? sal? hiredate? comm?? 등등 확인할 때, 명시적으로 sql문장으로 확인은 가능하나 때에 따라서 확인없이 사용해야 할 경우도 발생
-emp의 empno의 타입과 사이즈를 사용해서 새로운 pl sql 변수 선언
	v_empno emp.empno%type;*****참고로  v_는 안써도됨 구분을위해 쓰는거임
*/
drop table emp01;
create table emp01 as select * from emp;
--사번으로 사원번호, 이름, 급여 검색해서 출력
--select empno,ename,sal from emp where empno=7369

declare
	v_empno emp01.empno%type;
	v_ename emp01.ename%type;
	v_sal emp01.sal%type;
begin
	select empno,ename,sal
		into v_empno,v_ename,v_sal
	from emp01 where empno=7369;
	dbms_output.put_line(v_empno ||'  '|| v_ename || ' ' || v_sal);
end;
/


--7. 이미 존재하는 table의 record의 모든 컬럼 타입 활용 키워드: %rowtype
/*7369 사번으로 해당 사원의 모든 정보를 검색해서 사번, 이름만 착출해서 출력
declare
	v_row emp01%rowtype;
begin
	select *
		into v_row
	from emp01 where empno=7369;
	dbms_output.put_line(v_row.empno);
end;
/
*/







--8. ???
-- emp05라는 table을 데이터 없이 emp table로 부터 생성하기

-- %rowtype을 사용하셔서 emp의 사번이 7369인 사원 정보 검색해서 
-- emp05 table에 insert
-- 검색 
#-- 힌트 : begin 부분엔 다수의 sql문장 작성 가능 
drop table emp05;
create table emp05 as select * from emp where 1=0;
declare
	v_row emp05%rowtype;
begin
	select  *
		into v_row
	from emp where empno=7369;
	insert into emp05 values(v_row.empno,v_row.ename,v_row.job,v_row.mgr,v_row.hiredate,v_row.sal,v_row.comm,v_row.deptno);
end;
/
select * from emp05;

--혹은!!! 위에께 너무길면
declare
	v_row emp05%rowtype;
begin
	select  *
		into v_row
	from emp where empno=7369;
	insert into emp05 values v_row;
	commit;
end;
/
select * from emp05;


--9. 조건식
/*  1. 단일 조건식
	if(조건) then
	
	end if;
	
	2. 다중 조건
	if(조건1) then
		조건1이 true인 경우 실행되는 블록 
	elsif(조건2) then
		조건2가 true인 경우 실행되는 블록
	end if;  */
-- SMITH 사원의 연봉을 계산하는 procedure 개발[comm이 null인 직원들은 0으로 치환]
--sal*12 +comm
--조건식: comm이 null이면 0 값으로 할당
declare
	v_emp emp%rowtype;
	--연봉 데이터를 대입 받는 새로운 변수
	totalSal number(7,2);
begin
	select empno,ename,sal,comm
		into v_emp.empno, v_emp.ename, v_emp.sal,v_emp.comm
	from emp where ename='SMITH';
	if(v_emp.comm is null) then
		v_emp.comm := 0;
	end if;
	totalSal:=v_emp.sal*12 +v_emp.comm;
	dbms_output.put_line(v_emp.ename ||'   '|| totalSal);
end;
/
select sal*12+comm 
from emp 
where ename='SMITH';


--10.??? 실행시 가변적인 데이터 적용해 보기
-- plsql 블록 자체에 모든 test 데이터 반영해서 실행만(정적 데이터), 
실행시 가변적인 데이터(동적 데이터) 반영
	--가변적인 데이터 대입받는 동적 변수명은 :&표기 문법 반영

-- ps sql조건식으로 처리 
-- emp table의 deptno=10 : ACCOUNT 출력, 
-- deptno=20 이라면 RESEARCH 출력
-- test data는 각 사원의 사번


declare
	v_emp emp%rowtype;
begin
	select deptno
		into v_emp.deptno
	from emp where empno=7369;
	if(v_emp.deptno=10) then
		dbms_output.put_line('ACCOUNT');
	elsif(v_emp.deptno=20) then
		dbms_output.put_line('RESEARCH');
	end if;
end;
/


강사님 답

declare
	ck_empno number(4):= &v; --&v는 입력받는 것
	v_empno emp.empno%type;
	v_deptno emp.deptno%type;
	v_dname varchar2(10);
begin
	select empno, deptno
		into v_empno, v_deptno
	from emp
	where empno = ck_empno;
	if(v_deptno=10) then
		v_dname :='ACCOUNT';
	elsif(v_deptno=20) then
		v_dname :='RESEARCH';

	else
		v_dname:= 'NONE';
	end if;
	dbms_output.put_line(v_empno ||'의 부서명은 '|| v_dname);
end;
/


--11. 반복문
/* 
--loop,while,for 등으로 시작하여 end loop;로 끝난다.
1. 기본
loop 
	ps/sql 문장들
	exit 조건;
end loop;

2. while 기본문법
 while 조건식 loop
 	plsql 문장;
 end loop;

3. for 기본 문법
for 변수 in [reverse] start ..end loop
	plsql문장
end loop;
*/






------------------------------------- loop 예제

declare
	num number(2) := 0;
begin
	loop 
		--출력, 증가, 조건식
		dbms_output.put_line(num);
		num:=num +1;	
		exit when num >5;
	end loop;
end;
/

------------------------------------while이용 예제!
declare
	num number(2) :=0;
begin
	while num <6 loop
		dbms_output.put_line(num);
		num:=num +1;
	end loop;
end;
/


-----------------------------------사용 빈도가 가장높은 반복문 for!
-- 오름차순 출력 (때에 따라 declare가 없을수도 있다)
--for[사용 빈도 높음]: 초기값, 사용로직, 증감식, 비교식(조건식)

begin
	for v in 1..5 loop
		dbms_output.put_line(v);
	end loop;
end;
/



------------ 내림차순 출력
begin
	for i in  5..0 loop	
		dbms_output.put_line(i);
	end loop;
end;
/
--라고 생각할수있지만 이는 오류이다. reverse라는걸 써줘야한다
--따라서 답은

begin
	for i in reverse 1..5 loop	
		dbms_output.put_line(i);
	end loop;
end;
/



--12.? 사번을 입력받아서 해당하는 사원의 이름 음절 수 만큼 * (한 line)표 찍기 




declare
	ck_empno number(4):= &v;
	v_ename emp.ename%type;
	v_char varchar2(10):='*';
	
begin
	select ename
		into v_ename
	from emp
	where empno=ck_empno;
	for i in 2..length(v_ename) loop
	v_char:=v_char||'*';
	end loop;
	dbms_output.put_line(v_char);
end;
/ 










****자기주도 학습 10월 5일: 10번 문제, 2개의 plsql문제 만들기
--만들고 내 짝궁들 풀게하기(답안이 있는 파일 제출)
--수험생 관점에서 문제 두줄평(비판)
--파일명 - 제출자-누구,수험생-누구2.txt



























