#!/bin/bash

> traceroute.txt
> traceroute.dot

echo "digraph traceroute { " >traceroute.txt

cibles=("-T -p 80" "-T -p 22" "-I" "-T -p 443" "-U -p 33434" "-U -p 5060" "-U -p 1194" "")
dest=("www.iutbeziers.fr" "www.chine-nouvelle.com" "www.alliancetelecom.fr" "www.google.fr")
for d in "${dest[@]}"; do
    echo ""
    TTL_Max=$(traceroute -n $d | sed -n '$p' | awk '{print $1}')
    TTL=$(traceroute -n $d | sed '1d' | awk '{print $1}')
    for ((TTL = 1; TTL <= $TTL_Max; TTL++)); do
        for i in "${cibles[@]}"; do
            cmd=$(traceroute -n -A -m $TTL -f $TTL -q 1 -w 10 $i $d | awk '{print $1,$2,$3}' | sed '1d')
            result=$(echo "$cmd" | awk '{printf $2}')
            if [ "$result" == "*" ]; then
                if [ "$i" == "" ]; then
                    echo "-> \"$TTL Routeur numéro : $TTL"\" >> traceroute.txt
                    echo "$TTL Routeur numéro : $TTL"
                fi
            else
                if [ "$TTL" != "1" ]; then

                    echo " -> \"$cmd\"" >> traceroute.txt
                    echo "$cmd"
                    break
                fi

                echo "\"$cmd\"" >> traceroute.txt
                echo "$cmd"
                break

            fi

        done
    done
done

echo ""                                                 # Saut de ligne
echo ";" >> traceroute.txt                              # Fin du schéma dot
tr -d '\n' < traceroute.txt > traceroute.dot            # Transformer . texte en dot sans les sauts de ligne
echo "}" >> traceroute.dot                              # Terminer le fichier dot
dot -Tpdf traceroute.dot -o route.pdf                   # Générer le fichier PDF selon le graphe DOT