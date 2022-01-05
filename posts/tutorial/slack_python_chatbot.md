---
Title: Cómo crear un Chatbot en Slack con Python
Authors: helmcode
Date: 30/09/2021
Categories: tutorial
File: slack_python_chatbot
Description: En este post vamos a construir un ChatBot en Slack, el cuál nos permitirá ejecutar mediante comandos, scripts en el servidor donde esté corriendo el Chatbot.
Published: Yes
---

# Cómo crear un Chatbot en Slack con Python.
En este post vamos a construir un ChatBot en Slack, el cuál nos permitirá ejecutar mediante comandos en Slack, scripts, comandos y casi cualquier cosa en el servidor donde esté corriendo el Chatbot.
Para crearlo vamos a utilizar Python y [Bolt](https://slack.dev/bolt-python/concepts), el cuál es un Framework que nos permite construir aplicaciones para Slack.

**Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
#### Requisitos previos:
Lo primero que necesitas es tener una cuenta y un espacio de trabajo en Slack, ya sea gratuito o de pago. Una vez tengas esto deberás [crear una aplicación en Slack](https://api.slack.com/apps/new).

Si has pinchado en el Link anterior se te habrá abierto una pantalla como la siguiente:

![create_slack_app](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/slack_python_chatbot/create_slack_app.png)

Selecciona la opción marcada en la imagen, **"From scratch"**.
Ahora asigna un nombre para tu Chatbot(Esta es la forma en la que se mostrará en Slack) y finalmente escoge el espacio de trabajo donde quieres agregar esta aplicación.

Magnífico, vamos ahora a configurar los Tokens necesarios para desarrollar nuestro Chatbot. Por darte un poco de contexto, Slack nos provee de varios tipos de tokens dependientdo del uso que vayamos a darle a nuestra aplicación. En nuestro caso utilizaremos dos Tokens, a nivel de bot (xoxb) y a nivel de aplicación (xapp).

---

#### Generando el Bot Token.
En el panel de la izquierda, ve hasta **"OAuth & Permissions"** y ve hasta la parte donde pone **"Bot Token Scopes"**. Aquí presiona el botón que pone **"Add an OAuth Scope"**.
Ahora agrega los permisos: `commands` y `chat:write`.

Una vez hayas agregado los permisos ve a la parte de arriba de la página y presiona el botón **"Install App to Workspace"**. Se te abrirá una ventana donde tendrás que aceptar que la aplicación se instale en tu espacio de trabajo en Slack. En cuanto lo autorices podrás ver el Token de Bot que nos proporciona Slack:

![bot_token](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/slack_python_chatbot/bot_token.png)

---


#### Generando el App Token y activando el modo Socket.

Nuevamente en el panel de la izquierda selecciona **"Basic Information"**. Si bajas un poco verás el apartado **"App-Level Tokens"**. Aquí pincha en el botón **"Generate Token and Scopes"**. En el modal que se te ha abierto, asigna un nombre al Token y presiona en **"Add Scope"**. Selecciona la opción de `connections:write`. En cuanto guardes se te proporcionará el Token de aplicación. Cópialo y guárdalo en un lugar seguro porque lo necesitaremos para después.

Tras esto ve al panel de la izquierda y selecciona la opción **"Socket Mode"** y habilita esta opción.

---


#### Creando nuestro primeros comandos.
Para este ejemplo vamos a crear dos comandos:

- /help : Nos mostrará la ayuda y comandos disponibles de nuestro Bot.
- /echo_chatbot : Ejecutará el comando echo en nuestro sistema.

Antes de entrar en código, debemos crearlos en Slack. En el panel de la izquierda dirígete hacia **"Slash Commands"**. Aquí crea los comandos que hemos indicado anteriormente:

![slash_commands](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/slack_python_chatbot/slash_commands.png)

Tras crear estos comandos seguramente tengamos que reinstalar nuestra aplicación, para ello ve al panel de la izquierda en la sección **"Install App"** y presiona en el botón **"Reinstall to Workspace"**

---


#### Empezando con el Chatbot.
Ahora que ya hemos obtenido los Tokens, activado el Socket Mode y creado nuestros primeros comandos, podemos empezar a crear nuestro ChatBot. Como buena práctica vamos a crear nuestro entorno virtual:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Además para consumir nuestros Tokens vamos a exportar dos variables de entorno (Recuerda sustituir cada variable por tu Token correspondiente):

```bash
export SLACK_BOT_TOKEN=tu_bot_token
export SLACK_APP_TOKEN=tu_app_token
```

Por último, vamos a instalar Bolt:

```bash
pip install slack_bolt
```

---


#### Empecemos a codear por fin!
Vamos a crear crear un fichero llamado app.py y agregaremos el siguiente código:

```python
import os
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler


# Init Bolt
app = App(
    token=os.environ.get("SLACK_BOT_TOKEN")
)


# Commands List
@app.command("/help")
def help(ack, say, command):
    # Acknowledge command request
    ack()
    say(
        blocks=[
            {
                "type": "divider",
            },
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": "Comandos del Chatbot"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*Hola <@{command['user_name']}>*, te dejo los comandos que tengo disponibles:"
                },
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "- */help*: Comando para obtener la ayuda del Chatbot"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "- */echo_chatbot*: Comando para obtener ejecutar el comando echo en el sistema"
                }
            },
            {
                "type": "divider",
            },
        ],
        text=f"Help by <@{command['user_name']}>!"
    )


@app.command("/echo_chatbot")
def echo_chatbot(ack, say, command):
    # Acknowledge command request
    ack()

    script_output = subprocess.call(["/bin/echo", "Hola desde Slack"])

    if script_output == 0:
        say(
            blocks=[
                {
                    "type": "divider",
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": f"@{command['user_name']} Se ha ejecutado el comando con éxito."
                    },
                },
                {
                    "type": "divider",
                },
            ],
            text=f"Echo Chatbot by <@{command['user_name']}>!"
        )


# Start App
if __name__ == "__main__":
    handler = SocketModeHandler(app, os.environ["SLACK_APP_TOKEN"])
    handler.start()
```

Aunque he dejado algunos comentarios indicativos, vamos a explicar un poco el código:

- Primero importamos los componentes que necesitaremos para construir nuestro Chatbot.
- A continuación inicializamos Bolt, pasándole la variable de entorno que contiene nuestro Bot token.
- Después tenemos nuestros dos comandos: /help y /echo_chatbot. Estos envían una respuesta a Slack mediante la función **"say()"** que indica los bloques de datos a mostrar. Si quieres saber más sobre los bloques que podemos enviar a Slack te recomiendo esta [doc](https://api.slack.com/reference/block-kit/blocks).
- Finalmente arrancamos nuestra aplicación, donde también le pasamos nuestro App token.

---


#### Arrancando y probando nuestro Chatbot.
Para arrancar nuestro Chatbot ejecutaremos:

```bash
python3 app.py
```

Ahora irémos a Slack y en el canal que queramos llamaremos a nuestro Chatbot para añadirlo al canal que queramos. En mi caso mi Chatbot se llama **"r2d2"** y lo añadiré en el canal `#general`

![r2d2](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/slack_python_chatbot/r2d2.png)

Ahora ya podrás llamar a los comandos que hemos configurado!

![r2d2_help](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/slack_python_chatbot/r2d2_help.png)

---

Espero que este post te haya sido de utilidad, si tienes cualquier consulta o quieres darme feedback puedes enviarme un mensaje de [contacto](https://helmcode.com/contact) o sino siempre puedes mandarme un [Tweet](https://twitter.com/helmcode).

Hasta la próxima!
