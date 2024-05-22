--�л� ���̺�
create table student_info(
student_id number primary key,
name varchar2(30) not null,
gender varchar2(30) not null,
birthdate number(8) not null,
s_phone varchar2(15) not null,
s_email varchar2(50) not null,
s_address varchar2(50) not null
);

-- �л� ���� ����
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES (1, '��μ�', 'f', 980523, '010-1111-2222', 'kimminji@naver.com', '����Ư���� ������');

INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES (2, '�迵��', 'm', 920815, '010-1234-5678', 'kimys@naver.com', '������ ��õ��');

INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(3, '������', 'f', 970210, '010-9876-5432', 'leeje@naver.com', '��⵵ ������');

INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(4, '�ڼ���', 'm', 990523, '010-5555-6666', 'parksm@naver.com', '����Ư���� ���Ǳ�');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(5, '������', 'f', 980403, '010-1111-2222', 'jsh@naver.com', '����Ư���� ������');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(6, '�ֿ���', 'm', 960702, '010-9999-8888', 'cyj@naver.com', '��⵵ ����');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(7, '������', 'f', 950320, '010-7777-3333', 'kimjw@naver.com', '����Ư���� ���۱�');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(8, '�̽¿�', 'm', 940825, '010-1212-3434', 'leesw@naver.com', '����Ư���� ��������');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(9, '������', 'f', 930527, '010-4545-6767', 'parkjh@naver.com', '��⵵ �Ⱦ��');
INSERT INTO student_info (student_id, name, gender, birthdate, s_phone, s_email, s_address) 
VALUES(10, '������', 'm', 910703, '010-1313-5757', 'jmj@naver.com', '�뱸������ �߱�');
       


select * from student_info;
select * from lecture;


-- ���� ���̺�
create table lecture(
student_id number, -- ���ǵ�� �л�id
lecture_id number primary key, -- ���� ��ȣ(�����ڵ�)
lecture varchar2(30) not null, -- �����̸�
professor_id varchar2(8), -- �����ϴ� �����̸�
foreign key(student_id) references student_info(student_id),
foreign key(professor_id) references  professor_info(professor_id) on delete cascade
);
drop table lecture;
alter table lecture drop column student_id;

select * from lecture;
-- ���� ���̺� ������ ����
INSERT INTO lecture VALUES (1, 10, '������ ����', 'B2101001');
INSERT INTO lecture VALUES (2, 11, '�˰���', 'C2202002');
INSERT INTO lecture VALUES (3, 12, 'ȸ���̷�', 'E2003003');
INSERT INTO lecture VALUES (4, 13, '��� ����', 'M1904004');
INSERT INTO lecture VALUES (5, 14, '����ȭ��', 'H2305005');
INSERT INTO lecture VALUES (6, 15, '�繫 ����', 'B2001006');
INSERT INTO lecture VALUES (7, 16, '�ü��', 'C1802007');
INSERT INTO lecture VALUES (8, 17, '������ ��ȣ ó��', 'E2103008');
INSERT INTO lecture VALUES (9, 18, '��� ���', 'M1704009');
INSERT INTO lecture VALUES (10, 19, '����ȭ��', 'H1905010');


select * from lecture;

delete from lecture;

-- ���ǽ� ���̺�
create table class(
lecture_id number, -- ���� �ڵ�
class_id number, -- ���ǽ� �ڵ�
schedule date, -- ����ϴ� ��¥
class_time varchar2(30),
time number, -- ����ϴ� �ð�
student_count number not null, --���� ��� �л���
foreign key(lecture_id) references lecture(lecture_id) on delete cascade
);
drop table class;
delete from class;
INSERT INTO class VALUES (10, 1, TO_DATE('2024-05-20', 'YYYY-MM-DD'), '1����', 50, 20);

-- 2�� ������ ����
INSERT INTO class VALUES (11, 2, TO_DATE('2024-05-21', 'YYYY-MM-DD'), '2����', 60, 25);

-- 3�� ������ ����
INSERT INTO class VALUES (12, 3, TO_DATE('2024-05-22', 'YYYY-MM-DD'), '1����', 120, 15);

-- 4�� ������ ����
INSERT INTO class VALUES (13, 4, TO_DATE('2024-05-22', 'YYYY-MM-DD'), '2����', 50, 18);

-- 5�� ������ ����
INSERT INTO class VALUES (14, 5, TO_DATE('2024-05-24', 'YYYY-MM-DD'), '1����', 60, 10);

-- 6�� ������ ����
INSERT INTO class VALUES (15, 5, TO_DATE('2024-05-25', 'YYYY-MM-DD'), '2����', 40, 22);

-- 7�� ������ ����
INSERT INTO class VALUES (16, 2, TO_DATE('2024-05-26', 'YYYY-MM-DD'), '3����', 50, 17);

-- 8�� ������ ����
INSERT INTO class VALUES (17, 3, TO_DATE('2024-05-27', 'YYYY-MM-DD'), '3����', 40, 13);

-- 9�� ������ ����
INSERT INTO class VALUES (18, 4, TO_DATE('2024-05-28', 'YYYY-MM-DD'), '1����', 60, 28);

INSERT INTO class VALUES (19, 5, TO_DATE('2024-05-25', 'YYYY-MM-DD'), '4����', 50, 28);

------------- T4. �л� ���� ---------------
-- �ʿ� ����: student_id, management_id, department, major, semester1_gpa, semester_2_gpa
create table student_gpa(
student_id number,
management_id number primary key,
department varchar2(50) not null,
major varchar2(50) not null,
lecture1_id varchar2(50),
lecture2_id varchar2(50),
lecture3_id varchar2(50),
lecture4_id varchar2(50),
semester1 number,
semester2 number,
overall_gpa number
);

INSERT INTO student_gpa VALUES (1, 1, '�濵�а�', '���� �濵', '10', '12', '15', '19', 3.5, 3.7, (3.5+3.7) / 2);
INSERT INTO student_gpa VALUES (2, 2, '��ǻ�Ͱ��а�', '����Ʈ���� ����', '11', '13', '16', '18', 3.8, 4.0, (3.8 + 4.0) / 2);
INSERT INTO student_gpa VALUES (3, 3, '�������ڰ��а�', '��� ����', '10', '14', '17', '19', 3.2, 3.4, (3.2 + 3.4) / 2);
INSERT INTO student_gpa VALUES (4, 4, '�����а�', '��� ����', '12', '13', '15', '18', 3.9, 4.1, (3.9 + 4.1) / 2);
INSERT INTO student_gpa VALUES (5, 5, 'ȭ�а��а�', 'ȯ�� ����', '11', '14', '16', '17', 3.1, 3.3, (3.1 + 3.3) / 2);
INSERT INTO student_gpa VALUES (6, 6, '�濵�а�', '�繫 ����', '10', '13', '17', '19', 3.6, 3.8, (3.6 + 3.8) / 2);
INSERT INTO student_gpa VALUES (7, 7, '��ǻ�Ͱ��а�', '���� ����', '12', '15', '16', '18', 3.7, 3.9, (3.7 + 3.9) / 2);
INSERT INTO student_gpa VALUES (8, 8, '�������ڰ��а�', '���� ����', '11', '13', '14', '19', 3.4, 3.6, (3.4 + 3.6) / 2);
INSERT INTO student_gpa VALUES (9, 9, '�����а�', '�ڵ��� ����', '10', '12', '15', '17', 3.0, 3.2, (3.0 + 3.2) / 2);
INSERT INTO student_gpa VALUES (10, 10, 'ȭ�а��а�', '���̿� ����', '11', '14', '16', '18', 3.5, 3.9, (3.5 + 3.9) / 2);


------------- T3. ���� ���� ---------------
-- �ʿ� ����: professor_id, name, department, gender, birthdate, p_phone, p_email, p_address, lecture1, lecture2, lecture3, lecture4, num_lectures
create table professor_info(
professor_id varchar2(8) primary key,
name varchar2(50) not null,
department varchar2(50) not null,
lecture1 varchar2(50),
lecture2 varchar2(50),
lecture3 varchar2(50),
lecture4 varchar2(50),
num_lectures number(8));

drop table professor_info;


-- �濵�а� (B, ���ӳ⵵: 2021, department code: 01)
INSERT INTO professor_info VALUES ('B2101001', '�����', '�濵�а�','������ ����', '�귣�� �Ŵ�����Ʈ', '�Һ��� �ൿ��', '', 3);

-- ��ǻ�Ͱ��а� (C, ���ӳ⵵: 2022, department code: 02)
INSERT INTO professor_info VALUES ('C2202002', '������', '��ǻ�Ͱ��а�','�˰���', '�ڷᱸ��', '', '', 2);

-- �������ڰ��а� (E, ���ӳ⵵: 2020, department code: 03)
INSERT INTO professor_info VALUES ('E2003003', '�̵���', '�������ڰ��а�', 'ȸ���̷�', '���ڱ���', '��ȣ�� �ý���', '������ ȸ��', 4);

-- �����а� (M, ���ӳ⵵: 2019, department code: 04)
INSERT INTO professor_info VALUES ('M1904004', '�ֹ�ȣ', '�����а�', '��� ����', '������', '', '', 2);

-- ȭ�а��а� (H, ���ӳ⵵: 2023, department code: 05)
INSERT INTO professor_info VALUES ('H2305005', '������', 'ȭ�а��а�', '����ȭ��', '����ȭ��', 'ȭ�� ��������', 'ȭ�а���', 4);

-- �濵�а� (B, ���ӳ⵵: 2020, department code: 01)
INSERT INTO professor_info VALUES ('B2001006', '�̼���', '�濵�а�', '�繫 ����', '�濵 ���� �ý���', '', '', 2);

-- ��ǻ�Ͱ��а� (C, ���ӳ⵵: 2018, department code: 02)
INSERT INTO professor_info VALUES ('C1802007', '�����', '��ǻ�Ͱ��а�','�ü��', '���α׷��� ���', '��ǻ�� ��Ʈ��ũ', '', 3);

-- �������ڰ��а� (E, ���ӳ⵵: 2021, department code: 03)
INSERT INTO professor_info VALUES ('E2103008', '��ö��', '�������ڰ��а�', '������ ��ȣ ó��', '���� ȸ�� ����', '', '', 2);

-- �����а� (M, ���ӳ⵵: 2017, department code: 04)
INSERT INTO professor_info VALUES ('M1704009', '���̷�', '�����а�', '��� ���', '��ü ����', '���� �ý���', '', 3);

-- ȭ�а��а� (H, ���ӳ⵵: 2019, department code: 05)
INSERT INTO professor_info VALUES ('H1905010', '������', 'ȭ�а��а�', '����ȭ��', 'ȭ�а��а���', '�����ӵ���', '', 3);


select * from lecture;

------ ���̽� ------
-- ��� ���̺� 1: ������ ���� ���б� ����
-- 4.3�� ���� ������.
-- 1,2�б� ������ 3.8���� �Ѱ� ��� ������ 4.0 �̻��� �л����� ���б� ����
-- ��� ���� �������� ���������ؼ� ��
-- ���б��� ���� �� �ִ� �̸� ���� (�ִ� 3��)

select student_info.name, student_gpa.semester1, student_gpa.semester2, student_gpa.overall_gpa
from student_info
left outer join student_gpa on student_info.student_id=student_gpa.student_id
where (student_gpa.semester1>=3.6 and student_gpa.semester2>=3.6) and 
student_gpa.overall_gpa>=3.8 -- where������ ��Ī�� ��� ����
order by overall_gpa desc;


-- case2. ���������� �Ŀ� �����ϴ� ������ �̸�
select name
from professor_info
where professor_id in (
    select professor_id
    from lecture
    where lecture_id in (
        select lecture_id
        from class
        where schedule > (select sysdate from dual)));

select * from lecture;

select * from professor_info;

select * from class;

-- ���������� �Ŀ� �����ϴ� ������ �̸��� ��¥
select i.name,c.schedule
from lecture l join professor_info i
on l.professor_id = i.professor_id
join class c
on c.lecture_id = l.lecture_id
where c.schedule > (select sysdate from dual);


-- 1���� ������ ��� �л��� �̸� ���
select name
from student_info
where student_id in (
    select student_id
    from lecture
    where lecture_id in(
        select lecture_id
        from class
        where class_time like '1����'));

select * from class;


-- case 3. ���� ���ÿ� �ִ� ������ ��
select substr(class_time,1,1) ����, count(*) �ο�
from class
group by substr(class_time,1,1)
order by substr(class_time,1,1);


-- ���̽� 4: Department�� �л� average overall gpa
select department, avg(overall_gpa) as ��ռ���
from student_gpa
group by department
order by ��ռ��� desc;

-- ���̽� 5: �л� �̸�, �Ҽ� �к�, �а� ���
select student_info.name, student_gpa.department, student_gpa.major
from student_info
left outer join student_gpa on student_info.student_id=student_gpa.student_id;








