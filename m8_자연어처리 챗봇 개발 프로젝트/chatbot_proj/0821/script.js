// document.addEventListener("DOMContentLoaded", function() {
//     var chatWindow = document.querySelector('.chat-window');

//     // 스크롤을 최하단으로 이동시키는 함수
//     function scrollToBottom() {
//         chatWindow.scrollTop = chatWindow.scrollHeight;
//     }

//     // 페이지 로드 시 스크롤을 최하단으로 이동
//     scrollToBottom();

//     // 메시지 제출 후 페이지가 새로 로드되면 스크롤을 최하단으로 이동
//     document.querySelector(".chat-input-form").addEventListener("submit", function() {
//         setTimeout(scrollToBottom, 100);
//     });

//     // MutationObserver를 사용하여 메시지가 추가될 때 스크롤을 하단으로 이동
//     const observer = new MutationObserver(scrollToBottom);
//     observer.observe(chatWindow, { childList: true, subtree: true });
// });



// 채팅창 form(박스), submit 이벤트 감지를 위해 변수 선언
// let chatForm = document.querySelector('.chat-input-form');

// // 준비 함수, 약간의 시간을 두어 scroll 함수를 호출하기
// function prepareScroll() {
//   window.setTimeout(scrollChatWindow, 50);
// }

// // scroll 함수
// function scrollChatWindow() {
//   // 채팅창 전체 div 요소
//   let chatWindow = document.querySelector('.chat-window');
//   chatWindow.scrollTop = chatWindow.scrollHeight; // 스크롤의 위치를 최하단으로
// }

// // submit 이벤트 감지
// chatForm.addEventListener('submit', prepareScroll);



// window.addEventListener('beforeunload', function(event) {
//     // 이 요청은 브라우저 새로 고침 및 닫힘을 포함한 모든 unload 이벤트를 처리합니다.
//     navigator.sendBeacon('/reset_session');  // 비동기 요청을 사용하여 세션 초기화
// });


document.addEventListener("DOMContentLoaded", function() {
    var chatWindow = document.querySelector('.chat-window');


    // 스크롤을 최하단으로 이동시키는 함수
    function scrollToBottom() {
        chatWindow.scrollTop = chatWindow.scrollHeight;
    }

    // 페이지 로드 시 스크롤을 최하단으로 이동
    scrollToBottom();

    // 메시지 제출 후 페이지가 새로 로드되면 스크롤을 최하단으로 이동
    document.querySelector(".chat-input-form").addEventListener("submit", function(event) {
        event.preventDefault(); // 폼 제출 이벤트를 막아 서버로의 리퀘스트를 차단
        var form = event.target;
        
        // 서버에 제출 (AJAX 또는 fetch를 이용하여)
        // 이 부분은 필요에 따라 변경
        setTimeout(function() {
            form.submit();
            scrollToBottom(); // 제출 후 스크롤을 하단으로 이동
        }, 100);
    });

    // MutationObserver를 사용하여 메시지가 추가될 때 스크롤을 하단으로 이동
    const observer = new MutationObserver(scrollToBottom);
    observer.observe(chatWindow, { childList: true, subtree: true });
});
