#!/bin/bash

# Creer ou Efface Utilisateur et groupe provenant d'un fichier texte
# Syntaxe :  Gestion_users <nomDuFichierTexte> <"add" pour ajouter "del" pour effacer


checkIdUser(){
  if ! [[ $UID -eq 0 ]] ; then
    echo 'vous devez être root pour lancer le script'
    exit 1
  fi
}

checkFichierExiste (){
  if ! [[ -e "${Nom_fichier_liste}" ]] ; then
    echo le fichier "${Nom_fichier_liste}" est non trouvable
    exit 1
  fi
}

readListeAndAddUsers(){
  while read fullname user pass group
  do
    groupmod -n "${group}" "${group}" 2>/dev/null || addgroup "${group}"
    useradd "${user}" -p $(openssl passwd -1 "${pass}") --gid "${group}"
  done <"${Nom_fichier_liste}"
}

readListeAndDelUsers(){
  while read fullname user pass group
  do
    deluser "${user}"
    echo "${user}" effacé
    delgroup "${group}"
    echo "${group}" effacé
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
    *)    echo "mauvais choix (doit etre add ou del)" 
          exit 1 ;;
  esac
}

main $1 $2

