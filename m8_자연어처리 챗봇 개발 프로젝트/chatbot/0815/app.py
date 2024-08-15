from flask import Flask, render_template, request, redirect, url_for, session, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests
import pandas as pd
from database import db, get_user, create_user, save_chat, get_chat_history, ChatHistory

app = Flask(__name__)
app.secret_key = '809f4ce2787d43eabf3c7be1b85582368557683b7c966ea1'

# SQLAlchemy 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://user1:user1@localhost/chatbot_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SQLAlchemy 객체와 Flask 앱 연결
db.init_app(app)

# 데이터베이스 초기화
with app.app_context():
    db.create_all()

# GPT API 설정
GPT_API_URL = 'https://api.openai.com/v1/completions'
GPT_API_KEY = ''

@app.route('/', methods=['GET', 'POST'])
def index():
    user_id = session.get('user_id')
    
    if request.method == 'POST':
        user_input = request.form.get('message')
        
        # Save user input to database if logged in
        if user_id:
            save_chat(user_id, user_input)
        
        # Call GPT API
        headers = {
            'Authorization': f'Bearer {GPT_API_KEY}',
            'Content-Type': 'application/json',
        }
        data = {
            'model': 'text-davinci-003',
            'prompt': f'User input: {user_input}\nProvide a response based on the input:',
            'max_tokens': 150,
        }
        response = requests.post(GPT_API_URL, headers=headers, json=data)
        
        try:
            response_data = response.json()
            bot_response = response_data['choices'][0]['text'].strip()
        except KeyError:
            bot_response = "Sorry, there was an error processing your request."
        
        # Save bot response to database if logged in
        if user_id:
            save_chat(user_id, bot_response)
        
        # Get updated chat history
        chat_history = get_chat_history(user_id) if user_id else []
        return render_template('index.html', chat_history=chat_history)
    
    # Load chat history if logged in
    chat_history = get_chat_history(user_id) if user_id else []
    return render_template('index.html', chat_history=chat_history)

 


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        user = get_user(username, email, password)
        if user:
            session['user_id'] = user.id
            return redirect(url_for('index'))
        else:
            return "Invalid credentials, please try again."
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        password_confirm = request.form['password_confirm']
        
        if password == password_confirm:
            create_user(username, email, password)
            return redirect(url_for('login'))
        else:
            return "Passwords do not match."
    return render_template('register.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
