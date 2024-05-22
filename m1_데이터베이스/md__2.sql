
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
drop table animal_employee;

insert into animal_employee values (1,1,'ȫ�浿','f',to_date('2000-03-04','yyyy-mm-dd'),45,160,'����','���빮��','010-1234-1566');
--üũ ��������(C##MD.SYS_C007365)�� ����Ǿ����ϴ� -> �����߻�


--ALTER TABLE {���̺��} ADD CONSTRAINT {�������Ǹ�} {��������}
-- �������� ����
alter table animal_employee
add constraint check_employee check (startdate >= to_date('2000-01-01','yyyy-mm-dd'));

-- �������� ����
--alter table ���̺�� modify (�÷��� ��������)

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

-- ���ϴ� �����͸� �����ϱ�
-- ex)
delete animal
where animalid = 1;


delete from animal;
--Task2_0520. Customer ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� �����Ͻÿ�.

select * from customer;

update customer set address = (select address from customer where name = '�迬��')
where name = '�ڼ���';


update customer set address = '���ѹα� �λ�'
where name = '�ڼ���';

-- ����
select abs(-30), abs(30)
from dual;
--�ݿø�
select round(4.532,1)
from dual;

-- ���� ��� �ֹ� �ݾ��� ��� ������ �ݿø��� ���� ���Ͻÿ�
-- ��� �����̹Ƿ� '-' ���
select custid as ����ȣ, round(avg(saleprice),-2) as ����ֹ��ݾ�
from orders
group by custid
order by ����ȣ;

--Task3_0520.���� ���� ���߱����� ���Ե� ������ ���󱸡��� ������ �� ���� ���, ������ ���̽ÿ�.
select * from book;

update book set bookname = '��'
where bookname like '%�߱�%';

select bookname, price
from book;
commit;

update book set bookname = '�߱��� ��Ź��'
where bookid =8 ;


-- ���̺� ���� x / ��ȸ��
select bookid, replace(bookname, '�߱�','��') bookname, publisher, price
from book;

-- Q. '�½�����'���� ������ ������ ����� ������ ���� ��, ����Ʈ ���� ���̽ÿ�
select bookname ����, length(bookname) ���ڼ�, lengthb(bookname) ����Ʈ��
from book
where publisher = '�½�����';

--Task4_0520. ���缭���� �� �߿��� ���� ��(��)�� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���Ͻÿ�.

select substr(name,1,1) ��, count(*) �ο�
from customer
group by substr(name,1,1);

select * from customer;
--Task5_0520. ���缭���� �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.

select orderdate+10 "�ֹ� Ȯ�� ����"
from orders;

-- 2���� �� ���� Ȯ��
select orderdate,orderdate + 62
from orders;

-- add_months �Լ� Ȱ��
select orderid, orderdate as �ֹ���,
add_months(orderdate,2) as Ȯ������
from orders;

--Task6_0520.���缭���� 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���̽ÿ�. 
--�� �ֹ����� ��yyyy-mm-dd ���ϡ� ���·� ǥ���Ѵ�.
select orderid, orderdate, custid, bookid
from orders
where orderdate = to_date('2020-07-07','yyyy-mm-dd');

select orderid �ֹ���ȣ , to_char(orderdate,'yyyy-mm-dd day') �ֹ���
from orders

--����Ŭ������ ���ڿ��� DATE�� �ڵ� ��ȯ�Ͽ� ��
--where orderdate = '2020-07-07';
where orderdate = to_date('20/07/07','yy/mm/dd');
--where orderdate = to_date('20/07/24','dd/mm/yy');

--Task7_0520. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���̽ÿ�.
desc orders;

select * from orders;

select orderid, saleprice
from orders 
where saleprice < (select avg(saleprice) from orders)
order by orderid;

select o1.orderid, o1.saleprice
from orders o1
where o1.saleprice < (select avg(o2.saleprice) from orders o2);

-- ���������� o2��� ��Ī���� ����, saleprice�� ��� ���� avg_saleprice�� ���
select o1.orderid, o1.saleprice
from orders o1
join (select avg(saleprice) as avg_saleprice from orders) o2
on o1.saleprice < o2.avg_saleprice;


--Task8_0520. ���ѹα����� �����ϴ� ������ �Ǹ��� ������ �� �Ǹž��� ���Ͻÿ�.

select sum(saleprice) as ���Ǹž�
from orders
where custid in (select custid from customer where address like '%���ѹα�%');

commit;

--
drop table mart;
drop table department;

create table mart(
custid number primary key,
name varchar2(20),
age number,
sx char(2),
phone number not null,
address varchar2(100),
frequency number,
amount_num number,
amount_price number,
parking varchar2(20),
family number
);

alter table mart drop column amount_num;

select * from mart;
desc mart;

--�б� ������ ���Ͽ� ���̺� 2�� �̻����� db�� �����ϰ� 3�� �̻� Ȱ���� �� �ִ� case�� ���弼��
--�л� ���̺�
-- ����, ����

create table student_manage(
student_id number,
management_id number primary key,
onesemester number,
twosemester number,
liberalarts varchar2(20),
major varchar2(20),
crew varchar2(20)
);

alter table student_manage modify crew varchar2(40);

delete from student_manage;

INSERT INTO student_manage
VALUES (1910101, 1, 4.0, 4.3, '�����', '������а�', '��ȸ���� ���Ƹ�');

INSERT INTO student_manage
VALUES (2020202, 2, 3.8, 4.5, '�����', '������а�', '��� ���Ƹ�');

INSERT INTO student_manage
VALUES (2130303, 3, 4.5, 4.4, '������', '���а�', '���α׷��� ���Ƹ�');

INSERT INTO student_manage
VALUES (1940404, 4, 3.9, 4.2, '������', '�����а�', '������ ���Ƹ�');

INSERT INTO student_manage
VALUES (2050505, 5, 4.2, 4.1, '�����', '�����а�', '�м� ���Ƹ�');

INSERT INTO student_manage
VALUES (2160606, 6, 4.1, 4.5, '�����̷�', '�����а�', 'â���� ����');

INSERT INTO student_manage
VALUES (2270707, 7, 4.4, 4.3, '�ɸ��� ����', '�ɸ��а�', '������ȭ ���Ƹ�');

INSERT INTO student_manage
VALUES (2280808, 8, 4.3, 4.4, 'ȯ�����', 'ü���а�', 'Ŭ���̹� ���Ƹ�');

INSERT INTO student_manage
VALUES (2190909, 9, 4.5, 4.0, '������', '�����а�', '�濵 ���Ƹ�');

INSERT INTO student_manage
VALUES (2001010, 10, 4.0, 4.5, '�ɸ��� ����', '�ɸ��а�', '��ȸ ���� ���Ƹ�');


select * from student_manage;

select onesemester+twosemester as ����
from student_manage;

select substr(student_id,1,2) as �й� ,count(*) ���, sum(onesemester+twosemester) �й�������
from student_manage
group by substr(student_id,1,2);


--
select * from student_info;
select * from student_manage;
--

-- ���б��� ���� �� �ִ� �л��� �̸��� ���ϼ���(�ִ� 3��)
-- ���� : 1,2�б� ������ 4���� �Ѱ� ��ü ��������� 4.2�̻��� �л����� ���б� ����

select name
from student_info
where student_id in
(select student_id
from student_manage
where onesemester > 4 and twosemester > 4
group by student_id
having avg(onesemester+twosemester)/2 >= 4.2
order by avg(onesemester+twosemester)/2 desc)
and rownum <= 3;


SELECT name
FROM (
    SELECT name, ROWNUM AS rnum
    FROM (
        SELECT si.name
        FROM student_info si
        WHERE si.student_id IN (
            SELECT sm.student_id
            FROM student_manage sm
            WHERE sm.onesemester > 4 AND sm.twosemester > 4
            GROUP BY sm.student_id
            HAVING AVG(sm.onesemester + sm.twosemester) / 2 >= 4.2
        )
        ORDER BY (
            SELECT AVG(onesemester + twosemester) / 2
            FROM student_manage
            WHERE si.student_id = student_id
        ) DESC
    )
)
WHERE rnum <= 3;



select student_id
from student_manage
where onesemester > 4 and twosemester > 4
group by student_id
having avg(onesemester+twosemester)/2>= 4.2
order by avg(onesemester+twosemester)/2 desc;


select i.name
from student_info i inner join student_manage m
on i.student_id = m.student_id
where m.onesemester > 4 and m.twosemester > 4
group by m.student_id
having avg(m.onesemester+m.twosemester)/2>= 4.2
order by avg(m.onesemester+m.twosemester)/2 desc;


-- 2. ����� �հ��� ������ �л��� �̸��� �й��� ���ϼ���
-- ���� : Ÿ���� �л��̸鼭 + ������ ���� ���� 3��

select student_id as �й�
from student_manage
where student_id in
(select student_id from student_info where regional = 'y')
group by student_id
order by (avg(onesemester+twosemester)/2) desc;

select student_id as �й�, name as �̸�
from student_info
where student_id in (select student_id
from student_manage
where regional = 'y');

select i.name as �̸�, i.student_id as �й�, avg(m.onesemester+m.twosemester)/2 as �������
from student_info i inner join student_manage m
on i.student_id = m.student_id
where i.regional = 'y'
group by i.name, i.student_id
order by (avg(m.onesemester+m.twosemester)/2) desc;

select i.name as �̸�, i.student_id as �й�
from (select rownum, i.name, i.student_id
    from (
    select i.name as �̸�, i.student_id as �й�, avg(m.onesemester+m.twosemester)/2 as �������
    from student_info i inner join student_manage m
    on i.student_id = m.student_id
    where i.regional = 'y'
    group by i.name, i.student_id)
    order by (avg(m.onesemester+m.twosemester)/2) desc)
    )
where rownum <= 3;
    

select * from student_info;

drop table student_info;
select * from student_manage;
drop table student_manage;

-- �л� ���� ���� ����

--�л� ���̺�
create table student_info(
student_id number primary key,
name varchar2(30) not null,
gender varchar2(30) not null,
birthdate number(8) not null,
s_phone varchar2(15) not null,
s_email varchar2(50) not null,
s_address varchar2(50) not null
);

-- ���� ���̺�
create table lecture(
student_id number, -- ���ǵ�� �л�id
lecture_id number primary key, -- ���� ��ȣ(�����ڵ�)
lecture varchar2(30) not null, -- �����̸�
professor_name varchar2(30), -- �����ϴ� �����̸�
foreign key(student_id) references student_info(student_id)
foreign key(professor_name) references  on delete cascade
);

-- ���ǽ� ���̺�
create table class(
lecture_id number, -- ���� �ڵ�
class_id number primary key, -- ���ǽ� �ڵ�
schedule date, -- ����ϴ� ��¥
time number, -- ����ϴ� �ð�
student_count number, --���� ��� �л���
foreign key(lecture_id) references lecture(lecture_id) on delete cascade
);

-- ���� ���̺�
create table student_gpa(
student_id number,
management_id number primary key,
semester1_gpa number,
semester2_gpa number,
overall_gpa number
);



-- 3. ������ ��� �л��� 2�� �̸��� ��� ������ ������ �� �� ������ �Ǵ� ������� ���ϼ���
select liberalarts, count(*)
from student_manage
group by liberalarts
having count(*) < 2;

--
create table student_info(
student_id number primary key,
name varchar2(30) not null,
gender varchar2(30) not null,
birthdate number(8) not null,
family_members number not null, -- ���谡�� �� 
regional varchar2(10) not null, -- ������ Ÿ��������. Ÿ����: "y"
c_address varchar2(150) not null, -- ���� �л��� ���� �ּ�
s_mobile varchar2(15) not null, -- �л� ��ȭ��ȣ
e_number varchar2(15),-- ���� ���� ��ȣ
s_email varchar2(50) not null); -- �л� �̸����ּ�


insert into student_info values(
1910101, '������', 'f', 20000115,5,'y','����Ư���� ���빮�� �̹���', 
'010-1234-5678','010-0987-6543','jieun_lee@gmail.com');

INSERT INTO student_info VALUES (
2020202, '�����', 'm', 20010515, 4, 'n', '����Ư���� ������ ������', 
'010-2345-6789', '010-9876-5432', 'soohyun_kim@gmail.com');

INSERT INTO student_info VALUES (
2130303, '�ڽ���', 'f', 20021123, 3, 'y', '����Ư���� ���ʱ� ������', 
'010-3456-7890', '010-8765-4321', 'shinhye_park@gmail.com');

INSERT INTO student_info VALUES (
1940404, '�̹�ȣ', 'm', 20001004, 2, 'n', '����Ư���� ���ʱ� ������', 
'010-4567-8901', '010-7654-3210', 'minho_lee@gmail.com');

INSERT INTO student_info VALUES (
2050505, '�����', 'f', 20000212, 5, 'y', '����Ư���� ������ ������', 
'010-5678-9012', '010-6543-2109', 'suzy_bae@gmail.com');

INSERT INTO student_info VALUES (
2160606, '���߱�', 'm', 20020722, 3, 'n', '����Ư���� ������ ������', 
'010-6789-0123', '010-5432-1098', 'joongki_song@gmail.com');

INSERT INTO student_info VALUES (
2270707, '������', 'f', 20020417, 4, 'y', '����Ư���� ��걸 ���¿���', 
'010-7890-1234', '010-4321-0987', 'hyekyo_song@gmail.com');

INSERT INTO student_info VALUES (
2280808, '�ڰ���', 'm', 20000110, 6, 'y', '��⵵ ���� �ϻ꼭�� ��ȭ��', 
'010-8901-2345', '010-3210-9876', 'gong_yoo_p@gmail.com');

INSERT INTO student_info VALUES (
2190909, '������', 'f', 20011220, 3, 'y', '��⵵ ������ �д籸 ���ڵ�', 
'010-9012-3456', '010-2109-8765', 'jihyun_jun@gmail.com');

INSERT INTO student_info VALUES (
2001010, '�ں���', 'm', 19990616, 5, 'n', '����Ư���� ���α� ��ȭ��', 
'010-0123-4567', '010-1098-7654', 'bogum_park@gmail.com');



--

-- ���� ��¥�� �ð�, ���� Ȯ��
select sysdate, to_char(sysdate,'yyyy-mm-dd HH:MI:SS day')
from dual;

-- ��ȭ��ȣ�� ���� ���� ����ó �������� ǥ��
-- NVL�Լ�(��, ������)
select name �̸�, nvl(phone, '����ó ����') ��ȭ��ȣ
from customer;




