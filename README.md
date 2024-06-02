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
!insertar img1
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

