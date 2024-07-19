import os

# 현재 파일의 절대 경로를 기반하는 basedir 변수를 설정. 이 변수는 프로젝트의 기본 디렉터리를 나타낸다
# os.path.abspath(path) : 주어진 경로 path의 절대 경로를 반환
# __file__ 의 디렉토리 부분만을 추출. D:\kdt_240424\workspace\M4_웹어플리케이션\TodoList_10
# D:\kdt_240424\workspace\m4_웹어플리케이션\TodoList_10
basedir = os.path.abspath(os.path.dirname(__file__))
# flask configuration
# 세션 데이터 암호화, csrf 보호 등을 위해 사용


class Config:
    SECRET_KEY = 'a4e404bb64b98ad5d42a72ae8c83ac3a10f2dce3270d10c0'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://user1:user1@localhost:3306/user2_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    UPLOADED_FILES_DEST = os.path.join(basedir,"uploads")


# uploaded configuration
# 파일 업로드시 저장할 기본경로를 설정

# os.path.join(basedir,"uploades")
# os.path.join 함수는 여러 경로 요소를 하나의 경로로 결합