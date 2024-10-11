### Flask 서버(백엔드)

1. 가상환경 생성
python3 -m venv myenv

2. 가상환경 활성화
source myenv/bin/activate

3. 패키지 설치
pip install flask flask-cors ultralytics pillow

4. app.py작성

5. best.pt파일 추가

6. flask 서버 실행
python app.py


========================================================

### React 개발 서버(프론트엔드)

1. react 앱 생성
npx create-react-app client

2. cd client

3. 패키지 설치
npm install react-bootstrap bootstrap axios

4. package.json 수정
"overrides": {
    "react-scripts": {
      "@svgr/webpack": "8.1.0",
      "typescript": "4.9.5",
      "postcss": "8.4.38"
    }

제일 밑에 추가


5. rm -rf package-lock.json node_modules


6. npm install 실행

7. proxy 설정
package.json에서 제일 밑에
"proxy": "http://localhost:5000" 추가

8. client src에 있는 App.js 작성

9. App.css 수정

10. react-icon 설치
npm install react-icons

11. npm start

