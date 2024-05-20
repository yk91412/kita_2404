
--JOIN�� �� �� �̻��� ���̺��� �����Ͽ� ���õ� �����͸� ������ �� ���
--���� ���� (Inner Join)
--���� �ܺ� ���� (Left Outer Join) : . �� ��° ���̺� ��ġ�ϴ� �����Ͱ� ���� ��� NULL ���� ���
--������ �ܺ� ���� (Right Outer Join) : ù ��° ���̺� ��ġ�ϴ� �����Ͱ� ���� ��� NULL ���� ���
--FULL OUTER JOIN : ��ġ�ϴ� �����Ͱ� ���� ��� �ش� ���̺����� NULL ���� ���
--CROSS JOIN : �� ���̺� ���� ��� ������ ������ ����


--Q. �����ѹ̵����� ������ ������ ������ ���� �̸��� ���̽ÿ�.

--Q. ���ǻ纰�� ���ǻ��� ��� ���� ���ݺ��� ��� ������ ���Ͻÿ�.

--Q. ������ �ֹ����� ���� ���� �̸��� ���̽ÿ�.

--Q. �ֹ��� �ִ� ���� �̸��� �ּҸ� ���̽ÿ�.


--������ Ÿ��
--������ (Numeric Types)
--NUMBER: ���� �������� ���� ������ Ÿ��. ����, �Ǽ�, ���� �Ҽ���, �ε� �Ҽ��� ���� ����
-- number(39,0) 39: �ڸ���, 0 : �Ҽ��� /�Ҽ��� ������ �ڸ���

--������ (Character Types)
--VARCHAR2(size): ���� ���� ���ڿ��� ����. size�� �ִ� ���� ���̸� ����Ʈ�� ����
--NVARCHAR2(size)�� ����� ������ ���� ����Ʈ ���� ��� �׻� ���� ������ ũ�Ⱑ ����
--CHAR(size): ���� ���� ���ڿ��� ����. ������ ���̺��� ª�� ���ڿ��� �ԷµǸ� �������� �������� ä����

--varchar2 char���� byte���� Ȯ�ι�
SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS'
;

--��¥ �� �ð��� (Date and Time Types)
--DATE Ÿ���� ��¥�� �ð��� YYYY-MM-DD HH24:MI:SS �������� �����մϴ�.  
--���� ���, 2024�� 5�� 20�� ���� 3�� 45�� 30�ʴ� 2024-05-20 15:45:30���� ����
--DATE: ��¥�� �ð��� ����. ������ Ÿ���� ��, ��, ��, ��, ��, �ʸ� ����
--TIMESTAMP: ��¥�� �ð��� �� ���� ������ �������� ����
--���� �������� (Binary Data Types)
--BLOB: �뷮�� ���� �����͸� ����. �̹���, ����� ���� ���� �����ϴ� �� ����
--��Ը� ��ü�� (Large Object Types)
--CLOB: �뷮�� ���� �����͸� ����
--NCLOB: �뷮�� ������ ���� ���� �����͸� ����

--�������� : 
--PRIMARY KEY : �� ���� �����ϰ� �ĺ��ϴ� ��(�Ǵ� ������ ����). �ߺ��ǰų� NULL ���� ������� �ʴ´�.
--FOREIGN KEY : �ٸ� ���̺��� �⺻ Ű�� �����ϴ� ��. ���� ���Ἲ�� ����
--UNIQUE : ���� �ߺ��� ���� ����� ���� ����. NULL���� ���
--NOT NULL : ���� NULL ���� ������� �ʴ´�.
--CHECK : �� ���� Ư�� ������ �����ؾ� ���� ���� (��: age > 18)
--DEFAULT : ���� ������� ���� �������� ���� ��� ���� �⺻���� ����



--���� ���ڵ��� �ǹ�
--��ǻ�ʹ� ���ڷ� �̷���� �����͸� ó��. ���ڵ��� ���� ����(��: 'A', '��', '?')�� 
--����(�ڵ� ����Ʈ)�� ��ȯ�Ͽ� ��ǻ�Ͱ� �����ϰ� ������ �� �ְ� �Ѵ�.
--���� ���, ASCII ���ڵ������� �빮�� 'A'�� 65��, �ҹ��� 'a'�� 97�� ���ڵ�. 
--�����ڵ� ���ڵ������� 'A'�� U+0041, �ѱ� '��'�� U+AC00, �̸�Ƽ�� '?'�� U+1F60A�� ���ڵ�
--�ƽ�Ű�� 7��Ʈ�� ����Ͽ� �� 128���� ���ڸ� ǥ���ϴ� �ݸ� �����ڵ�� �ִ� 1,114,112���� ���ڸ� ǥ��

--ASCII ���ڵ�:
--���� 'A' -> 65 (10����) -> 01000001 (2����)
--���� 'B' -> 66 (10����) -> 01000010 (2����)

--�����ڵ�(UTF-8) ���ڵ�: 
--���� 'A' -> U+0041 -> 41 (16����) -> 01000001 (2����, ASCII�� ����)
--���� '��' -> U+AC00 -> EC 95 80 (16����) -> 11101100 10010101 10000000 (2����)

--CLOB: CLOB�� �Ϲ������� �����ͺ��̽��� �⺻ ���� ����(��: ASCII, LATIN1 ��)�� ����Ͽ� �ؽ�Ʈ �����͸� ����. 
--�� ������ �ַ� ����� ���� ���� ����Ʈ ���ڷ� �̷���� �ؽ�Ʈ�� �����ϴ� �� ���.
--NCLOB: NCLOB�� �����ڵ�(UTF-16)�� ����Ͽ� �ؽ�Ʈ �����͸� ����. ���� �ٱ��� ������ �ʿ��� ��, \
--�� �پ��� ���� ������ �ؽ�Ʈ �����͸� ������ �� ����. �ٱ��� ���ڰ� ���Ե� �����͸� ȿ�������� ó���� �� �ִ�.

-- AUTHOR ���̺� ����
create table authors(
id number primary key,
first_name varchar2(50) not null,
last_name varchar2(50) not null,
nationality varchar2(50)
);

drop table authors;


create table newbook(
bookid number,
isbn number(13),
bookname varchar2(50) not null,
author varchar2(50) not null,
publisher varchar2(50) not null,
price number default 10000 check (price >1000),
published_date date,
primary key(bookid)
);

drop table newbook;


insert into newbook values(1, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20', 'YYYY-MM-DD'));
--DATE Ÿ���� ��¥�� �ð��� YYYY-MM-DD HH24:MI:SS �������� �����մϴ�.
--���� ���, 2024�� 5�� 20�� ���� 3�� 45�� 30�ʴ� 2024-05-20 15:45:30���� ����
insert into newbook values(2, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

select * from newbook;

-- ���̺� ���� ���� ����,�߰�, �Ӽ� �߰�, ����, ����
alter table newbook modify (isbn varchar2(50));

delete from newbook;
alter table newbook add author_id number;
alter table newbook drop column author_id;
alter table newbook drop column published_date;
select * from newbook;

desc newbook;

commit;


-- on delete cascade �ɼ��� �����Ǿ� �־�, newcustomer ���̺��� � ���� ���ڵ尡 �����Ǹ�, �ش� ���� ��� �ֹ���
--neworders ���̺����� �ڵ����� ����
create table newcustomer(
custid number primary key,
name varchar2(40),
address varchar2(40),
phone varchar2(30)
);

create table neworders(
orderid number,
custid number not null,
bookid number not null,
saleprice number,
orderdate date,
primary key(orderid),
foreign key(custid) references newcustomer(custid) on delete cascade);


insert into newcustomer values(1,'KEVIN','���ﵿ','010-1234-1234');
insert into neworders values(10,1,100,1000,sysdate);
select * from newcustomer;
select * from neworders;
delete from newcustomer;

desc neworders;

desc newcustomer;

-- Tast1_0520. 10���� �Ӽ����� �����Ǵ� ���̺� 2���� �ۼ� �� foreign key�� ����Ͽ� ���� ���̺��� �����͸� ���� �� �ٸ� ���̺���
-- ���õǴ� �����͵� ��� �����ǵ��� �ϼ���(��� ���������� ���)
-- �� �� ���̺� 5���� �����͸� �Է��ϰ� �ι��� ���̺� ù���� �����͸� �����ϰ� �ִ� �Ӽ��� �����Ͽ� ������ ����
create table animal(
animalid number primary key,
animaltag number,
age number not null,
name varchar2(40) not null,
heigth number check(heigth > 10),
weight number default 10,
sex char(2) default 'f',
species varchar2(40),
color varchar2(20),
born date
);

insert into animal values(1,1,10,'��',12,3,'f','�����','����',to_date('2000-04-10','yyyy-mm-dd'));
insert into animal(animalid,animaltag,age,name,heigth,species,color,born)
values(2,3,12,'��',11,'ȣ����','���',to_date('2010-04-10','yyyy-mm-dd'));
insert into animal values(3,4,14,'zh',24,3,'m','ġŸ','����',to_date('2010-06-8','yyyy-mm-dd'));
insert into animal values(4,6,4,'an',15,3,'m','������','���',to_date('2021-09-15','yyyy-mm-dd'));
insert into animal values(5,8,8,'rk',18,3,'f','�䳢','��ȫ',to_date('2009-11-10','yyyy-mm-dd'));

create table animal_employee(
employeeid number,
animalid number not null,
name varchar2(30) not null,
sex char(2) default 'f',
startdate date check (startdate >= to_date('2001-01-01','yyyy-mm-dd')),
weight number default 40,
height number check(height> 150),
city varchar2(30),
address varchar2(30),
phone varchar2(30) not null,
primary key(employeeid),
foreign key(animalid) references animal(animalid) on delete cascade
);

insert into animal_employee values (1,1,'ȫ�浿','f',to_date('2000-03-04','yyyy-mm-dd'),45,160,'����','���빮��','010-1234-1566');
--üũ ��������(C##MD.SYS_C007365)�� ����Ǿ����ϴ� -> �����߻�


--ALTER TABLE {���̺��} ADD CONSTRAINT {�������Ǹ�} {��������}
-- �������� ����
alter table animal_employee
add constraint check_employee check (startdate >= to_date('2000-01-01','yyyy-mm-dd'));



drop table animal_employee;
insert into animal_employee values (1,1,'ȫ�浿','f',to_date('2019-03-04','yyyy-mm-dd'),45,160,'����','���빮��','010-1234-1566');
insert into animal_employee values (2,2,'¯��','m',to_date('2012-03-19','yyyy-mm-dd'),55,167,'��õ','����','010-3554-12526');
insert into animal_employee values (3,3,'ö��','m',to_date('2013-10-15','yyyy-mm-dd'),60,187,'��⵵','������','010-3224-1226');
insert into animal_employee values (4,3,'����','f',to_date('2016-02-23','yyyy-mm-dd'),32,151,'����','��걸','010-1235-1256');
insert into animal_employee values (5,5,'�ͱ�','m',to_date('2017-11-12','yyyy-mm-dd'),68,177,'��⵵','����','010-2143-1246');

select * from animal;
select * from animal_employee;


alter table animal add animal_class varchar(30);
alter table animal modify animal_class number;

desc animal;

alter table animal drop column animal_class;


delete from animal;
--Task2_0520. Customer ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� �����Ͻÿ�.

select * from customer;

update customer set address = (select address from customer where name = '�迬��')
where name = '�ڼ���';

--Task3_0520.���� ���� ���߱����� ���Ե� ������ ���󱸡��� ������ �� ���� ���, ������ ���̽ÿ�.
select * from book;

update book set bookname = '��'
where bookname like '%�߱�%';

select bookname, price
from book;
commit;
--Task4_0520. ���缭���� �� �߿��� ���� ��(��)�� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���Ͻÿ�.
--select count(*)
--from
--group by gender

--Task5_0520. ���缭���� �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.

select orderdate+10 "�ֹ� Ȯ�� ����"
from orders;

--Task6_0520.���缭���� 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���̽ÿ�. 
--�� �ֹ����� ��yyyy-mm-dd ���ϡ� ���·� ǥ���Ѵ�.
select orderid, orderdate, custid, bookid
from orders
where orderdate = to_date('2020-07-07','yyyy-mm-dd');

--Task7_0520. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���̽ÿ�.

select * from orders;

select orderid, saleprice
from orders
where saleprice < (select avg(saleprice) from orders)
order by orderid;

--Task8_0520. ���ѹα����� �����ϴ� ������ �Ǹ��� ������ �� �Ǹž��� ���Ͻÿ�.
select * from customer;

select saleprice
from orders
where 
