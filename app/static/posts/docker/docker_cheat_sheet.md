---
Title: Docker Cheat Sheet
Authors: Barckcode
Date: 27/10/2020
Categories: Docker
---

# Docker Cheat Sheet

En este doc vas a encontrar un listado de comandos y ejemplos prácticos de Docker.

Si nunca antes has usado Docker te recomiendo visitar antes esta [pequeña infografía](https://gist.github.com/BarckCode/35e2360fa49555382dabe1bfe356a064).

Y si tienes cualquier duda o quieres darme feedback no dudes en dejarme un [Tweet.](https://twitter.com/barckcode)

**Ahora sí. Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)
___
###  🎖 Comandos

#### - Levantando contenedores
🔹 Arrancar un contenedor.

```bash
docker run <image_container>
```
Ejemplo:

```bash
docker run hello-world
```

🔹 Arrancar un contenedor asignándole un nombre.

```bash
docker run --name <name_container> <image_container>
```

Ejemplo:

```bash
docker run --name contenedor_test ubuntu
```

🔹 Arrancar un contenedor con una terminal interactiva. Pasándole una shell para acceder al contenedor.

```bash
docker run -it <image_container> <shell>
```

Ejemplo:

```bash
docker run -it ubuntu bash
```

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

🔹 Arrancar un contenedor. Que tras terminar su periodo de vida. Será eliminado automáticamente.

```bash
docker run --rm <image_container>
```

Ejemplo:

```bash
docker run -p 8080:80 -d --rm nginx
```


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