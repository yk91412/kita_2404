SELECT * FROM BOOK;

SELECT BOOKNAME,BOOKID FROM BOOK
ORDER BY BOOKID DESC;

SELECT * FROM CUSTOMER;

SELECT * FROM ORDERS;

SELECT * FROM IMPORTED_BOOK;

select * from orders
where bookid > 5
order by bookid desc;

SELECT PUBLISHER FROM BOOK;

--�ߺ� ����
SELECT DISTINCT PUBLISHER FROM BOOK;

-- Q ������ ���� �̻��� ������ �˻�
SELECT * FROM book
where price >= 10000
ORDER BY price;

--Q ������ ���� �̻� �̸��� ������ �˻�
 SELECT * FROM book
 where price >= 10000 and price <= 20000;

SELECT * FROM book
WHERE price BETWEEN 10000 AND 20000;

--TAST1_0517. ���ǻ簡 '�½�����' Ȥ�� '���ѹ̵��' �� ������ �˻� �� 3���� ���
SELECT * FROM book
WHERE publisher = '�½�����' or publisher = '���ѹ̵��';

SELECT * FROM book
WHERE publisher = any('�½�����','���ѹ̵��');

SELECT * FROM book
WHERE publisher LIKE '�½�����' or publisher LIKE '���ѹ̵��';

--

--TAST2_0517. ���ǻ簡 '�½�����' Ȥ�� '���ѹ̵��' �� �ƴ� ������ �˻� �� 3���� ���
SELECT * FROM book
WHERE not (publisher = '�½�����' or publisher = '���ѹ̵��');

SELECT * FROM book
WHERE publisher != all('�½�����','���ѹ̵��');

SELECT * FROM book
WHERE publisher != '�½�����' and publisher != '���ѹ̵��';

-- LIKE�� ��Ȯ�� ��ġ�ϴ� �ุ ����
SELECT * FROM book
WHERE bookname LIKE '�౸�� ����';

-- �౸�� ���Ե� ���ǻ� -> % Ȱ��
SELECT bookname FROM book
WHERE bookname LIKE '%�౸%';

-- �ι�° ���ڰ� ���� ���� ã��
SELECT bookname,publisher FROM book
WHERE bookname LIKE '_��%';

--TAST3_0517. �౸�� ���� ���� �� ������ �̸��� �̻��� ������ �˻�
SELECT * FROM book
WHERE bookname LIKE '%�౸%' and 
price >= 20000;

-- Q ������ ���ݼ����� �˻��ϰ� ������ ������ �̸������� �˻�
SELECT * FROM book
ORDER BY price,bookname;

--Q 2�� �迬�� ���� �ֹ��� ������ �� �Ǹž��� ���Ͻÿ�
select * from orders;
select * from customer;

select sum(saleprice) from orders inner join customer
on orders.custid = customer.custid
where orders.custid = 2;

select sum(saleprice) as "�� �Ǹž�"
from orders
where custid = 2;

--GROUP BY : �����͸� Ư�� ���ؿ� ���� �׷�ȭ�ϴµ� ���. �̸� ���� �����Լ��� �̿��Ͽ� ��� ����
select sum(saleprice) as total,
avg(saleprice) as average,
min(saleprice) as mininum,
max(saleprice) as maximum
from orders;

select sum(saleprice) from orders
group by custid;

--�� �Ǹž��� custid �������� �׷�ȭ
select custid, count(*) as "��������",
sum(saleprice) as "�� �Ǹž�"
from orders
group by custid;

-- bookid�� 5���� ū ����
select custid, count(*) as "��������",
sum(saleprice) as "�� �Ǹž�"
from orders
where bookid >5
group by custid;

--���������� 2���� ū ����
select custid, count(*) as "��������",
sum(saleprice) as "�� �Ǹž�"
from orders
where bookid >5
group by custid
having count(*) > 2;

--Task4_0517. 2�� �迬�� ���� �ֹ��� ������ �� �Ǹž��� ���Ͻÿ�.
select sum(saleprice)
from orders
group by custid
having custid = 2;

--Task5_0517. ������ 8,000�� �̻��� ������ ������ ���� ���Ͽ� ���� �ֹ� ������ �� ������ ���Ͻÿ�. 
--��, �� �� �̻� ������ ���� ���Ͻÿ�.
select custid, count(*) as "�� ����"
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;

select * from customer;
select * from orders;
select * from book;

--Task6_0517. ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� �˻��Ͻÿ�.

select customer.name ,orders.saleprice 
from customer join orders
on customer.custid = orders.custid;

--Task7_0517. ������ �ֹ��� ��� ������ �� �Ǹž��� ���ϰ�, ������ �����Ͻÿ�.
select custid,sum(saleprice)
from orders
group by custid
order by custid;

commit;

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










