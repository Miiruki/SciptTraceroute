#!/bin/bash


echo "  _______ _____            _____ ______ _____   ____  _    _ _______ ______ "
echo " |__   __|  __ \     /\   / ____|  ____|  __ \ / __ \| |  | |__   __|  ____|"
echo "    | |  | |__) |   /  \ | |    | |__  | |__) | |  | | |  | |  | |  | |__   "
echo "    | |  |  _  /   / /\ \| |    |  __| |  _  /| |  | | |  | |  | |  |  __|  "
echo "    | |  | | \ \  / ____ \ |____| |____| | \ \| |__| | |__| |  | |  | |____ "
echo "    |_|  |_|  \_\/_/    \_\_____|______|_|  \_\\\____/ \____/   |_|  |______|"
echo "                                                                            "

> traceroute.txt                #Vide le fichier traceroute.txt
> traceroute.dot               # Vide le fichier traceroute.dot
rm -f *.rte                    #Supprime tous les fichiers.rte
rm -f route.pdf                #Supprime le fichier route.pdf
echo "digraph traceroute { " >traceroute.txt            #Commande xdot permettant de définir que traceroute.txt est un graphe.

sudo ./traceroute.sh
sudo ./traceroutedot.sh

dot -Tpdf traceroute.dot -o route.pdf                           # Générer le fichier PDF selon le graphe DOT