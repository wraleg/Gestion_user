#!/bin/bash
fichier=$1
carsep=":"
 
if [ -e $1 ] #on vérifie si le fichier entré en paramètre existe
	then
		while read ligne #pour chaque ligne
		do
			pre=$(echo $ligne | cut -d: -f1) #pre reçoit la 1ere partie de la ligne séparée par “ : ”
			nom=$(echo $ligne | cut -d: -f2)
			groupe=$(echo $ligne | cut -d: -f3)
			login=$pre"."$nom
			complet=$pre" "$nom
			#mdp=$(pwgen 4 1) #on génère un mot de passe aléatoire avec l’outil pwgen
			mdp=$(echo $ligne | cut -d: -f4)
			#echo $mdp
			echo $login":"$mdp &gt;&gt; comptes.txt #on écrit le login et mot de passe dans comptes.txt
			useradd -d /home/$login -c $complet -m -s /bin/false -g $groupe $login #création du compte unix
			echo -e "$mdp\n$mdp" | smbpasswd -a -s $login #création compte samba
		done &lt; $fichier
	else
 
		echo "fichier $1 non trouve"
fi 
 
# End of script