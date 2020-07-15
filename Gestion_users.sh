#!/bin/bash

# Creer ou Efface Utilisateur et groupe provenant d'un fichier texte
# Syntaxe :  Gestion_utilisateurs <nomDuFichierTexte> <"add" pour ajouter "del" pour effacer>


checkIdutilisateur(){
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

ajoutUtilisateurs(){
      groupmod -n "${groupe}" "${groupe}" 2>/dev/null || addgroup "${groupe}" &>/dev/null && echo groupe "${groupe}" créé
      useradd "${utilisateur}" -p $(openssl passwd -1 "${motDePasse}") --gid "${groupe}" &>/dev/null &&  echo création de l\'utilisateur "${utilisateur}" dans le groupe "${groupe}" OK
      echo -e "$motDePasse\n$motDePasse" | smbpasswd -a -s $utilisateur && echo création de "${utilisateur}" dans Samba     
}

effaceUtilisateur(){
      smbpasswd -x "${utilisateur}" &>/dev/null && echo "${utilisateur}" enlevé du LDAP Samba
      deluser "${utilisateur}" &>/dev/null && echo "${utilisateur}" effacé
      delgroup "${groupe}" &>/dev/null && echo "${groupe}" effacé
}

readListeAndAddutilisateurs(){
  while read fullname utilisateur motDePasse groupe
  do
#    id "$utilisateur" &>/dev/null && echo "utilisateur $utilisateur valide" || echo "votre nom d'utilisateur $utilisateur n'est pas valide."
    if $(id "${utilisateur}" &>/dev/null)
    then
      echo l\'utilisateur $utilisateur existe déjas
    else
      ajoutUtilisateurs
    fi
  done <"${Nom_fichier_liste}"
}

readListeAndDelutilisateurs(){
  # id "$new_utilisateur" &>/dev/null && echo "utilisateur valide" || echo "votre nom d'utilisateur n'est pas valide."
  # if id "$new_utilisateur" &>/dev/null
  # then echo "utilisateur valide"
  # else echo "votre nom d'utilisateur n'est pas valide."
  # fi
  while read fullname utilisateur motDePasse groupe
  do
#    id "$utilisateur" &>/dev/null && echo "utilisateur $utilisateur valide" || echo "votre nom d'utilisateur $utilisateur n'est pas valide."
    if id "$utilisateur" &>/dev/null; then 
      effaceUtilisateur
    else
      echo l\'utilisateur "${utilisateur}" n\'existe pas
    fi
  done<"${Nom_fichier_liste}"
}

main(){
  checkIdutilisateur
  Nom_fichier_liste=$1
  checkFichierExiste 
  quoi_faire=$2
  case "${quoi_faire}" in
    add)  readListeAndAddutilisateurs ;;
    del)  readListeAndDelutilisateurs ;;
    *)    echo "mauvais choix (doit etre add ou del)" ;;
  esac
}

main $1 $2

