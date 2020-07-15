#!/bin/bash

# Creer ou Efface Utilisateur et groupe provenant d'un fichier texte
# Syntaxe :  Gestion_users <nomDuFichierTexte> <"add" pour ajouter "del" pour effacer>


checkIdUser(){
  if ! [[ $UID -eq 0 ]] ; then
    echo 'vous devez être root pour lancer le script'
    exit 1
  fi
}

checkFichierExiste (){
  if ! [[ -e "${Nom_fichier_liste}" ]] ; then
    echo le fichier $1 non trouvable
    exit 1
  fi
}

readListeAndAddUsers(){
  while read fullname user pass group
  do
    if [ `id -u $user 2>/dev/null || echo -1` -eq 0 ]; then 
      groupmod -n "${group}" "${group}" 2>/dev/null || addgroup "${group}"
      useradd "${user}" -p $(openssl passwd -1 "${pass}") --gid "${group}"
      echo -e "$pass\n$pass" | smbpasswd -a -s $user
      echo création de l\'utilisateur "${user}" dans le groupe "${groupe}" OK
    else
      echo utilisateur $user existe déjas
    fi
  done <"${Nom_fichier_liste}"
}

readListeAndDelUsers(){
  while read fullname user pass group
  do
    deluser "${user}"
    delgroup "${group}"
    echo "${group}" effacé
    echo "${user}" effacé
  done<"${Nom_fichier_liste}"
}

main(){
  checkIdUser
  Nom_fichier_liste=$1
  checkFichierExiste 
  quoi_faire=$2
  case "${quoi_faire}" in
    add)  readListeAndAddUsers ;;
    del)  readListeAndDelUsers ;;
    *)    echo "mauvais choix (doit etre add ou del)" ;;
  esac
}

main $1 $2

