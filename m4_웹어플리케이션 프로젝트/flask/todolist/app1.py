# 1. 시크릿 키 생성
# 시크릿 키(Secret Key)는 애플리케이션의 보안을 강화하고, 다양한 보안 관련 기능(예: 웹 폼의 CSRF 공격 방어)을 수행하는 데 중요한 역할

# secrets 모듈 사용
# def함수를 통해 return secrets.token_hex(24) => 16진수 문자열 생성 => 함수를 불러와서 키 확인

from flask import Flask, render_template, redirect, url_for, request, jsonify
# Flask: 웹 애플리케이션을 생성하는 핵심 프레임워크.
# render_template: HTML 템플릿을 렌더링합니다 => 보여준다
# redirect, url_for: 사용자를 리디렉션하고 URL을 생성합니다
# request: 들어오는 요청 데이터를 처리
# jsonify: 파이썬 객체를 JSON 응답으로 변환
from flask_sqlalchemy import SQLAlchemy
# SQLAlchemy: 데이터베이스 작업을 위한 ORM (객체 관계 매핑) 라이브러리
from flask_wtf import FlaskForm
# FlaskForm: WTForms와 Flask를 통합하는 기본 클래스
from wtforms import StringField, SubmitField
# StringField, SubmitField: WTForms의 폼 필드
from wtforms.validators import DataRequired
# DataRequired: 필드가 비어 있지 않도록 하는 검증기

app = Flask(__name__)
# app.config 객체를 통해 애플리케이션의 설정을 관리
app.config['SECRET_KEY'] = 'f0b468ea34d7c402fd23119807bd7fe2927e79c2208a55c7'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///example.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# SQLAlchemy는 데이터베이스에 대한 모든 변경 사항을 추적
db = SQLAlchemy(app)
# QLAlchemy 객체를 생성합니다. SQLAlchemy는 Python에서 사용하는 ORM(Object-Relational Mapping) 라이브러리로, 데이터베이스와의 상호 작용을 쉽게


class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)

class TaskForm(FlaskForm):
    #  FlaskForm : 폼을 정의하고 유효성 검사를 쉽게 할 수 있도록 / 상속받음
    # 받는 것들 : 
#     FormField: 다른 폼 클래스를 포함할 수 있습니다.
# StringField: 문자열 입력 필드를 정의할 수 있습니다.
# PasswordField: 비밀번호 입력 필드를 정의할 수 있습니다.
# SubmitField: 폼을 제출하는 버튼을 정의할 수 있습니다.
    title = StringField('Title', validators=[DataRequired()])
    submit = SubmitField('Add Task')

@app.route("/",methods=['GET','POST'])
# @app.route 데코레이터는 Flask 애플리케이션에서 URL 경로와 그에 해당하는 함수를 매핑하는 역할을 합니다. 이 데코레이터를 사용하여 특정 URL 경로로 들어오는 요청(HTTP 요청)을 처리
# GET 요청 처리: 폼 객체 TaskForm을 생성하고, 이를 템플릿에 렌더링하여 사용자에게 입력 폼을 보여줍니다.

# POST 요청 처리: 사용자가 폼을 제출하면 form.validate_on_submit()이 참이 되어 새로운 Task 객체를 생성하고 데이터베이스에 추가한 후, 인덱스 페이지로 리디렉션합니다.
def index():
    form = TaskForm()
    if form.validate_on_submit():
        new_task = Task(title=form.title.data)
        db.session.add(new_task)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('index.html',form=form)

@app.route('/tasks')
def tasks():
    tasks = Task.query.all()
    return jsonify([{'id':task.id, 'title':task.title}for task in tasks])

@app.route('/')
if __name__ == "__main__":
    with app.app_context():
        #Flask 애플리케이션의 컨텍스트 내에서 코드를 실행하기 위한 블록
        db.create_all() # 메서드를 호출하여 데이터베이스의 모든 테이블을 생성
        #데이터베이스가 SQLite인 경우에만 해당
    app.run(debug=True) # 디버그 모드가 활성화되어, 코드 변경 사항이 자동으로 반영되고 디버그 정보가 터미널에 출력
