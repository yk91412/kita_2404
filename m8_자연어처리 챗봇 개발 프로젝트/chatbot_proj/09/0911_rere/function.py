import requests
from config import GPT_API_KEY, GPT_API_URL
from database import db, User, ChatHistory, PasswordResetToken
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta
import logging
import pdb
import secrets
from openai import OpenAI
from flask import session
import redis

def get_user(email, password):
    return db.session.query(User).filter_by(email=email, password=password).first()

def create_user(username, email, password):
    new_user = User(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

def save_chat(user_id, message, role, summary_id, summary=None):
    try:
        if user_id:
            chat = ChatHistory(user_id=user_id, message=message, role=role, summary_id=summary_id, summary=summary)
            db.session.add(chat)
            db.session.commit()
            logging.debug(f'Successfully saved chat: {message}')
    except Exception as e:
        logging.error(f'Error saving chat: {e}')
        db.session.rollback()




def get_summaries(user_id):
    """
    로그인 시 사이드바에 표시될 요약 목록을 불러옵니다.
    """
    if user_id:
        return ChatHistory.query.filter_by(user_id=user_id).order_by(ChatHistory.timestamp.desc()).all()
    return []

def get_chat_by_summary(user_id, summary_id):
    """
    요약을 클릭했을 때 해당 요약에 해당하는 전체 대화 기록을 불러옵니다.
    """
    if user_id and summary_id:
        chat_history = ChatHistory.query.filter_by(user_id=user_id, summary_id=summary_id).order_by(ChatHistory.timestamp).all()
        return [{'role': chat.role, 'message': chat.message} for chat in chat_history]
    return []


def summarize_text(text):
  
    client = OpenAI(api_key= GPT_API_KEY)
    response = client.chat.completions.create(
        model="gpt-4o-mini-2024-07-18",
        messages=[
                 {'role': 'system', 'content': '당신은 받은 내용을 간략하게 요약합니다. 예를 들어, 사용자가 "채팅 봇이 ~문제가 있어" 라고 하면 채팅 봇 문제 해결이라고 간결하게 요약합니다'},
                 {'role': 'user', 'content': f"다음 내용을 요약해 주세요: {text}"}
                 ],
        max_tokens= 50,
        temperature= 0.5,
    )

    try:
        summary = response.choices[0].message.content.strip()
        if not summary:
            logging.warning("Summary is empty")
        return summary
    except (KeyError, IndexError) as e:
        logging.error(f"Error in API response: {e}")
        return text[:20]

def generate_reset_token(email):
    # 새 토큰 생성
    token = secrets.token_urlsafe()
    expiration = datetime.utcnow() + timedelta(hours=1)  # 토큰 만료 시간 설정 (예: 1시간 후)
    reset_token = PasswordResetToken(email=email, token=token, created_at=datetime.utcnow())
    
    db.session.add(reset_token)
    db.session.commit()
    
    return token

def verify_reset_token(token):
    # 토큰 검증
    reset_token = db.session.query(PasswordResetToken).filter_by(token=token).first()
    
    if reset_token and datetime.utcnow() < reset_token.created_at + timedelta(hours=1):
        return reset_token.email
    else:
        return None
    
# 최대 summary_id 값을 조회하여 새로운 summary_id를 생성하는 함수
def get_next_summary_id():
    max_id = db.session.query(db.func.max(ChatHistory.summary_id)).scalar()
    print(f"가장 큰 id : {max_id}")
    return (max_id or 0) + 1

# # Redis 클라이언트 설정
# redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

# # Redis에서 대화 기록 불러오기
# def get_conversation_from_redis(session_id):
#     history = redis_client.get(f"chat_history:{session_id}")
#     if history:
#         return eval(history)  # 문자열을 리스트로 변환
#     return []

# # Redis에 대화 기록 저장
# def save_conversation_to_redis(session_id, chat_history):
#     redis_client.set(f"chat_history:{session_id}", str(chat_history))  # 리스트를 문자열로 변환 후 저장

# # 로그인 상태에서 DB와 Redis 대화 기록 병합
# def merge_db_and_session(user_id, session_id):
#     db_history = get_chat_by_summary(user_id, session.get('summary_id'))
#     redis_history = get_conversation_from_redis(session_id)
#     return db_history + redis_history if redis_history else db_history

# # AI 모델 호출 및 응답 처리
# def get_ai_response(user_input, system_message):
#     client = OpenAI(api_key=GPT_API_KEY)
#     response = client.chat.completions.create(
#         model="gpt-4o-mini-2024-07-18",
#         messages=[
#             {'role': 'system', 'content': system_message},
#             {'role': 'user', 'content': user_input}
#         ]
#     )
#     return response.choices[0].message.content.strip().replace('\n', '<br>')