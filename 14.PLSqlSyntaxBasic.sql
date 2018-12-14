--14.PLSqlSyntaxBasic.sql
/* 
1. oracle db���� ���α׷��� ���� ���
	1.�̸� ���� �ܼ� ����
	2.���ν������ Ÿ��Ʋ�� ���� -�̸��ο�(����)
	3.�Լ���� Ÿ��Ʋ�� ���� -�̸��ο�(����)
2. ����
	- �� �ѹ��� ���� ������ db ��ü�� ���� �Լ��� ���� ������ �˰������� ���� �װ���
	�̸��� �ο��ؼ� ���ο� �����Ű�� ����(�Լ�, ���� ���ν���)
	ù ����� -> ������(db �ν� ����� pcode��� ������ ����) -> pcode
	���� �ι�° ��û ���ʹ� �ܼ� sql ���ຸ�� performance�� ����
	
3. test�� ���� �ʼ� ���� 
	- set serveroutput on

4,�ʼ� �ϱ�!!
	1.�Ҵ�(����) ������ :=
	2.����,����,���� �ǹ��ϴ� 
		declare~ begin~ end;/
	3.����?
		-���α׷� �󿡼� �����͸� ǥ���� �� �ִ� ����
		-��μ�/26/����: ������ �� 3��
			���1: �ϳ��� ������ ������!
			���2: ���� ������ ���� ����(ex, �̸�, ���� ��� �� ��������)
			~~>�翬�� 2�� ����� ����. ���� ������ �� ��ŭ ������ ������ߵȴ�.
*/

--1. ���� ��� Ȯ���� ���� �ʼ� ���� ��ɾ�
set serveroutput on


--2. ������ ���� ������ ���� ����
/*1. �̸�����, 
	2.�ڵ� ���ο� �� ��ü�� Ÿ����(���� ������ ��� ����, �� parameter ���� ����)
	3.����:
		���ڰ� ���� ���� �ϳ� ����, ������, ���� ������� ���
		declare
			�����̸�(����)
		begin
			������ ����
			����� ���
		end;
		/
*/
--step01
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r ��� ���'||no);
end;
/


--step02
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r ���'||no);
	no:=no/2;
	dbms_output.put_line('r���'||no);
end;
/


--step03
declare
	no integer;
begin
	no:=10;
	dbms_output.put_line('r ���'||no);
	no:=no/0;
	dbms_output.put_line('r���'||no);
	exception
		when others then
			dbms_output.put_line('exception');
	dbms_output.put_line('running?-���ܰ� �߻��ǵ� ó���߱⶧���� ����Ǵ� ���'); 
end;
/
--����� others�� �׷��� ���� ��� ��츦 ��Ʋ��̴�)


DECLARE -����,��� ����� �ʱ�ȭ ����
BEGIN-�����
EXCEPTION-����ó����, ���� ��Ȳ�� ���� when��� ����
END;



--?3. ������ ���� ������ ���� ���� + ���� ó�� ���� 
/*��� ���α׷� ����� ����: Ȥ�� ���ܰ� �߻� ���, ���α׷� ������ �ƴ� ������ ó���� ���� ���� ����
����ó��= exception
(java/java script/python ��� ����ó���� � ��ǻ�� ���� ������ˤ����������������������������������������ִ�)
*/



--5. ��ø block
/*1.����: ������ ǥ�� ���, �������� �����Ͱ� ����
	2.������ ���� ��ġ�� ���� ��� ����
			��������(�������)-�ڵ� ��ü���� ���?
			���ú���- ����� ��������(local)������ ���?

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

--step02: ��ø�� ���� ��Ͽ��� ����� ���ú����� �ܺ� ��Ͽ��� ��� �Ұ�
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






--6. emp01 table�� �÷��� ����ؼ� %type ǥ��� �н�
/* %type
-����Ŭ db�� Ư�� �÷� Ÿ���� ǥ���ϴ� ǥ��
-emp�� ename Ÿ��? sal? hiredate? comm?? ��� Ȯ���� ��, ��������� sql�������� Ȯ���� �����ϳ� ���� ���� Ȯ�ξ��� ����ؾ� �� ��쵵 �߻�
-emp�� empno�� Ÿ�԰� ����� ����ؼ� ���ο� pl sql ���� ����
	v_empno emp.empno%type;*****�����  v_�� �Ƚᵵ�� ���������� ���°���
*/
drop table emp01;
create table emp01 as select * from emp;
--������� �����ȣ, �̸�, �޿� �˻��ؼ� ���
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


--7. �̹� �����ϴ� table�� record�� ��� �÷� Ÿ�� Ȱ�� Ű����: %rowtype
/*7369 ������� �ش� ����� ��� ������ �˻��ؼ� ���, �̸��� �����ؼ� ���
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
-- emp05��� table�� ������ ���� emp table�� ���� �����ϱ�

-- %rowtype�� ����ϼż� emp�� ����� 7369�� ��� ���� �˻��ؼ� 
-- emp05 table�� insert
-- �˻� 
#-- ��Ʈ : begin �κп� �ټ��� sql���� �ۼ� ���� 
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

--Ȥ��!!! ������ �ʹ����
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


--9. ���ǽ�
/*  1. ���� ���ǽ�
	if(����) then
	
	end if;
	
	2. ���� ����
	if(����1) then
		����1�� true�� ��� ����Ǵ� ��� 
	elsif(����2) then
		����2�� true�� ��� ����Ǵ� ���
	end if;  */
-- SMITH ����� ������ ����ϴ� procedure ����[comm�� null�� �������� 0���� ġȯ]
--sal*12 +comm
--���ǽ�: comm�� null�̸� 0 ������ �Ҵ�
declare
	v_emp emp%rowtype;
	--���� �����͸� ���� �޴� ���ο� ����
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


--10.??? ����� �������� ������ ������ ����
-- plsql ��� ��ü�� ��� test ������ �ݿ��ؼ� ���ุ(���� ������), 
����� �������� ������(���� ������) �ݿ�
	--�������� ������ ���Թ޴� ���� �������� :&ǥ�� ���� �ݿ�

-- ps sql���ǽ����� ó�� 
-- emp table�� deptno=10 : ACCOUNT ���, 
-- deptno=20 �̶�� RESEARCH ���
-- test data�� �� ����� ���


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


����� ��

declare
	ck_empno number(4):= &v; --&v�� �Է¹޴� ��
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
	dbms_output.put_line(v_empno ||'�� �μ����� '|| v_dname);
end;
/


--11. �ݺ���
/* 
--loop,while,for ������ �����Ͽ� end loop;�� ������.
1. �⺻
loop 
	ps/sql �����
	exit ����;
end loop;

2. while �⺻����
 while ���ǽ� loop
 	plsql ����;
 end loop;

3. for �⺻ ����
for ���� in [reverse] start ..end loop
	plsql����
end loop;
*/






------------------------------------- loop ����

declare
	num number(2) := 0;
begin
	loop 
		--���, ����, ���ǽ�
		dbms_output.put_line(num);
		num:=num +1;	
		exit when num >5;
	end loop;
end;
/

------------------------------------while�̿� ����!
declare
	num number(2) :=0;
begin
	while num <6 loop
		dbms_output.put_line(num);
		num:=num +1;
	end loop;
end;
/


-----------------------------------��� �󵵰� ������� �ݺ��� for!
-- �������� ��� (���� ���� declare�� �������� �ִ�)
--for[��� �� ����]: �ʱⰪ, ������, ������, �񱳽�(���ǽ�)

begin
	for v in 1..5 loop
		dbms_output.put_line(v);
	end loop;
end;
/



------------ �������� ���
begin
	for i in  5..0 loop	
		dbms_output.put_line(i);
	end loop;
end;
/
--��� �����Ҽ������� �̴� �����̴�. reverse��°� ������Ѵ�
--���� ����

begin
	for i in reverse 1..5 loop	
		dbms_output.put_line(i);
	end loop;
end;
/



--12.? ����� �Է¹޾Ƽ� �ش��ϴ� ����� �̸� ���� �� ��ŭ * (�� line)ǥ ��� 




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










****�ڱ��ֵ� �н� 10�� 5��: 10�� ����, 2���� plsql���� �����
--����� �� ¦�õ� Ǯ���ϱ�(����� �ִ� ���� ����)
--����� �������� ���� ������(����)
--���ϸ� - ������-����,�����-����2.txt



























