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


alter table animal add animal_class varchar(30);
alter table animal modify animal_class number;
alter table animal drop column animal_class;


--Task2_0520. Customer ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� �����Ͻÿ�.

update customer set address = (select address from customer where name = '�迬��')
where name = '�ڼ���';


--Task3_0520.���� ���� ���߱����� ���Ե� ������ ���󱸡��� ������ �� ���� ���, ������ ���̽ÿ�.

update book set bookname = '��'
where bookname like '%�߱�%';

-- ���̺� ���� x / ��ȸ��
select bookid, replace(bookname, '�߱�','��') bookname, publisher, price
from book;


--Task4_0520. ���缭���� �� �߿��� ���� ��(��)�� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���Ͻÿ�.

select substr(name,1,1) ��, count(*) �ο�
from customer
group by substr(name,1,1);


--Task5_0520. ���缭���� �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.

select orderdate+10 "�ֹ� Ȯ�� ����"
from orders;

--Task6_0520.���缭���� 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���̽ÿ�. 
--�� �ֹ����� ��yyyy-mm-dd ���ϡ� ���·� ǥ���Ѵ�.
select orderid, orderdate, custid, bookid
from orders
where orderdate = to_date('2020-07-07','yyyy-mm-dd');

select orderid �ֹ���ȣ , to_char(orderdate,'yyyy-mm-dd day') �ֹ���
from orders;


--����Ŭ������ ���ڿ��� DATE�� �ڵ� ��ȯ�Ͽ� ��
--where orderdate = '2020-07-07';
where orderdate = to_date('20/07/07','yy/mm/dd');
--where orderdate = to_date('20/07/24','dd/mm/yy');

--Task7_0520. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���̽ÿ�.

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

