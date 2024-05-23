-- 현재 hr에 있는 7개 테이블을 분석해서 인사관리에 의미 있는 인사이트 5개 이상을 기술

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

---------------------------------------------------------
----장기 근속 ----

-- 장기 근속 10명
select 이름, "근무한 일수"
from (
select first_name || ' ' || last_name 이름 ,
round((sysdate-hire_date)) "근무한 일수",
salary
from employees
order by round((sysdate-hire_date),2) desc)
where rownum <= 10;


-- 근무한 년도로 순위 매기기
select first_name || ' ' || last_name 이름,
row_number () over (order by months_between(sysdate,hire_date)/12 desc) "연차 순위",
floor(months_between(sysdate,hire_date)/12) 연차
from employees;


--case => 10년 이상 근무시 승진 대상자
select first_name || ' ' || last_name 이름,
floor(months_between(sysdate,hire_date)/12) 근무년도,
case when floor(months_between(sysdate,hire_date)/12) >= 20
then '20년 이상 근무자'
when floor(months_between(sysdate,hire_date)/12) >= 15
then '15년 이상 근무자'
when floor(months_between(sysdate,hire_date)/12) >= 10
then '10년 이상 근무자'
else '승진 대상자 아님'
end 승진대상자
from employees
order by 근무년도 desc;

-- 근무년도별 인원수 / 어느 승진대상자에 속하는지
select 연차, count(*) 인원수, 승진대상자
from (
select first_name || ' ' || last_name 이름,
floor(months_between(sysdate,hire_date)/12) 연차,
case when floor(months_between(sysdate,hire_date)/12) >= 20
then '20년 이상 근무자'
when floor(months_between(sysdate,hire_date)/12) >= 15
then '15년 이상 근무자'
when floor(months_between(sysdate,hire_date)/12) >= 10
then '10년 이상 근무자'
else '승진 대상자 아님'
end 승진대상자
from employees
order by 연차 desc)
group by 연차, 승진대상자
order by 인원수 desc;

--연차 5 , 10 15, 20
--25년 이상시 5년단위로 같은 보너스 지급 -> 600
select first_name || ' ' || last_name 이름,
months_between(sysdate,hire_date)/12 연차
from employees
order by 연차;


-- 올해기준 연차
select first_name || ' ' || last_name 이름,
trunc(months_between(sysdate,hire_date)/12) 연차
from employees
order by 연차;


-- 올해기준 연차가 5로 나누었을 때 나머지가 0인 사람의 이름과 연차
select 이름, 연차
from(
select first_name || ' ' || last_name 이름,
trunc(months_between(sysdate,hire_date)/12) 연차
from employees)
where mod(연차,5) = 0;

-- 간편화 하기위해 view 생성
create view this_year_bonus as
(select 이름, 연차
from(
select first_name || ' ' || last_name 이름,
trunc(months_between(sysdate,hire_date)/12) 연차
from employees)
where mod(연차,5) = 0);

select * from this_year_bonus;


-- 올해 연차가 5년 단위인 사람들의 이름, 연차, 보너스 비
select 이름, 연차,
case when 연차 = 5 then '200만원 지급 대상자'
when 연차 = 10 then '300만원 지급 대상자'
when 연차 = 15 then '400만원 지급 대상자'
when 연차 = 20 then '500만원 지급 대상자'
else '600만원 지급 대상자'
end "보너스 대상자"
from this_year_bonus;

---------------------------------------------------------


-- job_id와 직업별 인원수가 많은 순
select s.job_id, s.인원수, j.job_title
from (
select job_id,count(*) 인원수
from employees
group by job_id) s
join jobs j
on s.job_id = j.job_id
order by 인원수 desc
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


-- 직원별 연봉 순위
select e.first_name || ' ' || e.last_name 이름,
j.job_title,
e.salary,
row_number () over (order by e.salary desc) "연봉 순위"
from employees e 
inner join jobs j
on e.job_id = j.job_id;

--sales파트만 com이 붙는 사람들 연봉에서 com을 했을 때 순위 매기기
select * from employees;


select first_name || ' ' || last_name 이름,
salary "기존 급여" ,commission_pct 인센티브,
salary * (1+commission_pct) as "최종 급여",
rank () over (order by salary * (1+commission_pct) desc) 순위
from employees
where commission_pct is not null
order by "최종 급여" desc;


-- commission이 있을 경우 현재 연봉에 곱해서 연봉 순위
select first_name || ' ' || last_name 이름,
nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) 연봉,
rank() over (order by nvl((1+nvl(commission_pct,0)) * nvl(salary,0), nvl(salary,0)) desc) 순위
from employees;





----------------------------------------------------------------------------------------------------
------------------------ Category 1. 직원 수 정리 ---------------------------

-- Q1. 국가별 직원수
select l.country_id, count(*) 직원수
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id
order by 직원수 desc;

-- Q2. 국가 > department > city > job_title 로 정리한 직원 수
select*from countries; -- country_id, country_name
select*from locations; -- country_id, location_id
select*from departments; -- location_id, department_id, department_name
select*from employees; -- department_id, job_id
select*from jobs; -- job_id, job_title

create view hr_structure as
select l.country_id, l.city, d.department_name, j.job_title, count(*) 직원수
from locations l
join departments d on l.location_id=d.location_id
join employees e on d.department_id=e.department_id
join jobs j on e.job_id=j.job_id
group by l.country_id, l.city, d.department_name, j.job_title
order by l.country_id, l.city, d.department_name, j.job_title;

------------------------- Case 2. executive 제외한 부서별 연봉 및 차이 정리 ------------------------------ 

-- executive 제외한, 전체 직원 기준으로 avg_salary
select min(salary) min_salary, max(salary) max_salary, round(avg(salary),1) avg_salary
from employees
where department_id not like '90';
-- executive 제외한, 전체 직원 기준으로 avg_salary는 6081.7
select*from departments;

-- executive 제외한, 부서별 연봉 정보. avg_salary 기준으로 내림차순:
select d.department_name, count(*)as "직원수", min(e.salary) min_salary, max(e.salary) max_salary, round(avg(e.salary),0) avg_salary, (max(e.salary)-min(e.salary)) "d.max-min", (round(round(avg(e.salary),1)-6081.7)) "t.max-min"
from departments d
join employees e on d.department_id=e.department_id
where d.department_name not in ('Executive')
group by d.department_name
order by avg_salary desc;
-- 최고 avg salary 부서 == accounting : 10154
-- 최저 avg salary 부서 == shipping : 3476
