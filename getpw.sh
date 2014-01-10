#!/bin/sh

DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$_")")" && pwd -P )

# Should we be formatting a password for output?
if [[ $1 = '-fmt' ]]; then
  read PWID
  read SITE
  read USERNAME
  read PASSWORD
  read COMMENT
# Is this password one that we want?
  if [ -n "$2" ]; then
    if ! grep -q $2 <<EOF
$PWID
$SITE
$USERNAME
$COMMENT
EOF
      then
      exit
    fi
  fi
# More secure for printing out password
  cat <<EOF
Id: $PWID
Site: $SITE
Username: $USERNAME
Password: $PASSWORD
Comment: $COMMENT

EOF
else
# Retrieve all keys and check for those desired
  for p in $DIR/passwords/$USER/*; do
    gpg --use-agent --batch -q --decrypt $p | $0 -fmt $1
  done
fi



