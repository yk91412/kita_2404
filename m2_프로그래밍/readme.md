 # isidentifier()는 파이썬의 문자열 메서드로, 주어진 문자열이 유효한 식별자인지를 확인
- 키워드는 확인하지 않는다
- 키워드인지 확인하기 위해서는 keyword.iskeyword(s) 괄호안에 값을 넣어야 사용가능하다

  * 그외 확인 가능한 함수
  * isnumeric() > isdigit() > isdemical() : 숫자인지 확인
    (isnumeric이 가장 포괄적이며 수로 볼 수 있다면 True, isdigit은 주어진 문자열을 int형으로 변환가능한지 알아낸다,  isdemical은 단일글자가 숫자이면 True)
    (2의 제곱의 경우에서는 isdemical만 False를 반환함/isnumeric 숫자값 표현에 해당하는 문자열이라면까지 인정함(분수,제곱근,거듭제곱))
  * isalnum() : 문자열이 숫자 영어 한글로되어있으면 참 or 아니면 거짓
  * isalpha : 알파벳이 맞는지 확인
  * isspace : 공백이 맞는지 확인
