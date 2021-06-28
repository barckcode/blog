import requests

def send_message(name, email, message):
    URL= 'https://api.telegram.org/bot1313288615:AAEPcm_I_aSHai2HZdPy-oU3oAfzm4Gd_fk/sendMessage'
    headers = {
        'Content-Type': 'application/json',
    }
    chat_id = '501502268'
    text = 'Name: ' + name + '\nEmail: ' + email + '\nmensaje: ' + message
    notification = False
    data = '{"chat_id": "' + chat_id + '", "text": "' + text + '", "disable_notification": false"'+ '"}'

    try:
        requests.post( URL, headers = headers, data = data )
        return 'Mensaje enviado a Telegram'

    except Exception as e:
        print( 'La Exception >> ' + type(e).__name__ )
        return 'Error interno al enviar el mensaje a Telegram'
