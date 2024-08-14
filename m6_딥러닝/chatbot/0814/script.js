

document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('button').addEventListener('click', sendMessage);

    function sendMessage() {
        var userInput = document.getElementById('user-input').value;
        if (userInput.trim() === '') return;

        fetch('/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ message: userInput }),
        })
        .then(response => response.json())
        .then(data => {
            var chatBox = document.getElementById('chat-box');
            chatBox.innerHTML += '<div class="chat-message"><strong>You:</strong> ' + userInput + '</div>';
            chatBox.innerHTML += '<div class="chat-message"><strong>Bot:</strong> ' + data.reply + '</div>';
            document.getElementById('user-input').value = '';
            chatBox.scrollTop = chatBox.scrollHeight; // Scroll to bottom
        });
    }
});
