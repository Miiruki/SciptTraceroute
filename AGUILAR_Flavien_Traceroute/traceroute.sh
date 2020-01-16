#!/bin/bash

cibles=("-T -p 80" "-T -p 22" "-I" "-T -p 443" "-U -p 33434" "-U -p 5060" "-U -p 1194" "")                                                                                                                                   #Liste des protocoles/ports utilisés.
dest=("www.iutbeziers.fr" "www.univ-guyane.fr" "iut.univ-amu.fr") #"www.iut-blagnac.fr" "iutnb.univ-lorraine.fr" "www.iut-lannion.fr" "www.univ-guyane.fr" "www.carrefour.fr" "www.zalando.fr" "www.auchan.fr" "www.impots.gouv.fr" "www.nato.int") # Liste des destinations de notre traceroute.
for d in "${dest[@]}"; do
    echo ""
    TTL_Max=$(traceroute -n $d | sed -n '$p' | awk '{print $1}') # On determine le TTL MAX pour une cible donnée.
    TTL=$(traceroute -n $d | sed '1d' | awk '{print $1}')
    for ((TTL = 1; TTL <= $TTL_Max; TTL++)); do
        for i in "${cibles[@]}"; do
            cmd=$(traceroute -n -A -m $TTL -f $TTL -q 1 -w 10 $i $d | awk '{print $1,$2,$3}' | sed '1d')
            result=$(echo "$cmd" | awk '{printf $2}')
            if [ "$result" == "*" ]; then
                if [ "$i" == "" ]; then
                    echo "-> \"$TTL Routeur numéro : $TTL"\" >>traceroute.txt
                    echo "$TTL Routeur numéro : $TTL"
                fi
            else
                if [ "$TTL" != "1" ]; then

                    echo " -> \"$cmd\"" >>traceroute.txt # Pour tous les TTL sauf le premier on affiche une fleche + resultat de notre commande dans traceroute.txt
                    echo "$cmd" | tee -a $d.rte          #Affiche le résultat de la commande et le stocke dans un fichier .rte correspondant  au nom de domaine ciblé.
                    break
                fi

                echo "\"$cmd\"" >>traceroute.txt # Pour le premier TTL, on affiche seulement le résultat de la commande.
                echo "$cmd" | tee -a $d.rte
                break

            fi

        done
    done
done
