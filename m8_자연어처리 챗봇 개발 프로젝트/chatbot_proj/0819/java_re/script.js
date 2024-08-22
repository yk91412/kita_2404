document.addEventListener("DOMContentLoaded", function() {
    var chatWindow = document.querySelector('.chat-window');

    function scrollToBottom() {
        var lastMessage = chatWindow.querySelector('.chat-message:last-child');
        if (lastMessage) {
            lastMessage.scrollIntoView({ behavior: 'smooth' });
        }
        console.log("Scroll to bottom triggered. Last message scrolled into view.");
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
        .then(response => {
            console.log("Response status:", response.status);
            return response.text();
        })
        .then(() => {
            console.log("Form submitted successfully. Reloading...");
            window.location.reload();
        });
    });

    window.addEventListener("load", function() {
        setTimeout(scrollToBottom, 100);
    });
});
