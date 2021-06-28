import requests, os

def send_message(name, email, message):
    bot_token = os.getenv("BOT_TOKEN")
    URL= "https://api.telegram.org/bot" + bot_token + "/sendMessage"
    headers = {
        'Content-Type': 'application/json',
    }
    chat_id = os.getenv("CHAT_ID")
    text = "Name: " + name + "\nEmail: " + email + "\nMensaje: " + message
    data = '{"chat_id": "' + chat_id + '", "text": "' + text + '", "disable_notification": false"'+ '"}'

    try:
        requests.post( URL, headers = headers, data = data )
        return 'Mensaje enviado a Telegram'

    except Exception as e:
        print( 'La Exception >> ' + type(e).__name__ )
        return 'Error interno al enviar el mensaje a Telegram'
