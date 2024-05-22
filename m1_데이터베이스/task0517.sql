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

--TAST3_0517. �౸�� ���� ���� �� ������ �̸��� �̻��� ������ �˻�
SELECT * FROM book
WHERE bookname LIKE '%�౸%' and 
price >= 20000;

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

--Task6_0517. ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� �˻��Ͻÿ�.

select customer.name ,orders.saleprice 
from customer join orders
on customer.custid = orders.custid;

--Task7_0517. ������ �ֹ��� ��� ������ �� �Ǹž��� ���ϰ�, ������ �����Ͻÿ�.
select custid,sum(saleprice)
from orders
group by custid
order by custid;








