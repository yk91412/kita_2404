-- ���� hr�� �ִ� 7�� ���̺��� �м��ؼ� �λ������ �ǹ� �ִ� �λ���Ʈ 5�� �̻��� ���

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

---------------------------------------------------------
----��� �ټ� ----

-- ��� �ټ� 10��
select �̸�, "�ٹ��� �ϼ�"
from (
select first_name || ' ' || last_name �̸� ,
round((sysdate-hire_date)) "�ٹ��� �ϼ�",
salary
from employees
order by round((sysdate-hire_date),2) desc)
where rownum <= 10;


-- �ٹ��� �⵵�� ���� �ű��
select first_name || ' ' || last_name �̸�,
row_number () over (order by months_between(sysdate,hire_date)/12 desc) "���� ����",
floor(months_between(sysdate,hire_date)/12) ����
from employees;


--case => 10�� �̻� �ٹ��� ���� �����
select first_name || ' ' || last_name �̸�,
floor(months_between(sysdate,hire_date)/12) �ٹ��⵵,
case when floor(months_between(sysdate,hire_date)/12) >= 20
then '20�� �̻� �ٹ���'
when floor(months_between(sysdate,hire_date)/12) >= 15
then '15�� �̻� �ٹ���'
when floor(months_between(sysdate,hire_date)/12) >= 10
then '10�� �̻� �ٹ���'
else '���� ����� �ƴ�'
end ���������
from employees
order by �ٹ��⵵ desc;

-- �ٹ��⵵�� �ο��� / ��� ��������ڿ� ���ϴ���
select ����, count(*) �ο���, ���������
from (
select first_name || ' ' || last_name �̸�,
floor(months_between(sysdate,hire_date)/12) ����,
case when floor(months_between(sysdate,hire_date)/12) >= 20
then '20�� �̻� �ٹ���'
when floor(months_between(sysdate,hire_date)/12) >= 15
then '15�� �̻� �ٹ���'
when floor(months_between(sysdate,hire_date)/12) >= 10
then '10�� �̻� �ٹ���'
else '���� ����� �ƴ�'
end ���������
from employees
order by ���� desc)
group by ����, ���������
order by �ο��� desc;

--���� 5 , 10 15, 20
--25�� �̻�� 5������� ���� ���ʽ� ���� -> 600
select first_name || ' ' || last_name �̸�,
months_between(sysdate,hire_date)/12 ����
from employees
order by ����;


-- ���ر��� ����
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) ����
from employees
order by ����;


-- ���ر��� ������ 5�� �������� �� �������� 0�� ����� �̸��� ����
select �̸�, ����
from(
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) ����
from employees)
where mod(����,5) = 0;

-- ����ȭ �ϱ����� view ����
create view this_year_bonus as
(select �̸�, ����
from(
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) ����
from employees)
where mod(����,5) = 0);

select * from this_year_bonus;


-- ���� ������ 5�� ������ ������� �̸�, ����, ���ʽ� ��
select �̸�, ����,
case when ���� = 5 then '200���� ���� �����'
when ���� = 10 then '300���� ���� �����'
when ���� = 15 then '400���� ���� �����'
when ���� = 20 then '500���� ���� �����'
else '600���� ���� �����'
end "���ʽ� �����"
from this_year_bonus;

---------------------------------------------------------


-- job_id�� ������ �ο����� ���� ��
select s.job_id, s.�ο���, j.job_title
from (
select job_id,count(*) �ο���
from employees
group by job_id) s
join jobs j
on s.job_id = j.job_id
order by �ο��� desc
;

select job_id, count(*)
from employees
where commission_pct is not null
group by job_id;


select * from departments;
select * from jobs;
select * from employees;
select * from job_history;
select * from locations;
select * from regions;
select * from countries;

--
select count(*)
from employees e 
inner join departments d
on e.department_id = d.department_id
group by department_id;


select count(*)
from (select *
from employees e 
inner join departments d
on e.department_id = d.department_id)
group by department_id;


-- ������ ���� ����
select e.first_name || ' ' || e.last_name �̸�,
j.job_title,
e.salary,
row_number () over (order by e.salary desc) "���� ����"
from employees e 
inner join jobs j
on e.job_id = j.job_id;

--sales��Ʈ�� com�� �ٴ� ����� �������� com�� ���� �� ���� �ű��
select * from employees;


select first_name || ' ' || last_name �̸�,
salary "���� �޿�" ,commission_pct �μ�Ƽ��,
salary * (1+commission_pct) as "���� �޿�",
rank () over (order by salary * (1+commission_pct) desc) ����
from employees
where commission_pct is not null
order by "���� �޿�" desc;


-- commission�� ���� ��� ���� ������ ���ؼ� ���� ����
select first_name || ' ' || last_name �̸�,
nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) ����,
rank() over (order by nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) desc) ����
from employees;





----------------------------------------------------------------------------------------------------
------------------------ Category 1. ���� �� ���� ---------------------------

-- Q1. ������ ������
select l.country_id, count(*) ������
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id
order by ������ desc;

-- Q2. ���� > department > city > job_title �� ������ ���� ��
select*from countries; -- country_id, country_name
select*from locations; -- country_id, location_id
select*from departments; -- location_id, department_id, department_name
select*from employees; -- department_id, job_id
select*from jobs; -- job_id, job_title

create view hr_structure as
select l.country_id, l.city, d.department_name, j.job_title, count(*) ������
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id, l.city, d.department_name, j.job_title
order by l.country_id, l.city, d.department_name, j.job_title;

------------------------- Case 2. executive ������ �μ��� ���� �� ���� ���� ------------------------------ 

-- executive ������, ��ü ���� �������� avg_salary
select min(salary) min_salary, max(salary) max_salary, round(avg(salary),1) avg_salary
from employees
where department_id not like '90';
-- executive ������, ��ü ���� �������� avg_salary�� 6081.7
select*from departments;

-- executive ������, �μ��� ���� ����. avg_salary �������� ��������:
select d.department_name, count(*)as "������", min(e.salary) min_salary, max(e.salary) max_salary, round(avg(e.salary),0) avg_salary, (max(e.salary)-min(e.salary)) "d.max-min", (round(round(avg(e.salary),1)-6081.7)) "t.max-min"
from departments d
join employees e on d.department_id=e.department_id
where d.department_name not in ('Executive')
group by d.department_name
order by avg_salary desc;
-- �ְ� avg salary �μ� == accounting : 10154
-- ���� avg salary �μ� == shipping : 3476
