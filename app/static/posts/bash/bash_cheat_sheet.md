---
Title: Bash Cheat Sheet
Authors: Barckcode
Date: 13/09/2020
Categories: Bash
---

# Bash Cheat Sheet

En este doc vas a encontrar un listado de comandos y ejemplos de pequeños fragmentos de scripts de Bash.

Si tienes cualquier duda o quieres darme feedback no dudes en dejarme un  [Tweet.](https://twitter.com/barckcode)

**Ahora sí. Empecemos con el código!**

![programmer_gif](https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif)

---

### Variables.
**Buenas prácticas:** Las variables se suelen escribir en mayúsculas. Y si son variables globales. Se han de escribir al principio del programa.

```bash
EDAD=0
NOMBRE="Barckcode"
```

Puedes asignar a una variable la salida de un comando. De dos formas:

```bash
SALUDO=$(echo "hola mundo")

GREETING=`echo "hello world"`
```

Si queremos imprimir en pantalla el valor de las variables anteriores podemos hacer:

```bash
echo $SALUDO        # Salida en consola --> hola mundo

echo $GREETING      # Salida en consola --> hello world
```

Asignar el resultado de una operación aritmética:

```bash
# Utilizando la palabra reservada "let":
let OPERACION1=5+5

# Utilizando el comando "expr":
OPERACION2=$(expr 2 + 2)

echo $OPERACION1        # Salida en consola --> 10

echo $OPERACION2        # Salida en consola --> 4
```

---

### Arrays / Arreglos.
**Buenas prácticas:** Se suele usar lower camel case para identificar los arrays. Si desconoces lo que es: [¿Qué es camel case?](https://en.wikipedia.org/wiki/Camel_case)

**IMPORTANTE:** Fíjate en el uso de los espacios y comas para separar los valores que componen el array.

**Arrays de números:**

```bash
arregloNumeros=(1 2 3 4 5 6)
```

**Arrays de cadenas de caracteres:**

```bash
arregloCadenas=(Estefania, Antonio, Pedro, Susana)
```

 **Arrays de rangos:**
 
- En este ejemplo el primer rango del array ({A..Z}) abarca los valores de todo el abecedario desde la A a la Z.
- El segundo rango del array ({10..20}) abarca todos los números desde el 10 al 20. Ambos incluidos.

```bash
arregloRangos=({A..Z} {10..20})
```
---

### IF / ELIF / ELSE.
**Nota:** Es muy importante que respetes los espacios cuando declares las condiciones. Sino tu código NO se ejecutará.

**IMPORTANTE:** Recuerda cerrar el bloque de código siempre.

**Sintáxis:**

```bash
if [[ condición ]]
then
	código a ejecutar si se cumple la condición del if.
elif [[ condición ]]
then
	código a ejecutar si se cumple la condición del elif.
else
	código que se ejecuta si NO cumple ninguna condición
fi
```

**Ejemplo:**

```bash
VALIDACION=0
NOMBRE="Barckcode"

if [[ $VALIDACION -eq 0 ]]
then
	echo "a.- Tu nombre es: $NOMBRE"
elif [[ $VALIDACION -gt 0 ]]
	echo "b.- Tu nombre NO es: $NOMBRE"
else
	echo "c.- Su $VALIDACION no coincide con ninguna de las condiciones anteriores."
fi
```

Algunos operadores que podemos usar en nuestras condiciones.

**Para comparar cadenas de caracteres:**

- Mayor que ->   **\>**
- Menor que ->   **<**
- Igual que ->   **=**
- Distinto de ->   **!=**

**Para comparar números enteros:**

- Mayor que ->   **-gt**
- Menor que ->   **-lt**
- Mayor o igual que ->   **-ge**
- Menor o igual que ->   **-le**
- Igual que ->   **-eq**
- Distinto de ->   **-ne**

---

### Case.
**Nota:** Es muy importante que cada opción del case. Termine con **;;**

**IMPORTANTE:** Recuerda cerrar el bloque de código siempre.

**Sintáxis:**

```bash
case $variable in
	"1")
                # Podemos usar números para nombrar nuestras opciones.
		echo "Esta es la opción 1"        
		;;
	"B") 
                # Podemos usar letras para nombrar nuestras opciones.
		echo "Esta es la opción B" 
		;;
	[C-E])
                 # Podemos utilizar rangos para abarcar distintas opciones.
		echo "Esto es un rango de opciones. Que van de la C a la E"
		;;
	*)
                # Podemos usar el caracter especial * para abarcar todas las opciones restantes.
		echo "Esta es la opción por default"
		;;
esac
```
---

### For loop.
**IMPORTANTE:** Este bucle itera hasta recorrer todos los valores que le hayas proporcionado. Ten cuidado con crear bucles infinitos.

**Nota:** El nombre de variable más utilizado en el for suele ser la vocal **_i_**. Sin embargo, puedes nombrar la variable como desees.

**Sintaxis:**

```bash
for variable in valores_a_recorrer
do
	Bloque de código a ejecutar.
done
```

- Para este ejemplo vamos a **recorrer un array de números:**

```bash
arregloNumeros=(1 2 3 4 5 6)

for num in ${arregloNumeros[*]}
do
	echo "Numero: $num"
done
```

- Para este ejemplo vamos a **recorrer un fichero que contiene direcciones IP:**

Contenido del **fichero\_con_ips.txt**:

192.168.0.1

192.168.0.2

192.168.0.3

192.168.0.4


```bash
for i in `cat fichero_con_ips.txt`
do
	echo "Dirección IP: $i"
done
```
---

### While loop.
**IMPORTANTE:** Este bucle itera hasta que deja de cumplirse la condición indicada. Asegúrate de que la condición deje de cumplirse en algún momento. Sino crearás un bucle infinito.

**Nota:** Es muy importante que respetes los espacios cuando declares las condiciones. Sino tu código NO se ejecutará.

**Sintaxis:**

```bash
while [[ condición ]]
do
	código a ejecutarse en el bucle
done
```

**Ejemplo:**

```bash
NUMERO=0

# Recuerda que " -ne " significa --> distinto de
while [[ $NUMERO -ne 10 ]]
do
	echo "Imprimiendo $NUMERO veces"
	NUMERO=$(( NUMERO + 1 ))
done
```
---

### Pedir información al usuario.

En ocasiones necesitamos **pedir información al usuario** para continuar con el script. Te dejo un par de ejemplos:

- En este ejemplo. La información ingresada por el usuario se almacenará en la variable EDAD y podrás usarla posteriormente en tu script.

```bash
read -p "Ingresa tu edad" EDAD
```

- Si la información a ingresar debe ser secreta. Porque es una contraseña por ejemplo. Lo mejor es ocultar lo que escribe el usuario usando:

```bash
read -s -p "Escribe tu password secreta:" PASSWORD
```

- Para esperar hasta que el usuario presione una tecla:

```bash
read -n 1 -s -r -p "Presione [ENTER] para continuar..."
```
---

### Debugging
Podemos hacer debugging de un script para **ver cuál es su salida sin que se ejecute el script** en nuestro sistema.

**Sintáxis:**

```bash
➜ bash -x debugging_script.sh
```

**Ejemplo:**
Tenemos un script llamado. **prueba.sh** que desconocemos lo que hace. Podemos ejecutar en nuestra terminal:

```bash
bash -x prueba.sh

# Salida:
++ echo hola
+ prueba=hola
+ echo hola
hola
```
Y así sabremos lo que nos está devolviendo este script.

---

### Amplía conocimientos:

**Corchetes simples [  ] vs Corchetes Dobles [[  ]]**

Los dobles corchetes son una mejora respecto a los corchetes simples. Y siempre que puedas, utiliza corchetes dobles.
Las diferencias entre uno y otro son las siguientes:

1. No tienes que utilizar las comillas con las variables, los dobles corchetes trabajan con espacios. 
Esto `[ -f "$file" ]` es equivalente a `[[ -f $file ]]`.

2. Con `[[` puedes utilizar los operadores `||` (OR) y `&&` (AND)

3. Puedes utilizar el operador `=~` para expresiones regulares, como por ejemplo `[[ $respuesta =~ ^s(i)?$ ]]`

4. También puedes utilizar comodines como por ejemplo en la expresión `[[ abc = a\* ]]`

La única razón para seguir utilizando `[` corchete simple en lugar de doble. Es por **compatibilidad**.
Aunque bien es cierto que la mayoría de versiones actuales. Ya son compatibles con `[[` doble corchete.

**Algunos Posts interesantes:**

- Ofuscar/ocultar el código de nuestros Bash scripts:  [Link](https://blog.desdelinux.net/como-ofuscar-u-ocultar-codigo-de-nuestros-scripts-bash/)
- Cheat Sheet de bash mucho más completo:  [Link](https://devhints.io/bash)
- Libro abierto y gratuito de comandos Linux y programacion shell: [Link](https://openlibra.com/es/book/download/comandos-linux-unix-y-programacion-shell)
- Web para validar la sintaxis de un script: [Link](https://www.shellcheck.net/)
- Ayuda para generar expresiones regulares: [Linux](https://pythex.org/)
- Repositorio con scripts útiles: [Link](https://gitlab.com/barckcode/scripts/)
