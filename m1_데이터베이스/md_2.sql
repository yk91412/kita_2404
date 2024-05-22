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

--JOIN은 두 개 이상의 테이블을 연결하여 관련된 데이터를 결합할 때 사용
--내부 조인 (Inner Join)
--왼쪽 외부 조인 (Left Outer Join) : . 두 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
--오른쪽 외부 조인 (Right Outer Join) : 첫 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
--FULL OUTER JOIN : 일치하는 데이터가 없는 경우 해당 테이블에서는 NULL 값이 사용
--CROSS JOIN : 두 테이블 간의 모든 가능한 조합을 생성


--Q. ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.


--데이터 타입
--숫자형 (Numeric Types)
--NUMBER: 가장 범용적인 숫자 데이터 타입. 정수, 실수, 고정 소수점, 부동 소수점 수를 저장
-- number(39,0) 39: 자릿수, 0 : 소수점 /소수점 포함한 자릿수

--문자형 (Character Types)
--VARCHAR2(size): 가변 길이 문자열을 저장. size는 최대 문자 길이를 바이트로 지정
--NVARCHAR2(size)의 사이즈를 지정할 때는 바이트 단위 대신 항상 문자 단위로 크기가 지정
--CHAR(size): 고정 길이 문자열을 저장. 지정된 길이보다 짧은 문자열이 입력되면 나머지는 공백으로 채워짐

--varchar2 char인지 byte인지 확인법
SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS'
;

--날짜 및 시간형 (Date and Time Types)
--DATE 타입은 날짜와 시간을 YYYY-MM-DD HH24:MI:SS 형식으로 저장합니다.  
--예를 들어, 2024년 5월 20일 오후 3시 45분 30초는 2024-05-20 15:45:30으로 저장
--DATE: 날짜와 시간을 저장. 데이터 타입은 년, 월, 일, 시, 분, 초를 포함
--TIMESTAMP: 날짜와 시간을 더 상세히 나노초 단위까지 저장
--이진 데이터형 (Binary Data Types)
--BLOB: 대량의 이진 데이터를 저장. 이미지, 오디오 파일 등을 저장하는 데 적합
--대규모 객체형 (Large Object Types)
--CLOB: 대량의 문자 데이터를 저장
--NCLOB: 대량의 국가별 문자 집합 데이터를 저장

--제약조건 : 
--PRIMARY KEY : 각 행을 고유하게 식별하는 열(또는 열들의 조합). 중복되거나 NULL 값을 허용하지 않는다.
--FOREIGN KEY : 다른 테이블의 기본 키를 참조하는 열. 참조 무결성을 유지
--UNIQUE : 열에 중복된 값이 없어야 함을 지정. NULL값이 허용
--NOT NULL : 열에 NULL 값을 허용하지 않는다.
--CHECK : 열 값이 특정 조건을 만족해야 함을 지정 (예: age > 18)
--DEFAULT : 열에 명시적인 값이 제공되지 않을 경우 사용될 기본값을 지정



--문자 인코딩의 의미
--컴퓨터는 숫자로 이루어진 데이터를 처리. 인코딩을 통해 문자(예: 'A', '가', '?')를 
--숫자(코드 포인트)로 변환하여 컴퓨터가 이해하고 저장할 수 있게 한다.
--예를 들어, ASCII 인코딩에서는 대문자 'A'를 65로, 소문자 'a'를 97로 인코딩. 
--유니코드 인코딩에서는 'A'를 U+0041, 한글 '가'를 U+AC00, 이모티콘 '?'를 U+1F60A로 인코딩
--아스키는 7비트를 사용하여 총 128개의 문자를 표현하는 반면 유니코드는 최대 1,114,112개의 문자를 표현

--ASCII 인코딩:
--문자 'A' -> 65 (10진수) -> 01000001 (2진수)
--문자 'B' -> 66 (10진수) -> 01000010 (2진수)

--유니코드(UTF-8) 인코딩: 
--문자 'A' -> U+0041 -> 41 (16진수) -> 01000001 (2진수, ASCII와 동일)
--문자 '가' -> U+AC00 -> EC 95 80 (16진수) -> 11101100 10010101 10000000 (2진수)

--CLOB: CLOB은 일반적으로 데이터베이스의 기본 문자 집합(예: ASCII, LATIN1 등)을 사용하여 텍스트 데이터를 저장. 
--이 때문에 주로 영어와 같은 단일 바이트 문자로 이루어진 텍스트를 저장하는 데 사용.
--NCLOB: NCLOB은 유니코드(UTF-16)를 사용하여 텍스트 데이터를 저장. 따라서 다국어 지원이 필요할 때, \
--즉 다양한 언어로 구성된 텍스트 데이터를 저장할 때 적합. 다국어 문자가 포함된 데이터를 효율적으로 처리할 수 있다.

-- AUTHOR 테이블 생성
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

-- 테이블 제약 조건 수정,추가, 속성 추가, 삭제, 수정
alter table newbook modify (isbn varchar2(50));

delete from newbook;
alter table newbook add author_id number;
alter table newbook drop column author_id;
alter table newbook drop column published_date;
select * from newbook;

desc newbook;










