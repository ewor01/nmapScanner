#!/bin/bash

# Script de Escaneo y Análisis de Puertos para Ciberseguridad
# Creado por: ewor01

target=$1
output_file_initial=${2:-"allPorts"}
output_file_targeted=${3:-"targeted"}
temp_file="temp_ports.txt"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

function print_usage {
    # Imprimir mensaje de uso del script
    echo -e "${RED}Uso:${NC} $0 <dirección_ip>\n"
    echo -e "${YELLOW}Ejemplo:${NC} $0 192.168.1.1 primerEscaneo SegundoEscaneo, Si no proporcionas un nombre para los escaneos asignara los que son por defecto: allPorts y targeted\n"
}

# Validar si se proporciona una dirección IP como argumento
if [ -z "$target" ] || ! [[ "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error:${NC} Debes proporcionar una dirección IP válida como argumento.\n"
    print_usage
    exit 1
fi

function initial_nmap_scan {
    # Primer escaneo con Nmap para descubrir puertos abiertos
    echo -e "${GREEN}Descubriendo los puertos abiertos en $target...${NC}\n"
    nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn $target -oG $output_file_initial

    # Extraer puertos abiertos y guardarlos en el archivo temporal
    open_ports=$(grep -oP '\d+/open' $output_file_initial | awk -F'/' '{print $1}' | tr '\n' ',')
    echo $open_ports > $temp_file

    echo -e "${GREEN}Escaneo de puertos completado. Resultados guardados en '$output_file_initial'.${NC}\n"
}

function targeted_nmap_scan {
    # Segundo escaneo con Nmap basado en los puertos encontrados en el archivo temporal
    echo -e "${GREEN}Buscando versiones y servicios para los puertos encontrados...${NC}\n"

    # Leer puertos desde el archivo temporal
    open_ports=$(cat $temp_file)

    # Validar que haya al menos un puerto
    if [ -z "$open_ports" ]; then
        echo -e "${YELLOW}No se encontraron puertos abiertos para el segundo escaneo.${NC}\n"
        return
    fi

    # Segundo escaneo con Nmap
    nmap -sCV --open -p $open_ports -vvv -n -Pn $target -oN $output_file_targeted

    echo -e "${GREEN}Escaneo de servicios completado. Resultados guardados en '$output_file_targeted'.${NC}\n"

    # Copiar los puertos abiertos a la clipboard
    extractPorts $output_file_targeted
}

function extractPorts {
    # Función para extraer puertos abiertos y copiarlos a la clipboard
    ports=$(grep -oP '\d{1,5}/open' $1 | awk -F'/' '{print $1}' | xargs)
    ip_address=$(grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' $1 | sort -u | head -n 1)
    
    if [ -n "$ports" ]; then
        echo $ports | tr -d '\n' | xclip -sel clip
        bat extractPorts.tmp
        rm extractPorts.tmp
    fi
}

# Realizar el primer escaneo con Nmap para descubrir puertos abiertos
initial_nmap_scan

# Realizar el segundo escaneo con Nmap basado en los puertos encontrados en el archivo temporal
targeted_nmap_scan

# Eliminar el archivo temporal una vez utilizado
rm -f $temp_file

echo -e "${GREEN}Escaneo Finalizado.${NC}\n"

