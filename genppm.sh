#!/usr/bin/bash

function genppm {
	png_name=$2/$(basename "${1}.png") 
	ppm_name="${png_name%.*}.ppm"
	convert -coalesce $1 $png_name
	mogrify -format ppm $png_name
	rm $png_name
	echo "Generated ${ppm_name}"
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

