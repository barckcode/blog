---
Title: Configurar conexiones SSH sin contraseña
Authors: helmcode
Date: 17/01/2021
Categories: tutorial
File: ssh_whitout_password
Description: En este post encontrarás cómo configurar conexiones SSH sin contraseña entre diferentes servidores y entre diferentes usuarios.
Published: No
---

# Configurar conexiones SSH sin contraseña
Muchas veces necesitamos conectarnos a algunos servidores varias veces y el tener que andar introduciendo la contraseña constantemente termina siendo algo tedioso. En este post vamos a aprender a conectarnos por SSH sin utilizar la contraseña pero de una forma segura (Crear relación de confianza entre servidores).

**Empecemos con el post!**

![gif](https://media.giphy.com/media/KDWJpk7QkR1MPmNH8S/giphy.gif)

---
### Identificando los equipos y los usuarios:

Para el ejemplo vamos a utilizar dos servidores Linux que los hemos llamado:

- **sauron**
- **bbdd01**

En ambos servidores tenemos un usuario llamado `test`

Este ejemplo puede servir de la misma forma para Linux y MacOS. Desde Windows también puedes seguir los mismos pasos de este tutorial pero deberás usar [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) (Windows Subsystem Linux).

**¿Qué problema intentamos resolver con esto?**

Como decíamos antes lo que intentamos es utilizando un usuario, en nuestro caso `test`, conectarnos por SSH desde **sauron** a **bbdd01** y viceversa sin necesidad de introducir una contraseña. Para ello vamos a crear una relación de confianza entre estos dos servidores.

![ssh_diagram_01](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_diagram_01.png)


### Creando nuestras llaves RSA:

Bien, una vez tengamos identificado qué necesitamos y dónde lo vamos a hacer podemos comenzar. En el servidor **sauron** vamos a crear las llaves RSA para nuestro usuario `test`:

```bash
ssh-keygen -t rsa
```

Cuando pulsemos enter nos hará dos diferentes preguntas:

- El fichero donde queremos que guarde nuestra llave.
- Clave para cifrar el fichero.

Dado que el ejemplo es para métodos didácticos, vamos a dejar todo por defecto por lo que pulsaremos la tecla enter hasta que finalice. En mi caso ha creado mis llaves dentro del directorio: `/home/test/.ssh`

Dentro de este directorio tengo dos llaves RSA:

- `/home/test/.ssh/id_rsa` : Es nuestra llave **PRIVADA**. Esta llave NO debe compartirse con nadie.
- `/home/test/.ssh/id_rsa.pub` : Es nuestra llave **PÚBLICA**. Esta es la llave que compartiremos con otros servidores para crear la relación de confianza.

Una vez lo tengamos todo, vamos a hacer lo mismo en el servidor **bbdd01**. Con el usuario `test` ejecutaremos el comando:

```bash
ssh-keygen -t rsa
```

![ssh_rsa_keys](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_rsa_keys.png)

### Generando la relación de confianza.

Una vez tengamos nuestra llaves RSA creadas en ambos servidores. Vamos a proceder a crear primero la relación de confianza que nos permitirá conectarnos del servidor **sauron** al servidor **bbdd01** con el usuario `test` sin contraseña.

Para ello, en el servidor **bbdd01** creamos el fichero `/home/test/.ssh/authorized_keys` el cuál contendrá las llaves públicas de los servidores que puedan conectarse a él.

```bash
touch /home/test/.ssh/authorized_keys

chmod 600 /home/test/.ssh/authorized_keys
```

Dentro de este fichero que hemos creado en **bbdd01** copiamos nuestra llave pública del servidor **sauron**

![ssh_trust_relationship](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_trust_relationship.png)

Asegurate que tu llave PÚBLICA de un servidor coincide con lo que has pegado dentro del `authorized_keys` del otro servidor.

Finalmente, podemos probar si nuestra relación de confianza ha funcionado. Por lo que vamos a probar a conectarnos con el usuario `test` desde nuestro servidor **sauron** a nuestro servidor **bbdd01**:

![ssh_test_01](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_test_01.png)

Exito! nos hemos podido conectar correctamente desde **sauron** a **bbdd01**

Ahora bien, fijate en la parte derecha de la captura. Nos hemos intentado conectar desde **bbdd01** a **sauron** y me ha dicho que me peine 😡 ¿Qué ha pasado?

Bueno, si recuerdas de momento pillamos la llave PÚBLICA del usuario `test` que existe en el servidor **sauron** y la copiamos en el servidor **bbdd01**, esto significa que el servidor **bbdd01** puede autorizar el acceso sin contraseña al usuario `test` desde **sauron** porque conoce su llave PÚBLICA pero el servidor **sauron** no conoce ninguna llave PÚBLICA que venga del servidor **bbdd01**

### Finalizando la relación de confianza.

Para solucionar lo indicado anteriormente, vamos a copiar la llave PÚBLICA del usuario `test` del servidor **bbdd01** en el fichero `/home/test/.ssh/authorized_keys` del servidor **sauron**

Una vez hecho esto verás que ahora ya podemos conectarnos bidireccionalmente. Desde **sauron** a **bbdd01** y de **bbdd01** a **sauron**

![ssh_test_02](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_test_02.png)


### Relación de confianza entre dos usuarios distintos.

En el ejemplo anterior ambos servidores tenían el usuario `test` creado pero ¿es necesario que sea siempre el mismo usuario?

Lo cierto es que no, en este segundo ejemplo vamos a usar los mismos servidores pero vamos a crear la relación de confianza usando los usuarios `test`(bbdd01) y `arya`(sauron). De esta forma, nos conectaremos desde **sauron** desde el usuario `arya` al servidor **bbdd01** pero conectandonos con el usuario `test`

![ssh_diagram_02](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_diagram_02.png)

Vamos allá, al igual que antes en el usuario `arya` (sauron) crearemos sus llaves RSA:

```bash
ssh-keygen -t rsa
```

Después copiaremos su llave PÚBLICA en el fichero `authorized_keys` del servidor **bbdd01**. Una vez hecho esto vamos a realizar la conexión ssh de un servidor a otro:

![ssh_arya](https://s3.eu-west-1.amazonaws.com/static.helmcode.com/images/posts/tutorial/ssh_whitout_password/ssh_arya.png)

Espero que este post te haya sido de utilidad, si tienes cualquier consulta o quieres darme feedback puedes enviarme un mensaje a través de la página de [contacto](https://helmcode.com/contact) o sino siempre puedes mandarme un [Tweet](https://twitter.com/helmcode).

Hasta la próxima!
