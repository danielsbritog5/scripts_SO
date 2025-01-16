# Directorio actual
directorio_actual=$(pwd)

# Crear un subdirectorio para guardar las gráficas
mkdir -p $directorio_actual/graficas

# Función para generar gráficas
generar_grafica() {
    archivo_csv=$1
    nombre_archivo=$(basename "$archivo_csv" .csv)
    archivo_grafica="$directorio_actual/graficas/${nombre_archivo}.png"

    gnuplot <<- EOF
        set datafile separator ","
        set terminal png size 800,600
        set output "$archivo_grafica"
        set title "Monitor de Recursos - $nombre_archivo"
        set xlabel "Segundos"
        set ylabel "Uso (%)"
        set key outside
        plot "$archivo_csv" using 1:2 with lines title "Uso de CPU", \
             "$archivo_csv" using 1:3 with lines title "Uso de Memoria", \
             "$archivo_csv" using 1:4 with lines title "Uso de Disco"
EOF
}

# Buscar todos los archivos CSV en el directorio actual y generar gráficas
for archivo_csv in "$directorio_actual"/*.csv; do
    [ -e "$archivo_csv" ] || continue
    generar_grafica "$archivo_csv"
done

echo "Gráficas generadas en el directorio '$directorio_actual/graficas'."
