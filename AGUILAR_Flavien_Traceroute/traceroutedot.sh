#!/bin/bash

echo ""                                                         # Saut de ligne
echo ";" >> traceroute.txt                                      # Fin du schéma dot
tr -d '\n' < traceroute.txt > traceroute.dot                    # Transformer . texte en dot sans les sauts de ligne
echo "}" >> traceroute.dot                                      # Terminer le fichier dot
dot -Tpdf traceroute.dot -o route.pdf                           # Générer le fichier PDF selon le graphe DOT