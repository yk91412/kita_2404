from flask import Flask, request, jsonify, render_template, redirect, url_for, session
from models import db, User, ChatRecord
from werkzeug.security import generate_password_hash, check_password_hash
import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db.init_app(app)

@app.before_first_request
def create_tables():
    db.create_all()

@app.route('/')
def index():
    chat_records = ChatRecord.query.filter_by(username=session.get('username')).order_by(ChatRecord.timestamp.desc()).all() if 'logged_in' in session else []
    return render_template('index.html', chat_records=chat_records)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        if user and check_password_hash(user.password, password):
            session['logged_in'] = True
            session['username'] = username
            return redirect(url_for('index'))
        return "로그인 실패"
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])
        new_user = User(username=username, password=password)
        db.session.add(new_user)
        db.session.commit()
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json.get('message')
    username = session.get('username', 'Guest')

    bot_response = f"귀하의 메시지 '{user_message}'에 대한 응답입니다."

    # Save chat record to database
    new_record = ChatRecord(username=username, message=user_message)
    db.session.add(new_record)
    db.session.commit()

    return jsonify({'reply': bot_response})


@app.route('/admin')
def admin():
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    records = ChatRecord.query.all()
    return render_template('admin.html', records=records)

if __name__ == '__main__':
    app.run(debug=True)
