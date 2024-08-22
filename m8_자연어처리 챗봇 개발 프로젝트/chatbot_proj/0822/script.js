document.addEventListener("DOMContentLoaded", function() {
    var chatWindow = document.querySelector('.chat-window');

    function scrollToBottom() {
        chatWindow.scrollTop = chatWindow.scrollHeight;
    }
    
    scrollToBottom();

    const observer = new MutationObserver(() => {
        scrollToBottom();
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
            response.text().then(() => {
                window.location.reload();
                chatBox.scrollTop = chatBox.scrollHeight;
            })
        });
        
    });

    window.addEventListener("load", function() {
        setTimeout(scrollToBottom, 100);
    });
});
