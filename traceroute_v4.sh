#!/bin/bash

cibles=("-T -p 80" "-T -p 22" "-I" "-T -p 443")
read -p 'Veuillez entrer une adresse IP ou un nom de domaine : ' destination
while [ -z "$destination" ]; do
    read -p 'Veuillez rentrer une adresse IP ou un nom de domaine :' destination
done
TTL_Max=$(traceroute -n $destination | sed -n '$p' | awk '{print $1}')
TTL=$(traceroute -n $destination | sed '1d' | awk '{print $1}')
for ((TTL = 1; TTL <= $TTL_Max; TTL++)); do
    for i in "${cibles[@]}"; do
        cmd=$(traceroute -n -A -m $TTL -f $TTL -q 1 -w 10 $i $destination | awk '{print $1,$2}' | sed -e's/(//g' | sed -e's/)//g' | sed '1d')
        #echo "$i"
        echo "$cmd"
        if echo "$cmd" | awk '{print $2}' | grep '*' >>/dev/null; then
            if echo "${cibles[3]}" == "$cibles"; then
                echo "Je trouve pas wlh"
                echo "$i"
                break
            fi
        else
            echo "$cmd en utlisant :$i"
            break
        fi
    done
done
