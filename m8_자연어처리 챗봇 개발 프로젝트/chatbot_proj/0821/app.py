import pandas as pd
from flask import Flask, render_template, request, redirect, url_for, session, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests
from database import db, get_user, create_user, save_chat, get_chat_history, ChatHistory
from flask_migrate import Migrate
from datetime import timedelta, datetime

app = Flask(__name__)
app.secret_key = '809f4ce2787d43eabf3c7be1b85582368557683b7c966ea1'

app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SECURE'] = False
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=1)



# SQLAlchemy 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://user1:user1@localhost/chatbot_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SQLAlchemy 객체와 Flask 앱 연결
db.init_app(app)

# Migrate 객체 생성
migrate = Migrate(app, db)

# 데이터베이스 초기화
with app.app_context():
    db.create_all()


# CSV 파일에서 금융 상품 데이터 읽기
financial_products = pd.read_csv('financial_products.csv')

# GPT API 설정
GPT_API_URL = 'https://api.openai.com/v1/chat/completions'
GPT_API_KEY = ''


# 시스템 메시지 정의
system_message = """
    당신은 금융 상품 전문가입니다.
    당신의 주된 일은 사용자의 질문에 따라 맞춤형 상품을 추천합니다.
    상품과 관련해서 묻는 질문은 중학생도 알아 듣기 쉽게 설명해줍니다.

    ** 추천 방식 **

    추천하는 상품의 종류는 총 3가지로, 예금, 적금, 파킹통장이 있습니다.

    상품을 추천할 때는 기본금리가 높은 순으로 3개, 최고금리가 높은 순으로 3개를 추천합니다.

    단, 최고한도가 넘지 않는 상품을 골라 추천합니다.

    추천시 은행은 제 1금융권과 제 2금융권을 포함합니다.

    제 1금융권은 저축은행을 제외한 은행과 뱅크로 끝납니다.
    예를 들어 KB국민은행, 신한은행, 우리은행, KEB하나은행, 부산은행, 경남은행, 대구은행, 광주은행, 전북은행, 제주은행, SC제일은행, 씨티은행, 카카오뱅크, 케이뱅크, 토스뱅크, 한국은행, 수출입은행, KDB산업은행, IBK기업은행, Sh수협은행, NH농협은행입니다.


    제 2금융권은 보험회사, 증권회사, 자산운용회사, 저축은행, 상호금융기관,
    여신전문금융회사(카드사, 캐피탈) 등입니다.
    예를 들어 KB저축은행, 하나저축은행 등이 있습니다.

    사용자가 제공하는 정보를 바탕으로 가장 적절한 상품을 추천하되, 상품의 특징과 이점을 명확하게 설명합니다.

    추천을 할 때는 다음의 정보를 포함시킵니다:
    - 해당하는 상품의 은행, 상품명
    - 상품의 기본금리, 최고금리
    - 이자 계산 방식(단리인지 복리인지 알려줍니다.)
    - 적립 방식(적금인 경우에만 알려주며, 정액 적립식인지 자유 적립식인지 알려줍니다. )
    - 가입 대상
    - 개월 수
    - 가입 방법
    - 기타 유의사항

    ** 추천 형식 **
    은행과 상품명은 양 옆에 **을 붙입니다. 예를 들어 : ** 하나은행 내맘 적금 **
    한 상품의 정보를 다 알려줬다면
    다음 상품을 한줄 띄고 보여줍니다.

    기본 금리가 높은 순으로 3개를 먼저 보여주고, 최고 금리가 높은 순 3개를 보여주기전
    =으로 선을 나눕니다.
    선으로 나눌 때는 한줄 전체를 =로 사용합니다.

    한 문장이 끝나고 다음 문장을 시작할 때 줄바꿈을 합니다.





    ** 사용자 질문 형식 **
    1. 3가지의 상품 중 하나를 골라 추천을 해달라고 할 땐 추천 방식에 따라 추천합니다.
    예를 들어, 적금을 들려고 하는데 추천해줘라고 할 경우 적금 상품 중에서 기본금리가 높은 순으로 3개, 최고금리가 높은 순으로 3개를 추천합니다.
    단, 상품명도 자세히 적어줍니다.

    2. 입출금이 쉬운 상품을 찾는다면 파킹통장을 우선으로 추천합니다. 파킹통장도 기본금리가 높은 순으로 3개, 최고금리가 높은 순으로 3개를 추천합니다.
    3. 나이와 성별을 입력했다면 가입대상에 맞춰서 추천합니다.
    4. 특정 개월 수가 아니라면 재입력을 받습니다.
    5. 원하는 특정 은행이 있다면 그 은행에서만 상품을 추천해줍니다.
    6. 사용자가 우대조건을 말할 경우 그 우대에 맞는 상품을 우선적으로 보여줍니다.
    7. 1개월동안 돈을 넣는 경우 파킹통장을 우선으로 추천합니다.
     추천시 이유를 알려줍니다.
    8. 추천시 제 1금융권과 제 2금융권 모두를 포함하지만 특정 은행이나 특정 금융권을 원한다면 특정한 곳에 속하는 상품을 추천합니다.




    ** 개월 수 제한 **
    개월 수는 1개월, 3개월, 6개월, 12개월, 24개월, 36개월이 있습니다.

    이 개월 수외에 다른 개월 수를 받으면 가능한 개월 수를 알려주고 다시 입력을 받아야 합니다.

    예를 들어 5개월동안 적금을 들려고 하는 사용자가 있다면,

    가능한 개월수는 1개월, 3개월, 6개월, 12개월, 24개월, 36개월이 있습니다.

    이중에서 선택해 주세요.라고 재 입력을 받아야 합니다.




    ** 사용자와 상호작용 **
    상담하는 말투로 상냥하고 정중하게 제안합니다. 사용자가 특정 언어를 요구하지 않는 이상 한국어로 질의응답을 합니다.



    ** 최고 금리 계산 **
    사용자가 특정 상품의 우대 조건을 궁금해 할 경우 우대 조건을 보여주고, 해당하는 번호를 입력 받습니다.

    기본 금리에 우대 금리를 합하여 알려줍니다.

    해당하는 번호를 입력 받은 후에 다음의 정보를 포함시켜 알려줍니다.:
    - 기본금리에 우대금리를 합한 금리
    - 세후 이자율

    세후 이자율 계산은 기본금리에 우대금리를 합한 금리 * 0.846을 해서 나온 결과에 소수점 한자리까지 알려줍니다.






"""

def filter_financial_products(product_type, min_duration=None, max_duration=None):
    filtered_df = financial_products[financial_products['상품종류'] == product_type]
    
    if min_duration and max_duration:
        filtered_df = filtered_df[(filtered_df['개월수'] >= min_duration) & (filtered_df['개월수'] <= max_duration)]
    
    return filtered_df



        

@app.route('/', methods=['GET', 'POST'])
def index():
    user_id = session.get('user_id')

    if not user_id and 'chat_history' not in session:
        session.pop('chat_history', None)  # 세션에서 이전 기록 삭제 (초기화)
        chat_history = []  # 빈 리스트로 초기화
    elif user_id:
        chat_history = get_chat_history(user_id)  # 로그인된 사용자의 대화 기록 불러오기
    else:
        chat_history = session.get('chat_history', [])

    current_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    if request.method == 'POST':
    

        user_input = request.form.get('message')

        # GPT API 호출을 위한 설정
        headers = {
            'Authorization': f'Bearer {GPT_API_KEY}',
            'Content-Type': 'application/json',
        }
        data = {
            'model': 'gpt-4o-mini-2024-07-18',
            'messages': [
                {'role': 'system', 'content': system_message},
                {'role': 'user', 'content': user_input}
            ],
            'max_tokens': 1500,
        }


        # 사용자의 입력을 메시지로만 추가
        chat_history.append({'role': 'user', 'message': user_input})

        # GPT API 호출
        response = requests.post(GPT_API_URL, headers=headers, json=data)
        try:
            response_data = response.json()
            bot_response = response_data['choices'][0]['message']['content'].strip()
        except KeyError:
            bot_response = "죄송합니다. 요청 처리 중 오류가 발생했습니다."
        
        # GPT 응답을 메시지로만 추가
        chat_history.append({'role': 'bot', 'message': bot_response})

        # 채팅 기록 저장
        if user_id:
            save_chat(user_id, user_input, 'user')  # 사용자 메시지 저장
            save_chat(user_id, bot_response, 'bot')  # 봇 응답 저장
        else:
            session['chat_history'] = chat_history  # 세션에 대화 기록 저장

        # POST 요청 후 대화 기록을 렌더링
        return render_template('index.html', chat_history=chat_history)

    return render_template('index.html', chat_history=chat_history)

# @app.route('/reset_session', methods=['POST'])
# def reset_session():
#     session.clear()  # 세션 데이터 초기화
#     return '', 204  # No Content 응답


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        user = get_user(username, email, password)
        
        if user:
            session['user_id'] = user.id  # 사용자의 세션에 ID를 저장

        return redirect(url_for('index'))
    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        password_confirm = request.form['password_confirm']
        
        if password == password_confirm:
            create_user(username, email, password)
            return redirect(url_for('login'))
        else:
            error = "Passwords do not match."
    return render_template('register.html', error=error)


@app.route('/logout')
def logout():
    # session.pop('user_id', None)  # 로그아웃 시 세션에서 사용자 ID를 삭제
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)