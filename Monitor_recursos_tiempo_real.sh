# Capturar la fecha y hora de inicio del script
fecha_inicio=$(date +%Y%m%d_%H%M%S)

# Archivo CSV para guardar los datos, usando la fecha de inicio en el nombre del archivo
archivo_salida="monitoreo_recursos_$fecha_inicio.csv"

# Escribir encabezados en el archivo CSV
echo "Segundos,Uso de CPU (%),Uso de Memoria (%),Uso de Disco (%)" > $archivo_salida

# Monitor de recursos en tiempo real
tiempo_inicio=$(date +%s)

while true; do
    # Calcular los segundos desde que se inició el script
    tiempo_actual=$(date +%s)
    tiempo_transcurrido=$((tiempo_actual - tiempo_inicio))
    
    # Capturar el uso del CPU
    uso_cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 + $6 + $10 + $12 + $14 + $16}')
    
    # Capturar el uso de la memoria RAM
    uso_memoria=$(free | awk '/^Mem/ {printf("%.2f\n", $3/$2 * 100.0)}')
    
    # Capturar el uso del disco
    uso_disco=$(df -h | awk 'NR==2 {printf("%.0f\n", $5)}' | sed 's/%//')
    

    
    # Posicionar el cursor en la parte superior de la pantalla
    tput cup 0 0
    
    # Imprimir los mensajes y resultados
    echo "Presiona Ctrl+C para salir."
    echo "Uso de CPU:       $uso_cpu%"
    echo "Uso de Memoria:   $uso_memoria%"
    echo "Uso de Disco:     $uso_disco%"

    
    # Guardar solo los datos relevantes en el archivo CSV
    echo "$tiempo_transcurrido,$uso_cpu,$uso_memoria,$uso_disco" >> $archivo_salida
    
    # Esperar 3 segundos antes de la próxima captura
    sleep 3
done
