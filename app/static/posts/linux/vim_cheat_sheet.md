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

![](https://firebasestorage.googleapis.com/v0/b/blog-barckcode.appspot.com/o/CollectedNotes%2Fvim_cheat_sheet%2Fvisual_block.png?alt=media&token=63364dd6-f904-470f-adee-cf19a3cec273)

- Con las teclas cursores (←,↑,→,↓) seleccionamos las líneas que necesitemos.

![](https://firebasestorage.googleapis.com/v0/b/blog-barckcode.appspot.com/o/CollectedNotes%2Fvim_cheat_sheet%2Fdata_seleccionada.png?alt=media&token=d2a4f921-eab9-4a65-b1c3-cbdeb67b40aa)

- Para insertar lo que necesitemos en las líneas seleccionadas. Pulsamos `Shift + i`

![](https://firebasestorage.googleapis.com/v0/b/blog-barckcode.appspot.com/o/CollectedNotes%2Fvim_cheat_sheet%2Finsert_mode.png?alt=media&token=24ba90df-9ccf-458f-a236-a01e73440d5a)

- Posteriormente escribimos lo que necesitemos. En mi caso un **#**

![](https://firebasestorage.googleapis.com/v0/b/blog-barckcode.appspot.com/o/CollectedNotes%2Fvim_cheat_sheet%2Fwrite_one.png?alt=media&token=6783a303-6440-454d-b271-2243a62036f1)

- Finalmente pulsamos la tecla `ESC`.

![](https://firebasestorage.googleapis.com/v0/b/blog-barckcode.appspot.com/o/CollectedNotes%2Fvim_cheat_sheet%2Fwrite_all.png?alt=media&token=7b846f51-c332-4354-b488-dc63c43d2ca4)

Y listo! Todas las líneas comentadas a la vez.
