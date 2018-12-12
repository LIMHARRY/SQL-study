--12.sequence.sql
/*
1. ������ 
	: �������� ������ �ڵ����� �ݿ��Ҽ� �ִ� �ſ� ������ ��� 
	: �⺻�� 1�� �ڵ� ����
		- ����ġ, �ִ밪 �߰� ������ ����
		- ���� : �ϳ��� �������� �ټ��� table���� ��� ����
	: ����, �ʿ伺, ����(create, drop, nextval, currval)

2. ��ǥ���� Ȱ�� ����
	- �Խù� �۹�ȣ�� �ַ� ���

3. Ư¡
	- ���� �ߺ� �Ұ� 
 
 ���� : ����
	��õ���� �Խñ� ����
	500���� �ۼ��� ����
	�� �Խñ��� �Խù�ȣ�� ������ ������ ����
	��? �������� ���� ���� �ڿ����� ����,
		������ ������ �ſ� �������� ���� ���ҽ� ������ �ϳ�
*/

--1. sequence ���� ���ɾ�
drop table seq_test;
-- ������ ���� ����
create sequence seq_test_seq;


--2. seq~�� Ȱ���� insert
	-- �⺻������ ������ ��� 1�� �ڵ� ����
create table seq_test(
	no1 number(2),
	no2 number(2)
);

insert into seq_test values(seq_test_seq.nextval, 1);
insert into seq_test values(seq_test_seq.nextval, 2);
insert into seq_test values(seq_test_seq.nextval, 3);
select * from seq_test;
	
--sequence�� �˻�
select seq_test_seq.currval from dual;











--3. �ټ��� table���� �ϳ��� seq�� ���� ����?
create table seq_test2(
	no1 number(2),
	no2 number(2)
);
insert into seq_test2 values(seq_test_seq.nextval, 1);
insert into seq_test2 values(seq_test_seq.nextval, 2);

insert into seq_test values(seq_test_seq.nextval, 1);

select * from seq_test;
select * from seq_test2;

--4. ����index ���� �� ����ġ�� �����ϴ� seq ���� ���ɾ�
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

--5. seq ���� ���ɾ�


--6. �� sequence�� �����Ͱ� �˻��ϱ�
create sequence seq2_test start with 1 increment by 2 maxvalue 10;

