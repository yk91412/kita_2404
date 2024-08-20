


document.addEventListener('DOMContentLoaded', function() {
    const chatWindow = document.querySelector('.chat-window');

    function scrollToBottom() {
        chatWindow.scrollTop = chatWindow.scrollHeight;
    }

    // 페이지 로드 시 스크롤을 맨 아래로 이동
    scrollToBottom();

    // 메시지가 추가될 때마다 스크롤을 맨 아래로 이동
    const observer = new MutationObserver(scrollToBottom);
    observer.observe(chatWindow, { childList: true });
});


