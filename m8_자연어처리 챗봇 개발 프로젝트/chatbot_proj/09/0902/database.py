from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import requests
from config import GPT_API_KEY, GPT_API_URL

db = SQLAlchemy()

# 모델 클래스 추가
class Summary(db.Model):
    __tablename__ = 'summary'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    date = db.Column(db.String(255), nullable=False)
    summary = db.Column(db.Text, nullable=False)
    user = db.relationship('User', backref=db.backref('summaries', lazy=True))
    
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
    summary_id = db.Column(db.Integer, db.ForeignKey('summary.id'))
    message = db.Column(db.Text, nullable=False)
    role = db.Column(db.String(10), nullable=False)  # 'user' or 'bot'
    user = db.relationship('User', backref=db.backref('chats', lazy=True))
    summary = db.relationship('Summary', backref=db.backref('chats', lazy=True))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)


class PasswordResetToken(db.Model):
    __tablename__ = 'password_reset_token'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), nullable=False)
    token = db.Column(db.String(255), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)