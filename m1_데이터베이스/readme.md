
- distinct 중복 제거
- 
  ex) select distinct publisher from book
  
- like 정확히 일치하는 행만 선택
- 
  %활용 => %구% 구가 어디에나 포함되어 있는지
  
  ex) select * from book
      where bookname like '_구%'

      => 앞에 아무 한글자+구+아무 글자(없어도 가능)

  ====================================================
  
- join
  
   ** 내부조인
  
      inner join : 교집합
  
   ** 외부 조인 : 일치하는게 없다면 null

      left outer join
      right outer join
      full outer join

    ** cross join : 모든 가능한 조합 생성


   ====================================================

 * 데이터 타입
  
1. 숫자형 (Numeric Types)

--NUMBER: 가장 범용적인 숫자 데이터 타입. 정수, 실수, 고정 소수점, 부동 소수점 수를 저장

     number(39,0) 39: 자릿수, 0 : 소수점 /소수점 포함한 자릿수

2. 문자형 (Character Types)

--VARCHAR2(size): 가변 길이 문자열을 저장. size는 최대 문자 길이를 바이트로 지정

*** varchar2 char인지 byte인지 확인법

SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS'

--NVARCHAR2(size)의 사이즈를 지정할 때는 바이트 단위 대신 항상 문자 단위로 크기가 지정

--CHAR(size): 고정 길이 문자열을 저장. 지정된 길이보다 짧은 문자열이 입력되면 나머지는 공백으로 채워짐

3. 날짜 및 시간형 (Date and Time Types)
  
--DATE 타입은 날짜와 시간을 YYYY-MM-DD HH24:MI:SS 형식으로 저장
  
--DATE: 날짜와 시간을 저장. 데이터 타입은 년, 월, 일, 시, 분, 초를 포함

--TIMESTAMP: 날짜와 시간을 더 상세히 나노초 단위까지 저장

--이진 데이터형 (Binary Data Types)

--BLOB: 대량의 이진 데이터를 저장. 이미지, 오디오 파일 등을 저장하는 데 적합

--대규모 객체형 (Large Object Types)

--CLOB: 대량의 문자 데이터를 저장(텍스트)

--NCLOB: 대량의 국가별 문자 집합 데이터를 저장


* 제약조건
  
--PRIMARY KEY : 각 행을 고유하게 식별하는 열(또는 열들의 조합)

                중복되거나 NULL 값을 허용X

--FOREIGN KEY : 다른 테이블의 기본 키를 참조하는 열. 참조 무결성을 유지

--UNIQUE : 열에 중복된 값이 없어야 함을 지정. NULL값이 허용

--NOT NULL : 열에 NULL 값을 허용하지 않는다.

--CHECK : 열 값이 특정 조건을 만족해야 함을 지정 (예: age > 18)

--DEFAULT : 열에 명시적인 값이 제공되지 않을 경우 사용될 기본값을 지정



