--학교 관리를 위하여 테이블 2개 이상으로 db를 구축하고 3개 이상 활용할 수 있는 case를 만드세요
--학생 테이블
-- 성적, 과목

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
VALUES (1910101, 1, 4.0, 4.3, '세계사', '국어국문학과', '사회봉사 동아리');

INSERT INTO student_ma
VALUES (2020202, 2, 3.8, 4.5, '세계사', '영어영문학과', '토론 동아리');

INSERT INTO student_ma
VALUES (2130303, 3, 4.5, 4.4, '경제학', '수학과', '프로그래밍 동아리');

INSERT INTO student_ma
VALUES (1940404, 4, 3.9, 4.2, '경제학', '물리학과', '스포츠 동아리');

INSERT INTO student_ma
VALUES (2050505, 5, 4.2, 4.1, '세계사', '역사학과', '학술 동아리');

INSERT INTO student_ma
VALUES (2160606, 6, 4.1, 4.5, '음악이론', '음악학과', '창작의 세계');

INSERT INTO student_ma
VALUES (2270707, 7, 4.4, 4.3, '심리학 기초', '심리학과', '국제문화 동아리');

INSERT INTO student_ma
VALUES (2280808, 8, 4.3, 4.4, '환경과학', '체육학과', '클라이밍 동아리');

INSERT INTO student_ma
VALUES (2190909, 9, 4.5, 4.0, '경제학', '경제학과', '경영 동아리');

INSERT INTO student_ma
VALUES (2001010, 10, 4.0, 4.5, '심리학 기초', '심리학과', '사회 봉사 동아리');


select * from student_ma;

select onesemester+twosemester as 성적
from student_manage;

select substr(student_id,1,2) as 학번 ,count(*) 명수, sum(onesemester+twosemester) 학번별성적
from student_manage
group by substr(student_id,1,2);

--

-- 장학금을 받을 수 있는 학생의 이름을 구하세요(최대 3명)
-- 조건 : 1,2학기 성적이 4점이 넘고 전체 평균학점이 4.2이상인 학생에게 장학금 수여

select *
from ( select i.name, avg(m.onesemester+m.twosemester)/2 as 평균학점
from student_in i inner join student_ma m
on i.student_id = m.student_id
where m.onesemester > 4 and m.twosemester >4
group by m.student_id, i.name
having avg(m.onesemester+m.twosemester)/2 >= 4.2
order by avg(m.onesemester+m.twosemester)/2 desc)
where rownum <= 3;



-- 2. 기숙사 합격이 가능한 학생의 이름과 학번을 구하세요
-- 조건 : 타지역 학생이면서 + 성적이 가장 높은 3명


select *
from (
select i.student_id, i.name, avg(m.onesemester+m.twosemester)/2 평균학점
from student_in i inner join student_ma m
on i.student_id = m.student_id
where regional = 'y'
group by i.student_id, i.name
order by avg(m.onesemester+m.twosemester)/2 desc)
where rownum <= 3;

    
commit;

-- 3. 교양을 듣는 학생이 2명 미만일 경우 교양이 폐지가 될 때 폐지가 되는 교양명을 구하세요
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
family_members number not null, -- 직계가족 수 
regional varchar2(10) not null, -- 본가가 타지역인지. 타지역: "y"
c_address varchar2(150) not null, -- 현재 학생의 거주 주소
s_mobile varchar2(15) not null, -- 학생 전화번호
e_number varchar2(15),-- 비상시 연락 번호
s_email varchar2(50) not null); -- 학생 이메일주소


insert into student_in values(
1910101, '이지은', 'f', 20000115,5,'y','서울특별시 동대문구 이문동', 
'010-1234-5678','010-0987-6543','jieun_lee@gmail.com');

INSERT INTO student_in VALUES (
2020202, '김수현', 'm', 20010515, 4, 'n', '서울특별시 강남구 논현동', 
'010-2345-6789', '010-9876-5432', 'soohyun_kim@gmail.com');

INSERT INTO student_in VALUES (
2130303, '박신혜', 'f', 20021123, 3, 'y', '서울특별시 서초구 반포동', 
'010-3456-7890', '010-8765-4321', 'shinhye_park@gmail.com');

INSERT INTO student_in VALUES (
1940404, '이민호', 'm', 20001004, 2, 'n', '서울특별시 서초구 반포동', 
'010-4567-8901', '010-7654-3210', 'minho_lee@gmail.com');

INSERT INTO student_in VALUES (
2050505, '배수지', 'f', 20000212, 5, 'y', '서울특별시 마포구 연남동', 
'010-5678-9012', '010-6543-2109', 'suzy_bae@gmail.com');

INSERT INTO student_in VALUES (
2160606, '송중기', 'm', 20020722, 3, 'n', '서울특별시 마포구 연남동', 
'010-6789-0123', '010-5432-1098', 'joongki_song@gmail.com');

INSERT INTO student_in VALUES (
2270707, '송혜교', 'f', 20020417, 4, 'y', '서울특별시 용산구 이태원동', 
'010-7890-1234', '010-4321-0987', 'hyekyo_song@gmail.com');

INSERT INTO student_in VALUES (
2280808, '박공유', 'm', 20000110, 6, 'y', '경기도 고양시 일산서구 대화동', 
'010-8901-2345', '010-3210-9876', 'gong_yoo_p@gmail.com');

INSERT INTO student_in VALUES (
2190909, '전지현', 'f', 20011220, 3, 'y', '경기도 성남시 분당구 정자동', 
'010-9012-3456', '010-2109-8765', 'jihyun_jun@gmail.com');

INSERT INTO student_in VALUES (
2001010, '박보검', 'm', 19990616, 5, 'n', '서울특별시 종로구 혜화동', 
'010-0123-4567', '010-1098-7654', 'bogum_park@gmail.com');


