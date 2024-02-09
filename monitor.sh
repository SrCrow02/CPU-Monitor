#!/bin/bash

vermelho='\033[0;31m'
verde='\033[0;32m'
reset='\033[0m'

check_disk_usage() {
    local disk=$(df . | awk 'NR==2 {print $1}')
    echo "Uso de Disco para $disk:"
    df -h $disk
}

check_network_info() {
    echo "Informações de Rede:"
    netstat -rn
}

check_cpu_usage() {
    local cpu_usage=$(mpstat 1 1 | awk '$12 ~ /[0-9.]+/ { print 100 - $12 }')
    local memory_usage=$(free -m | awk 'NR==2 {print "Memória em uso: " $3 "MB"}')
    local memory_free=$(free -m | awk  'NR==7 {print "Memória Disponível: " $7 " MB"}')

    echo "Uso de CPU: $cpu_usage%"
    echo -e "${vermelho}$memory_usage${reset}"
    echo -e "${verde}$memory_free${reset}"
    top -b -n 1 | tail -n +8 | head -n 5
}

while true; do
    clear
    echo "Monitor de Recursos do Sistema"
    echo "=============================="
    echo "$(date)"
    echo ""
    check_disk_usage
    check_network_info
    check_cpu_usage
    sleep 5  
done
