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

--중복 제거
SELECT DISTINCT PUBLISHER FROM BOOK;

-- Q 가격이 만원 이상인 도서를 검색
SELECT * FROM book
where price >= 10000
ORDER BY price;

--Q 가격이 만원 이상 이만원 도서를 검색
 SELECT * FROM book
 where price >= 10000 and price <= 20000;

SELECT * FROM book
WHERE price BETWEEN 10000 AND 20000;

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

-- LIKE는 정확히 일치하는 행만 선택
SELECT * FROM book
WHERE bookname LIKE '축구의 역사';

-- 축구가 포함된 출판사 -> % 활용
SELECT bookname FROM book
WHERE bookname LIKE '%축구%';

-- 두번째 글자가 구인 도서 찾기
SELECT bookname,publisher FROM book
WHERE bookname LIKE '_구%';

--TAST3_0517. 축구에 관한 도서 중 가격이 이만원 이상인 도서를 검색
SELECT * FROM book
WHERE bookname LIKE '%축구%' and 
price >= 20000;

-- Q 도서를 가격순으로 검색하고 가격이 같으면 이름순으로 검색
SELECT * FROM book
ORDER BY price,bookname;

--Q 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오
select * from orders;
select * from customer;

select sum(saleprice) from orders inner join customer
on orders.custid = customer.custid
where orders.custid = 2;

select sum(saleprice) as "총 판매액"
from orders
where custid = 2;

--GROUP BY : 데이터를 특정 기준에 따라 그룹화하는데 사용. 이를 통해 집계함수를 이용하여 계산 가능
select sum(saleprice) as total,
avg(saleprice) as average,
min(saleprice) as mininum,
max(saleprice) as maximum
from orders;

select sum(saleprice) from orders
group by custid;

--총 판매액을 custid 기준으로 그룹화
select custid, count(*) as "도서수량",
sum(saleprice) as "총 판매액"
from orders
group by custid;

-- bookid가 5보다 큰 조건
select custid, count(*) as "도서수량",
sum(saleprice) as "총 판매액"
from orders
where bookid >5
group by custid;

--도서수량이 2보다 큰 조건
select custid, count(*) as "도서수량",
sum(saleprice) as "총 판매액"
from orders
where bookid >5
group by custid
having count(*) > 2;

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

select * from customer;
select * from orders;
select * from book;

--Task6_0517. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.

select customer.name ,orders.saleprice 
from customer join orders
on customer.custid = orders.custid;

--Task7_0517. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
select custid,sum(saleprice)
from orders
group by custid
order by custid;

commit;