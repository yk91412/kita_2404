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