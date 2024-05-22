-- Tast1_0520. 10개의 속성으로 구성되는 테이블 2개를 작성 단 foreign key를 사용하여 한쪽 테이블의 데이터를 삭제 시 다른 테이블의
-- 관련되는 데이터도 모두 삭제되도록 하세요(모든 제약조건을 사용)
-- 단 각 테이블에 5개의 데이터를 입력하고 두번재 테이블에 첫번재 데이터를 참조하고 있는 속성을 선택하여 데이터 삭제
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

insert into animal values(1,1,10,'콩',12,3,'f','고양이','검정',to_date('2000-04-10','yyyy-mm-dd'));
insert into animal(animalid,animaltag,age,name,heigth,species,color,born)
values(2,3,12,'무',11,'호랑이','노랑',to_date('2010-04-10','yyyy-mm-dd'));
insert into animal values(3,4,14,'zh',24,3,'m','치타','갈색',to_date('2010-06-8','yyyy-mm-dd'));
insert into animal values(4,6,4,'an',15,3,'m','강아지','흰색',to_date('2021-09-15','yyyy-mm-dd'));
insert into animal values(5,8,8,'rk',18,3,'f','토끼','분홍',to_date('2009-11-10','yyyy-mm-dd'));

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

insert into animal_employee values (1,1,'홍길동','f',to_date('2000-03-04','yyyy-mm-dd'),45,160,'서울','서대문구','010-1234-1566');

--ALTER TABLE {테이블명} ADD CONSTRAINT {제약조건명} {제약조건}
-- 제약조건 변경
alter table animal_employee
add constraint check_employee check (startdate >= to_date('2000-01-01','yyyy-mm-dd'));

-- 제약조건 변경
--alter table 테이블명 modify (컬럼명 제약조건)

drop table animal_employee;
insert into animal_employee values (1,1,'홍길동','f',to_date('2019-03-04','yyyy-mm-dd'),45,160,'서울','서대문구','010-1234-1566');
insert into animal_employee values (2,2,'짱구','m',to_date('2012-03-19','yyyy-mm-dd'),55,167,'인천','동구','010-3554-12526');
insert into animal_employee values (3,3,'철수','m',to_date('2013-10-15','yyyy-mm-dd'),60,187,'경기도','의정부','010-3224-1226');
insert into animal_employee values (4,3,'유리','f',to_date('2016-02-23','yyyy-mm-dd'),32,151,'서울','용산구','010-1235-1256');
insert into animal_employee values (5,5,'맹구','m',to_date('2017-11-12','yyyy-mm-dd'),68,177,'경기도','오산','010-2143-1246');


alter table animal add animal_class varchar(30);
alter table animal modify animal_class number;
alter table animal drop column animal_class;


--Task2_0520. Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.

update customer set address = (select address from customer where name = '김연아')
where name = '박세리';


--Task3_0520.도서 제목에 ‘야구’가 포함된 도서를 ‘농구’로 변경한 후 도서 목록, 가격을 보이시오.

update book set bookname = '농구'
where bookname like '%야구%';

-- 테이블 변경 x / 조회만
select bookid, replace(bookname, '야구','농구') bookname, publisher, price
from book;


--Task4_0520. 마당서점의 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.

select substr(name,1,1) 성, count(*) 인원
from customer
group by substr(name,1,1);


--Task5_0520. 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.

select orderdate+10 "주문 확정 일자"
from orders;

--Task6_0520.마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오. 
--단 주문일은 ‘yyyy-mm-dd 요일’ 형태로 표시한다.
select orderid, orderdate, custid, bookid
from orders
where orderdate = to_date('2020-07-07','yyyy-mm-dd');

select orderid 주문번호 , to_char(orderdate,'yyyy-mm-dd day') 주문일
from orders;


--오라클에서는 문자열을 DATE로 자동 변환하여 비교
--where orderdate = '2020-07-07';
where orderdate = to_date('20/07/07','yy/mm/dd');
--where orderdate = to_date('20/07/24','dd/mm/yy');

--Task7_0520. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.

select orderid, saleprice
from orders 
where saleprice < (select avg(saleprice) from orders)
order by orderid;

select o1.orderid, o1.saleprice
from orders o1
where o1.saleprice < (select avg(o2.saleprice) from orders o2);

-- 서브쿼리를 o2라는 별칭으로 지정, saleprice의 평균 값을 avg_saleprice로 계산
select o1.orderid, o1.saleprice
from orders o1
join (select avg(saleprice) as avg_saleprice from orders) o2
on o1.saleprice < o2.avg_saleprice;


--Task8_0520. 대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.

select sum(saleprice) as 총판매액
from orders
where custid in (select custid from customer where address like '%대한민국%');

