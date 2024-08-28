document.addEventListener("DOMContentLoaded", function() {
    var chatWindow = document.querySelector('.chat-window');
    var sidebarToggle = document.querySelector('.sidebar-toggle');
    var chatContainer = document.querySelector('.container');
    var sidebar = document.querySelector('.sidebar');
    var chatInputForm = document.querySelector('.chat-input-form');

    function scrollToBottom() {
        var lastMessage = chatWindow.querySelector('.chat-message:last-child');
        if (lastMessage) {
            lastMessage.scrollIntoView({ behavior: 'smooth' });
        }
    }

    function adjustLayout() {
        const isSidebarVisible = document.body.classList.contains('sidebar-visible');

        if (window.innerWidth >= 769) { // 웹에서
            if (isSidebarVisible) {
                chatContainer.style.marginLeft = '200px';
                chatContainer.style.width = 'calc(100% - 200px)';
                sidebar.style.transform = 'translateX(0)'; // 사이드바 보이도록
                chatInputForm.style.width = 'calc(100% - 200px)'; // 입력창 너비 조정
            } else {
                chatContainer.style.marginLeft = '0';
                chatContainer.style.width = '100%';
                sidebar.style.transform = 'translateX(-100%)'; // 사이드바 숨기도록
                chatInputForm.style.width = '100%';
            }
        } else { // 모바일에서
            chatContainer.style.marginLeft = '0';
            chatContainer.style.width = '100%';
            sidebar.style.transform = isSidebarVisible ? 'translateX(0)' : 'translateX(-100%)';
            chatInputForm.style.width = '100%'; // 모바일에서 입력창 너비 조정
        }
    }

    function toggleSidebar() {
        document.body.classList.toggle('sidebar-visible');
        document.body.classList.toggle('sidebar-hidden');
        adjustLayout(); // 레이아웃 조정
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
        .then(html => {
            document.querySelector('.container').innerHTML = html; // 서버에서 받은 응답으로 채팅창 업데이트
            form.reset();
            scrollToBottom(); // 채팅창 스크롤을 하단으로 이동
        })
        .catch(error => console.error('Error during fetch:', error));
    });

    sidebarToggle.addEventListener('click', toggleSidebar);

    window.addEventListener('resize', adjustLayout);

    // 페이지 로드 후 스크롤 조정
    window.addEventListener("load", function() {
        setTimeout(scrollToBottom, 100);
    });
});
