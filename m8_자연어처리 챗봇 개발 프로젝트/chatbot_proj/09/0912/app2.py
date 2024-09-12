import pandas as pd
from flask import Flask, render_template, request, redirect, url_for, session, jsonify
import requests
from database import db, ChatHistory,  User, Summary, Savings, load_savings_from_csv
from function import get_user, create_user, save_chat,  save_summary,\
add_message_to_chat_history, get_summaries, get_chat_by_summary, summarize_text,\
generate_reset_token,verify_reset_token, get_next_summary_id
from flask_migrate import Migrate
from datetime import timedelta, datetime
from config import GPT_API_KEY, GPT_API_URL, MAIL_USERNAME, MAIL_PASSWORD
from flask_mail import Mail, Message
from langchain_openai import ChatOpenAI
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferMemory
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder


app = Flask(__name__)
app.secret_key = '809f4ce2787d43eabf3c7be1b85582368557683b7c966ea1'



# SQLAlchemy 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://user1:user1@localhost/chatbot_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Flask-Mail 설정
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = MAIL_USERNAME
app.config['MAIL_PASSWORD'] = MAIL_PASSWORD
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

mail = Mail(app)
# SQLAlchemy 객체와 Flask 앱 연결
db.init_app(app)

# Migrate 객체 생성
migrate = Migrate(app, db)

with app.app_context():
    db.create_all()
    load_savings_from_csv('savings_final_2.csv')



# 시스템 메시지 정의
system_message = """
    당신은 금융 상품 전문가입니다.
    당신의 주된 일은 사용자의 질문에 따라 맞춤형 상품을 추천합니다.
    상품과 관련해서 묻는 질문은 중학생도 알아 듣기 쉽게 설명해줍니다.



    ** 추천 방식 **

    추천하는 상품은 적금입니다.

    상품을 추천할 때는 기본금리가 높은 순으로 3개를 추천합니다.

    추천시 은행은 제 1금융권과 제 2금융권을 포함합니다.

    제 1금융권은 저축은행을 제외한 은행과 뱅크로 끝납니다.
    예를 들어 KB국민은행, 신한은행, 우리은행, KEB하나은행, 부산은행, 경남은행, 대구은행, 광주은행, 전북은행, 제주은행, SC제일은행, 씨티은행, 카카오뱅크, 케이뱅크, 토스뱅크, 한국은행, 수출입은행, KDB산업은행, IBK기업은행, Sh수협은행, NH농협은행입니다.

    제 2금융권은 은행명이 '~저축은행'과 같이 구성되어있습니다.
    예를 들어 KB저축은행, 하나저축은행 등이 있습니다.

    사용자가 제공하는 정보를 바탕으로 가장 적절한 상품을 추천하되, 상품의 특징과 이점을 명확하게 설명합니다.
    추천을 할 때는 ** 추천 형식 ** 과 같이 추천합니다.



    ** 개월 수 제한 **

    개월 수는 1개월, 3개월, 6개월, 12개월, 24개월, 36개월이 있습니다.

    사용자가 따로 저축할 기간을 말하지 않는다면 이 ** 개월 수 제한 ** 을 참고해서 추천할 필요가 없지만,
    사용자가 저축할 기간을 말했을 때 이 개월 수외에 다른 개월 수를 받으면 가능한 개월 수를 알려주고 다시 입력을 받아야 합니다.

    예를 들어, 5개월동안 적금을 들려고 하는 사용자가 있다면,
    가능한 개월수는 1개월, 3개월, 6개월, 12개월, 24개월, 36개월이 있습니다.

    이중에서 선택해 주세요.라고 재 입력을 받아야 합니다.






    ** 사용자 질문 형식 **
    사용자가 ** 프로세스 ** 에 있는 질문과 같은 질문을 한다면 ** 프로세스 ** 에 답변과 똑같이 대답합니다.




    ** 프로세스 **
    프로세스는 총 3가지가 있습니다.
    1번은 공통 답변이며, 1번 답변에 따른 사용자 질문에 따라 2-1, 2-2, 2-3으로 맞춰서 대답합니다.
    2-2로 시작하면 3-1, 4-1, 5-1, 6-1, 7-1순으로 대답합니다.
    2-3로 시작하면 3-2, 4-2, 5-2순으로 대답합니다.
    아래 예시 사용자 질문과 같이 질문을 한다면 답변과 똑같이 대답합니다.

    1. 
    사용자 질문 : 적금 추천해줘
    (적금이라는 단어가 들어간다면 아래 답변과 같이 대답합니다.)
    답변 : 적금 상품을 생각하고 계시군요 
            1) 간단한 상품 추천
            2) 원하는 조건에 맞는 상품 추천
            3) 우대조건에 맞는 상품 추천
            이중에 선택해주세요 !

        단, 1번, 2번, 3번을 제외하고 다른 번호를 받았을 경우 재입력을 받아야합니다.
        간단한 상품 추천, 원하는 조건에 맞는 상품 추천, 우대조건에 맞는 상품 추천으르 제외하고 다른 추천을 원할 경우 재입력을 받아야합니다.


    2-1. * 간단한 상품 추천을 했을 경우 *
    사용자가 1번이나 간단한 상품을 추천을 원한다고 했을 경우

    답변 : 
    <h2> 기본금리가 높은 순으로 3개의 적금 상품 추천해드리겠습니다! </h2>
    <br><br>
    <button onclick="window.location.href='https://www.pepperbank.kr/'"> TOP 1. 페퍼저축은행 - 정기적금 : </button>
    - 기본금리 : 6.0%
    - 우대금리 : 6.0%
    - 적립 방식 : 정액적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 개인고객(당행 입출금 계좌 보유 고객 중 페퍼스타디움 방문 관람 시 제공된 쿠폰코드를 수령한 고객/ 1인1계좌)/쿠폰 유효기간에 한함
    - 가입 방법 : 스마트폰

    <button onclick="window.location.href='https://www.pepperbank.kr/'"> TOP 2. 페퍼저축은행 - 페퍼스 펫적금 with 핏펫 : </button>
    - 기본금리 : 5.0%
    - 우대금리 : 5.0%
    - 적립 방식 : 정액적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 개인고객(1인 1계좌, 당행 입출금 보유고객 중 핏펫 앱에서 로그인 후 쿠폰코드를 수령한 고객)
    - 가입 방법 : 스마트폰

    <button onclick="window.location.href='https://www.o2banking.com/'"> TOP 3. 오투저축은행 - 정기적금 : </button>
    - 기본금리 : 5.0%
    - 우대금리 : 5.0%
    - 적립 방식 : 정액적립식
    - 이자 계산 방식 : 복리
    - 가입 대상 : 제한없음
    - 가입 방법 : 영업점



==================================================================



    2-2. * 원하는 조건에 맞는 상품을 추천했을 경우 *
    사용자가 2번이나 조건에 맞는 상품을 추천을 원한다고 했을 경우

    답변 : 원하는 조건에 맞는 상품을 원하시군요. 몇 개월동안 저축하실지 생각하셨나요?


    3-1.
    사용자 질문 : 12개월 생각중이예요
    (1개월, 3개월, 6개월, 12개월, 24개월, 36개월중 개월 수 하나를 선택하면 그에 맞는 답변을 해줍니다.
    단, ** 개월 수 제한 ** 에 따라 해당하지 않는 개월 수를 말한다면 다시 입력을 받아야합니다. )
    답변 : 12개월 적금 상품을 찾고 계시군요! 원하시는 적립방식이 있나요? 적립방식에는 자유적립/정액적립 방식이 있습니다.





    4-1.
    사용자 질문 : 자유적립방식이 좋겠어요.
    (자유 적립이나 정액 적립중 하나를 선택한다면 아래 답변과 같이 대답합니다.
    단, 자유 적립이나 정액 적립을 제외하고 다른 적립을 말한다면 다시 입력을 받아야합니다.)
    답변 : 좋아요! 저축 금액은 한 달에 얼마정도 생각하고 계신가요?

    5.1.
    사용자 질문 : 10만원 정도 할거 같아요.
    답변 : 원하는 이자 계산 방식이 있으신가요 ? 계산방식에는 단리/복리가 있습니다.

    6-1. 
    사용자 질문 : 단리로 할게요.
    답변 : 
    <h2> 기본금리가 높은 순으로 3개의 적금 상품 추천해드리겠습니다! </h2>
    <br><br>
    <button onclick="window.location.href='https://www.cksavingsbank.co.kr/'"> TOP 1. CK저축은행 - 정기적금 : </button>
    <br>
    - 기본금리 : 4.4%
    - 우대금리 : 4.4%
    - 적립 방식 : 자유적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 제한없음
    - 가입 방법 : 영업점/인터넷/스마트폰

    <button onclick="window.location.href='https://www.daemyungbank.co.kr/'"> TOP 2. 대명상호저축은행 - 정기적금 : </button> 
    <br>
    - 기본금리 : 4.1%
    - 우대금리 : 4.1%
    - 적립 방식 : 자유적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 제한없음
    - 가입 방법 : 영업점

    <button onclick="window.location.href='http://www.kusb.co.kr/'"> TOP 3. 유니온저축은행 - 정기적금 : </button>
    <br>
    - 기본금리 : 4.0%
    - 우대금리 : 4.0%
    - 적립 방식 : 자유적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 제한없음
    - 가입 방법 : 인터넷/스마트폰




    7-1.
    사용자 질문 : CK저축은행 정기적금을 가입할 경우 받을 수 있는 금액이 얼마인가요?
    답변 : CK저축은행 정기적금에 관심이 있으시군요 ! CK저축은행 정기적금 상품 가입시 12개월 뒤 받을 금액 알려드리겠습니다!
    이자는 12 * 100,000 * 0.044 * 0.846 = 이자이고
    총 금액은 12 * 100,000 + 이자 입니다.
    단, 답변을 할 때는 이자를 계산을 해서 숫자로 바꿔 대답합니다.




=================================================================================
    
    2-3. * 우대조건에 맞는 상품을 추천했을 경우 *
    사용자가 3번이나 우대 조건에 맞는 상품을 추천을 원한다고 했을 경우

    답변 : 우대조건에 맞는 상품을 원하시군요. 고객님의 정보를 가볍게 서술해주시겠어요 ?


    3-2. 
    사용자 질문 : 저는 20살 청년입니다. 집에 강아지를 키우고 있어요
    답변 : 감사합니다 ! 
    조건에 맞는 금융 상품을 추천해볼게요 !

    <button onclick="window.location.href='https://www.jejubank.co.kr/'"> TOP 1. 제주은행 - MZ 플랜적금 : </button>
    <br> 
    - 기본금리 : 4.0%
    - 우대금리 : 5.5%
    - 적립 방식 : 자유적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 개인 및 개인사업자
    - 가입 방법 : 영업점/인터넷/스마트폰
    - 개월 수 : 24
    - 우대 조건 :
    ① 매월 1회이상 지속적 납입시:1년제: 0.50%
    ② 목표 금액 달성:0.50%
    ③ 신용카드/체크카드 합산 사용액 월10만원 이상 사용: 0.50%
    * 청년이니까응원합니다 이벤트 : 0.50%

    <button onclick="window.location.href='https://www.shinhansavings.com/'"> TOP 2. 신한저축은행 - 청포도 청년적금 : </button>
    <br>
    - 기본금리 : 4.1%
    - 우대금리 : 4.1%
    - 적립 방식 : 정액적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 19~39세
    - 가입 방법 : 인터넷/스마트폰
    - 개월 수 : 6개월
    - 우대 조건:
    ① 개인(신용)정보 수집?이용 동의[상품서비스안내 등] 상품서비스 안내 수단 전체 동의시 0.1 % 우대금리 제공
    ② 계약기간 총 월불입금 횟수의 1/2이상을 당사 입출금계좌에서 이체하여 불입하는 경우 0.3% 우대금리 제공
    ③ 가입 후 만기해지시까지 통장 미발행시(ESG) 0.6% 우대금리 제공

    <button onclick="window.location.href='https://www.kbstar.com/'"> TOP 3. 국민은행 - KB반려행복적금 : </button>
    <br> 
    - 기본금리 : 3.5%
    - 우대금리 : 5.0%
    - 적립 방식 : 자유적립식
    - 이자 계산 방식 : 단리
    - 가입 대상 : 실명의 개인
    - 가입 방법 : 스마트폰
    - 개월 수 : 36개월
    - 우대 조건 :
    ① 반려동물 등록: 연 0.2%p
    ② 미지(유기)입양: 연 0.2%p
    ③ 반려동물애정활동: 연 0.2%p
    ④ 반려동물요금제: 연 0.2%p
    ⑤ KB거래감사: 연 0.2%p ⑥ KB첫거래: 연 0.5%p

    4-2.
    사용자 질문 : KB반려행복적금이 맘에 들어요.
    답변 : 우대조건은 이렇습니다. 해당하는 번호를 알려주세요.
    ① 반려동물 등록: 연 0.2%p
    ② 미지(유기)입양: 연 0.2%p
    ③ 반려동물애정활동: 연 0.2%p
    ④ 반려동물요금제: 연 0.2%p
    ⑤ KB거래감사: 연 0.2%p ⑥ KB첫거래: 연 0.5%p


    5-2. 
    사용자 질문 : 1번, 2번에 해당합니다.
    답변 : 기본금리는 3.5%이고, 우대조건은 0.2% + 0.2% = 0.4%이므로,
    총 금리 3.9%입니다.



    ** 사용자와 상호작용 **
    상담하는 말투로 상냥하고 정중하게 제안합니다. 사용자가 특정 언어를 요구하지 않는 이상 한국어로 질의응답을 합니다.




"""


chat_memory = ConversationBufferMemory()
chat_model = ChatOpenAI(api_key=GPT_API_KEY, model="gpt-4o-mini-2024-07-18")



@app.route('/', methods=['GET', 'POST'])
def index():
    user_id = session.get('user_id')
    sidebar_visible = session.get('sidebar_visible', True)
    summary_id = session.get('summary_id')

    if user_id:
        chat_history = session.get('chat_history', [])
        summaries = get_summaries(user_id)
    else:
        chat_history = session.get('chat_history', [])
        summaries = []  # 로그아웃 상태에서는 요약을 표시하지 않음

    if request.method == 'POST':
        user_input = request.form.get('message')
        print("Chat history reset")
        # 대화 초기화
        if user_id and session.get('chat_reset', False):
            chat_history = []
            session['chat_reset'] = False

        # 첫 대화 시 날짜 추가
        if user_id and session.get('show_date', False):
            current_date = datetime.now().strftime('%Y-%m-%d')
            chat_history.append({'role': 'system', 'message': current_date, 'date': current_date})
            session['show_date'] = False  # 날짜가 한 번 표시된 후에는 다시 표시되지 않도록 플래그를 설정
            print(f"Date added: {current_date}")

        add_message_to_chat_history(chat_history, {'role': 'user', 'message': user_input})
        print(f"Chat history updated: {chat_history}")



        conversation = ConversationChain(
            llm=chat_model,
            memory=chat_memory
        )

        # 시스템 메시지 및 사용자 입력 처리
        conversation_input = system_message + f"\n사용자: {user_input}\n"
        print(f"Conversation input: {conversation_input}")
        bot_response = conversation.run(input=conversation_input)
        print(f"Bot response: {bot_response}")

        try:
            # 봇 응답 처리
            bot_response_cleaned = bot_response.replace('\n', '<br>')
            print(f"Bot response cleaned: {bot_response_cleaned}")

        except KeyError as e:
            print(f"KeyError: {e}")
            bot_response_cleaned = "죄송합니다. 요청 처리 중 오류가 발생했습니다."
        print('완료')
        add_message_to_chat_history(chat_history, {'role': 'bot', 'message': bot_response_cleaned})

# 첫 대화 이후에만 요약 생성 및 저장
        if user_id :
            if len(chat_history) == 3:  # 첫 대화가 완료된 후에만 요약 저장
                latest_summary_id = max([s.id for s in summaries], default=0)
                if summary_id is None or summary_id != latest_summary_id:
                    current_date = datetime.now().strftime('%Y-%m-%d')
                    question_summary = summarize_text(user_input)
                    summary_id = save_summary(user_id, current_date, question_summary)
                    session['summary_id'] = summary_id
                    summaries = get_summaries(user_id)  # 요약 리스트 업데이트

            # 이후 대화는 기존 summary_id에 저장
        if user_id and summary_id:
            save_chat(user_id, user_input, 'user', summary_id)
            save_chat(user_id, bot_response, 'bot', summary_id)

        session['chat_history'] = chat_history
        print(f"Final chat history: {chat_history}")

        return render_template('index.html', chat_history=chat_history, summaries=summaries,sidebar_visible=sidebar_visible, show_sidebar=True)

    return render_template('index.html', chat_history=chat_history, summaries=summaries,sidebar_visible=sidebar_visible, show_sidebar=True)

# 새채팅을 시작하는 함수
@app.route('/start_new_chat', methods=['POST'])
def start_new_chat():
    user_id = session.get('user_id')

    # 새로운 summary_id 생성
    new_summary_id = get_next_summary_id()
    print(f"{new_summary_id}가 생성되었습니다")
    # 새로운 채팅 시작 시 기존 채팅 기록과 요약을 초기화
    session['chat_history'] = []
    print("초기화를 합니다")
    session['summary_id'] = new_summary_id  # 새로 생성된 summary_id 저장
    session['show_date'] = True

    return jsonify({'status': 'success', 'summary_id': new_summary_id,'show_date': session['show_date']}), 200


@app.route('/summary/<int:summary_id>', methods=['GET'])
def show_summary(summary_id):
    user_id = session.get('user_id')
    print('summary id가 존재합니다')
    if user_id:
        chat_history = get_chat_by_summary(user_id, summary_id)
        session['chat_history'] = chat_history
        session['summary_id'] = summary_id
        print('id와 history를 불러옵니다')

        # if session.get('show_date', False):
        #     # 날짜는 사용자가 첫 질문을 할 때 추가되도록 하기 위해 초기 단계에서 처리하지 않음
        #     session['show_date'] = 'pending'  # 날짜 생성을 위해 대기 상태로 설정

        # if len(chat_history) == 3 and session.get('show_date', '') == 'pending':
        #     # 첫 질문이 추가된 후 날짜를 추가
        #     current_date = datetime.now().strftime('%Y-%m-%d')
        #     chat_history.insert(0, {'role': 'system', 'message': current_date, 'date': current_date})
        #     session['show_date'] = False  # 날짜가 추가된 후에는 플래그를 변경

        # if len(chat_history) == 3:  # 첫 대화가 완료된 후에만 요약 저장
        #     latest_summary_id = max([s.id for s in get_summaries(user_id)], default=0)
        #     if summary_id is None or summary_id != latest_summary_id:
        #         question_summary = summarize_text(chat_history[-1]['message'])  # 최근 메시지 또는 대화의 마지막 부분 요약
        #         summary_id = save_summary(user_id, current_date, question_summary)
        #         session['summary_id'] = summary_id
        #         summaries = get_summaries(user_id)  # 요약 리스트 업데이트



        return render_template('index.html', chat_history=chat_history, summaries=get_summaries(user_id), show_sidebar=True)
    return redirect(url_for('index'))


# 대화기록 삭제 함수
@app.route('/delete_summary/<int:summary_id>', methods=['POST'])
def delete_summary(summary_id):
    user_id = session.get('user_id')
    if user_id:
        # 해당 요약을 가져와서 사용자가 소유한 경우 삭제합니다.
        summary = Summary.query.filter_by(id=summary_id, user_id=user_id).first()
        if summary:
            # 관련된 채팅 기록도 삭제합니다.
            ChatHistory.query.filter_by(summary_id=summary_id).delete()
            db.session.delete(summary)
            db.session.commit()
            return jsonify({'status': 'success'}), 200
    return jsonify({'status': 'failure'}), 403


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = get_user(email, password)

        if user:
            session['user_id'] = user.id
            session['chat_history'] = []  # 로그인 시 채팅 기록 초기화
            session['show_date'] = True  # 날짜 표시 여부 초기화
            session['chat_reset'] = True
            # 로그인 성공 시
            session['sidebar_visible'] = True

            return redirect(url_for('index'))
        else:
            error = "이메일 또는 비밀번호가 잘못되었습니다."
            return render_template('login.html', error=error, show_sidebar=False)
    return render_template('login.html', show_sidebar=False)


# 비밀번호 찾기 페이지
@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']
        user = db.session.query(User).filter_by(email=email).first()

        if user:
            # 비밀번호 재설정 링크 생성 (예: 토큰 사용)
            reset_token = generate_reset_token(user.email)
            reset_url = url_for('reset_password', token=reset_token, _external=True)

            # 이메일 전송
            msg = Message('비밀번호 재설정 요청', sender=MAIL_USERNAME, recipients=[email])
            msg.body = f'비밀번호 재설정을 하시려면 다음 링크를 클릭하십시오: {reset_url}'
            mail.send(msg)

            return '비밀번호 재설정 링크가 이메일로 전송되었습니다.'
        else:
            error = "등록된 이메일이 없습니다."
            return render_template('forgot_password.html', error=error, show_sidebar=False)
    return render_template('forgot_password.html', show_sidebar=False)

# 비밀번호 재설정 페이지
@app.route('/reset_password/<token>', methods=['GET', 'POST'])
def reset_password(token):
    email = verify_reset_token(token)  # 토큰 검증 함수 호출
    if email is None:
        return '잘못된 또는 만료된 링크입니다.'

    if request.method == 'POST':
        new_password = request.form['password']
        user = db.session.query(User).filter_by(email=email).first()
        if user:
            user.password = new_password
            db.session.commit()
            return redirect(url_for('login'))

    return render_template('reset_password.html', show_sidebar=False)




@app.route('/register', methods=['GET', 'POST'])
def register():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        password_confirm = request.form['password_confirm']

        existing_user = db.session.query(User).filter_by(email=email).first()
        if existing_user:
            error = "이미 존재하는 이메일입니다."
        elif password != password_confirm:
            error = "비밀번호가 일치하지 않습니다."
        else:
            # 새로운 사용자 생성
            create_user(username, email, password)
            return render_template('register.html', success=True, show_sidebar=False)

    return render_template('register.html', error=error, show_sidebar=False)


@app.route('/logout')
def logout():
    session.clear()  # 모든 세션 변수를 삭제하여 초기화

    return redirect(url_for('index'))



if __name__ == '__main__':
    app.run(debug=True)
