select * from employees;

-- rownum 
--������ ����
select *
from (select * 
from employees
order by salary)
where rownum = 1;

--�ֻ��� ���� 3��
select *
from (
select * 
from employees
order by salary desc)
where rownum <= 3;

--
-- Q ����� 120���� ����� ���, �̸�, ����, ������ ���
select e.employee_id ���, e.first_name �̸�, e.last_name ��, e.job_id ����, j.job_title ������
from employees e
inner join jobs j on e.job_id = j.job_id
where e.employee_id = 120;


-- frist_name || ' ' || last_name as �̸� : �������� �����Ͽ� ��ġ��, ��Ī�� �̸����� ����
select first_name || ' ' || last_name as �̸�
from employees
where employee_id = 120;


-- join���� where���� ����
select employee_id ���,
first_name || ' ' || last_name as �̸�,
j.job_id ����,
j.job_title ������
from employees e, jobs j
where e.employee_id = 120
and e.job_id = j.job_id;

-- 2005�� ��ݱ⿡ �Ի��� ������� �̸�(full name)�� ���

select * from employees;

select 
first_name || ' ' || last_name as �̸�,
hire_date �Ի���
from employees
where to_char(hire_date,'yy/mm') between '05/01' and '05/06';



-- _�� ���ϵ� ī�尡 �ƴ� ���ڷ� ����ϰ� ���� �� escape �ɼ��� ���
select * from employees where job_id like '%\_A%';
select * from employees where job_id like '%\_A%' escape '\';
select * from employees where job_id like '%#_A%' escape '#';

-- in : or ��� ���
select * from employees where manager_id = 101 or manager_id = 102 or manager_id = 103;
select * from employees where manager_id in (101,102,103);

select * from employees;

-- ���� sa_man, it_prog, st_man �� ����� ���
select * 
from employees
where job_id in ('SA_MAN', 'IT_PROG', 'ST_MAN');


-- is null / is not null
-- null �������� Ȯ���� ��� = �� �����ڸ� ������� �ʰ� is null�� ���
select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;


--desc ��������, acs ��������

-- mod ������
select * from employees where mod(employee_id,2) = 1; -- id�� Ȧ���� �͸� ���
select mod(10,3) from dual; -- 10 % 3�� ������ �� 1

--round()�ݿø�
select round(355.5342) from dual;
select round(355.9555,2) from dual;
select round(355.95555,-2) from dual;

-- trunc() �����Լ�, ������ �ڸ��� ���� ����
select trunc(45.555,1) from dual;

--ceil() �ø��Լ�, �ڸ� ����x
select ceil(45.222) from dual;

-- Q. hr.employees ���̺��� �̸�, �޿�, 10% �̻�� �޿��� ���
select last_name �̸�, salary �޿�, salary * 1.1 "�λ�� �޿�"
from employees;


--Q. employee_id�� Ȧ���� ������ employee_id �� last_name�� ����ϼ���
select employee_id "���� ID", last_name �̸�
from employees
where mod(employee_id,2) = 1;

select employee_id �����ȣ, last_name �̸�
from employees
where employee_id in (select employee_id from employees where mod(employee_id,2) = 1);

commit;

-- Q. employees ���̺��� commission_pct�� null�� ������ ���
select count(*) from employees where commission_pct is null;

-- Q. employees ���̺��� department_id�� ���� ������ �����Ͽ� position�� �������� ����ϼ��� position ���� �߰�

select nvl(department_id, '����')
from employees;

select employee_id, first_name ||' '|| last_name �̸�, '����' position
from employees
where department_id is null;

select employee_id, first_name ||' '|| last_name �̸�, '����' position
from employees;

-- �ٹ��� ��¥ ���
select last_name, round(sysdate-hire_date) �ٹ��Ⱓ from employees;


-- add_months() Ư�� ���� ���� ���� ��¥�� ���Ѵ�
select last_name, hire_date, add_months(hire_date,6) revised_date
from employees;

-- last_day() �ش� ���� ������ ��¥�� ��ȯ�ϴ� �Լ�
select last_name, hire_date, last_day(hire_date) from employees;

--hire_date �������� ������ ��¥ ��ȯ
select last_name, hire_date, add_months(last_day(hire_date),1)
from employees;

--next_day() �ش� ��¥�� �������� ������ ���� ���Ͽ� �ش��ϴ� ��¥�� ��ȯ
-- ��~��, 1~7�� ǥ������
select hire_date, next_day(hire_date,'��')
from employees;

select hire_date, next_day(hire_date,2)
from employees;


--months_between() ��¥�� ��¥ ������ �������� ���Ѵ�(���� ���� �Ҽ��� ù° �ڸ����� �ݿø�)
select hire_date, round(months_between(sysdate, hire_date),1)
from employees;

commit;

--�� ��ȯ �Լ� : to_date() ���ڿ��� ��¥��
-- '2023-01-01' �̶�� ���ڿ��� ��¥ Ÿ������ ��ȯ
select to_date('2023-01-01','yyyy-mm-dd')
from dual;

-- to_char(��¥) ��¥�� ���ڷ� ��ȯ
select to_char(sysdate, 'yy/mm/dd')
from dual;

select to_char(sysdate, 'yyyy/mon/day')
from dual;

select to_char(sysdate, 'yyyy/mm/dd d day dy pm hh hh24 mi ss')
from dual;

--����
--YYYY       �� �ڸ� ����
--YY      �� �ڸ� ����
--YEAR      ���� ���� ǥ��
--MM      ���� ���ڷ�
--MON      ���� ���ĺ�����
--DD      ���� ���ڷ�
--DAY      ���� ǥ��
--DY      ���� ��� ǥ��
--D      ���� ���� ǥ��
--AM �Ǵ� PM   ���� ����
--HH �Ǵ� HH12   12�ð�
--HH24      24�ð�
--MI      ��
--SS      ��

--���� ��¥(sysdate)�� 'yyyy/mm/dd' ������ ���ڿ��� ��ȯ�ϼ���
select to_char(sysdate, 'yyyy/mm/dd') ��¥
from dual;

-- Q. '01-01-2023'�̶�� ���ڿ��� ��¥ Ÿ������ ��ȯ�ϼ���
select to_date('01-01-2023', 'dd-mm-yyyy')
from dual;

-- Q. ���� ��¥�� �ð��� 'yyy-mm-dd hh24:mi:ss' ������ ���ڿ��� ��ȯ�ϼ���
select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
from dual;

-- Q. '2023-01-01 15:30:00'�̶�� ���ڿ��� ��¥ �� �ð� Ÿ������ ��ȯ�ϼ���
select to_date('2023-01-01 15:30:00', 'yyyy-mm-dd hh24:mi:ss')
from dual;

--to_char( ���� )   ���ڸ� ���ڷ� ��ȯ
--9      �� �ڸ��� ���� ǥ��      ( 1111, ��99999�� )      1111   
--0      �� �κ��� 0���� ǥ��      ( 1111, ��099999�� )      001111
--$      �޷� ��ȣ�� �տ� ǥ��      ( 1111, ��$99999�� )      $1111
--.      �Ҽ����� ǥ��         ( 1111, ��99999.99�� )      1111.00
--,      Ư�� ��ġ�� , ǥ��      ( 1111, ��99,999�� )      1,111
--MI      �����ʿ� - ��ȣ ǥ��      ( 1111, ��99999MI�� )      1111-
--PR      �������� <>�� ǥ��      ( -1111, ��99999PR�� )      <1111>
--EEEE      ������ ǥ��         ( 1111, ��99.99EEEE�� )      1.11E+03
--V      10�� n�� ���Ѱ����� ǥ��   ( 1111, ��999V99�� )      111100
--B      ������ 0���� ǥ��      ( 1111, ��B9999.99�� )      1111.00
--L      ������ȭ         ( 1111, ��L9999�� )

select salary, to_char(salary, '099999')
from employees;

select salary, to_char(-salary, '9999999mi')
from employees;

--������ ǥ���
select to_char(11111,'9.999eeee') from dual;

select to_char(-1111111,'9999999mi') from dual;

--width_bucket() ������,�ּҰ�,�ִ밪,bucket���� => �����Լ�
select width_bucket(90,0,100,10) from dual;
select width_bucket(100,0,100,10) from dual;

select max(salary) max, min(salary) min
from employees;

-- 24001�� ������ �ȵȴ� 24000����
select salary, width_bucket(salary, 2100,24001,5) as grade
from employees;

--�����Լ� character function
-- upper() �빮�ڷ� ����
select upper('Hello world') from dual;
--lower() �ҹ��ڷ� ����
select lower('HELLO world') from dual;

-- Q. last name�� seo�� ������ last_name�� salary�� ���ϼ���(seo,SEO,Seo��� ����)
select last_name, salary
from employees
where lower(last_name) = 'seo';

select last_name, salary
from employees
where upper(last_name) = 'SEO';

--initcap() ù���ڸ� �빮��
select job_id, initcap(job_id)
from employees;

--length() ���ڿ��� ����
select job_id, length(job_id)
from employees;

--�ε��� ���� 1����
--instr() ���ڿ�, ã�� ����, ã�� ��ġ(���� ��ġ), ã�� ���� �� ���°�� �ִ���
select instr('Hello World','o',3,2)
from dual;

select instr('Hello World','l',3,2)
from dual;

select instr('Hello World','o',3)
from dual;

--substr() ���ڿ�, ������ġ, ����
select substr('Hello World',3,3)
from dual;

select substr('Hello World',-3,3)
from dual;

select substr('Hello World',-5,2)
from dual;

--lpad() ������ ���� �� ���ʿ� ���ڸ� ä���
select lpad('Hello World', 20,'#')
from dual;

select lpad('Hello World', 20,0)
from dual;

--rpad() ���� ���� �� �����ʿ� ���ڸ� ä���
select rpad('Hello World', 20,'#')
from dual;

--ltrim()
select ltrim('aaaHello Worldaaa','a')
from dual;

--rtrim()
select rtrim('aaaHello Worldaaa','a')
from dual;

select last_name �̸�, ltrim(last_name,'A') as ��ȯ
from employees;

--trim()
select trim( '            Hello World                    ')
from dual;

select last_name, trim('A' from last_name)
from employees;

commit;

-- ���� hr�� �ִ� 7�� ���̺��� �Ҽ��ؼ� �λ������ �ǹ� �ִ� �λ���Ʈ 5�� �̻��� ���
-- �λ���� ������ ���� KPI 2���� �����ϰ� �̰͵��� ���̺���� �����Ϳ� �ݿ��� �� �ٽ� �м��� �ݿ� ���θ� ����

-- 1. ��� �ټ� 10���� �޿� 10% �λ�

select �̸�, salary "���� �޿�", salary *1.1 "�λ�� �޿�"
from (
select first_name || ' ' || last_name �̸� ,
round((sysdate-hire_date)) "�ٹ��� �ϼ�",
salary
from employees
order by round((sysdate-hire_date),2) desc)
where rownum <= 10;


-- ��簡 ���� ���� �μ� �޿� 5% ����



----------------------------------------------------------------

-- nvl()
select last_name, manager_id,
nvl(to_char(manager_id),'CEO') revised_id from employees;


--decode()    if���̳� case���� ���� ���� ��츦 ������ �� �ֵ��� �ϴ� �Լ�
--DECODE �Լ��� �ܼ��� ���ǿ� ����Ͽ� ���� ��ȯ�մϴ�. ������ DECODE(expression, search1, result1, ..., searchN, resultN, default) 
--���⼭ expression�� �˻��� ���� ��Ÿ����, search�� result�� ���� ���ǰ� �ش� ������ ���� �� ��ȯ�� ��
--default�� ��� search ������ ������ �� ��ȯ�� �⺻ �� ���


select last_name, department_id,
decode(department_id,
90, '�濵 ������',
60, '���α׷���',
100, '�λ��' , '��Ÿ' ) �μ�
from employees;

-- Q. employees ���̺��� commission_pct�� null�� �ƴ� ���, 'A' null�ΰ�� 'N'�� ǥ���ϴ� ������ �ۼ�

select commission_pct as commission
, decode(commission_pct, null, 'N' ,'A') as ��ȯ
from employees
order by ��ȯ desc;


--case()
--decode() �Լ��� �����ϳ� decode() �Լ��� �ܼ��� ���� �񱳿� ���Ǵ� �ݸ�
--case() �Լ��� �پ��� �񱳿����ڷ� ������ ������ �� �ִ�.
--CASE ���� ���ǿ� ���� �ٸ� ���� ��ȯ�ϴ� �� ���Ǹ�, DECODE���� ������ ������ ǥ���� �� �ִ�. 
--������ CASE WHEN condition THEN result ... ELSE default END�̴�. 

select last_name, department_id,
case when department_id = 90 then '�濵������'
when department_id = 60 then '���α׷���'
when department_id = 100 then '�λ��'
else '��Ÿ'
end as �Ҽ�
from employees;


-- Q. employees ���̺��� salary�� 20000 �̻��̸� 'a', 10000�� 20000�̸� ���̸� 'b', �� ���ϸ� 'c'��
--ǥ���ϴ� ������ �ۼ�

select last_name, salary,
case
when salary >= 20000
then 'a'
when salary > 10000 and salary <20000 
then 'b'
else 'c'
end as ���
from employees;


--Concatenation : �޸� ��ſ� ����ϸ� ���ڿ��� ����Ǿ� ���
select last_name, 'is a', job_id
from employees;

select last_name || ' is a ' || job_id
from employees;

-- ����
-- UNION(������) INTERSECT (������) MINUS (������) UNION ALL (��ġ�� �ͱ��� ����)
-- �ΰ��� �������� ����ؾ��ϸ� ������ Ÿ���� ��ġ���Ѿ� �Ѵ�

select first_name �̸�, salary �޿�
from employees
union
select first_name �̸�, salary �޿�
from employees
where hire_date < '99/01/01';


select first_name �̸�, salary �޿�, hire_date
from employees
where salary < 5000
minus
select first_name �̸�, salary �޿�, hire_date
from employees
where hire_date < '99/01/01';


select first_name �̸�, salary �޿�, hire_date
from employees
where salary < 5000
intersect
select first_name �̸�, salary �޿�, hire_date
from employees
where hire_date < '99/01/01';



select first_name �̸�, salary �޿�, hire_date
from employees
where salary < 5000
union all
select first_name �̸�, salary �޿�, hire_date
from employees
where hire_date < '99/01/01';

commit;


--CREATE VIEW ��ɾ�� ����Ŭ SQL���� ���̺��� Ư�� �κ��̳� ���ε� ����� ������ ��(view)�� ���� �� ���
--��� �����͸� ����ϰų� ������ ������ �ܼ�ȭ�ϸ�, ����ڿ��� �ʿ��� �����͸��� �����ִ� �� ����
--��� ���� ���̺� �����͸� �������� �ʰ�, ��� ������ ��ü�� ����
--���� �ֿ� Ư¡
--���� �ܼ�ȭ: ������ ������ ��� ���������ν� ����ڴ� ������ �������� �ݺ��ؼ� �ۼ��� �ʿ� ���� �����ϰ� �並 ������ �� �ִ�.
--������ �߻�ȭ: ��� �⺻ ���̺��� ������ ����� ����ڿ��� �ʿ��� �����͸��� ������ �� �־�, ������ �߻�ȭ�� ����.
--���� ��ȭ: �並 ����ϸ� Ư�� �����Ϳ� ���� ������ ������ �� ������, ����ڰ� �� �� �ִ� �������� ������ ������ �� �ִ�.
--������ ���Ἲ ����: �並 ����Ͽ� �����͸� �����ϴ���, �� ��������� �⺻ ���̺��� ������ ���Ἲ ��Ģ�� �������� �ʵ��� ������ �� �ִ�.

create view employee_details as
select employee_id, last_name, department_id
from employees;


select * from employee_details;

-- Q. employees ���̺��� salary�� 10000�� �̻��� �������� �����ϴ� ��
--special_employee�� �����ϴ�  sql ��ɹ��� �ۼ��Ͻÿ���

create view special_employee as
select *
from employees
where salary >= 10000;

select * from special_employee;

select * from employees;
--Q. employees  ���̺��� �� �μ��� ���� ���� �����ϴ� �並 ����

create view count_employee as
select department_id, count(*) as "�μ� �� ���� ��"
from employees
group by department_id;

select * from count_employee;

--Q. employees ���̺��� �ټ� �Ⱓ�� 10�� �̻��� ������ �����ϴ� �並 ����

create table date_employee as
select *
from employees
where mod((sysdate-hire_date),365) >= 10;
-- trunc(sysdate-hire_date) > 365 * 10

select * from date_employee;


--TCL (Transaction Control Language)
--COMMIT: ���� Ʈ����� ������ ����� ��� ����(INSERT, UPDATE, DELETE ��)�� �����ͺ��̽��� ���������� ����.
--COMMIT ����� �����ϸ�, Ʈ������� �Ϸ�Ǹ�, �� ���Ŀ��� ���� ������ �ǵ��� �� ����.
--ROLLBACK: ���� Ʈ����� ������ ����� ������� ����ϰ�, �����ͺ��̽��� Ʈ������� �����ϱ� ���� ���·� �ǵ�����. 
--������ �߻��߰ų� �ٸ� ������ Ʈ������� ����ؾ� �� ��쿡 ���ȴ�.
--SAVEPOINT: Ʈ����� ������ �߰� üũ����Ʈ�� �����մϴ�. ������ �߻��� ���, ROLLBACK�� ����Ͽ� �ֱ��� SAVEPOINT���� �ǵ��� �� �ִ�.
--Ʈ������� ��Ʈ���ϴ� TCL(TRANSACTION CONTROL LANGUAGE)

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
--orders��� ���̺��� �����ϰ�, order_id, customer_id, order_date, amount, status��� �Ӽ��� �����ϼ���.
--�����͸� 5�� �Է��ϼ���.
--�Է��� ������ �� 2���� �����ϼ���.
--������ �����͸� ����ϱ� ���� �ѹ��� ����ϼ���.
--3���� ���ο� �����͸� �Է��ϰ�, �� �� ������ ������ �Է¸� ����� �� �������� Ŀ���ϼ���.

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
-- ������ ���Ἲ�� ���� department_id�� ���� ������� job_id�� �´� department_id�� �ο����ַ�����
--1. null�� ��� ã��
select *
from employees
where department_id is null;

-- 1-1 ������ savepoint

--2. job_id�� SA_REP�� idã�� ������ �´� �μ� ã��
select job_id, department_id
from job_history
where job_id in 'SA_REP';


--3. ����

----------------------------------------------------------------------
--�μ��� �޿� ��Ȳ
--���̺����, �μ��� �޿��� �� �޿��� Ȯ�� �� �� ����.
--(�޿��� �� ��� �ּڰ� �ִ�, �� ������, �޿���ü����, ������ձ޿�, �μ���ձ޿�)
--table ����� �μ��� �޿��� �뷫������ ����
--����� ���̺� Ȯ��
select * from jobs;
select * from departments;
select * from employees;
select * from job_history;

--�μ� ��� Ȯ��
SELECT department_id
from employees
group by department_id
order by department_id DESC;
-- �μ� ��� department_id : 10,20,30,40,50,60,70,80,90,100,110 �� �� ������(120~200��..)�� ���� null ���� ����.
--department_id �� null �� ����� ��� job_id �� �´� department_id �� �ο����ַ�����(������ ���Ἲ)
--1. department_id �� null ���� ��� ã��
select *
from employees
where department_id IS NULL;
--�Ѹ� �ۿ� ����. department_id : null, employee_id : 178, Job_id : SA_REP

--2. job_id �� SA_REP �� department_id ã�� (������ �´� �μ� ã��)
select job_id, department_id
from job_history
where job_id IN 'SA_REP';
--SA_REP �� department_id �� 80

--3. ���� �� savepoint ����
SAVEPOINT null_to_80;
------------------------SAVEPOINT---------------------------------

--4. ��������primary key �� employee_id �� ã�Ƽ� derpartment_id �� 80���� ����
UPDATE employees
SET department_id = 80
WHERE employee_id = 178;

select * from employees where employee_id = 178;
--ROLLBACK null_to_80; -- savepoint�� ����
--commit;
--������

--�� �μ����� ������ ����̰� � �����ǵ��� �ְ� ������ ��� �Ǵ���
--rollup�� ���������� ���� ����� ���� : ��� �� �μ� �� ������ ���� ���� ����

select e.department_id, d.department_name, nvl(e.job_id, 'total') job_id, count(*) ������
from employees e
left outer join departments d
on e.department_id = d.department_id
group by rollup((e.department_id,d.department_name),e.job_id)
order by e.department_id;


-- job_id �� ������� �� �޴��� �� �������� ������ ���
select job_id, ����, round(avg(salary)) ��ձ޿�
from (
select job_id, floor(months_between(sysdate, hire_date)/12) as ����,
salary
from employees)
group by job_id, ����
order by job_id, ����;

commit;


