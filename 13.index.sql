--13.index.sql
/*
1. db�� ���� �˻��� ���� ���� ����� index �н�
	- primary key�� �⺻������ �ڵ� index�� ������
	-DB ��ü������ ���� �˻� ��� �ο�
		�� ���� �˻� ���- index
	-����� ����� ���� index ������ ������ �˻� �ӵ� �ٿ�!!
	-������ ���� 15%�̻��� �����͵��� ���� ������ �̷��� ��� index ���� 
	-�⺻Ű Ư¡
		: ���� �ߺ� ����, ���� null�� ��� ����
		�˻��� ���� ������

		�Խ����� �Խñ� �����ϰ��� �ϴ� ������? �Խñ� ��ȣ
		���� �����ϱ� ���� ���� ������? �� ��ȣ
		�л� ���� ���α׷������� �л��� �����ϱ� ���� ������? �й�
		���� ������ ���� ������? ������ȣ
		������ ������ ���� ������? ���
		primary key�� �����ϴ� ������ ���� �˻��� �����̴�.


2. ���� �ӵ� üũ�� ���� �ɼ� ��ɾ�
	set timing on
	set timing off
3. ***
	sql��ɹ��� �˻� ó�� �ӵ� ����� ���� oracle db ��ü�� ��ü
4. ���ǻ���
	- index�� �ݿ��� �÷� �����Ͱ� ���÷� ����Ǵ� 
		�����Ͷ�� index ������ ������ ���ۿ�
*/

--1. index�� �˻� �ӵ� Ȯ���� ���� table ����
drop table emp01;
create table emp01 as select * from emp;

--2. �׽�Ʈ�� ���� �����Ͱ��� ���� �ٿ��ֱ�
insert into emp01 select * from emp01;
select count(*) from emp01;

select * from emp01 where ename='SMITH';


--3. emp01 table�� index ��� ����
create index idx_emp01_empno on emp01(empno);


--4. SMITH ��� �˻� �ð� üũ  
select * from emp01 where empno=7369;


--5. index ���� ��ɾ�
drop index idx_emp01_empno;

drop table emp01;
