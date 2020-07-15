#!/bin/bash

if ! [ $UID -eq 0 ]
then
        echo 'vous devez être root pour lancer le script'
        exit 1
fi

while read fullname user pass group
do
  echo Groupe : $group /n Nom : $fullname /n MDP : $pass /n Utilisateur : $user
  groupmod -n ${group} ${group} 2>/dev/null && echo ... || addgroup ${group}
  useradd ${user} -p $(openssl passwd -1 ${pass}) --gid ${group}
done <liste2.txt
