#!/bin/bash
cibles=("-U -p33434" "-U -p5060" "-U -p1194" "-T -p80" "-T -p22" "-T -p443" "-I")
read -p 'Veuillez entrer une adresse IP ou un nom de domaine :' destination
while [ -z "$destination" ]; do
    read -p 'Veuillez rentrer une adresse IP ou un nom de domaine :' destination
done
TTL_Max=$(traceroute -n $destination | sed -n '$p' | awk '{print $1}')
for i in "${cibles[@]}"; do
    cmd=$(traceroute -n -w 10 $i $destination)
    echo "$cmd" | awk '{print $1,$2}'| sed -e's/(//g' | sed -e's/)//g' | sed '1d' > ./fichiers_rte/$destination.rte
done