#!/usr/bin/bash

function genppm {
	png_name=$2/$(basename "${1}.png") 
	ppm_name="${png_name%.*}.ppm"
	convert -coalesce $1 -resize 32x32\! $png_name
	
	# Uncomment this lines for PNG, comment for PPM
        echo "Generated ${png_name}"
	rm $ppm_name
	
	# Uncomment this lines for PPM, comment for PNG
        #mogrify -format ppm $png_name
	#echo "Generated ${ppm_name}"
	#rm $png_name
}

function iter {
	if [ "$1" -lt 10 ]; then
		n="0$i"
	else
		n=$i
	fi
	dirname="out/000$n"
	mkdir -p $dirname
	for f in $(ls in/*$n*); do
		genppm $f  $dirname 			
	done
}

for i in $(seq 1 15); do
	iter $i &
	pids[${i}]=$!
done

for pid in ${pids[*]}; do
    wait $pid
done

