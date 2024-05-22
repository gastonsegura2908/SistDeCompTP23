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

---
Al ingresar al link propuesto por la consigna, nos encontramos con tres comandos a seguir (previos a una abreviatura de TLDR, Too Long; Didn’t Read):
```
git clone (url of this repo)
git submodule init
git submodule update
```
