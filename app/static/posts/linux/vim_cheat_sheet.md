---
Title: Vim Cheat Sheet
Authors: Barckcode
Date: 11/12/2020
Categories: Linux
---

# Vim Cheat Sheet

En este doc vas a encontrar un listado de atajos, comandos, ejemplos e info relevante para sentirte lo más cómodo posible al usar Vim.

**Ahora sí. Empecemos!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---
### Leyenda:
>❗️-> Modo Comando.

>👁 -> Modo Visual.

>👀 -> Modo Visual Block.

---
**🔹 Acceso a los distintos Modos**

- Tecla `ESC` -> Se accede al Modo Comando (Es el modo por defecto).

- `v` -> ❗️Se accede al Modo Visual.

- `Ctrl + v` -> ❗️Se accede al Modo Visual Block.

---
**🔹 Moviéndonos por el fichero**

- `0` ->❗️Nos movemos al principio de la línea.

- `$` ->❗️Nos movemos al final de línea.

- `G` ->❗️Nos movemos a la última línea del fichero.

- `gg` ->❗️Nos movemos al principio del fichero.

- `:10` ->❗️Nos mueve hasta la línea 10. O hasta el número que le indiquemos.

---
**🔹 Cortar, copiar y pegar**

- `y` -> Copia lo seleccionado al portapapeles.

- `p` -> Pega lo que tenga guardado en el portapapeles.

- `dd` -> Corta la línea donde estemos situados.

- `yw` -> Copia la palabra donde estemos situados.

- `yy`-> Copia la línea donde estemos situados.

---
**🔹 Escribir en varias líneas a la vez**

Pongamos como ejemplo este fichero:

```
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
```

En el cual necesitamos añadir un **#** en todas las líneas.

Podemos ir una a una. O seleccionar el principio de todas las líneas y añadir el caracter en todas a la vez.

Para ello:

- Desde el Modo Comando entramos en el Modo Visual Block.

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/visual_block.png)

- Con las teclas cursores (←,↑,→,↓) seleccionamos las líneas que necesitemos. En mi caso quiero comentar las dos líneas con los "export".

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/visual_block_select.png)

- Para insertar lo que necesitemos en las líneas seleccionadas. Pulsamos `Shift + i`, de esta forma como ves pasamos al Modo Insert.

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/insert.png)

- Posteriormente escribimos lo que necesitemos. En mi caso un **#**

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/insert_hastag.png)

- Después pulsamos la tecla `ESC`. Como ves automáticamente escribe en todas las líneas lo que hayamos escrito mientras estabamos en Modo Insert.

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/insert_hastag_all.png)

- Finalmente para salir guardando los cambios escribimos `:wq` y pulsan la tecla `Enter`. (Si por algún motivo quisieran salir sin guardar los cambios tendrían que teclear `:q!` y posteriormente pulsar la tecla `Enter`)

![](https://s3-eu-west-1.amazonaws.com/static.helmcode.com/images/posts/linux/vim_cheat_sheet/vi_save.png)

Y listo! Todas las líneas comentadas a la vez.
