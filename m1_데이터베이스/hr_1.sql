select * from employees;

-- rownum 
--최하위 연봉
select *
from (select * 
from employees
order by salary)
where rownum = 1;

--최상위 연봉 3명
select *
from (
select * 
from employees
order by salary desc)
where rownum <= 3;

--
-- Q 사번이 120번인 사람의 사번, 이름, 업무, 업무명 출력
select e.employee_id 사번, e.first_name 이름, e.last_name 성, e.job_id 업무, j.job_title 업무명
from employees e
inner join jobs j on e.job_id = j.job_id
where e.employee_id = 120;


-- frist_name || ' ' || last_name as 이름 : 공백으로 연결하여 합치고, 별칭을 이름으로 지정
select first_name || ' ' || last_name as 이름
from employees
where employee_id = 120;


-- join말고 where절로 연결
select employee_id 사번,
first_name || ' ' || last_name as 이름,
j.job_id 업무,
j.job_title 업무명
from employees e, jobs j
where e.employee_id = 120
and e.job_id = j.job_id;

-- 2005년 상반기에 입사한 사람들의 이름(full name)만 출력

select * from employees;

select 
first_name || ' ' || last_name as 이름,
hire_date 입사일
from employees
where to_char(hire_date,'yy/mm') between '05/01' and '05/06';



-- _을 와일드 카드가 아닌 문자로 취급하고 싶을 때 escape 옵션을 사용
select * from employees where job_id like '%\_A%';
select * from employees where job_id like '%\_A%' escape '\';
select * from employees where job_id like '%#_A%' escape '#';

-- in : or 대신 사용
select * from employees where manager_id = 101 or manager_id = 102 or manager_id = 103;
select * from employees where manager_id in (101,102,103);

select * from employees;

-- 업무 sa_man, it_prog, st_man 인 사람만 출력
select * 
from employees
where job_id in ('SA_MAN', 'IT_PROG', 'ST_MAN');


-- is null / is not null
-- null 값인지를 확인할 경우 = 비교 연산자를 사용하지 않고 is null을 사용
select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;


--desc 내림차순, acs 내림차순

-- mod 나머지
select * from employees where mod(employee_id,2) = 1; -- id가 홀수인 것만 출력
select mod(10,3) from dual; -- 10 % 3의 나머지 값 1

--round()반올림
select round(355.5342) from dual;
select round(355.9555,2) from dual;
select round(355.95555,-2) from dual;

-- trunc() 버림함수, 지정한 자리수 이하 버림
select trunc(45.555,1) from dual;

--ceil() 올림함수, 자리 지정x
select ceil(45.222) from dual;

-- Q. hr.employees 테이블에서 이름, 급여, 10% 이상된 급여를 출력
select last_name 이름, salary 급여, salary * 1.1 "인상된 급여"
from employees;


--Q. employee_id가 홀수인 직원의 employee_id 와 last_name을 출력하세요
select employee_id "직원 ID", last_name 이름
from employees
where mod(employee_id,2) = 1;

select employee_id 사원번호, last_name 이름
from employees
where employee_id in (select employee_id from employees where mod(employee_id,2) = 1);

commit;

-- Q. employees 테이블에서 commission_pct의 null값 갯수를 출력
select count(*) from employees where commission_pct is null;

-- Q. employees 테이블에서 department_id가 없는 직원을 추출하여 position을 신입으로 출력하세요 position 열을 추가

select nvl(department_id, '신입')
from employees;

select employee_id, first_name ||' '|| last_name 이름, '신입' position
from employees
where department_id is null;

select employee_id, first_name ||' '|| last_name 이름, '신입' position
from employees;

-- 근무한 날짜 계산
select last_name, round(sysdate-hire_date) 근무기간 from employees;


-- add_months() 특정 개월 수를 더한 날짜를 구한다
select last_name, hire_date, add_months(hire_date,6) revised_date
from employees;

-- last_day() 해당 월의 마지막 날짜를 반환하는 함수
select last_name, hire_date, last_day(hire_date) from employees;

--hire_date 다음달의 마지막 날짜 반환
select last_name, hire_date, add_months(last_day(hire_date),1)
from employees;

--next_day() 해당 날짜를 기준으로 다음에 오는 요일에 해당하는 날짜를 반환
-- 일~토, 1~7로 표현가능
select hire_date, next_day(hire_date,'월')
from employees;

select hire_date, next_day(hire_date,2)
from employees;


--months_between() 날짜와 날짜 사이의 개월수를 구한다(개월 수를 소수점 첫째 자리까지 반올림)
select hire_date, round(months_between(sysdate, hire_date),1)
from employees;

commit;

--형 변환 함수 : to_date() 문자열을 날짜로
-- '2023-01-01' 이라는 문자열을 날짜 타입으로 변환
select to_date('2023-01-01','yyyy-mm-dd')
from dual;

-- to_char(날짜) 날짜를 문자로 변환
select to_char(sysdate, 'yy/mm/dd')
from dual;

select to_char(sysdate, 'yyyy/mon/day')
from dual;

select to_char(sysdate, 'yyyy/mm/dd d day dy pm hh hh24 mi ss')
from dual;

--형식
--YYYY       네 자리 연도
--YY      두 자리 연도
--YEAR      연도 영문 표기
--MM      월을 숫자로
--MON      월을 알파벳으로
--DD      일을 숫자로
--DAY      요일 표현
--DY      요일 약어 표현
--D      요일 숫자 표현
--AM 또는 PM   오전 오후
--HH 또는 HH12   12시간
--HH24      24시간
--MI      분
--SS      초

--현재 날짜(sysdate)를 'yyyy/mm/dd' 형식의 문자열로 변환하세요
select to_char(sysdate, 'yyyy/mm/dd') 날짜
from dual;

-- Q. '01-01-2023'이라는 문자열을 날짜 타입으로 변환하세요
select to_date('01-01-2023', 'dd-mm-yyyy')
from dual;

-- Q. 현재 날짜와 시간을 'yyy-mm-dd hh24:mi:ss' 형식의 문자열로 변환하세요
select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
from dual;

-- Q. '2023-01-01 15:30:00'이라는 문자열을 날짜 및 시간 타입으로 변환하세요
select to_date('2023-01-01 15:30:00', 'yyyy-mm-dd hh24:mi:ss')
from dual;

--to_char( 숫자 )   숫자를 문자로 변환
--9      한 자리의 숫자 표현      ( 1111, ‘99999’ )      1111   
--0      앞 부분을 0으로 표현      ( 1111, ‘099999’ )      001111
--$      달러 기호를 앞에 표현      ( 1111, ‘$99999’ )      $1111
--.      소수점을 표시         ( 1111, ‘99999.99’ )      1111.00
--,      특정 위치에 , 표시      ( 1111, ‘99,999’ )      1,111
--MI      오른쪽에 - 기호 표시      ( 1111, ‘99999MI’ )      1111-
--PR      음수값을 <>로 표현      ( -1111, ‘99999PR’ )      <1111>
--EEEE      과학적 표현         ( 1111, ‘99.99EEEE’ )      1.11E+03
--V      10을 n승 곱한값으로 표현   ( 1111, ‘999V99’ )      111100
--B      공백을 0으로 표현      ( 1111, ‘B9999.99’ )      1111.00
--L      지역통화         ( 1111, ‘L9999’ )

select salary, to_char(salary, '099999')
from employees;

select salary, to_char(-salary, '9999999mi')
from employees;

--과학적 표기법
select to_char(11111,'9.999eeee') from dual;

select to_char(-1111111,'9999999mi') from dual;

--width_bucket() 지정값,최소값,최대값,bucket개수 => 분할함수
select width_bucket(90,0,100,10) from dual;
select width_bucket(100,0,100,10) from dual;

select max(salary) max, min(salary) min
from employees;

-- 24001은 포함이 안된다 24000까지
select salary, width_bucket(salary, 2100,24001,5) as grade
from employees;

--문자함수 character function
-- upper() 대문자로 변경
select upper('Hello world') from dual;
--lower() 소문자로 변경
select lower('HELLO world') from dual;

-- Q. last name이 seo인 직원의 last_name과 salary를 구하세요(seo,SEO,Seo모두 검출)
select last_name, salary
from employees
where lower(last_name) = 'seo';

select last_name, salary
from employees
where upper(last_name) = 'SEO';

--initcap() 첫글자만 대문자
select job_id, initcap(job_id)
from employees;

--length() 문자열의 길이
select job_id, length(job_id)
from employees;

--인덱스 시작 1부터
--instr() 문자열, 찾을 문자, 찾을 위치(시작 위치), 찾은 문자 중 몇번째에 있는지
select instr('Hello World','o',3,2)
from dual;

select instr('Hello World','l',3,2)
from dual;

select instr('Hello World','o',3)
from dual;

--substr() 문자열, 시작위치, 개수
select substr('Hello World',3,3)
from dual;

select substr('Hello World',-3,3)
from dual;

select substr('Hello World',-5,2)
from dual;

--lpad() 오른쪽 정렬 후 왼쪽에 문자를 채운다
select lpad('Hello World', 20,'#')
from dual;

select lpad('Hello World', 20,0)
from dual;

--rpad() 왼쪽 정렬 후 오른쪽에 문자를 채운다
select rpad('Hello World', 20,'#')
from dual;

--ltrim()
select ltrim('aaaHello Worldaaa','a')
from dual;

--rtrim()
select rtrim('aaaHello Worldaaa','a')
from dual;

select last_name 이름, ltrim(last_name,'A') as 변환
from employees;

--trim()
select trim( '            Hello World                    ')
from dual;

select last_name, trim('A' from last_name)
from employees;

commit;

-- 현재 hr에 있는 7개 테이블을 불석해서 인사관리에 의미 있는 인사이트 5개 이상을 기술
-- 인사관리 개선을 위한 KPI 2개를 설정하고 이것들을 테이블들의 데이터에 반영한 후 다시 분석해 반영 여부를 검증

-- 1. 장기 근속 10명에게 급여 10% 인상

select 이름, salary "현재 급여", salary *1.1 "인상된 급여"
from (
select first_name || ' ' || last_name 이름 ,
round((sysdate-hire_date)) "근무한 일수",
salary
from employees
order by round((sysdate-hire_date),2) desc)
where rownum <= 10;


-- 퇴사가 가장 많은 부서 급여 5% 인하



----------------------------------------------------------------

-- nvl()
select last_name, manager_id,
nvl(to_char(manager_id),'CEO') revised_id from employees;


--decode()    if문이나 case문과 같이 여러 경우를 선택할 수 있도록 하는 함수
--DECODE 함수는 단순한 조건에 기반하여 값을 반환합니다. 구문은 DECODE(expression, search1, result1, ..., searchN, resultN, default) 
--여기서 expression은 검사할 값을 나타내고, search와 result는 각각 조건과 해당 조건이 참일 때 반환할 값
--default는 모든 search 조건이 거짓일 때 반환할 기본 값 출력


select last_name, department_id,
decode(department_id,
90, '경영 지원실',
60, '프로그래머',
100, '인사부' , '기타' ) 부서
from employees;

-- Q. employees 테이블에서 commission_pct가 null이 아닌 경우, 'A' null인경우 'N'을 표시하는 쿼리를 작성

select commission_pct as commission
, decode(commission_pct, null, 'N' ,'A') as 변환
from employees
order by 변환 desc;


--case()
--decode() 함수와 유사하나 decode() 함수는 단순한 조건 비교에 사용되는 반면
--case() 함수는 다양한 비교연산자로 조건을 제시할 수 있다.
--CASE 문은 조건에 따라 다른 값을 반환하는 데 사용되며, DECODE보다 복잡한 조건을 표현할 수 있다. 
--구문은 CASE WHEN condition THEN result ... ELSE default END이다. 

select last_name, department_id,
case when department_id = 90 then '경영지원실'
when department_id = 60 then '프로그래머'
when department_id = 100 then '인사부'
else '기타'
end as 소속
from employees;


-- Q. employees 테이블에서 salary가 20000 이상이면 'a', 10000과 20000미만 사이면 'b', 그 이하면 'c'로
--표시하는 쿼리를 작성

select last_name, salary,
case
when salary >= 20000
then 'a'
when salary > 10000 and salary <20000 
then 'b'
else 'c'
end as 등급
from employees;


--Concatenation : 콤마 대신에 사용하면 문자열이 연결되어 출력
select last_name, 'is a', job_id
from employees;

select last_name || ' is a ' || job_id
from employees;

-- 집합
-- UNION(합집합) INTERSECT (교집합) MINUS (차집합) UNION ALL (겹치는 것까지 포함)
-- 두개의 쿼리문을 사용해야하며 데이터 타입을 일치시켜야 한다

select first_name 이름, salary 급여
from employees
union
select first_name 이름, salary 급여
from employees
where hire_date < '99/01/01';


select first_name 이름, salary 급여, hire_date
from employees
where salary < 5000
minus
select first_name 이름, salary 급여, hire_date
from employees
where hire_date < '99/01/01';


select first_name 이름, salary 급여, hire_date
from employees
where salary < 5000
intersect
select first_name 이름, salary 급여, hire_date
from employees
where hire_date < '99/01/01';



select first_name 이름, salary 급여, hire_date
from employees
where salary < 5000
union all
select first_name 이름, salary 급여, hire_date
from employees
where hire_date < '99/01/01';

commit;


--CREATE VIEW 명령어는 오라클 SQL에서 테이블의 특정 부분이나 조인된 결과를 논리적인 뷰(view)로 만들 때 사용
--뷰는 데이터를 요약하거나 복잡한 조인을 단순화하며, 사용자에게 필요한 데이터만을 보여주는 데 유용
--뷰는 실제 테이블 데이터를 저장하지 않고, 대신 쿼리문 자체를 저장
--뷰의 주요 특징
--쿼리 단순화: 복잡한 쿼리를 뷰로 저장함으로써 사용자는 복잡한 쿼리문을 반복해서 작성할 필요 없이 간단하게 뷰를 참조할 수 있다.
--데이터 추상화: 뷰는 기본 테이블의 구조를 숨기고 사용자에게 필요한 데이터만을 보여줄 수 있어, 데이터 추상화를 제공.
--보안 강화: 뷰를 사용하면 특정 데이터에 대한 접근을 제한할 수 있으며, 사용자가 볼 수 있는 데이터의 범위를 제어할 수 있다.
--데이터 무결성 유지: 뷰를 사용하여 데이터를 수정하더라도, 이 변경사항이 기본 테이블의 데이터 무결성 규칙을 위반하지 않도록 관리할 수 있다.

create view employee_details as
select employee_id, last_name, department_id
from employees;


select * from employee_details;

-- Q. employees 테이블에서 salary가 10000원 이상인 직원만을 포함하는 뷰
--special_employee를 생성하는  sql 명령문을 작성하시오오

create view special_employee as
select *
from employees
where salary >= 10000;

select * from special_employee;

select * from employees;
--Q. employees  테이블에서 각 부서별 직원 수를 포함하는 뷰를 생성

create view count_employee as
select department_id, count(*) as "부서 별 직원 수"
from employees
group by department_id;

select * from count_employee;

--Q. employees 테이블에서 근속 기간이 10년 이상인 직원을 포함하는 뷰를 생성

create table date_employee as
select *
from employees
where mod((sysdate-hire_date),365) >= 10;
-- trunc(sysdate-hire_date) > 365 * 10

select * from date_employee;


--TCL (Transaction Control Language)
--COMMIT: 현재 트랜잭션 내에서 수행된 모든 변경(INSERT, UPDATE, DELETE 등)을 데이터베이스에 영구적으로 저장.
--COMMIT 명령을 실행하면, 트랜잭션은 완료되며, 그 이후에는 변경 사항을 되돌릴 수 없다.
--ROLLBACK: 현재 트랜잭션 내에서 수행된 변경들을 취소하고, 데이터베이스를 트랜잭션이 시작하기 전의 상태로 되돌린다. 
--오류가 발생했거나 다른 이유로 트랜잭션을 취소해야 할 경우에 사용된다.
--SAVEPOINT: 트랜잭션 내에서 중간 체크포인트를 생성합니다. 오류가 발생할 경우, ROLLBACK을 사용하여 최근의 SAVEPOINT까지 되돌릴 수 있다.
--트랜잭션을 콘트롤하는 TCL(TRANSACTION CONTROL LANGUAGE)

drop table members;

create table members(
member_id number primary key,
name varchar2(100),
email varchar2(100),
join_date date,
status varchar2(20)
);

INSERT INTO members (member_id, name, email, join_date, status) VALUES (1, 'John Doe', 'john@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (2, 'Jane Doe', 'jane@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (3, 'Mike Smith', 'mike@example.com', SYSDATE, 'Inactive');


select * from members;

INSERT INTO members (member_id, name, email, join_date, status) VALUES (4, 'Alice Johnson', 'alice@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (5, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');

INSERT INTO members (member_id, name, email, join_date, status) VALUES (6, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');

savepoint sp1;


INSERT INTO members (member_id, name, email, join_date, status) VALUES (7, 'Bob kim', 'bob@example.com', SYSDATE, 'Inactive');

rollback to sp1;

commit;

select * from members;

--Task1_0523. 
--orders라는 테이블을 생성하고, order_id, customer_id, order_date, amount, status라는 속성을 설정하세요.
--데이터를 5개 입력하세요.
--입력한 데이터 중 2개를 수정하세요.
--수정한 데이터를 취소하기 위해 롤백을 사용하세요.
--3개의 새로운 데이터를 입력하고, 그 중 마지막 데이터 입력만 취소한 후 나머지를 커밋하세요.

create table orders(
order_id number,
customer_id number,
order_date date,
amount number,
status varchar2(30)
);

insert into orders values (1,10,'2024-04-20',233, 'shipping');
insert into orders values (2,20,'2024-03-27',26, 'finish');
insert into orders values (3,30,'2024-03-24',37, 'shipping');
insert into orders values (4,40,'2024-04-15',667, 'release');
insert into orders values (5,50,'2024-03-29',373, 'finish');

savepoint or2;

select * from orders;

update orders set amount = 45
where order_id = 1;

update orders set status = 'finish'
where customer_id = 30;

rollback to or2;

select * from orders;

insert into orders values (6,60,'2024-05-20',88, 'shipping');
insert into orders values (7,70,'2024-04-27',67, 'finish');

savepoint or3;

insert into orders values (8,80,'2024-04-24',57, 'finish');

rollback to or3;
commit;

select * from orders;
-- 데이터 무결성을 위해 department_id가 없는 사람에게 job_id에 맞는 department_id를 부여해주려고함
--1. null인 사람 찾기
select *
from employees
where department_id is null;

-- 1-1 수정전 savepoint

--2. job_id가 SA_REP인 id찾기 직업에 맞는 부서 찾기
select job_id, department_id
from job_history
where job_id in 'SA_REP';


--3. 수정

----------------------------------------------------------------------
--부서별 급여 현황
--테이블생성, 부서별 급여와 총 급여를 확인 할 수 있음.
--(급여의 합 평균 최솟값 최댓값, 총 직원수, 급여전체총합, 직원평균급여, 부서평균급여)
--table 만들기 부서별 급여를 대략적으로 보기
--사용할 테이블 확인
select * from jobs;
select * from departments;
select * from employees;
select * from job_history;

--부서 목록 확인
SELECT department_id
from employees
group by department_id
order by department_id DESC;
-- 부서 목록 department_id : 10,20,30,40,50,60,70,80,90,100,110 그 외 나머지(120~200등..)는 없고 null 값이 있음.
--department_id 가 null 인 사람은 모두 job_id 에 맞는 department_id 를 부여해주려고함(데이터 무결성)
--1. department_id 가 null 값인 사람 찾기
select *
from employees
where department_id IS NULL;
--한명 밖에 없음. department_id : null, employee_id : 178, Job_id : SA_REP

--2. job_id 가 SA_REP 인 department_id 찾기 (직업에 맞는 부서 찾기)
select job_id, department_id
from job_history
where job_id IN 'SA_REP';
--SA_REP 의 department_id 는 80

--3. 수정 전 savepoint 생성
SAVEPOINT null_to_80;
------------------------SAVEPOINT---------------------------------

--4. 제약조건primary key 인 employee_id 로 찾아서 derpartment_id 를 80으로 수정
UPDATE employees
SET department_id = 80
WHERE employee_id = 178;

select * from employees where employee_id = 178;
--ROLLBACK null_to_80; -- savepoint로 가기
--commit;
--수정끝

--각 부서마다 팀원은 몇명이고 어떤 포지션들이 있고 구성은 어떻게 되는지
--rollup은 다차원적인 집계 결과를 도출 : 사용 각 부서 및 직무별 직원 수를 집계

select e.department_id, d.department_name, nvl(e.job_id, 'total') job_id, count(*) 직원수
from employees e
left outer join departments d
on e.department_id = d.department_id
group by rollup((e.department_id,d.department_name),e.job_id)
order by e.department_id;


-- job_id 별 몇년차는 얼마 받는지 각 년차별로 샐러리 평균
select job_id, 연차, round(avg(salary)) 평균급여
from (
select job_id, floor(months_between(sysdate, hire_date)/12) as 연차,
salary
from employees)
group by job_id, 연차
order by job_id, 연차;

commit;


