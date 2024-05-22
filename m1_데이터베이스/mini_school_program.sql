--�б� ������ ���Ͽ� ���̺� 2�� �̻����� db�� �����ϰ� 3�� �̻� Ȱ���� �� �ִ� case�� ���弼��
--�л� ���̺�
-- ����, ����

create table student_ma(
student_id number,
management_id number primary key,
onesemester number,
twosemester number,
liberalarts varchar2(20),
major varchar2(20),
crew varchar2(20)
);

alter table student_ma modify crew varchar2(40);

delete from student_ma;

INSERT INTO student_ma
VALUES (1910101, 1, 4.0, 4.3, '�����', '������а�', '��ȸ���� ���Ƹ�');

INSERT INTO student_ma
VALUES (2020202, 2, 3.8, 4.5, '�����', '������а�', '��� ���Ƹ�');

INSERT INTO student_ma
VALUES (2130303, 3, 4.5, 4.4, '������', '���а�', '���α׷��� ���Ƹ�');

INSERT INTO student_ma
VALUES (1940404, 4, 3.9, 4.2, '������', '�����а�', '������ ���Ƹ�');

INSERT INTO student_ma
VALUES (2050505, 5, 4.2, 4.1, '�����', '�����а�', '�м� ���Ƹ�');

INSERT INTO student_ma
VALUES (2160606, 6, 4.1, 4.5, '�����̷�', '�����а�', 'â���� ����');

INSERT INTO student_ma
VALUES (2270707, 7, 4.4, 4.3, '�ɸ��� ����', '�ɸ��а�', '������ȭ ���Ƹ�');

INSERT INTO student_ma
VALUES (2280808, 8, 4.3, 4.4, 'ȯ�����', 'ü���а�', 'Ŭ���̹� ���Ƹ�');

INSERT INTO student_ma
VALUES (2190909, 9, 4.5, 4.0, '������', '�����а�', '�濵 ���Ƹ�');

INSERT INTO student_ma
VALUES (2001010, 10, 4.0, 4.5, '�ɸ��� ����', '�ɸ��а�', '��ȸ ���� ���Ƹ�');


select * from student_ma;

select onesemester+twosemester as ����
from student_manage;

select substr(student_id,1,2) as �й� ,count(*) ���, sum(onesemester+twosemester) �й�������
from student_manage
group by substr(student_id,1,2);

--

-- ���б��� ���� �� �ִ� �л��� �̸��� ���ϼ���(�ִ� 3��)
-- ���� : 1,2�б� ������ 4���� �Ѱ� ��ü ��������� 4.2�̻��� �л����� ���б� ����

select *
from ( select i.name, avg(m.onesemester+m.twosemester)/2 as �������
from student_in i inner join student_ma m
on i.student_id = m.student_id
where m.onesemester > 4 and m.twosemester >4
group by m.student_id, i.name
having avg(m.onesemester+m.twosemester)/2 >= 4.2
order by avg(m.onesemester+m.twosemester)/2 desc)
where rownum <= 3;



-- 2. ����� �հ��� ������ �л��� �̸��� �й��� ���ϼ���
-- ���� : Ÿ���� �л��̸鼭 + ������ ���� ���� 3��


select *
from (
select i.student_id, i.name, avg(m.onesemester+m.twosemester)/2 �������
from student_in i inner join student_ma m
on i.student_id = m.student_id
where regional = 'y'
group by i.student_id, i.name
order by avg(m.onesemester+m.twosemester)/2 desc)
where rownum <= 3;

    
commit;

-- 3. ������ ��� �л��� 2�� �̸��� ��� ������ ������ �� �� ������ �Ǵ� ������� ���ϼ���
select liberalarts, count(*)
from student_manage
group by liberalarts
having count(*) < 2;

--
create table student_in(
student_id number primary key,
name varchar2(30) not null,
gender varchar2(30) not null,
birthdate number(8) not null,
family_members number not null, -- ���谡�� �� 
regional varchar2(10) not null, -- ������ Ÿ��������. Ÿ����: "y"
c_address varchar2(150) not null, -- ���� �л��� ���� �ּ�
s_mobile varchar2(15) not null, -- �л� ��ȭ��ȣ
e_number varchar2(15),-- ���� ���� ��ȣ
s_email varchar2(50) not null); -- �л� �̸����ּ�


insert into student_in values(
1910101, '������', 'f', 20000115,5,'y','����Ư���� ���빮�� �̹���', 
'010-1234-5678','010-0987-6543','jieun_lee@gmail.com');

INSERT INTO student_in VALUES (
2020202, '�����', 'm', 20010515, 4, 'n', '����Ư���� ������ ������', 
'010-2345-6789', '010-9876-5432', 'soohyun_kim@gmail.com');

INSERT INTO student_in VALUES (
2130303, '�ڽ���', 'f', 20021123, 3, 'y', '����Ư���� ���ʱ� ������', 
'010-3456-7890', '010-8765-4321', 'shinhye_park@gmail.com');

INSERT INTO student_in VALUES (
1940404, '�̹�ȣ', 'm', 20001004, 2, 'n', '����Ư���� ���ʱ� ������', 
'010-4567-8901', '010-7654-3210', 'minho_lee@gmail.com');

INSERT INTO student_in VALUES (
2050505, '�����', 'f', 20000212, 5, 'y', '����Ư���� ������ ������', 
'010-5678-9012', '010-6543-2109', 'suzy_bae@gmail.com');

INSERT INTO student_in VALUES (
2160606, '���߱�', 'm', 20020722, 3, 'n', '����Ư���� ������ ������', 
'010-6789-0123', '010-5432-1098', 'joongki_song@gmail.com');

INSERT INTO student_in VALUES (
2270707, '������', 'f', 20020417, 4, 'y', '����Ư���� ��걸 ���¿���', 
'010-7890-1234', '010-4321-0987', 'hyekyo_song@gmail.com');

INSERT INTO student_in VALUES (
2280808, '�ڰ���', 'm', 20000110, 6, 'y', '��⵵ ���� �ϻ꼭�� ��ȭ��', 
'010-8901-2345', '010-3210-9876', 'gong_yoo_p@gmail.com');

INSERT INTO student_in VALUES (
2190909, '������', 'f', 20011220, 3, 'y', '��⵵ ������ �д籸 ���ڵ�', 
'010-9012-3456', '010-2109-8765', 'jihyun_jun@gmail.com');

INSERT INTO student_in VALUES (
2001010, '�ں���', 'm', 19990616, 5, 'n', '����Ư���� ���α� ��ȭ��', 
'010-0123-4567', '010-1098-7654', 'bogum_park@gmail.com');


