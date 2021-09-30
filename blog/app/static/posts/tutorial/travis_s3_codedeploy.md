---
Title: Deploy con TravisCI + AWS S3 + AWS CodeDeploy
Authors: helmcode
Date: 15/07/2021
Categories: tutorial
File: travis_s3_codedeploy
Description: En este post encontrarás cómo implementar Continuous Deployment a instancias EC2 utilizando TravisCI + S3 + AWS CodeDeploy
Published: Yes
---

# Deploy con TravisCI + AWS S3 + AWS CodeDeploy
¿Cómo automatizar el proceso de despliegue de nuestras aplicaciones en nuestras instancias EC2 de AWS? Bueno existen muchas maneras de realizar este proceso. En este post encontrarás cómo implementar Continuous Deployment de nuestras aplicaciones en instancias EC2 utilizando TravisCI + S3 + AWS CodeDeploy y GitHub.

**Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
#### Requisitos previos:
- Necesitamos una cuenta de [GitHub](https://github.com/) y un repositorio donde tendremos el código de nuestra aplicación. En mi caso voy a utilizar este: [APP.](https://github.com/helmcode/apps)
- Una cuenta de [TravisCI](https://www.travis-ci.com/), en mi caso yo la he creado sincronizándola directamente con mi cuenta de GitHub, ya que requiere permisos sobre nuestros repositorios para automatizar el proceso de despliegue.
- Una cuenta activa de [AWS](https://aws.amazon.com/es/).

¿Lo tienes todo? Perfecto! Entonces podemos comenzar.

### Configuración de los servicios de AWS:
Empecemos por AWS ya que para este proceso necesitamos hacer uso de varios servicios y asignar permisos para que el deploy se realice correctamente. Para esta serie de pasos vamos a utilizar los siguientes servicios de AWS:

- IAM (Crearemos varias policies, crearemos un usuario específico para TravisCI y crearemos roles para nuestras instancias EC2 y para nuestra aplicación de CodeDeploy)
- EC2 (Crearemos nuestra instancia con los permisos correspondientes)
- S3 (Crearemos un bucket donde se almacenará el código de nuestra aplicación)
- CodeDeploy (Crearemos y configuraremos el deploy de nuestra aplicación)

#### 1.- Policy para los servidores.
Accede a la consola de AWS y busca el servicio de IAM. Una vez estés ahí ve al apartado de Policies que se encuentra en el panel de la izquierda:

![policies](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/policies.png)

Una vez dentro busca un botón azul que pone "Create Policy". Cuando te encuentres dentro de esta opción selecciona la pestaña JSON y te saldrá algo parecido a esto:

![create_policy_json](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/create_policy_json.png)

Elimina el código JSON que aparece y pega el siguiente código:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

Cuando lo hayas pegado, en la parte inferior presiona el botón de "Next", esto te conducirá a un panel donde podrás asignarle Tags a esta Policy, dejo a tu elección ponerle las etiquetas que creas oportunas. Puedes no poner ningún tag en este caso. Cuando hayas finalizado dale a "Next" nuevamente.

En este punto tendremos que asignarle un nombre a nuestra Policy, en mi caso le pondre el nombre:
**DeployEC2_test**

Puedes asignarle el nombre que creas oportuno pero te recomiendo que sea lo más descriptivo posible. En cuanto a la política que estamos creando la utilizaremos para que nuestras instancias EC2 puedan obtener cualquier dato de nuestros buckets de S3.

Una vez hayas finalizado procede a darle a "Create Policy"

#### 2.- Policy para TravisCI.
Igual que antes, en el apartado Policies, crea una nueva Policy que contenga el siguiente JSON:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

En mi caso nombraré esta policy como:
**Travis_deploy_to_S3**

Esta Policy permite a Travis subir el código de nuestra aplicación a S3.

Dado que Travis también interactuará con el servicio de CodeDeploy deberemos crear una política que le de los permisos necesarios. Al igual que antes deberás crear una nueva política con el siguiente JSON:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:RegisterApplicationRevision",
                "codedeploy:GetApplicationRevision"
            ],
            "Resource": [
                "arn:aws:codedeploy:ServerRegion:AccountId:application:CodeDeployApplication"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetDeployment"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:GetDeploymentConfig"
            ],
            "Resource": [
                "arn:aws:codedeploy:ServerRegion:AccountId:deploymentconfig:CodeDeployDefault.AllAtOnce"
            ]
        }
    ]
}
```

Ojo con este código porque hay diferentes cosas que deberás modificar con tus propios datos. Vamos a ir poco a poco. En el **primer** apartado "Resource" que está dentro de "Statement" deberás sustituir los apartados:

- ServerRegion -> Por el código de la región donde estés levantando tus recursos. En mi caso por ejemplo estoy en París, por tanto el código de mi región en **eu-west-3**
- AccountId -> Esto lo puedes encontrar dando click en la parte derecha de la consola en el apartado donde sale tu nombre de cuenta. Cuando le des click se te abrira una pestaña, donde te aparecerá el apartado "My Account", esos números son tu AccountID. Cópialos y sustituyelo en el archivo JSON:

![account_id](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/account_id.png)

- CodeDeployApplication -> Aquí puedes poner el nombre que quieras, sin embargo recuerdalo bien porque así será como se llame la aplicación que crearemos en CodeDeploy más adelante. En mi caso he puesto **blogTest**

En mi caso ha quedado algo como lo siguiente (He sustituido los datos sensibles por cuestiones de seguridad):

```json
            "Resource": [
                "arn:aws:codedeploy:eu-west-3:12345678910:application:blogTest"
            ]
```

Ahora también deberemos sustituir el "Resource" que está al final del JSON. Nuevamente los apartados a sustituir son:

- ServerRegion
- AccountId

Quedando algo como lo siguiente:
```json
            "Resource": [
                "arn:aws:codedeploy:eu-west-3:12345678910:deploymentconfig:CodeDeployDefault.AllAtOnce"
            ]
```

A esta política la he llamado:
**Travis-Code-Deploy-Policy**

#### 3.- Crear un usuario para TravisCI
Ahora en el panel de la izquierda en lugar de Policies, seleccionaremos la opción de "Users". Una vez dentro presionaremos en "Add User"

El usuario en mi caso lo he llamado **TravisCI-test**, aunque como siempre puedes llamarlo como prefieras, además selecciona la opción de "Programmatic access":

![add_user](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/add_user.png)

Ahora en la parte inferior presiona "Next: Permissions" para ir al siguiente punto. Aquí seleccionaremos la opción de "Attach existing policies directly" y en mi caso buscaré y seleccionaré las políticas que necesito según las he nombrado:

- Travis_deploy_to_S3
- Travis-Code-Deploy-Policy

![add_user_policies](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/add_user_policies.png)

Una vez lo tengamos presiona "Next: Tags". Si lo crees conveniente asigna Tags, en caso contrario puedes saltartelo, para ello presiona "Next: Create User". Esto te llevará una pantalla donde tendremos que pulsar en el botón "Dowload .csv". Esto te descargará un fichero con las credenciales de acceso programático del usuario TravisCI-test que acabamos de crear. Guarda este fichero porque lo usaremos más adelante.

#### 4.- Crear un rol para las instancias EC2
Nuevamente en el panel de la izquierda busca y selecciona la opción de "Roles". Dentro presiona en el botón azul "Create role"

Cuando presiones el botón, te aparecerá una pantalla parecida a esta:

![create_role](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/create_role.png)

Selecciona "EC2" y dale a "Next: Permissions". En este punto buscaremos la primera política que creamos, que en mi caso la llamé **DeployEC2_test**. La selecciono y le doy a "Next: Tags":

![create_role_policy](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/create_role_policy.png)

Igual que siempre, si lo necesitas asigna tags a este rol. En mi caso le daré a "Next: Review" y en este apartado solo le asignararemos un nombre al rol:
**CodeDeploy_EC2_DEPLOY_INSTANCE**

#### 4.- Crear un rol para CodeDeploy
Al igual que antes vamos a crear un nuevo rol, pero en esta ocasión seleccionaremos el servicio de "CodeDeploy" y de las opciones que nos da, volveremos a seleccionar CodeDeploy.

En cuanto a permisos por defecto nos asignará la policy: "AWSCodeDeployRole". Le daremos a "Next" hasta el último punto cuando nos pida nombrar el nuevo rol, en mi caso lo nombraré como:
**CodeDeployServiceRole**

#### 5.- Crear/asignar el rol a una instancia EC2
Para crear una instancia EC2 puedes seguir estos pasos que nos da AWS: [Pasos para crear una instancia EC2](https://aws.amazon.com/es/getting-started/hands-on/deploy-wordpress-with-amazon-rds/3/#:~:text=Para%20crear%20su%20instancia%20EC2,asistente%20de%20creaci%C3%B3n%20de%20instancias.&text=En%20la%20primera%20p%C3%A1gina%2C%20elegir%C3%A1,Machine%20(%E2%80%9CAMI%E2%80%9D).)

Una vez tengas tu instancia EC2 vamos a editarla para añadir el role necesario para realizar el deploy sobre ella. Para ello vamos a nuestra consola de AWS buscamos el servicio EC2, en el panel de la izquierda debes seleccionar donde pone "Instances", aquí selecciona la instancia que quieres editar y presiona en el botón "Actions", en el panel que te sale selecciona "Security" y finalmente dale click sobre "Modify IAM role":

![modify_role_ec2](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/modify_role_ec2.png)

Esto te dirigirá a otra pantalla donde tendremos que seleccionar el Role, en mi caso el role a seleccionar se llama: **CodeDeploy_EC2_DEPLOY_INSTANCE**. Una vez lo tengas dale a "Save" y listo.

Además del rol vamos a tener que asignar un Tag a nuestra instancia EC2, esto lo podemos hacer seleccionando nuestra instancia y en el panel inferior que se abre seleccionar la petaña "Tags" y presionar en el botón "Manage Tags". En mi caso he añadido el Tag:
**Use    deploy_blog** como puedes ver aquí:

![ec2_tags](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/ec2_tags.png)

Esto lo utilizaremos más adelante para seleccionar las instancias sobre las que hacer despligues con CodeDeploy.

#### 5.- Crear un bucket de S3.
Para crear un bucket de S3 puedes seguir estos pasos: [Creating Bucket](https://docs.aws.amazon.com/es_es/AmazonS3/latest/userguide/creating-bucket.html)

En mi caso he creado un bucket que he llamado: **source.helmcode.com**

#### 6.- Configurar CodeDeploy.
Ahora vamos a crear una nueva aplicación en CodeDeploy que será la encargada de realizar el despliegue de nuestra app en nuestra instancia de EC2.

Primero en la consola de AWS buscamos el servicio de CodeDeploy. Una vez ahí, en el panel de la izquierda selecciona "Applications" y dale al botón que pone "Create application", esto nos dirigirá a una nueva pantalla.

Aquí llamaremos a nuestra aplicación igual que nombramos el apartado de CodeDeployApplication en el paso número 2. En mi caso lo llamé **blogTest**, por lo que a mi aplicación de CodeDeploy la debo llamar igual. Además selecciono EC2/On-premises en el apartado "Compute platform". Una vez hecho esto presionamos en "Create application":

![create_application](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/create_application.png)

Esto nos llevará a la pantalla de administración de nuestra aplicación. Aquí presiona sobre el botón "Create deployment group", aquí asigna el nombre que creas conveniente para el nombre del grupo de deployment. En mi caso lo llamaré igual que la aplicación **blogTest**.

Ahora en el apartado de "Service role" selecciona el role que creamos anteriormente que en mi caso lo llamé **CodeDeployServiceRole**

En el apartado "Environment configuration" selecciona tu tipo de instancia, en mi caso como es algo de prueba lo estoy haciendo sobre una instancia única asi que selecciono la opción de "Amazon EC2 instances" y las busco por el Tag que asignamos anteriormente a nuestra instancia EC2. En mi caso el Tag tiene una "Key: **Use**" y un "Value: **deploy_blog**".

Después en el apartado de "Load Balancer", en mi caso dado que es una prueba he desactivado la opción "Enable load balancing".

Por último selecciona "Create deployment group".

Listo! Tenemos listos nuestros servicios de AWS para automatizar el deployment. Vamos ahora a crear los ficheros de configuración necesarios para llevar a cabo todo.

#### 7.- Fichero de configuración para Travis.
La aplicación de prueba que estoy usando en este post la puedes encontrar en este [repositorio](https://github.com/helmcode/apps). Por darte algo más de contexto es una aplicación Flask que corre en Docker Swarm dentro de una instancia EC2.

Ahora bien volviendo al fichero de configuración que necesita Travis, **en la raíz de tu repositorio** debes crear un fichero llamado **.travis.yml**. En mi caso para mi aplicación he creado este fichero con el siguiente contenido:

```yaml
language: python

git:
  depth: 3

branches:
  only:
    - "main"

deploy:
- provider: s3
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key: $AWS_SECRET_KEY
  local_dir: blog
  skip_cleanup: true
  on: &2
    repo: helmcode/apps
    branch: "main"
  bucket: source.helmcode.com
  region: eu-west-1
- provider: codedeploy
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key: $AWS_SECRET_KEY
  bucket: source.helmcode.com
  key: latest.zip
  bundle_type: zip
  application: blogTest
  deployment_group: blogTest
  region: eu-west-1
  on: *2
script:
  - zip -r latest *
  - mkdir -p blog
  - mv latest.zip blog/latest.zip

```

Intentaré destacarte los puntos más importantes pero siempre puedes consultar la [documentación oficial](https://docs.travis-ci.com/user/tutorial/).

- **languaje:** el lenguaje de programación que está usando este proyecto. En mi caso es Python.
- **git > depth:** la profundidad de mi repo que descargará Travis a la hora de hacer un clone de mi aplicación en sus servidores.
- **branches > only:** la rama que deberá clonar Travis.
- **deploy:** los pasos que seguirá Travis para hacer deploy.
- **deploy > provider:** el proveedor con el que interactuará Travis (En nuestro caso serán los servicios de AWS S3 y CodeDeploy)
- **deploy > acces_key_id y secret_access_key:** las credenciales de AWS, en este caso las estamos pasando como variables de entorno que crearemos en Travis más adelante para no exponerlas.
- **deploy > key:** el nombre del fichero comprimido que se subirá a S3 que contendrá el código de nuestra aplicación.
- **deploy > application:** el nombre de la aplicación que creamos anteriormente en CodeDeploy.
- **script:** esto es opcional en mi caso estoy subiendo un fichero comprimido llamado latest.zip por lo que lo estoy comprimiendo aquí, en tu caso dependerá de como quieras gestionar esto.

Revisa bien todos los puntos de **deploy** y sustituye los apartados por los que correspondan según tus necesidades.

#### 8.- Fichero de configuración para CodeDeploy.
CodeDeploy necesita un fichero que le indique cómo debe hacer ciertos pasos. Te dejo aquí un link con la [documentación oficial](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html) que es bastante completa y extensa...

El fichero también deberemos crearlo en la raíz de nuestro proyecto y el fichero se deberá llamar: **appspec.yml**. En mi caso para esta prueba he creado un fichero básico con le siguiente contenido:

```yaml
version: 0.0
os: linux
files:
  - source: /blog
    destination: /var/www/helmcode_com
hooks:
  ApplicationStop:
    - location: infrastructure/ansible/conf/scripts/stop_blog.sh
      timeout: 300
  BeforeInstall:
    - location: infrastructure/ansible/conf/scripts/before_install.sh
      timeout: 300
  AfterInstall:
    - location: infrastructure/ansible/conf/scripts/after_install.sh
      timeout: 600
```

Nuevamente intentaré explicar brevemente los puntos principales de este fichero. Aunque recuerda que si necesitas profundizar consulta la [documentación oficial](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html).

- **os:** el sistema operativo que voy a usar, en mi caso Linux.
- **files > sorce** mi proyecto tiene una estructura determinada pero de todo solo me interesa copiar en mi servidor el directorio /blog que contiene mi aplicación.
- **files > destination:** el directorio donde se copiará el código de mi aplicación dentro de la instancia EC2.
- **hooks:** CodeDeploy cuenta con varios pasos que puedes utilizar para optimizar/mejorar tu proceso de despliegue. En mi caso estoy realizando 3 pasos: parar mi aplicación, antes y después de instalar mi código ejecuto otros scripts. Esto como te indico es opcional y depende enteramente de cómo quieras gestionar tu proceso de despliegue.

#### 9.- Añadir nuestras credenciales de AWS en Travis como variables de entorno.
Para este paso vamos a ir a la consola de TravisCI, accederemos a nuestro repositorio y daremos click sobre el menú hamburguesa y seleccionaremos "Settings":

![travis_settings](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/travis_s3_codedeploy/travis_settings.png)

Esto nos conducirá a la configuración del proyecto. Iremos hasta el apartado "Environment Variables" y aquí añadiremos nuestras credenciales de AWS como variables de entorno, recuerda poner el mismo nombre aquí como en el fichero de configuración de **.travis.yml**.

Una vez hecho esto, cada vez que subas cambios a tu repositorio a la rama que hayas configurado en **.travis.yml** se iniciará un despliegue automático hacia las instancias EC2 que hayas indicado.

Espero que este post te haya sido de utilidad, si tienes cualquier consulta o quieres darme feedback puedes enviarme un mensaje de [contacto](https://helmcode.com/contact) o sino siempre puedes mandarme un [Tweet](https://twitter.com/helmcode).

Hasta la próxima!
