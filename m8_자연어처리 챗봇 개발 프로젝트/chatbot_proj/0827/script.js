document.addEventListener("DOMContentLoaded", function() {
    var chatWindow = document.querySelector('.chat-window');

    function scrollToBottom() {
        var lastMessage = chatWindow.querySelector('.chat-message:last-child');
        if (lastMessage) {
            lastMessage.scrollIntoView({ behavior: 'smooth' });
        }
    }

    scrollToBottom(); // 페이지 로드 시 스크롤을 최하단으로 이동

    const observer = new MutationObserver(() => {
        scrollToBottom(); // DOM에 변동이 있을 때마다 스크롤을 최하단으로 이동
    });
    observer.observe(chatWindow, { childList: true, subtree: true });

    document.querySelector(".chat-input-form").addEventListener("submit", function(event) {
        event.preventDefault();

        var form = event.target;

        fetch(form.action, {
            method: 'POST',
            body: new FormData(form)
        })
        .then(response => response.text())
        .then(() => {
            console.log("Form submitted successfully.");
            // 사이드바 상태 유지 및 레이아웃 조정
            adjustLayout(); 
            // 채팅창 스크롤을 하단으로 이동
            scrollToBottom();
        });
    });

    function adjustLayout() {
        const isSidebarVisible = document.body.classList.contains('sidebar-visible');
        const chatContainer = document.querySelector('.container');
        const chatInputForm = document.querySelector('.chat-input-form');

        if (window.innerWidth >= 769) { // 웹에서
            if (isSidebarVisible) {
                chatContainer.style.marginLeft = '200px';
                chatContainer.style.width = 'calc(100% - 200px)';
                chatInputForm.style.left = '200px';
                chatInputForm.style.width = 'calc(100% - 200px)';
            } else {
                chatContainer.style.marginLeft = '0';
                chatContainer.style.width = '100%';
                chatInputForm.style.left = '0';
                chatInputForm.style.width = '100%';
            }
        } else { // 모바일에서
            chatContainer.style.marginLeft = '0';
            chatContainer.style.width = '100%';
            chatInputForm.style.left = '0';
            chatInputForm.style.width = '100%';
        }
    }

    // 사이드바 토글 버튼 클릭 시
    document.querySelector('.sidebar-toggle').addEventListener('click', function() {
        document.body.classList.toggle('sidebar-visible');
        document.body.classList.toggle('sidebar-hidden');
        adjustLayout(); // 레이아웃 조정
    });

    // 페이지 로드 및 창 크기 조정 시 레이아웃 조정
    adjustLayout();
    window.addEventListener('resize', adjustLayout);
    
    // 페이지 로드 후 스크롤 조정
    window.addEventListener("load", function() {
        setTimeout(scrollToBottom, 100);
    });
});
