
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
--DATE 타입은 날짜와 시간을 YYYY-MM-DD HH24:MI:SS 형식으로 저장합니다.
--예를 들어, 2024년 5월 20일 오후 3시 45분 30초는 2024-05-20 15:45:30으로 저장
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

commit;


-- on delete cascade 옵션이 설정되어 있어, newcustomer 테이블에서 어떤 고객의 레코드가 삭제되면, 해당 고객의 모든 주문이
--neworders 테이블에서도 자동으로 삭제
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


insert into newcustomer values(1,'KEVIN','역삼동','010-1234-1234');
insert into neworders values(10,1,100,1000,sysdate);
select * from newcustomer;
select * from neworders;
delete from newcustomer;

desc neworders;

desc newcustomer;

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
--체크 제약조건(C##MD.SYS_C007365)이 위배되었습니다 -> 오류발생


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

select * from animal;
select * from animal_employee;


alter table animal add animal_class varchar(30);
alter table animal modify animal_class number;

desc animal;

alter table animal drop column animal_class;

-- 원하는 데이터만 삭제하기
-- ex)
delete animal
where animalid = 1;


delete from animal;
--Task2_0520. Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.

select * from customer;

update customer set address = (select address from customer where name = '김연아')
where name = '박세리';


update customer set address = '대한민국 부산'
where name = '박세리';

-- 절댓값
select abs(-30), abs(30)
from dual;
--반올림
select round(4.532,1)
from dual;

-- 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오
-- 백원 단위이므로 '-' 사용
select custid as 고객번호, round(avg(saleprice),-2) as 평균주문금액
from orders
group by custid
order by 고객번호;

--Task3_0520.도서 제목에 ‘야구’가 포함된 도서를 ‘농구’로 변경한 후 도서 목록, 가격을 보이시오.
select * from book;

update book set bookname = '농구'
where bookname like '%야구%';

select bookname, price
from book;
commit;

update book set bookname = '야구를 부탁해'
where bookid =8 ;


-- 테이블 변경 x / 조회만
select bookid, replace(bookname, '야구','농구') bookname, publisher, price
from book;

-- Q. '굿스포츠'에서 출판한 도서의 제목과 제목의 글자 수, 바이트 수를 보이시오
select bookname 제목, length(bookname) 글자수, lengthb(bookname) 바이트수
from book
where publisher = '굿스포츠';

--Task4_0520. 마당서점의 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.

select substr(name,1,1) 성, count(*) 인원
from customer
group by substr(name,1,1);

select * from customer;
--Task5_0520. 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.

select orderdate+10 "주문 확정 일자"
from orders;

-- 2개월 후 매출 확정
select orderdate,orderdate + 62
from orders;

-- add_months 함수 활용
select orderid, orderdate as 주문일,
add_months(orderdate,2) as 확정일자
from orders;

--Task6_0520.마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오. 
--단 주문일은 ‘yyyy-mm-dd 요일’ 형태로 표시한다.
select orderid, orderdate, custid, bookid
from orders
where orderdate = to_date('2020-07-07','yyyy-mm-dd');

select orderid 주문번호 , to_char(orderdate,'yyyy-mm-dd day') 주문일
from orders

--오라클에서는 문자열을 DATE로 자동 변환하여 비교
--where orderdate = '2020-07-07';
where orderdate = to_date('20/07/07','yy/mm/dd');
--where orderdate = to_date('20/07/24','dd/mm/yy');

--Task7_0520. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.
desc orders;

select * from orders;

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

--학교 관리를 위하여 테이블 2개 이상ㄷ으로 db를 구축하고 3개 이상 활용할 수 있는 case를 만드세요
--학생 테이블
-- 성적, 과목

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
VALUES (1910101, 1, 4.0, 4.3, '세계사', '국어국문학과', '사회봉사 동아리');

INSERT INTO student_manage
VALUES (2020202, 2, 3.8, 4.5, '세계사', '영어영문학과', '토론 동아리');

INSERT INTO student_manage
VALUES (2130303, 3, 4.5, 4.4, '경제학', '수학과', '프로그래밍 동아리');

INSERT INTO student_manage
VALUES (1940404, 4, 3.9, 4.2, '경제학', '물리학과', '스포츠 동아리');

INSERT INTO student_manage
VALUES (2050505, 5, 4.2, 4.1, '세계사', '역사학과', '학술 동아리');

INSERT INTO student_manage
VALUES (2160606, 6, 4.1, 4.5, '음악이론', '음악학과', '창작의 세계');

INSERT INTO student_manage
VALUES (2270707, 7, 4.4, 4.3, '심리학 기초', '심리학과', '국제문화 동아리');

INSERT INTO student_manage
VALUES (2280808, 8, 4.3, 4.4, '환경과학', '체육학과', '클라이밍 동아리');

INSERT INTO student_manage
VALUES (2190909, 9, 4.5, 4.0, '경제학', '경제학과', '경영 동아리');

INSERT INTO student_manage
VALUES (2001010, 10, 4.0, 4.5, '심리학 기초', '심리학과', '사회 봉사 동아리');


select * from student_manage;

select onesemester+twosemester as 성적
from student_manage;

select substr(student_id,1,2) as 학번 ,count(*) 명수, sum(onesemester+twosemester) 학번별성적
from student_manage
group by substr(student_id,1,2);


--
select * from student_info;
select * from student_manage;
--

-- 장학금을 받을 수 있는 학생의 이름을 구하세요(최대 3명)
-- 조건 : 1,2학기 성적이 4점이 넘고 전체 평균학점이 4.2이상인 학생에게 장학금 수여

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


-- 2. 기숙사 합격이 가능한 학생의 이름과 학번을 구하세요
-- 조건 : 타지역 학생이면서 + 성적이 가장 높은 3명

select student_id as 학번
from student_manage
where student_id in
(select student_id from student_info where regional = 'y')
group by student_id
order by (avg(onesemester+twosemester)/2) desc;

select student_id as 학번, name as 이름
from student_info
where student_id in (select student_id
from student_manage
where regional = 'y');

select i.name as 이름, i.student_id as 학번, avg(m.onesemester+m.twosemester)/2 as 평균학점
from student_info i inner join student_manage m
on i.student_id = m.student_id
where i.regional = 'y'
group by i.name, i.student_id
order by (avg(m.onesemester+m.twosemester)/2) desc;

select i.name as 이름, i.student_id as 학번
from (select rownum, i.name, i.student_id
    from (
    select i.name as 이름, i.student_id as 학번, avg(m.onesemester+m.twosemester)/2 as 평균학점
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

-- 학생 교수 강의 성적

--학생 테이블
create table student_info(
student_id number primary key,
name varchar2(30) not null,
gender varchar2(30) not null,
birthdate number(8) not null,
s_phone varchar2(15) not null,
s_email varchar2(50) not null,
s_address varchar2(50) not null
);

-- 강의 테이블
create table lecture(
student_id number, -- 강의듣는 학생id
lecture_id number primary key, -- 강의 번호(수업코드)
lecture varchar2(30) not null, -- 강의이름
professor_name varchar2(30), -- 강의하는 교수이름
foreign key(student_id) references student_info(student_id)
foreign key(professor_name) references  on delete cascade
);

-- 강의실 테이블
create table class(
lecture_id number, -- 수업 코드
class_id number primary key, -- 강의실 코드
schedule date, -- 사용하는 날짜
time number, -- 사용하는 시간
student_count number, --강의 듣는 학생수
foreign key(lecture_id) references lecture(lecture_id) on delete cascade
);

-- 성적 테이블
create table student_gpa(
student_id number,
management_id number primary key,
semester1_gpa number,
semester2_gpa number,
overall_gpa number
);



-- 3. 교양을 듣는 학생이 2명 미만일 경우 교양이 폐지가 될 때 폐지가 되는 교양명을 구하세요
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
family_members number not null, -- 직계가족 수 
regional varchar2(10) not null, -- 본가가 타지역인지. 타지역: "y"
c_address varchar2(150) not null, -- 현재 학생의 거주 주소
s_mobile varchar2(15) not null, -- 학생 전화번호
e_number varchar2(15),-- 비상시 연락 번호
s_email varchar2(50) not null); -- 학생 이메일주소


insert into student_info values(
1910101, '이지은', 'f', 20000115,5,'y','서울특별시 동대문구 이문동', 
'010-1234-5678','010-0987-6543','jieun_lee@gmail.com');

INSERT INTO student_info VALUES (
2020202, '김수현', 'm', 20010515, 4, 'n', '서울특별시 강남구 논현동', 
'010-2345-6789', '010-9876-5432', 'soohyun_kim@gmail.com');

INSERT INTO student_info VALUES (
2130303, '박신혜', 'f', 20021123, 3, 'y', '서울특별시 서초구 반포동', 
'010-3456-7890', '010-8765-4321', 'shinhye_park@gmail.com');

INSERT INTO student_info VALUES (
1940404, '이민호', 'm', 20001004, 2, 'n', '서울특별시 서초구 반포동', 
'010-4567-8901', '010-7654-3210', 'minho_lee@gmail.com');

INSERT INTO student_info VALUES (
2050505, '배수지', 'f', 20000212, 5, 'y', '서울특별시 마포구 연남동', 
'010-5678-9012', '010-6543-2109', 'suzy_bae@gmail.com');

INSERT INTO student_info VALUES (
2160606, '송중기', 'm', 20020722, 3, 'n', '서울특별시 마포구 연남동', 
'010-6789-0123', '010-5432-1098', 'joongki_song@gmail.com');

INSERT INTO student_info VALUES (
2270707, '송혜교', 'f', 20020417, 4, 'y', '서울특별시 용산구 이태원동', 
'010-7890-1234', '010-4321-0987', 'hyekyo_song@gmail.com');

INSERT INTO student_info VALUES (
2280808, '박공유', 'm', 20000110, 6, 'y', '경기도 고양시 일산서구 대화동', 
'010-8901-2345', '010-3210-9876', 'gong_yoo_p@gmail.com');

INSERT INTO student_info VALUES (
2190909, '전지현', 'f', 20011220, 3, 'y', '경기도 성남시 분당구 정자동', 
'010-9012-3456', '010-2109-8765', 'jihyun_jun@gmail.com');

INSERT INTO student_info VALUES (
2001010, '박보검', 'm', 19990616, 5, 'n', '서울특별시 종로구 혜화동', 
'010-0123-4567', '010-1098-7654', 'bogum_park@gmail.com');



--

-- 현재 날짜와 시간, 요일 확인
select sysdate, to_char(sysdate,'yyyy-mm-dd HH:MI:SS day')
from dual;

-- 전화번호가 없는 고객은 연락처 없음으로 표시
-- NVL함수(값, 지정값)
select name 이름, nvl(phone, '연락처 없음') 전화번호
from customer;




