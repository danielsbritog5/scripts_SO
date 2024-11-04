# Archivo de salida
Reporte="recursos.txt"

# Encabezado en el archivo de salida
echo "Tiempo(s) | % Total de CPU libre | % Memoria Libre | % Disco Libre" > $Reporte

# Bucle de monitoreo (5 minutos con una captura cada 60 segundos)
for i in {1..5}; do
    # Tiempo transcurrido
    Tiempo=$((i * 60))

    # Obtener porcentaje de CPU libre (asumiendo múltiples procesadores)
    CPU_Libre=$(top -b -n1 | grep "Cpu(s)" | awk '{print 100 - $2 - $3 - $4 - $5 - $6 - $7 - $8 - $9}')

    # Obtener porcentaje de memoria libre
    Memoria_Libre=$(free | grep Mem | awk '{printf "%.2f", $4/$2 * 100.0}')

    # Obtener porcentaje de disco libre
    Disco_Libre=$(df -h / | awk 'NR==2 {print $5}')

    # Escribir en el archivo de salida
    echo "$Tiempo s | $CPU_Libre %| $Memoria_Libre % | $Disco_Libre" >> $Reporte

    # Esperar 60 segundos antes de la próxima captura
    sleep 60
done
