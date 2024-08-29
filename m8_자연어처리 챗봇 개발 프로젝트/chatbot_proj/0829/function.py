import requests
from config import GPT_API_KEY, GPT_API_URL
from database import User, Summary, ChatHistory
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from database import db
import logging


def get_user(username, email, password):
    return db.session.query(User).filter_by(username=username, email=email, password=password).first()

def create_user(username, email, password):
    new_user = User(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

def save_chat(user_id, message, role,summary_id):
    if user_id:
        chat = ChatHistory(user_id=user_id, message=message, role=role, summary_id=summary_id)
        db.session.add(chat)
        db.session.commit()

def get_chat_history(user_id=None):
    if user_id:
        # 데이터베이스에서 대화 기록 가져오기
        chat_records = ChatHistory.query.filter_by(user_id=user_id).all()
        # ChatHistory 객체를 딕셔너리로 변환
        chat_history = [{'role': chat.role, 'message': chat.message} for chat in chat_records]
        return chat_history
    return []  # 로그아웃 상태에서는 빈 리스트를 반환


def add_message_to_chat_history(chat_history, message, user_id=None):
    if user_id and not chat_history:
        current_date = datetime.now().strftime('%Y-%m-%d')
        chat_history.append({'role': 'system', 'message': current_date, 'date': current_date})
    chat_history.append(message)


import pdb

def save_summary(user_id, date, summary):
    if user_id:
        print(f"User ID: {user_id}")
        print(f"Date: {date}")
        print(f"Summary: {summary}")
        
        summary_entry = Summary(user_id=user_id, date=date, summary=summary)
        db.session.add(summary_entry)
        try:
            db.session.commit()
            print(f"Summary saved successfully: {summary_entry}")
            return summary_entry.id
        except Exception as e:
            db.session.rollback()
            print(f"Error saving summary: {e}")
            return None
    return None





def get_summaries(user_id):
    """
    로그인 시 사이드바에 표시될 요약 목록을 불러옵니다.
    """
    if user_id:
        return Summary.query.filter_by(user_id=user_id).order_by(Summary.date.desc()).all()
    return []

# def get_chat_by_summary(user_id, summary_id):
#     """
#     요약을 클릭했을 때 해당 요약에 해당하는 전체 대화 기록을 불러옵니다.
#     """
#     if user_id:
#         summary = Summary.query.filter_by(id=summary_id, user_id=user_id).first()
#         if summary:
#             chat_history = ChatHistory.query.filter_by(user_id=user_id).filter(ChatHistory.timestamp >= summary.date).order_by(ChatHistory.timestamp).all()
#             return [{'role': chat.role, 'message': chat.message} for chat in chat_history]
#     return []

def get_chat_by_summary(user_id, summary_id):
    """
    요약을 클릭했을 때 해당 요약에 해당하는 전체 대화 기록을 불러옵니다.
    """
    if user_id and summary_id:
        summary = Summary.query.filter_by(id=summary_id, user_id=user_id).first()
        if summary:
            chat_history = ChatHistory.query.filter_by(user_id=user_id).filter(ChatHistory.timestamp >= summary.date).order_by(ChatHistory.timestamp).all()
            return [{'role': chat.role, 'message': chat.message} for chat in chat_history]
    return []


def summarize_text(text):
    headers = {
        'Authorization': f'Bearer {GPT_API_KEY}',
        'Content-Type': 'application/json',
    }
    data = {
        'model': 'gpt-4o-mini-2024-07-18',
        'messages': [{'role':'system', 'content':'당신은 받은 내용을 간략하게 요약합니다. 예를 들어, 사용자가 "채팅 봇이 ~문제가 있어" 라고 하면 채팅 봇 문제 해결이라고 간결하게 요약합니다'},
                     {'role': 'user', 'content': f"다음 내용을 요약해 주세요: {text}"}],
        'max_tokens': 50,
        'temperature': 0.5,
    }

    response = requests.post(GPT_API_URL, headers=headers, json=data)

    try:
        response_data = response.json()
        summary = response_data['choices'][0]['message']['content'].strip()
        if not summary:
            logging.warning("Summary is empty")
        return summary
    except (KeyError, IndexError) as e:
        logging.error(f"Error in API response: {e}")
        return text[:20]

