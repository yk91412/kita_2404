from flask import Flask, render_template, redirect, url_for, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
#  Flask 애플리케이션에서 데이터베이스 마이그레이션을 쉽게 관리할 수 있도록 도와주는 패키지
#  Migrate 클래스는 Flask 애플리케이션과 SQLAlchemy 데이터베이스 객체를 초기화하는 역할
from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, DateField
from wtforms.validators import DataRequired
from flask_wtf.csrf import CSRFProtect
from datetime import datetime
import pytz

app = Flask(__name__)
app.config.from_pyfile('config.py')

db = SQLAlchemy(app)
migrate = Migrate(app,db)
csrf = CSRFProtect(app)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100),nullable=False) 
    contents = db.Column(db.Text, nullable=False) # Text 제한 x
    input_date = db.Column(db.Date, nullable=False, default = datetime.utcnow)
    due_date = db.Column(db.Date, nullable=False)


class TaskForm(FlaskForm):
    title = StringField('제목', validators=[DataRequired()])
    contents = TextAreaField('내용',validators=[DataRequired()])
    due_date = DateField('마감일',format='%Y-%m-%d', validators=[DataRequired()])




# Task 클래스: 데이터베이스의 특정 테이블과 1:1로 매핑되어 데이터베이스의 실제 데이터를 표현합니다. 각 객체는 데이터베이스 레코드의 한 행을 나타냅니다.

# TaskForm 클래스: 사용자가 웹 페이지에서 데이터를 입력하고 제출할 수 있는 폼을 정의합니다.
# 폼은 입력 필드를 포함하고, 이를 통해 사용자 입력을 수집하며, 데이터 유효성 검사를 통해 유효성을 검사한 후 처리합니다.
@app.route('/') #웹 실행시 뜨는 창
def index():
    form = TaskForm()
    csrf_token = form.csrf_token._value()
    return render_template('index.html',form=form, csrf_token = csrf_token)

@app.route('/tasks')
def tasks():
    tasks = Task.query.all()
    return jsonify(
        [
            {
                "id": task.id,
                'title':task.title,
                'contents': task.contents,
                'input_date':task.input_date.strftime('%Y-%m-%d'),
                'due_date': task.due_date.strftime('%Y-%m-%d')
            }
            for task in tasks
        ]
    )

@app.route('/',methods=['POST'])
def add_task():
    form = TaskForm()
    if form.validate_on_submit():
        title = form.title.data
        contents = form.contents.data

        # 한국 시간으로 현재 날짜 설정
        kst = pytz.timezone('Asia/Seoul')
        input_date = datetime.now(kst).date()
        due_date = form.due_date.data

        new_task = Task(
            title= title, contents=contents, input_date = input_date, due_date = due_date
        )
        db.session.add(new_task)
        db.session.commit()
        return redirect(url_for('index'))
    csrf_token = form.csrf_token._value()
    return render_template('index.html',form=form, csrf_token=csrf_token)

@app.route('/edit/<int:task_id>', methods=['GET','POST'])
def edit(task_id):
    task = Task.query.get_or_404(task_id)
    form = TaskForm(obj=task)
    if request.method == 'POST' and form.validate_on_submit():
        task.title = form.title.data
        task.contents = form.contents.data
        task.due_date = form.due_date.data
# task는 데이터베이스의 테이블을 taskform은 인터페이스를 나타내는데 상호작용을 하여 데이터 일관성을 위해서 task 즉 테이블에 다시 할당을 해준다
        db.session.commit()
        return redirect(url_for('index'))
    csrf_token = form.csrf_token._value()
    return render_template(
        'edit_task.html',
        form=form,
        task_id=task.id,
        csrf_token=csrf_token,
        task_title = task.title,
        task_contents=task.contents,
        task_input_date = task.input_date.strftime('%Y-%m-%d'),
        task_due_date = task.due_date.strftime('%Y-%m-%d')
    )

@app.route('/delete/<int:task_id>')
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)
    db.session.delete(task)
    db.session.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)