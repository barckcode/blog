---
Title: Docker Cheat Sheet
Authors: helmcode
Date: 27/10/2020
Categories: docker
File: docker_cheat_sheet
Description: En este doc vas a encontrar un listado de comandos y ejemplos prácticos de Docker.
Published: Yes
---

# Docker Cheat Sheet

En este doc vas a encontrar un listado de comandos y ejemplos prácticos de Docker. Si tienes cualquier duda o quieres darme feedback no dudes en dejarme un [Tweet.](https://twitter.com/helmcode)

**Ahora sí. Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
###  🎖 Comandos

#### - Construyendo imágenes
🔹 Construir una imagen utilizando un Dockerfile que se encuentra en el directorio donde estemos.

```bash
docker build .
```
---

🔹 Construir una imagen utilizando un fichero Dockerfile específico.

```bash
docker build -f <file>
```
Ejemplo:

```bash
docker build -f ./Dockerfile.local
```
---

🔹 Construir una imagen utilizando un fichero Dockerfile específico e indicandole una etiqueta para identificar nuestra imagen.

```bash
docker build -f <file> -t <repository/image_name:tag>
```
Ejemplo:

```bash
docker build -f ./Dockerfile.local -t barckcode/flask_blog:1.0
```
---

#### - Levantando contenedores
🔹 Arrancar un contenedor.

```bash
docker run <image_container>
```
Ejemplo:

```bash
docker run hello-world
```
---

🔹 Arrancar un contenedor asignándole un nombre.

```bash
docker run --name <name_container> <image_container>
```

Ejemplo:

```bash
docker run --name contenedor_test ubuntu
```
---

🔹 Arrancar un contenedor con una terminal interactiva. Pasándole una shell para acceder al contenedor.

```bash
docker run -it <image_container> <shell>
```

Ejemplo:

```bash
docker run -it ubuntu bash
```
---

🔹 Arrancar un contenedor. Mapeando un puerto del host a un puerto del contenedor.

- puerto_host : puerto\_contenedor

```bash
docker run -p <host_port>:<container_port> <image_container>
```

Ejemplo:

```bash
docker run -p 8080:80 nginx
```

Igual que el ejemplo anterior pero dejándolo en segundo plano.

```bash
docker run -p 8080:80 -d nginx
```
---

🔹 Arrancar un contenedor. Que tras terminar su periodo de vida. Será eliminado automáticamente.

```bash
docker run --rm <image_container>
```

Ejemplo:

```bash
docker run -p 8080:80 -d --rm nginx
```
---


🔹 Arrancar un contenedor con un volume.

```bash
docker run -v <volume_name>:<mount_point>:<options> <image_container>
```

Ejemplo:

- Volume -> test
- Punto de montaje en el contenedor -> /apps
- Opciones -> rw (Lectura y escritura)

```bash
docker run -v test:/apps:rw nginx
```
---

🔹 Arrancar un contenedor con un bind mount.

```bash
docker run -v <shared_folder>:<mount_point>:<options> <image_container>
```

Ejemplo:

- Ruta del host a compartir -> /home/application
- Punto de montaje en el contenedor -> /apps
- Opciones -> ro (Solo lectura)

```bash
docker run -v /home/application:/apps:ro ubuntu
```
---

🔹 Arrancar un contenedor con tmpfs.

```bash
docker run \
--mount type=tmpfs,destination=<mount_point>,tmpfs-mode=<permisos>,tmpfs-size=<bytes_size> \
<image_container>
```

Ejemplo:

- Punto de montaje en el contenedor -> /temporal
- Permisos -> Todos los permisos solo para el propietario.
- Tamaño del FS -> 21474836480 bytes = 20G

```bash
docker run \
--mount type=tmpfs,destination=/temporal,tmpfs-mode=700,tmpfs-size=21474836480 \
nginx
```
___

#### - Listando contenedores
🔹 Lista de los contenedores activos.

```bash
docker ps
```

🔹 Lista de todos los contenedores activos e inactivos del sistema.

```bash
docker ps -a
```

🔹 Lista los ID de todos los contenedores.

```bash
docker ps -aq
```
___

#### - Debugging
🔹 Inspeccionar la data de un contenedor.

- Por su ID:

```bash
docker inspect <id_container>
```

- Por su nombre:

```bash
docker inspect <name_container>
```

- Aplicando filtros. Por ejemplo buscando las variables de entorno:

```bash
docker inspect -f '{{ json .Config.Env }}' <name_container>
```

🔹 Ver los logs del contenedor.

```bash
docker logs <name_container>
```
___

#### - Eliminando contenedores
🔹 Eliminar un contenedor que no este arriba.

- Se puede hacer tanto por nombre como por ID.

```bash
docker rm <name_container>
```

🔹 Eliminar un contenedor aunque este arriba. Forzándolo.

- Se puede hacer tanto por nombre como por ID.

```bash
docker rm -f <id_container>
```

🔹 Eliminar todos  los contenedores que no esten arriba a la vez.

```bash
docker rm $(docker ps -aq)
```
___

#### - Administrando contenedores
🔹 Parar un contenedor.

- Se puede hacer tanto por nombre como por ID.

```bash
docker stop <name_container>
```

🔹 Reiniciar un contenedor.

- Se puede hacer tanto por nombre como por ID.

```bash
docker restart <name_container>
```

🔹 Copiar un fichero local a un path dentro del contenedor.

```bash
docker cp <local_file> <container:path>
```

🔹 Copiar un fichero del contenedor a un path local.

```bash
docker cp <container:file> <local_path>
```
___

#### - Docker Swarm

🔹 Iniciar el clúster de docker swarm en una IP específica.

```bash
docker swarm init --advertise-addr <IP_server>
```

🔹 Añadir workers al clúster de docker swarm.

```bash
docker swarm join --token <token>
```

🔹 Ver las instrucciones y obtener el token para añadir un worker.

```bash
docker swarm join-token manager
```

🔹 Ver los nodos del clúster.

```bash
docker node ls
```
---

🔹 Crear un servicio en docker swarm indicandole:

- Nombre del servicio.
- Número de réplicas.
- Puntos de montaje.
- Interfaz de red.
- Exposición y mapeo de puertos.
- Variable de entorno.
- Imagen a utilizar por los contenedores y el comando a ejecutar.

```bash
docker service create \
--name <name_svc> \
--replicas <num_replicas> \
--mount <type=[volume|bind|tmpfs|npipe]>,<source=name_volume>,<destination=/container_path> \
--network <interface_name> \
--publish <published=exposed_port_container>,<target=app_port> \
--env <key=value> \
<img_container> <command>
```

Ejemplo:

```bash
docker service create \
--name prod_app \
--replicas 4 \
--mount type=bind,source=/var/www,destination=/app \
--network net_app \
--publish published=8000,target=8000 \
--env FLASK_ENV=production \
python:3.9 flask run --host=0.0.0.0
```
---

🔹 Listar los servicios del cluster.

```bash
docker service ls
```
---

🔹 Ver los servicios que estan corriendo en el cluster.

```bash
docker service ps <svc>
```
---

🔹 Escalar un servicio.

```bash
docker service scale <id_svc=num_replicas>
```

Ejemplo:

```bash
docker service scale prod_app=2
```
---

🔹 Ver detalles de un servicio.

```bash
docker service inspect --pretty <svc>
```
---

🔹 Actualizar la imagen de un servicio.

```bash
docker service update --image <img_container> <svc>
```
---

🔹 Reiniciar un servicio / Forzar actualización.

```bash
docker service update <svc> --force
```
---

Espero que este post te haya sido de utilidad, si tienes cualquier consulta o quieres darme feedback puedes enviarme un mensaje de [contacto](https://helmcode.com/contact) o sino siempre puedes mandarme un [Tweet](https://twitter.com/helmcode).

Hasta la próxima!
