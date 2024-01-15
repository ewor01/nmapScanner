# nmapScanner

Cliente de terminal hecho en Bash, para decubrir que puertos estan abiertos en una maquina y descubrir los servicios que corren para esos puertos, ideal para ahorrar tiempo a la hora de hacer pentesting.
Este script realiza escaneos de puertos utilizando Nmap y proporciona funciones adicionales para analizar y copiar puertos abiertos a la clipboard. La funcion extractPorts que utilizamos para copiar los puertos a la clipboard fue creada por s4vitar.

## Uso

``` ./tuscript.sh <dirección_ip> [nombre_archivo_inicial] [nombre_archivo_targeted] ```

- <dirección_ip>: La dirección IP del objetivo que se escaneará.
- [nombre_archivo_inicial]: (Opcional) Nombre personalizado para el archivo del primer escaneo. Si no se proporciona, se utilizará "allPorts" por defecto.
- [nombre_archivo_targeted]: (Opcional) Nombre personalizado para el archivo del segundo escaneo. Si no se proporciona, se utilizará "targeted" por defecto.

#Requisitos
- Nmap: Asegúrate de tener Nmap instalado en tu sistema antes de ejecutar el script.
- xclip: Asegúrate de tener xclip instalado en tu sistema antes de ejecutar el script. Si no lo tienes solo tienes que ejecutar el siguiente comando: ``` sudo apt install xclip ```

#Ejemplos
- Escaneo predeterminado:
``` ./tuscript.sh 192.168.1.1 ```
- Escaneo personalizado:
``` ./tuscript.sh 192.168.1.1 escaneo_inicial escaneo_secundario ```
Con el segundo lo que hacemos es asignar un nombre a los ficheros creados por ambos escaneos.
