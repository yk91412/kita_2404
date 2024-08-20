document.addEventListener('DOMContentLoaded', function() {
    const chatWindow = document.querySelector('.chat-container');
    let isUserScrolling = false;

    // 스크롤 이벤트를 감지하여 사용자가 직접 스크롤하는지 확인
    chatWindow.addEventListener('scroll', function() {
        const isScrolledToBottom = chatWindow.scrollHeight - chatWindow.scrollTop === chatWindow.clientHeight;
        if (!isScrolledToBottom) {
            isUserScrolling = true;
        } else {
            isUserScrolling = false;
        }
    });

    function updateScrollPosition() {
        if (!isUserScrolling) {
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }
    }

    // 페이지 로드 시 스크롤 업데이트
    updateScrollPosition();

    // 메시지가 추가될 때 스크롤 업데이트
    const observer = new MutationObserver(updateScrollPosition);
    observer.observe(chatWindow, { childList: true });
});
