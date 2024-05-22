--TAST1_0517. 출판사가 '굿스포츠' 혹은 '대한미디어' 인 도서를 검색 총 3가지 방법
SELECT * FROM book
WHERE publisher = '굿스포츠' or publisher = '대한미디어';

SELECT * FROM book
WHERE publisher = any('굿스포츠','대한미디어');

SELECT * FROM book
WHERE publisher LIKE '굿스포츠' or publisher LIKE '대한미디어';

--

--TAST2_0517. 출판사가 '굿스포츠' 혹은 '대한미디어' 가 아닌 도서를 검색 총 3가지 방법
SELECT * FROM book
WHERE not (publisher = '굿스포츠' or publisher = '대한미디어');

SELECT * FROM book
WHERE publisher != all('굿스포츠','대한미디어');

SELECT * FROM book
WHERE publisher != '굿스포츠' and publisher != '대한미디어';

--TAST3_0517. 축구에 관한 도서 중 가격이 이만원 이상인 도서를 검색
SELECT * FROM book
WHERE bookname LIKE '%축구%' and 
price >= 20000;

--Task4_0517. 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
select sum(saleprice)
from orders
group by custid
having custid = 2;

--Task5_0517. 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 
--단, 두 권 이상 구매한 고객만 구하시오.
select custid, count(*) as "총 수량"
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;

--Task6_0517. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.

select customer.name ,orders.saleprice 
from customer join orders
on customer.custid = orders.custid;

--Task7_0517. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
select custid,sum(saleprice)
from orders
group by custid
order by custid;








