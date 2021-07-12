---
Title: Deploy con TravisCI + AWS S3 + AWS CodeDeploy
Authors: helmcode
Date: 15/07/2021
Categories: docker
File: travis_s3_codedeploy
Description: En este post encontrarás cómo implementar Continuous Deployment a instancias EC2 utilizando TravisCI + S3 + AWS CodeDeploy
Published: No
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

