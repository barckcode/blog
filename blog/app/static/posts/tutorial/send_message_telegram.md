---
Title: Cómo enviar mensajes a un Bot de Telegram con Curl y Python
Authors: helmcode
Date: 24/08/2021
Categories: tutorial
File: send_message_telegram
Description: En este post tendrás un ejemplo de cómo enviar un mensaje al chat de un Bot de Telegram utilizando curl y otro ejemplo utilizando Python.
Published: Yes
---

# Cómo enviar mensajes a un Bot de Telegram con Curl y Python
En este post tendrás un ejemplo de cómo enviar un mensaje al chat de un Bot de Telegram utilizando curl y otro ejemplo utilizando Python.
Aquí solo se va a cubrir cómo enviar un mensaje, sin embargo, puedes utilizar la misma fórmula para realizar otras tareas con el Bot de Telegram.

**Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
#### Requisitos previos:
- Necesitamos una cuenta de [Telegram](https://web.telegram.org/) y [crear un Bot.](https://core.telegram.org/bots#6-botfather)
- Obten el Token de tu Bot de Telegram con [@BotFather](https://telegram.me/BotFather), guarda el Token porque lo necesitaremos a lo largo del tutorial.
- En Telegram recuerda añadir tu Bot para poder ver los mensajes que envíes a su chat.

¿Lo tienes todo? Perfecto! Entonces podemos comenzar.

### Enviando mensaje con CURL:
Curl es un comando disponible en la mayoría de sistemas Linux y MacOS. Esta herramienta nos permite realizar peticiones a URLs utilizando diversos protocolos. Si quieres saber más sobre curl en este [post](https://www.hostinger.es/tutoriales/comando-curl) explican más en detalle las características de este comando.

Para poder enviar mensajes al chat de tu Bot primero debemos conseguir el ID del Chat que nos proporciona Telegram, esto lo podemos conseguir tambien mediante CURL ejecutando lo siguiente:

```bash
curl https://api.telegram.org/bot$BOT_TOKEN/getUpdates | jq .message.chat.id
```

Recuerda sustituir la variable $BOT_TOKEN por tu Token del Bot. Te doy un ejemplo completo de cómo sería la petición anterior utilizando un Token:

```bash
curl https://api.telegram.org/bot110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw/getUpdates | jq .message.chat.id
```

Una vez tengas el ID del chat de tu Bot, vamos a realizar una petición HTTP de tipo POST, para enviar el mensaje, de la siguiente manera:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "$CHAT_ID", "text": "Esto es una prueba desde CURL"}' \
     https://api.telegram.org/bot$BOT_TOKEN/sendMessage
```

Recuerda sustituir las variables $CHAT_ID y $BOT_TOKEN por tus datos correspondientes.

Un ejemplo completo de la petición anterior sería:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "0123456789", "text": "Esto es una prueba desde CURL"}' \
     https://api.telegram.org/bot110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw/sendMessage
```

Ahora si revisas en Telegram, en el chat de tu Bot tendrás un mensaje que pone _Esto es una prueba desde CURL_


#### Enviando mensaje con Python:
Al igual que antes debes tener tanto tu ID del chat del Bot de Telegram como el Token de tu Bot.

Para realizar la petición desde Python vamos a utilizar la librería **request**. Te dejo aquí el snippet de código que voy a utilizar:

```python
import requests

def send_message():
    bot_token = "110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw"
    URL = "https://api.telegram.org/bot" + bot_token + "/sendMessage"
    headers = {
        'Content-Type': 'application/json',
    }
    chat_id = "0123456789"
    text = "Esto es una prueba desde Python"
    data = '{"chat_id": "' + chat_id + '", "text": "' + text + '", "disable_notification": false"'+ '"}'

    try:
        requests.post(URL, headers=headers, data=data)
        return 'Mensaje enviado a Telegram'

    except Exception as e:
        print( 'La Exception >> ' + type(e).__name__ )
        return 'Error interno al enviar el mensaje a Telegram'
```

Como ves en este caso hemos guardado nuestro ID del chat y el Token del Bot en las variables **bot_token** y **chat_id** respectivamente.

Además aquí en la variable **data**, hemos añadido un parámetro adicional para que no nos deshabilite las notificaciones en Telegram al enviarnos el mensaje. Esto lo hemos hecho con el parámetro "disable_notification" en "false".

Como ves es bastante sencillo pero a la vez es realmente potente y útil.

Espero que este post te haya sido de utilidad, si tienes cualquier consulta o darme feedback puedes enviarme un mensaje de [contacto](https://helmcode.com/contact) o sino siempre puedes mandarme un [Tweet](https://twitter.com/helmcode).

Hasta la próxima!
