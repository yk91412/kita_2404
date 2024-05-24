-- view :
select*from hr_structure;
select*from income_by_departments;
select*from income_imbalanced;
select*from employees_yr;
select*from SA_employees;

---------------------------- [ 0523 ���� ] ------------------------------ 


------------------------ Category 1. �η� ��ġ �� ���� �ľ� ---------------------------

-- << ������ ������ >>
select l.country_id, count(*) ������
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id
order by ������ desc;

-- << ���� > department > city > job_title �� ������ ���� �� >>
--select*from countries; -- country_id, country_name
--select*from locations; -- country_id, location_id
--select*from departments; -- location_id, department_id, department_name
--select*from employees; -- department_id, job_id
--select*from jobs; -- job_id, job_title

create view hr_structure as
select l.country_id, l.city, d.department_name, j.job_title, count(*) ������
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id, l.city, d.department_name, j.job_title
order by l.country_id, l.city, d.department_name, j.job_title;

select*from hr_structure;

-- �� 4����, 7�� ����, 11�� �μ�, 19�� ����, �� 107���� ����
-- ĳ���� (1): �����. ������ �μ��� ����, �Ŵ��� 1��� rep 1��
-- ���� (1): ����. PR �μ��� ����, PR rep 1��
-- ���� (2): ����. HR �μ���, HR rep 1��
--          ��������. Sales �μ���, �Ŵ��� 5��, rep 30��
-- �̱� (3) : �ÿ�Ʋ�� �����ε�? 
--           �ÿ�Ʋ. �� 5�μ�. 
--                  - executive ȸ�� 1��, ��ȸ�� 2�� 
--                  - accounting. �Ŵ��� 1��, rep 1��
--                  - adnin. assistant 1��
--                  - finance. �Ŵ��� 1��, accountant 5��
--                  - purchasing. �Ŵ��� 1��, clerk 5��
--           �������ý���. shipping �μ���, stock �Ŵ��� 5��, stock clerk 20��, shipping clerk 20��
--           ��콺����ũ (�ػ罺). IT. ���α׷��� 5��
-- ���̷��Ա��� �� ����� �ִ°���? 


------------------------- Case 2. executive ������ �μ��� ���� �� ���� ���� ------------------------------ 

-- ��ü ���� ����, �ּ�, �ִ�, ��� ����
select min(salary) min_salary, max(salary) max_salary, round(avg(salary),1) avg_salary
from employees;
-- �ּ�: 2100, �ִ�: 24000, ��� 6461.8

-- << �μ��� ���� ���� (avg_salary ���� ��������) >>
select d.department_name, count(*)as "������", min(e.salary) min_salary, max(e.salary) max_salary, 
round(avg(e.salary),0) avg_salary, (max(e.salary)-min(e.salary)) "�μ� �ִ��ּ�����", round(round(avg(e.salary),0)-6461.8) "��ü ��� �μ� ���"
from departments d
join employees e on d.department_id=e.department_id
group by d.department_name
order by avg_salary desc;
-- �ְ� avg salary �μ� == executive : 19333
-- ���� avg salary �μ� == shipping : 3476

-- executive ������, ��ü ���� �������� avg_salary
select min(salary) min_salary, max(salary) max_salary, round(avg(salary),1) avg_salary
from employees
where department_id not like '90';
-- executive ������, ��ü ���� �������� avg_salary�� 6081.7
select*from employees;

--savepoint sq1;

-- employee_id : 178, department_id: null --> 80 ���� -- 
--savepoint sq2;

--select*from employees;
--update employees set department_id=80 
--where employee_id=178;

--commit;


-- << executive ������, �μ��� ���� ����. avg_salary �������� �������� >>:
select d.department_name, count(*)as "������", min(e.salary) min_salary, max(e.salary) max_salary, 
round(avg(e.salary),0) avg_salary, (max(e.salary)-min(e.salary)) "�μ� �ִ��ּ�����", (round(round(avg(e.salary),0)-6081.7)) "��ü ��� �μ� ���"
from departments d
join employees e on d.department_id=e.department_id
where d.department_name not in ('Executive')
group by d.department_name
order by avg_salary desc;
-- �ְ� avg salary �μ� == accounting : 10154. ��մ�� �� 4000 ���� �� ����
-- ���� avg salary �μ� == shipping : 3476. ��� ��� �� 2600 ���� �� ���� 


------------------------- Case 3. ���� �ұ��� Ȯ�� ------------------------------
-- << department��, job_id �� ������ �ּ�, �ִ�, ��� ���� >>
--select*from departments; -- department_id, location_id, department_name
--select*from employees; -- job_id, department_id
--select*from jobs; -- job_id, job_title
create view income_by_departments as
select d.department_id, d.department_name, j.job_id, j.job_title, trunc(months_between(sysdate,e.hire_date)/12) "�ټӱⰣ", count(*) ������, 
round(avg(e.salary),0) ��տ���, round(min(e.salary),0) �ּҿ���, round(max(e.salary),0) �ִ뿬��, round(max(e.salary),0)-round(min(e.salary),0) "��������"
from jobs j
join employees e on j.job_id=e.job_id
join departments d on d.department_id=e.department_id
group by d.department_id, d.department_name, j.job_id, j.job_title, trunc(months_between(sysdate,e.hire_date)/12)
order by d.department_name, j.job_title, �ټӱⰣ desc;

select*from income_by_departments;

------------ ���� �μ�, ����, �ټӱⰣ �� ���� ���� Ȯ�� ----------
    -- e.g. ���� job�̰� �ټӱⰣ�� �ٸ��� ���� ��������? 
    -- e.g. ���� job�̰� �ټӱⰣ�� ������ ������ �ٸ� ���̽��� �ִ���?
--select min(��������), max(��������), round(avg(��������),1)
--from income_by_departments
--where �������� not in (0);
-- �ּ�: 100, �ִ�: 4200, �������: 1233.3

-- ���� �μ�, ����, �ټӱⰣ �� ���� ���̰� �ִ� ��츸 ���͸� 
--select*from income_by_departments
--where �������� not in (0)
--order by �������� desc, ������;

-- << ���� �ұ����ڵ� ���̽� (���� ����, �ټӱⰣ ������ ���� �������� 1000 �̻��� ���) >> :
create view income_imbalanced as
select*from income_by_departments
where �������� >=1000
order by department_id, �ټӱⰣ desc;

select*from income_imbalanced;

------ �ټӱⰣ ������ employee ���� 
create view employees_yr as
select employee_id, first_name ||' '|| last_name as "full name", email, phone_number, hire_date, trunc(months_between(sysdate,hire_date)/12) as �ټӱⰣ, 
salary, commission_pct, department_id, job_id
from employees;

select*from employees_yr;

-- ���� �ұ����ڵ� (���� ����, ���� ��� ��տ������� 1000 �̻� under�� ���):
select*from income_imbalanced;

-- IT �μ�
select*from employees_yr
where job_id='IT_PROG'
order by �ټӱⰣ desc, salary desc; -- �ټӱⰣ ���о��� �ѹ��� Ȯ��
-- 18���� �� Alexander Hunold�� ���� ������ ���� �ټӱⰣ ������ ��� 4200 �� ���� ���� (AH=9000, �� ��=4800)
        -- �ټӱⰣ != ���. Hunold�� �ٸ� ������ ��� ��°� ������ �� ǳ���ϰ� ���� �� �ϴ°���? 
-- 17������ Bruce�� Diana�� �޿��� 6000: 4200���� 1800 ���� ��

-- Sales �μ�
select*from income_imbalanced;

--select*from employees_yr
--where job_id='SA_MAN' and �ټӱⰣ='19'
--order by salary desc;
-- �� 3��. �� 1500�� ����. �Ի��� ������ ������ ���̰� ��.(�� 2-3������ ���̳�)

-- << SA_Rep ���� ���� Ƣ�� ������ >> 
select*from employees_yr
where job_id='SA_REP' and �ټӱⰣ in ('17','18','19')
order by �ټӱⰣ desc, hire_date asc, salary desc, commission_pct desc;
-- Clara Vishney�� Louise Doran �� ����� �ñ� �Ի��������� �ұ��ϰ� 10500���� ���� ���̰� 3000�̳� ��. 
-- Harrison Bloom ���� ������ 10000���� �Ի�ñⰡ ����� ������ ���̿��� ����. 
-- Danielle Greene ���� �ټӱⰣ�� ����� ������ ��� ������ 2000 ������ �� ����. 


------- ������ ���� commission ������ ������ �ִ� �� ������? 17������ 15-25, 18������ 20-30, 19������ 25-35 �ε�????
-- ������ ���� salary bracket�� �ִ� �� ����. 

--select*from employees_yr
--where job_id='SA_REP' and �ټӱⰣ='16'
--order by �ټӱⰣ desc, hire_date asc, salary desc, commission_pct desc;
-- 8�� ���ļ� �յ��� ��
--
--select*from employees_yr
--where job_id='SA_REP' and �ټӱⰣ='20'
--order by �ټӱⰣ desc, hire_date asc, salary desc, commission_pct desc;
-- 500�� ������
--select*from employees_yr;
--drop view employees_yr;


------------------------- Case 4. SA Department commission ���̺� ------------------------------
-- Sales department�� �ټӱⰣ�� ���� Ŀ�̼� ���̰� �ִ� ������ ����
create view SA_employees as
select*from employees_yr
where department_id=80
order by job_id asc, hire_date asc, commission_pct desc;

--------- << SA department�� ���� ���� >>
select*from SA_employees;

select job_id, substr(hire_date,2,1) �Ի�⵵, count(*) ������, min(salary) �ּҿ���, max(salary) �ִ뿬��, round(avg(salary),1) ��տ���,
min(commission_pct) "�ּ� Ŀ�̼�", max(commission_pct) "�ִ� Ŀ�̼�", round(avg(commission_pct),2) "��� Ŀ�̼�"
from SA_employees
group by job_id, substr(hire_date,2,1)
order by job_id, �Ի�⵵;

-- SA department Ŀ�̼� ���̺�:
-- rep ����: 21���� = 0.3~0.35
        --  20���� = 0.25~0.3
        --  19���� = 0.2~0.25 
        --  18���� = 0.15
        --  17���� = 0.1


------------------------- Case 5. Sales department�� commission ���� ���� ���� ------------------------------
-- commission�� ���� ��� ���� ������ ���ؼ� ���� ����
-- << ���� �ӱ� �� ** Ŀ�̼� �ִ� ������ Ŀ�̼� ���ļ� ��� >>
select first_name || ' ' || last_name �̸�,
nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) ����,
rank() over (order by nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) desc) ����
from employees;

-- << SA �μ��� ���� �ӱݼ� ** Ŀ�̼� ���� >>
select first_name || ' ' || last_name �̸�, job_id,
salary "���� �޿�" ,commission_pct �μ�Ƽ��,
salary * (1+commission_pct) as "���� �޿�",
rank () over (order by salary * (1+commission_pct) desc) ����
from employees
where commission_pct is not null
order by "���� �޿�" desc;


------------------------- Case 6. �ټ� ���ʽ� ������ ------------------------------
-- ���ر��� �ټӱⰣ
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) �ټӱⰣ
from employees
order by �ټӱⰣ;

--���� 5 , 10 ,15, 20 -> 200 , 300, 400, 500
--25�� �̻�� 5������� ���� ���ʽ� ���� -> 600
-- ���ر��� �ټӱⰣ�� 5�� �������� �� �������� 0�� ����� �̸��� �ټӱⰣ
-- << �ټ� ���ʽ� ������ >>
select �̸�, �ټӱⰣ
from(
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) �ټӱⰣ
from employees)
where mod(�ټӱⰣ,5) = 0;

-- ����ȭ �ϱ����� view ����
create view this_year_bonus as
(select �̸�, �ټӱⰣ
from(
select first_name || ' ' || last_name �̸�,
trunc(months_between(sysdate,hire_date)/12) �ټӱⰣ
from employees)
where mod(�ټӱⰣ,5) = 0);

select * from this_year_bonus;

drop view this_year_bonus;
-- ���� �ټӱⰣ�� 5�� ������ ������� �̸�, �ټӱⰣ, ���ʽ� ��
select �̸�, �ټӱⰣ,
case when �ټӱⰣ = 5 then '200���� ���� �����'
when �ټӱⰣ = 10 then '300���� ���� �����'
when �ټӱⰣ = 15 then '400���� ���� �����'
when �ټӱⰣ = 20 then '500���� ���� �����'
else '600���� ���� �����'
end "���ʽ� �����"
from this_year_bonus;

commit;

