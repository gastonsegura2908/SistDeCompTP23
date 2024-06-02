# Sistemas de Computacion

Repositorio destinado al trabajo práctico #3 de la parte practica de la materia Sistemas de Computación.

## GRUPO: The Tux Titans
## INTEGRANTES :
 - Federica Mayorga
 - Gaston Marcelo Segura
 - Lourdes Guyot
---
### Consigna:

Los procesadores x86 mantienen compatibilidad con sus antecesores y para agregar nuevas funcionalidades deben ir “evolucionando” en el tiempo durante el proceso de arranque. Todos los CPUs x86 comienzan en modo real en el momento de carga (boot time) para asegurar compatibilidad hacia atrás,  en cuanto se los energiza se comportan  de manera muy primitiva, luego mediante comandos se los hace evolucionar hasta poder obtener la máxima cantidad de prestaciones posibles.

El **modo protegido** es un modo operacional de los CPUs compatibles x86 de la serie 80286 y posteriores. Este modo es el primer salto evolutivo de los x86. El modo protegido tiene un número de nuevas características diseñadas para mejorar la multitarea y la estabilidad del sistema, tales como la **protección de memoria**, y soporte de hardware para **memoria virtual** como también la **conmutación de tareas**.

En este TP ejecutaremos un trozo de código que configura nuestro procesador para llevarlo desde el modo real al modo protegido.

Antes de la clase:

- Revisar el teórico
- Clonen este repositorio e inicializan los submódulos (ver README).

https://gitlab.com/sistemas-de-computacion-2021/protected-mode-sdc

Se adjunta el manual del desarrollador para procesadores x86 de Intel.

Y un repositorio de código muy interesante para el práctico que ya está incluido en el repositorio clonado.

https://github.com/cirosantilli/x86-bare-metal-examples

Para este trabajo deberán realizar un informe que responda a las consignas que se encuentran en la presentación. Mostrar la ejecución del ejemplo en una máquina virtual explicando lo que sucede.

### Objetivos:
1. Correr la imagen.

   Instalar y correr qemu con la imagen en cuestión.
   ```
   sudo apt install qemu-system-x86
   qemu-system-x86_64 --drive file=main.img,format=raw,index=0,media=disk
   ```
   
2. Ejecutar programas en el hardware.

   Grabar un pendrive con la imagen a probar, colocar el pen en la pc y colocar el pen en la pc encenderla e indicar que inicie desde la misma.
   ```
   sudo dd if=main.img of=/dev/sdX
   ```

3. UEFI y coreboot.

   ¿Qué es UEFI? ¿Cómo puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.
   
   ¿Menciona casos de bugs de UEFI que puedan ser explotados?
   
   ¿Qué es Converged Security and Management Engine (CSME), y the Intel Management Engine BIOS Extension (Intel MEBx)?
   
   ¿Qué es coreboot? ¿Qué productos lo incorporan? ¿Cuáles son las ventajas de su utilización?

4. Pequeño hello world.
5. Linker.

   ¿Qué es un linker? ¿Qué hace?

   ¿Qué es la dirección que aparece en el script del linker?¿Porqué es necesaria?

   Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen.

   Grabar la imagen en un pendrive y probarla en una pc y subir una foto.

   ¿Para que se utiliza la opción --oformat binary en el linker?

6. Depuración de ejecutables con llamadas a bios int.

   Una vez lanzado qemu se puede liberar el mouse con ctrl+alt.
   ```
   qemu-system-i386 -fda ../01HelloWorld/main.img
   -boot a -s -S -monitor stdio
   ```

   Depurar con gdb.
   
   Colocar un breakpoint en la dirección de arranque. Luego colocar otro a continuación de la llamada a la interrupción. Utilizar “c” continue antes de las interrupciones y “si” para ejecutar una sola instrucción.

7. Modo Protegido, desafío final.

   Crear un código assembler que pueda pasar a modo protegido (sin macros).

   ¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?

   Cambiar los bits de acceso del segmento de datos para que sea de solo lectura,  intentar escribir, ¿Que sucede? ¿Qué debería suceder a continuación? (revisar el teórico) Verificarlo con gdb.

   En modo protegido, ¿Con qué valor se cargan los registros de segmento ? ¿Por que?
   
---
Al ingresar al link propuesto por la consigna, nos encontramos con tres comandos a seguir (previos a una abreviatura de TLDR, Too Long; Didn’t Read):
```
git clone (url of this repo)
git submodule init
git submodule update
```
y vemos en terminal:
```bash
(base) federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3$ git clone https://gitlab.com/sistemas-de-computacion-2021/protected-mode-sdc
Cloning into 'protected-mode-sdc'...
warning: redirecting to https://gitlab.com/sistemas-de-computacion-2021/protected-mode-sdc.git/
remote: Enumerating objects: 83, done.
remote: Counting objects: 100% (83/83), done.
remote: Compressing objects: 100% (55/55), done.
remote: Total 83 (delta 33), reused 70 (delta 27), pack-reused 0 (from 0)
Receiving objects: 100% (83/83), 9.52 MiB | 299.00 KiB/s, done.
Resolving deltas: 100% (33/33), done.
(base) federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3$ cd protected-mode-sdc/
(base) federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc$ git submodule init 
Submodule 'x86-bare-metal-examples' (https://github.com/cirosantilli/x86-bare-metal-examples.git) registered for path 'x86-bare-metal-examples'
(base) federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc$ git submodule update 
Cloning into '/home/federica/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/x86-bare-metal-examples'...
```

A continuación una breve explicacion de las acciones que llevan estos comandos:

- **`git clone`**: Descarga un repositorio completo desde una URL remota.
- **`git submodule init`**: Inicializa los submódulos en el repositorio. Los submódulos en Git son repositorios dentro de otros repositorios. A veces, un proyecto principal depende de otros proyectos más pequeños o módulos.
- **`git submodule update`**: Actualiza los submódulos a la última versión. Esto descargará los cambios más recientes en los submódulos y los vinculará correctamente al proyecto principal.


En la presentacion de clase, tenemos como primer paso o acercamiento, como hacer una MBR (Master Boot Record) con la creación de una imagen de disco con una instrucción hlt.
```bash
# Crear un archivo llamado main.img y escribir una secuencia específica de bytes
printf '\364%509s\125\252' > main.img

# Crear un archivo llamado a.S y escribir la instrucción "hlt" en él
echo hlt > a.S

# Ensamblar el archivo a.S y generar un archivo objeto llamado a.o
as -o a.o a.S

# Desensamblar el archivo objeto a.o y mostrar el código ensamblador original
objdump -S a.o

# Mostrar el contenido hexadecimal del archivo main.img
hd main.img
```

A continuación una explicacion de que hace este primer comando **`printf '\364%509s\125\252'`**, no tan intuitivo, y sus detalles:

- **`\364`** en octal es equivalente a **`0xf4`** en hexadecimal, que representa la instrucción **`hlt`** en lenguaje ensamblador. La instrucción **`hlt`** detiene la ejecución del procesador.
- **`%509s`** produce 509 espacios en blanco. Esto es necesario para completar la imagen hasta el byte 510. Siendo que desde el byte 510 hasta el 511, es donde se almacena el *Boot signature*.
- **`\125\252`** en octal es equivalente a **`0x55 0xAA`** en hexadecimal. Estos valores son requisitos para que la imagen sea interpretada como un registro maestro de arranque (MBR) válido.

### Objetivo 1
Observamos que al ejecutar el cmd propuesto por la consigna, obtenemos los siguientes WARNINGS.
```bash
(base) federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/00SimpleMBR$ qemu-system-x86_64 --drive file=main.img,format=raw,index=0,media=disk
[Parent 1952, IPC I/O Parent] WARNING: process 2861 exited on signal 11: file /builds/worker/checkouts/gecko/ipc/chromium/src/base/process_util_posix.cc:265
[Parent 1952, IPC I/O Parent] WARNING: process 3110 exited on signal 11: file /builds/worker/checkouts/gecko/ipc/chromium/src/base/process_util_posix.cc:265
```
El mensaje “WARNING: process xxxx exited on signal 11” indica que un proceso finalizó de manera anormal debido a una señal 11. Esta señal se conoce como SIGSEGV (Segmentation Violation) y generalmente ocurre cuando un programa intenta acceder a una ubicación de memoria no válida o no asignada. En otras palabras, el proceso intentó acceder a una parte de la memoria que no le correspondía, lo que puede deberse a un error en el código del programa o a una sobrecarga de memoria.

Observamos la ejecución de los comandos previo a la realización de la imagen main.img.
![Imagen 1](/img/img1.jpg)
En la vista superior de la ventana de QEMU, hacemos Machine → Pause.

### Objetivo 2
En nuestro caso particular, iniciando el booteo desde la imagen creada, no vemos nada en pantalla y tampoco podemos accionar ningún botón salvo la combinación de ctrl + alt + sup que nos lleva al estado de inicio nuevamente y si no seleccionamos opciones de booteo, comienza el booteo regular del SO instalado.

### Objetivo 3
La UEFI (Unified Extensible Firmware Interface o Interfaz unificada de firmware extensible)  es una especificación que define la arquitectura del firmware utilizado para bootear el hardware y su interfaz para interactuar con el sistema operativo.

¿Cómo se habilita el modo de arranque **UEFI**?

1. Arranque el ordenador y pulse la tecla **F2** para iniciar la utilidad de configuración del BIOS durante el inicio.
2. Cuando aparezca la ventana inicial, seleccione el menú de configuración y pulse Entrar.
3. En el menú de configuración, seleccione boot Maintenance Manager y pulse Entrar.
4. Desde el gestor de mantenimiento de arranque, seleccione Opciones avanzadas de arranque y pulse Entrar.
5. Desde el menú de Opciones de arranque avanzadas , cambie el modo de arranque a **UEFI**.
6. Guarde los cambios y reinicie pulsando la tecla **F10** .

Las infecciones **UEFI** son poco comunes y por lo general, difícil de ejecutar, pero cuando ocurren son persistentes y casi indetectables.  A continuación se mencionan casos en los que se puede afectar la **UEFI**:

- Problema de seguridad que podría permitir el borrado de la **BIOS** o **UEFI** del sistema o corrupción de la misma:

https://blog.segu-info.com.ar/2018/04/bug-en-intel-spi-permite-alterar-la.html?m=0

- Kit de arranque **UEFI** que infecta dispositivos Windows que se inyecta en el Administrador de arranque de Windows:

https://www.muyseguridad.net/2021/10/02/finfisher-arranque-de-windows/

- Rootkit que hace que se instale y ejecute malware en el proceso de inicio de del sistemas operativo:

https://www.muyseguridad.net/2018/09/28/rootkit-malware-persistente-firmware-uefi/

CSME es un subsistema integrado  y un dispositivo periférico diseñado para actuar como un controlador de seguridad y administración en la PCH (Platform Controller Hub). El objetivo de CSME es implementar un entorno informático aislado del software principal del sistema, que ejecuta la CPU  como la BIOS, el sesenta operativo y las aplicaciones. Puede acceder a un número limitado de interfaces, como GPIO y LAN/Wireless LAN, para realizar las operaciones previstas.

El firmware y los archivos de configuración del Intel CSME se almacenan en una memoria de acceso aleatorio no volátil, como en la memoria flash del bus del  SPI.

El motor de administración de Intel o Intel Management Engine es un subsistema autónomo incorporado en casi todos los chips de procesador Intel desde 2008. Está ubicado en la PCH de las placas madres modernas de Intel. Esta configuración está incluida en la BIOS a través de la extensión Intel Management Engine Extension (MEBx). La MEBx permite cambiar y/o recoger la configuración de hardware del sistema, la pasa al firmware de administración y facilita la configuración de la interfaz de usuario de Intel ME.

Coreboot, conocido también como LinuxBIOS es un proyecto de software  destinado a reemplazar el firmware patentado (BIOS o UEFI) que se encuentra en muchas computadoras con un firmware ligero diseñado para trabajar sólo con el mínimo número de tareas necesarias para cargar y correr un sistema operativo de 32 o 64 bits.

Coreboot está disponible en un número limitado de plataformas de hardware y de modelos  de placas madres debido a que se inicializa en hardwares vacíos y debe ser adaptado a cada chipset o placa madre. Las arquitecturas de CPU que son compatibles incluyen IA-32, x86-64, ARM, ARM64, MIPS and RISC-V.

Entre las ventajas de su utilización, están: Al estar escrito principalmente en C, con un pequeña parte en ensamblador, facilita su auditoría del código comparado con las BIOS usadas normalmente y eso se traduce en una mayor seguridad; coreboot realiza la cantidad mínima de inicialización de hardware y luego pasa el control al sistema operativo; su versión x86 funciona en modo 32 bits tras sólo ejecutar 10 instrucciones (casi todas las demás BIOS x86 se ejecutan en 16 bits).

### Objetivo 4
Para el siguiente objetivo, se propone realizar un pequeño hello world, el cual contiene un main.S y un link.ld :
```assembly
.code16
    mov $msg, %si
    mov $0x0e, %ah
loop:
    lodsb
    or %al, %al
    jz halt
    int $0x10
    jmp loop
halt:
    hlt
msg:
    .asciz "hello world"
```
Este es un programa en lenguaje assembly para mostrar el mensaje "*hello world*".

- `.code16`: Esta directiva le indica al ensamblador que genere código para una CPU de 16 bits.
- `mov $msg, %si`: Esta instrucción mueve la dirección de memoria de la cadena 'msg' (que es "*hello world*") al registro de índice de fuente (Source Index).
- `mov $0x0e, %ah`: Esta instrucción carga el valor hexadecimal 0x0e en el registro AH. Este valor se usa para la interrupción de la BIOS 0x10 que se encarga de imprimir caracteres en la pantalla.
- `loop:`: Esta es la etiqueta para el inicio del bucle que imprimirá cada carácter de la cadena "*hello world*".
- `lodsb`: Esta instrucción carga el byte en la dirección de memoria apuntada por SI en el registro AL, y luego incrementa SI. Es decir, cada vez que se ejecuta esta instrucción, se carga el siguiente carácter de la cadena en AL.
- `or %al, %al`: Esta instrucción realiza la operación de OR bit a bit en el contenido del registro AL. En este contexto, se utiliza para verificar si el carácter cargado es el carácter nulo de terminación de la cadena. Si lo es, la operación OR producirá un cero.
- `jz halt`: Esta instrucción salta a la etiqueta 'halt' si la operación OR anterior produjo un cero (es decir, si se ha alcanzado el final de la cadena).
- `int $0x10`: Esta instrucción genera la interrupción de la BIOS 0x10, que maneja varias funciones de video, incluyendo la impresión de caracteres en la pantalla. La función específica que se utiliza (en este caso, la impresión de un carácter) se determina por el valor en el registro AH, que se estableció en 0x0e.
- `jmp loop`: Esta instrucción salta de nuevo al inicio del bucle para imprimir el siguiente carácter.
- `halt:`: Esta es la etiqueta a la que se salta cuando se ha imprimido toda la cadena.
- `hlt`: Esta instrucción detiene la ejecución de la CPU hasta que se recibe la siguiente interrupción.
- `msg:`: Esta etiqueta marca el inicio de la cadena de caracteres que se va a imprimir.
- `.asciz "hello world"`: Esta directiva del ensamblador coloca la cadena "*hello world*" en la memoria, seguida de un carácter nulo para marcar el final de la cadena. Al igual que .ascii, pero .asciz.

Y el archivo del linker para el enlazador ld de GNU, que contiene:
```
SECTIONS
{
/* The BIOS loads the code from the disk to this location.
* We must tell that to the linker so that it can properly
* calculate the addresses of symbols we might jump to.
*/
. = 0x7c00;
.text :
{
__start = .;
(.text)
/ Place the magic boot bytes at the end of the first 512 sector. /
. = 0x1FE;
SHORT(0xAA55)
}
}
/
as -g -o main.o main.S
ld --oformat binary -o main.img -T link.ld main.o
qemu-system-x86_64 -hda main.img
*/
```

Específicamente, es un script de enlace para crear una imagen de arranque que se puede cargar desde el sector de arranque de un disco.

- `SECTIONS`: Este bloque define las secciones en la imagen de salida.
- `. = 0x7c00;`: Esta línea establece la ubicación del contador de ubicación (.), que controla dónde se ubicará el código en la imagen de salida, a **0x7c00**. Este es el lugar donde la **BIOS** carga el sector de arranque en memoria.
- `.text :`: Este bloque define la sección .text, que es donde se colocará el código de la imagen de salida.
- `__start = .;`: Esta línea define un símbolo llamado __start en la ubicación actual del contador de ubicación (.). Este símbolo se puede usar en el código para referirse a la ubicación inicial del código.
- `(.text)`: Esta línea incluye todo el contenido de la sección .text de todos los archivos de entrada en la imagen de salida.
- `. = 0x1FE;`: Esta línea establece la ubicación del contador de ubicación (.) a 0x1FE. Este es el lugar donde se colocarán los bytes mágicos de arranque en el sector de arranque.
- `SHORT(0xAA55)`: Esta línea coloca los bytes mágicos de arranque (0xAA55) en la imagen de salida en la ubicación actual del contador de ubicación (.). Estos bytes son necesarios para que la **BIOS** reconozca el sector de arranque como tal.
- Las líneas de comentarios al final proporcionan comandos para ensamblar el código de arranque, enlazarlo con el script de enlace y ejecutarlo con el emulador **QEMU**.

El fragmento de código está escrito en un lenguaje específico para controlar el proceso de enlace y asegurar que las secciones se coloquen correctamente en la memoria.

Ya con esto, se ejecutan los comandos para compilar y linkear los archivos:
```bash
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ ls -l
total 20
-rw-rw-r-- 1 federica federica  107 May 18 13:01 compilarycorrer
-rw-rw-r-- 1 federica federica  515 May 18 13:01 link.ld
-rwxrwxr-x 1 federica federica  512 May 18 13:01 main.img
-rw-rw-r-- 1 federica federica 2064 May 18 13:01 main.o
-rw-rw-r-- 1 federica federica  160 May 18 13:01 main.S
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ as -g -o main.o main.S
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ ld --oformat binary -o main.img -T link.ld main.o
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ qemu-system-x86_64 -hda main.img
```
A continuación, una breve explicacion sobre los comando utilizados en la ejecución del codigo.

1. `ls -l`: Este comando lista todos los archivos y directorios en el directorio actual en un formato detallado, incluyendo permisos, número de enlaces, propietario, grupo, tamaño en bytes y marca de tiempo de la última modificación.
2. `as -g -o main.o main.S`: Este comando compila el archivo de ensamblador `main.S` en un archivo de objeto `main.o`. La opción `g` se usa para generar información de depuración y la opción `o main.o` especifica el nombre del archivo de salida.
3. `ld --oformat binary -o main.img -T link.ld main.o`: Este comando enlaza el archivo de objeto `main.o` para crear una imagen binaria `main.img`. La opción `-oformat binary` especifica que la salida debe estar en formato binario. La opción `o main.img` especifica el nombre del archivo de salida y `T link.ld` especifica el script del enlazador a usar.
4. `qemu-system-x86_64 -hda main.img`: Este comando ejecuta la imagen binaria `main.img` en el emulador QEMU. La opción `hda main.img` especifica que `main.img` debe ser usado como el disco duro primario del sistema emulado.

Con lo cual, ejecutamos y vemos en la ventana de QEMU:
![Imagen 2](/img/img2.jpg)

### Objetivo 5
Un linker es un programa que desempeña un papel crucial en el proceso de convertir el código fuente de un lenguaje de alto nivel en un archivo ejecutable que pueda entender nuestro sistema. Aunque a menudo pasa desapercibido, su función es esencial.
Es parte del Proceso de compilación, para lo cual recordemos los pasos previos en el proceso de compilación:

1. **Preprocesador**: Expande directivas como **`#define`** y elimina comentarios.
2. **Compilador**: Convierte el código fuente en código ensamblador.
3. **Ensamblador**: Genera archivos de código objeto (**`.o`**) a partir del código ensamblador.

Las funciones del linker son:

1. Combina varios archivos de código objeto en un único archivo ejecutable. Para ello, realiza dos tareas fundamentales:
    - **Resolución de símbolos**:
        - Los archivos de código objeto hacen referencia a símbolos (como funciones o variables).
        - La resolución de símbolos asocia cada referencia con una única definición del símbolo.
    - **Traslado (relocation)**:
        - Los compiladores y ensambladores generan código objeto con secciones que comienzan en la dirección 0.
        - El linker traslada estas secciones a direcciones específicas, asociando cada definición de un símbolo con una dirección y haciendo referencia a ella en las referencias del símbolo.

Es esencial para crear programas ejecutables a partir de múltiples archivos de código objeto, asegurando que los símbolos se resuelvan correctamente y que las secciones se ubiquen adecuadamente en memoria.

La dirección que aparece en el script del linker (también conocido como linker script) es una parte fundamental del proceso de enlace. En el script del linker, la dirección se refiere a la ubicación específica en la memoria donde se colocarán las secciones de código y datos del programa.

La Importancia de la dirección en el linker script esta en la Resolución de símbolos ya que el linker necesita saber dónde colocar cada función, variable o símbolo definido en el código y la dirección especificada en el script permite asignar direcciones únicas a estos símbolos.

Tambien en la Ubicación en la memoria porque el sistema operativo o el hardware espera que ciertas partes del programa estén en ubicaciones específicas. Asi mismo en la Segmentación y paginación la dirección también afecta cómo se accede a los datos y cómo se gestionan los límites de memoria.


Comparando la salida del comando objdump  con la salida del comando hd , observamos que: 
```bash
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ objdump -D main.o

main.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <loop-0x5>:
   0:   be 00 00 b4 0e          mov    $0xeb40000,%esi

0000000000000005 <loop>:
   5:   ac                      lods   %ds:(%rsi),%al
   6:   08 c0                   or     %al,%al
   8:   74 04                   je     e <halt>
   a:   cd 10                   int    $0x10
   c:   eb f7                   jmp    5 <loop>

000000000000000e <halt>:
   e:   f4                      hlt    

000000000000000f <msg>:
   f:   68 65 6c 6c 6f          push   $0x6f6c6c65
  14:   20 77 6f                and    %dh,0x6f(%rdi)
  17:   72 6c                   jb     85 <msg+0x76>
  19:   64                      fs
        ...
```

Este código es la salida de `objdump -D main.o`, es decir, es el resultado de desensamblar el archivo de objeto `main.o` que contiene el código del programa. Aquí está una explicación línea por línea:

- `0000000000000000 <loop-0x5>:`: Esta línea indica la dirección de memoria y la etiqueta del siguiente bloque de código. En este caso, la dirección es 0x0 y la etiqueta es `loop-0x5`.
- `0: be 00 00 b4 0e mov $0xeb40000,%esi`: Esta es una instrucción para mover el valor hexadecimal 0xeb40000 al registro ESI.
- `0000000000000005 <loop>:`: Indica la dirección de memoria y la etiqueta del siguiente bloque de código. La dirección es 0x5 y la etiqueta es `loop`.
- `5: ac lods %ds:(%rsi),%al`: Esta instrucción carga el byte apuntado por el registro de índice de origen (RSI) en el registro AL y luego incrementa RSI.
- `6: 08 c0 or %al,%al`: Esta instrucción realiza una operación OR bit a bit en el registro AL con él mismo. Es una forma de verificar si el valor en AL es cero.
- `8: 74 04 je e <halt>`: Esta instrucción salta a la dirección de memoria 0xe (etiquetada como `halt`) si el resultado de la operación OR anterior fue cero.
- `a: cd 10 int $0x10`: Esta instrucción genera una interrupción de software. En este caso, la interrupción 0x10 que es una interrupción de la BIOS para las funciones de video.
- `c: eb f7 jmp 5 <loop>`: Esta instrucción salta a la dirección de memoria 0x5 (etiquetada como `loop`).
- `000000000000000e <halt>:`: Indica la dirección de memoria y la etiqueta del siguiente bloque de código. La dirección es 0xe y la etiqueta es `halt`.
- `e: f4 hlt` : Esta instrucción detiene la ejecución del procesador hasta que se reciba la próxima interrupción.
- `000000000000000f <msg>:`: Indica la dirección de memoria y la etiqueta del siguiente bloque de código. La dirección es 0xf y la etiqueta es `msg`.
- `f: 68 65 6c 6c 6f push $0x6f6c6c65`: Esta instrucción empuja el valor hexadecimal 0x6f6c6c65 (que representa la cadena "hell" en ASCII) en la pila.
- `14: 20 77 6f and %dh,0x6f(%rdi)`: Esta instrucción realiza una operación AND bit a bit entre el valor en el registro DH y el valor en la dirección de memoria apuntada por RDI más 0x6f.
- `17: 72 6c jb 85 <msg+0x76>`: Esta instrucción salta a la dirección de memoria 0x85 (etiquetada como `msg+0x76`) si la bandera de acarreo está establecida, lo que indica que la última operación aritmética resultó en un acarreo o préstamo.
- `19: 64 fs`: Esta es una instrucción de prefijo de segmento que cambia el segmento predeterminado para la siguiente instrucción. En este caso, cambia el segmento a FS.

Vemos como la **dirección inicial** en este fragmento de código ensamblador se encuentra en la etiqueta **`<loop-0x5>`**, que corresponde a la dirección **`0x0000000000000000`**.

```bash
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc/01HelloWorld$ hd main.img
00000000  be 0f 7c b4 0e ac 08 c0  74 04 cd 10 eb f7 f4 68  |..|.....t......h|
00000010  65 6c 6c 6f 20 77 6f 72  6c 64 00 66 2e 0f 1f 84  |ello world.f....|
00000020  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
00000030  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
00000040  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
00000050  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
00000060  00 66 2e 0f 1f 84 00 00  00 00 00 66 2e 0f 1f 84  |.f.........f....|
00000070  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
00000080  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
00000090  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
000000a0  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
000000b0  00 66 2e 0f 1f 84 00 00  00 00 00 66 2e 0f 1f 84  |.f.........f....|
000000c0  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
000000d0  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
000000e0  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
000000f0  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
00000100  00 66 2e 0f 1f 84 00 00  00 00 00 66 2e 0f 1f 84  |.f.........f....|
00000110  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
00000120  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
00000130  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
00000140  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
00000150  00 66 2e 0f 1f 84 00 00  00 00 00 66 2e 0f 1f 84  |.f.........f....|
00000160  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
00000170  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
00000180  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
00000190  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
000001a0  00 66 2e 0f 1f 84 00 00  00 00 00 66 2e 0f 1f 84  |.f.........f....|
000001b0  00 00 00 00 00 66 2e 0f  1f 84 00 00 00 00 00 66  |.....f.........f|
000001c0  2e 0f 1f 84 00 00 00 00  00 66 2e 0f 1f 84 00 00  |.........f......|
000001d0  00 00 00 66 2e 0f 1f 84  00 00 00 00 00 66 2e 0f  |...f.........f..|
000001e0  1f 84 00 00 00 00 00 66  2e 0f 1f 84 00 00 00 00  |.......f........|
000001f0  00 66 2e 0f 1f 84 00 00  00 00 00 0f 1f 00 55 aa  |.f............U.|
00000200
```
El comando hd main.img se usa para visualizar el contenido del archivo main.img en formato hexadecimal. hd es un alias para el comando hexdump -C, que muestra los datos en formato hexadecimal. Los números y letras que ves representan los bytes de datos en el archivo.

En relación al resto del código, cada línea muestra una dirección de memoria, seguida por hasta 16 bytes de datos en hexadecimal. Vemos en la línea 00000000  be 0f 7c b4 0e ac 08 c0  74 04 cd 10 eb f7 f4 68 comienza con la dirección de memoria 00000000 y luego muestra 16 bytes de datos (be 0f 7c b4 0e ac 08 c0 74 04 cd 10 eb f7 f4 68). El mensaje de hello world vemos comienza en la dirección de memoria 00000000 mostrando el carácter ‘h’ y continua en la dirección de memoria 00000010 con ‘ello world’.

Los caracteres después de los bytes de datos son la representación ASCII de los bytes, donde los caracteres no imprimibles se muestran como un punto. 

La última línea 00000200 es la siguiente dirección de memoria después del último byte que se muestra.


La opción --oformat binary en el linker se utiliza para generar un archivo binario plano a partir de los archivos de código objeto. Su significado es que cuando utilizas -oformat binary, le indicas al linker que la salida debe ser un archivo binario sin formato específico, como un archivo ejecutable ELF (Executable and Linkable Format) o COFF (Common Object File Format). En lugar de crear un archivo ejecutable con una estructura específica (como encabezados, tablas de símbolos, etc.), el linker simplemente concatena los datos de los archivos de código objeto en un solo archivo binario.

Esto es util para cuando a veces, se necesita generar un archivo binario para cargarlo directamente en una memoria ROM o en un dispositivo específico (como un microcontrolador). Esta opción permite crear un archivo sin la sobrecarga de un formato ejecutable completo. Asi mismo, en la creación de imágenes de arranque personalizadas como el sector de arranque maestro (Master Boot Record, MBR), se puede usar esta opción para generar un archivo binario que contenga el código de arranque. Luego, se puede escribir este archivo directamente en un dispositivo de almacenamiento (como un USB) para que sea reconocido como un bootloader válido.

### Objetivo 6
Ejecutamos el comando  qemu-system-i386 -fda 01HelloWorld/main.img -boot a -s -S -monitor stdio, el cual observamos por terminal, expone el siguiente mensaje de WARNING.
```bash
federica@federica-HR14:~/Documents/Sistemas_de_Computacion/practico_3/protected-mode-sdc$ qemu-system-i386 -fda 01HelloWorld/main.img -boot a -s -S -monitor stdio
WARNING: Image format was not specified for '01HelloWorld/main.img' and probing guessed raw.
         Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
         Specify the 'raw' format explicitly to remove the restrictions.
QEMU 6.2.0 monitor - type 'help' for more information
```
Este mensaje de advertencia indica que QEMU no pudo determinar el formato de la imagen main.img y adivinó que es un archivo en formato “raw”. Para resolverlo, debes especificar explícitamente el formato como “raw”, de la siguiente forma:
```
qemu-system-i386 -fda 01HelloWorld/main.img -boot a -s -S -monitor stdio -drive format=raw,file=01HelloWorld/main.img
```

Al quitar la pausa de QEMU, observamos en pantalla:
![Imagen 3](/img/img3.jpg)

Se realiza la instalación de GDB dashboard tal y como se indica en el link. Se abre una nueva terminal y se depura colocando un breakpoint en la dirección de arranque, otro en la llamada a la interrupción y luego se utiliza “c” continue antes de las interrupciones y “si” para ejecutar una sola instrucción. Luego, se realizan los siguientes comando sugeridos:
![Imagen 4](/img/img4.jpg)

Colocados los bearkpoints br *0x7c00 y br *0x7c0c , al principio del programa y en la interrupcion, seteando la arquitectura set architecture i8086 y depurando paso a paso, se observa en pantalla como se va completando carácter a carácter nuestro “hello world”.

![Imagen 5](/img/img5.jpg)
![Imagen 6](/img/img6.jpg)
![Imagen 7](/img/img7.jpg)

### Objetivo 7
En un procesador Intel i-8086 tenemos dos modos de funcionamiento. El Modo Real y el Modo Protegido. 

El modo real es el modo de operación inicial de este procesador y otros compatibles. El procesador tiene acceso a hasta 1 MB de direccionamiento de memoria RAM, segmentación de memoria (direcciones físicas de 20 bits), sin protección de memoria ni privilegios.

El Modo Protegido es el modo nativo de algunos procesadores posteriores. Estos ya cuentan con protección de memoria, que previene que un programa dañe la memoria de otras tareas o del núcleo del sistema operativo. El procesador  tiene acceso a hasta 16 MB de memoria física y 1 GB de memoria virtual y distintos niveles de privilegios (anillos): siendo 0 el más privilegiado y hasta el 3, el menos privilegiado.

En resumen, el modo real es más simple pero menos seguro, mientras que el modo protegido ofrece características avanzadas como protección de memoria y multitarea.



La GDT (Global Descriptor Table o en español, Tabla de Descriptores Globales) es una estructura de datos utilizada por los procesadores Intel x86 para definir las características de las diversas áreas de memoria utilizadas durante la ejecución del programa. La misma especifica y define segmentos de memoria, incluyendo la dirección base, el tamaño y los privilegios de acceso (como ejecución y capacidad de escritura). Tambien los tipos de descriptores, los descriptores de segmento del sistema y los niveles de privilegio.

La GDT es fundamental para la administración de la memoria y la seguridad de este tipo de arquitecturas, permitiendo la protección y el control de acceso a los recursos de la memoria.


Para arrancar un sistema operativo en modo protegido desde el arranque inicial, se siguen los siguientes pasos:
1. **Deshabilitar interrupciones**: Antes de cargar la tabla de descriptores globales (GDT), es importante deshabilitar las interrupciones para evitar que se produzcan interrupciones no deseadas durante el proceso de inicialización. Para esto utilizamos la instrucción `cli` (clear interrupt flag).
2. **Cargar la GDT**: La GDT es una estructura de datos que contiene los descriptores de segmento necesarios para el manejo de memoria y la protección en modo protegido. Se carga la dirección base de la GDT en el registro GDTR (Global Descriptor Table Register). Para esto utilizamos la instrucción `lgdt [GDT_descriptor]`.
3. **Fijar el bit más bajo del CR0 en 1**: El registro CR0 controla el modo de operación del procesador. Para habilitar el modo protegido, se establece el bit más bajo (PE) en 1 en el registro CR0. Esto cambia el procesador al modo protegido y permite el acceso a las características avanzadas de la arquitectura x86.
4. **Saltar a la sección de código de 32 bits**: Se realiza un salto (jump) a la dirección de memoria donde se encuentra el código de inicialización en modo protegido. Este código se encuentra en una ubicación específica y se encarga de configurar los segmentos, la paginación y otras características necesarias para el funcionamiento del sistema operativo en modo protegido.
    
    Para el paso 3 y 4 utilizamos un codigo como:
   ```assembly
   mov eax, cr0
   or eax, 0x1
   mov cr0, eax
   jmp 0x08:modo_protegido
   ```

5. **Configurar el resto de los segmentos**: Una vez en modo protegido, se configuran los demás segmentos (como el segmento de datos, el segmento de pila, etc.) en la GDT. Además, se establecen las tablas de paginación para habilitar la traducción de direcciones virtuales a direcciones físicas.


Como indica la consigna, creamos un codigo assembler que pueda pasar al Modo Protegido, sin utilizar macros.
```assembly
section .text
global _start

_start:
; Deshabilitar las interrupciones
cli

; Configurar la GDT (Tabla de Descriptores Globales)
mov eax, gdt_end - gdt_start - 1
shl eax, 16
mov ax, gdt_start
lgdt [eax]

; Cambiar al Modo Protegido
mov eax, cr0
or eax, 0x1
mov cr0, eax
jmp 0x08:modo_protegido

modo_protegido:
; Configurar otros segmentos y tablas de paginación

; Código en modo protegido continúa desde aca

; Salir del programa
hlt

section .data
gdt_start:
; Descriptores de segmento (código, datos, etc.)

gdt_end:
```

Este es un programa básico en lenguaje Assembly que configura la Tabla de Descriptores Globales (GDT) y entra en el Modo Protegido en un procesador x86. A continuación su explicacion:

- `global _start` : Esto hace que el símbolo `_start` sea visible desde otros archivos. `_start` es el punto de entrada predeterminado para el vinculador.
- `_start:` : Esta es la etiqueta de inicio del programa.
- `cli` : Esta instrucción deshabilita las interrupciones del procesador para prevenir la interrupción del proceso de cambio de modo.
- `mov eax, gdt_end - gdt_start - 1` : Esto calcula la longitud de la GDT y la almacena en el registro EAX.
- `shl eax, 16` : Esto desplaza los bits de la longitud de la GDT 16 lugares a la izquierda en el registro EAX.
- `mov ax, gdt_start` : Esto mueve la dirección de inicio de la GDT al registro AX.
- `lgdt [eax]` : Esto carga el registro GDTR con la dirección y la longitud de la GDT.
- `mov eax, cr0` : Esto mueve el contenido del registro CR0 al registro EAX. CR0 es un registro de control que determina el modo de operación y las características del procesador.
- `or eax, 0x1` : Esto establece el bit menos significativo del registro EAX en 1. Este bit determina si el procesador está en Modo Real (si el bit es 0) o en Modo Protegido (si el bit es 1).
- `mov cr0, eax` : Esto mueve el contenido del registro EAX al registro CR0, cambiando así el modo del procesador a Modo Protegido.
- `jmp 0x08:modo_protegido` : Esto salta al código que se ejecutará en Modo Protegido. 0x08 es el selector de segmento para el segmento de código en Modo Protegido.
- `modo_protegido:` : Esta es la etiqueta para el inicio del código que se ejecutará en Modo Protegido.
- `hlt` : Esta instrucción detiene la ejecución de la CPU hasta que se recibe la próxima interrupción.
- `section .data` : Esto define la sección de datos donde se almacenan las variables y constantes utilizadas por el programa.
- `gdt_start:` : Esta es la etiqueta para el inicio de la GDT.
- `gdt_end:` : Esta es la etiqueta para el final de la GDT.


Un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados, siguiendo nuestro formato anterior, se vería de la siguiente forma:
```assembly
section .text
global _start

_start:
; Deshabilitar interrupciones
cli

; Configurar la GDT (Tabla de Descriptores Globales)
mov eax, gdt_end - gdt_start - 1
shl eax, 16
mov ax, gdt_start
lgdt [eax]

; Cambiar al Modo Protegido
mov eax, cr0
or eax, 0x1
mov cr0, eax
jmp 0x08:modo_protegido

modo_protegido:
; Configurar el descriptor de código
mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

; Configurar el descriptor de datos
mov ax, 0x18
mov ss, ax

; Código en modo protegido continúa desde aca

; Salir del programa
hlt

section .data
gdt_start:
; Descriptor de código (base = 0, límite = 4 GB, acceso = 0x9A)
dw 0xFFFF  ; Límite (16 bits más bajos)
dw 0x0000  ; Base (16 bits más bajos)
db 0x00    ; Base (8 bits siguientes)
db 0x9A    ; Tipo de descriptor (código ejecutable, acceso presente, nivel de privilegio 0)
db 0xCF    ; Límite (4 bits más altos) y atributos (granularidad, tamaño de operando)

; Descriptor de datos (base = 0, límite = 4 GB, acceso = 0x92)
dw 0xFFFF  ; Límite (16 bits más bajos)
dw 0x0000  ; Base (16 bits más bajos)
db 0x00    ; Base (8 bits siguientes)
db 0x92    ; Tipo de descriptor (datos, acceso presente, nivel de privilegio 0)
db 0xCF    ; Límite (4 bits más altos) y atributos (granularidad, tamaño de operando)

gdt_end:
```
Este código es un programa en lenguaje ensamblador que configura la CPU para cambiar al Modo Protegido. Aquí está la explicación de cada línea, que sea diferente al codigo antes presentado:

- `modo_protegido:`: Esta es la etiqueta a la que se salta después de habilitar el Modo Protegido.
- `mov ax, 0x10`: Carga el índice del descriptor de segmento de código en el registro AX.
- `mov ds, ax` y `mov es, ax`, `mov fs, ax`, `mov gs, ax`: Configuran los registros de segmento de datos (DS, ES, FS, GS) con el descriptor de segmento de código.
- `mov ax, 0x18`: Carga el índice del descriptor de segmento de datos en el registro AX.
- `mov ss, ax`: Configura el registro de segmento de pila (SS) con el descriptor de segmento de datos.
- `hlt`: Detiene la ejecución de la CPU.
- `section .data`: Define el inicio de la sección de datos, que es donde se almacenan las variables y constantes.
- `gdt_start:`: Esta es la etiqueta de inicio de la GDT.
- Las siguientes líneas definen dos descriptores de segmento en la GDT, uno para el segmento de código y otro para el segmento de datos. Cada descriptor de segmento especifica la base y el límite del segmento, así como los atributos de acceso y otros atributos.
- `gdt_end:`: Esta es la etiqueta de final de la GDT.

Al cambiar los bits de acceso del segmento de datos para que sea solo de lectura, e intentando escribir, se hace una pequeña modificación en el codigo anterior por:
```assembly
modo_protegido:
; Configurar el descriptor de código
; ...

; Configurar el descriptor de datos
; ...

; Intentar escribir en una dirección de memoria dentro del segmento de datos
mov dword [0x1000], 0xDEADBEEF  ; Esto generará una excepción GPF

; Salir del programa
hlt
```
Y se verifica en gdb con el siguiente comando por terminal:
```bash
nasm -f elf32 mp_dmd_bl.asm -o mp_dmd_bl.o
ld -m elf_i386 -o mp_dmd_bl mp_dmd_bl.o
```
