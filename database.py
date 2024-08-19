from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

def init_db():
    db.create_all()

def get_user(username, email, password):
    return db.session.query(User).filter_by(username=username, email=email, password=password).first()

def create_user(username, email, password):
    new_user = User(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

def save_chat(user_id, message):
    if user_id:
        chat = ChatHistory(user_id=user_id, message=message)
        db.session.add(chat)
        db.session.commit()

def get_chat_history(user_id=None):
    if user_id:
        return ChatHistory.query.filter_by(user_id=user_id).all()
    return []  # 로그아웃 상태에서는 빈 리스트를 반환

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password = db.Column(db.String(255), nullable=False)

class ChatHistory(db.Model):
    __tablename__ = 'chat_history'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    message = db.Column(db.Text, nullable=False)
    user = db.relationship('User', backref=db.backref('chats', lazy=True))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
